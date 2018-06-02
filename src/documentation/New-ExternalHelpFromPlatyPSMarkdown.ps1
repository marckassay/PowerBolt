using module .\.\MKPowerShellDocObject.psm1

function New-ExternalHelpFromPlatyPSMarkdown {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
        [MKPowerShellDocObject]$Data,

        [Parameter(Mandatory = $False)]
        [string]$Path = (Get-Location | Select-Object -ExpandProperty Path),

        [Parameter(Mandatory = $False)]
        [string]$MarkdownFolder = 'docs',

        [Parameter(Mandatory = $False)]
        [string]$OutputFolder = 'en-US'
    )

    begin {
        if (-not $Data) {
            $Data = [MKPowerShellDocObject]::new(
                $Path,
                $MarkdownFolder,
                $OutputFolder
            )
        }
    }

    end {
        $MarkdownFolder = Join-Path -Path $Data.Path -ChildPath $Data.MarkdownFolder

        $HelpLocaleFolder = Join-Path -Path $Data.Path -ChildPath $Data.Locale

        if ((Test-Path -Path $HelpLocaleFolder -PathType Container) -eq $False) {
            New-Item -Path $HelpLocaleFolder -ItemType Container | Out-Null
        }

        New-ExternalHelp -Path $MarkdownFolder -OutputPath $HelpLocaleFolder -Force | `
            Out-Null
        
        Write-Output $Data
    }
}