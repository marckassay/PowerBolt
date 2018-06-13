using module .\.\MKDocumentationInfo.psm1

function Build-Documentation {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $True,
            Position = 1,
            ParameterSetName = "ByPath")]
        [string]$Path,

        [Parameter(Mandatory = $False)]
        [string]$MarkdownFolder = 'docs',

        [Parameter(Mandatory = $False)]
        [string]$Locale = 'en-US',
        
        [Parameter(Mandatory = $False)]
        [string]$OnlineVersionUrlTemplate = '',

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

        # Output Field Separator - default is ' '
        $OFS = ''
        
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
        Write-Output $DocInfo | `
            Build-PlatyPSMarkdown | `
            New-ExternalHelpFromPlatyPSMarkdown | `
            Update-ReadmeFromPlatyPSMarkdown

        $OFS = ' '
    }
}