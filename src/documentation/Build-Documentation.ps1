using module .\.\MKPowerShellDocObject.psm1

function Build-Documentation {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $True, 
            ParameterSetName = "ByName")]
        [string]$Name = '',
        
        [Parameter(Mandatory = $True, 
            Position = 0,
            ParameterSetName = "ByPath")]
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
        
        [switch]
        $NoReImportModule
    )

    begin {
        # Output Field Separator - default is ' '
        $OFS = ''

        $Path = Resolve-Path $Path | Select-Object -ExpandProperty Path
        
        if (-not $Data) {
            $Data = [MKPowerShellDocObject]::new(
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
        Write-Output $Data | `
            Build-PlatyPSMarkdown | `
            New-ExternalHelpFromPlatyPSMarkdown | `
            Update-ReadmeFromPlatyPSMarkdown

        $OFS = ' '
    }
}