using module .\.\MKDocumentationInfo.psm1

function Build-PlatyPSMarkdown {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $True, 
            ValueFromPipeline = $True, 
            ParameterSetName = "ByPipe")]
        [MKDocumentationInfo]$DocInfo,

        [Parameter(Mandatory = $True,
            Position = 1,
            ParameterSetName = "ByPath")]
        [string]$Path,

        [Parameter(Mandatory = $False)]
        [string]$MarkdownFolder = 'docs',

        [Parameter(Mandatory = $False)]
        [string]$Locale = 'en-US',
        
        [Parameter(Mandatory = $False)]
        [string]$OnlineVersionUrlTemplate,

        [Parameter(Mandatory = $False)]
        [ValidateSet("Auto", "Omit")]
        [string]$OnlineVersionUrlPolicy = 'Auto',
        
        [switch]
        $NoReImportModule
    ) 
    
    DynamicParam {
        return GetModuleNameSet -Mandatory -Position 0
    }
    
    begin {
        $Name = $PSBoundParameters['Name']

        if (-not $Name) {
            if (-not $Path) {
                $Path = '.'
            }

            $Path = Resolve-Path $Path.TrimEnd('\', '/') | Select-Object -ExpandProperty Path
        }

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

    end {
        $DocInfo.ModuleMarkdownFolder = Join-Path -Path $DocInfo.ModuleFolder -ChildPath $DocInfo.MarkdownFolder
        $MarkdownFolderItems = Get-ChildItem -Path $DocInfo.ModuleMarkdownFolder -Include '*.md' -Recurse -ErrorAction SilentlyContinue
        if ($MarkdownFolderItems.Count -eq 0) {
            New-Item -Path $DocInfo.ModuleMarkdownFolder -ItemType Container -Force | Out-Null

            if ($DocInfo.NoReImportModule -eq $False) {
                Remove-Module -Name $DocInfo.ModuleName
                Import-Module -Name $DocInfo.RootManifest -Force -Scope Global
            }
            
            New-MarkdownHelp -Module $DocInfo.ModuleName -OutputFolder $DocInfo.ModuleMarkdownFolder | Out-Null

            $DocInfo.UpdateOnlineVersionUrl()
        }
        else {
            if ($DocInfo.NoReImportModule -eq $False) {
                Remove-Module -Name $DocInfo.ModuleName
                Import-Module -Name $DocInfo.RootManifest -Force -Scope Global
            }

            $ExportedFunctions = Get-Module -Name $DocInfo.ModuleName | `
                Select-Object -ExpandProperty ExportedFunctions | `
                Select-Object -ExpandProperty Values | `
                Select-Object -ExpandProperty Name

            # remove obsolete .md files
            $MarkdownFolderItems | `
                Select-Object -ExpandProperty BaseName | `
                ForEach-Object {
                if ($ExportedFunctions -notcontains $_) {
                    Remove-Item -Path ($DocInfo.ModuleMarkdownFolder + "\$_.md") -Confirm
                }
            }

            Update-MarkdownHelpModule -Path $DocInfo.ModuleMarkdownFolder | Out-Null

            $DocInfo.UpdateOnlineVersionUrl()
        }

        Write-Output $DocInfo
    }
}