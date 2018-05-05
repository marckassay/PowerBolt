using module .\.\MKPowerShellDocObject.psm1

function Build-Documentation {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
        [MKPowerShellDocObject]$Data,

        [Parameter(Mandatory = $False)]
        [string]$Name = '',
        
        [Parameter(Mandatory = $False)]
        [string]$Path = (Get-Location | Select-Object -ExpandProperty Path),

        [Parameter(Mandatory = $False)]
        [string]$MarkdownFolder = 'docs',

        [Parameter(Mandatory = $False)]
        [string]$Locale = 'en-US',
        
        [Parameter(Mandatory = $False)]
        [string]$OnlineVersionUrlTemplate = '',

        [Parameter(Mandatory = $False)]
        [ValidateSet("Auto", "Omit")]
        [string]$OnlineVersionUrlPolicy = 'Auto',
        
        [Parameter(Mandatory = $False)]
        [string]$ReadMeBeginBoundary = '## Functions',
        
        [Parameter(Mandatory = $False)]
        [string]$ReadMeEndBoundary = '## Roadmap',

        [Parameter(Mandatory = $False)]
        [string]$MarkdownSnippetCollection = '',
        
        [switch]
        $NoReImportModule
    )

    begin {
        if (-not $Data) {
            $Data = [MKPowerShellDocObject]::new(
                $Name,
                $Path,
                $MarkdownFolder,
                $Locale,
                $OnlineVersionUrlTemplate,
                $OnlineVersionUrlPolicy,
                $ReadMeBeginBoundary,
                $ReadMeEndBoundary,
                $MarkdownSnippetCollection,
                $NoReImportModule.IsPresent
            )
        }
    }

    end {
        Write-Output $Data | `
            Build-PlatyPSMarkdown | `
            New-ExternalHelpFromPlatyPSMarkdown | `
            Update-ReadmeFromPlatyPSMarkdown
    }
}