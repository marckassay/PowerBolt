using module .\.\MKDocumentationInfo.psm1
using module .\..\module\manifest\AutoUpdateSemVerDelegate.ps1

function Build-PlatyPSMarkdown {
    [CmdletBinding(PositionalBinding = $true, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $false, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.',

        [Parameter(Mandatory = $true,
            Position = 1,
            ValueFromPipeline = $true, 
            ParameterSetName = "ByPipe")]
        [MKDocumentationInfo]$DocInfo,

        [Parameter(Mandatory = $false)]
        [string]$MarkdownFolder = 'docs',

        [Parameter(Mandatory = $false)]
        [string]$Locale = 'en-US',
        
        [Parameter(Mandatory = $false)]
        [string]$OnlineVersionUrlTemplate,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Auto", "Omit")]
        [string]$OnlineVersionUrlPolicy = 'Auto',
        
        [switch]
        $RemoveSourceAndTestLinks,
        
        [switch]
        $NoReImportModule,
        
        [switch]
        $Force
    ) 
    
    DynamicParam {
        return GetModuleNameSet -Position 0 -Mandatory 
    }
    
    begin {
        $Name = $PSBoundParameters['Name']

        if (-not $DocInfo) {
            $DocInfo = [MKDocumentationInfo]::new(
                $Name,
                $Path,
                $MarkdownFolder,
                $Locale,
                $OnlineVersionUrlTemplate,
                $OnlineVersionUrlPolicy,
                $MarkdownSnippetCollection,
                $NoReImportModule.IsPresent
            )
        }
    }

    process {
        AutoUpdateSemVerDelegate($DocInfo.Path)

        $DocInfo.ModuleMarkdownFolder = Join-Path -Path $DocInfo.ModuleFolder -ChildPath $DocInfo.MarkdownFolder
        # create markdown folder if it doesn't exist 
        New-Item -Path $DocInfo.ModuleMarkdownFolder -ItemType Container -Force | Out-Null
        $MarkdownFolderItems = Get-ChildItem -Path $DocInfo.ModuleMarkdownFolder -Include '*.md' -Recurse -ErrorAction SilentlyContinue

        if ($DocInfo.NoReImportModule -eq $false) {
            # SilentlyContinue to prevent CLI telling me that 'PackageManagement' cant be removed 
            # with Force.
            Remove-Module -Name $DocInfo.ModuleName -ErrorAction SilentlyContinue
            Import-Module -Name $DocInfo.ManifestPath -Force -Scope Global
        }
            
        $MarkdownFolderItems = Get-ChildItem -Path $DocInfo.ModuleMarkdownFolder -Include '*.md' -Recurse -ErrorAction SilentlyContinue
        if ($MarkdownFolderItems.Count -eq 0) {
            New-MarkdownHelp -Module $DocInfo.ModuleName -OutputFolder $DocInfo.ModuleMarkdownFolder | Out-Null
        }
        else {
            $ExportedFunctions = Get-Module -Name $DocInfo.ModuleName | `
                Select-Object -ExpandProperty ExportedFunctions | `
                Select-Object -ExpandProperty Values | `
                Select-Object -ExpandProperty Name
    
            # remove obsolete .md files
            $MarkdownFolderItems | `
                Select-Object -ExpandProperty BaseName | `
                ForEach-Object {
                if ($ExportedFunctions -notcontains $_) {
                    Remove-Item -Path ($DocInfo.ModuleMarkdownFolder + "\$_.md") -Confirm:$($Force.IsPresent -ne $true)
                }
            }
    
            Update-MarkdownHelpModule -Path $DocInfo.ModuleMarkdownFolder | Out-Null
        }

        $DocInfo.UpdateVersionUrls(($RemoveSourceAndTestLinks.IsPresent) -eq $false)
        
        Write-Output $DocInfo
    }
}