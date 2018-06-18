using module .\.\MKDocumentationInfo.psm1

function Build-PlatyPSMarkdown {
    [CmdletBinding(PositionalBinding = $True, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $False,
            Position = 0,
            ValueFromPipeline = $False, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.',

        [Parameter(Mandatory = $True,
            Position = 1,
            ValueFromPipeline = $True, 
            ParameterSetName = "ByPipe")]
        [MKDocumentationInfo]$DocInfo,

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

            $DocInfo.UpdateOnlineVersionUrl($True)
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

            # TODO: adding a parameter to Build-PlatyPSMarkdown for this line below wouldnt require 
            # much work. should remove source-and-test links when and if setting to False when they
            # exist.
            $DocInfo.UpdateOnlineVersionUrl($True)
        }

        Write-Output $DocInfo
    }
}