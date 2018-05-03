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

    if ($Data) {
        $Path = $Data.ModuleFolder 
        $MarkdownFolder = $Data.ModuleMarkdownFolder
        $OutputFolder = $Data.Locale
    }

    $MarkdownFolder = Join-Path -Path $Path -ChildPath $MarkdownFolder

    $HelpLocaleFolder = Join-Path -Path $Path -ChildPath $OutputFolder

    if ((Test-Path -Path $HelpLocaleFolder -PathType Container) -eq $False) {
        New-Item -Path $HelpLocaleFolder -ItemType Container
    }

    New-ExternalHelp -Path $MarkdownFolder -OutputPath $HelpLocaleFolder -Force | `
        Out-Null
    
    $Data
}