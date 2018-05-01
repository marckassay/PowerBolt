function New-ExternalHelpFromPlatyPSMarkdown {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True)]
        [PSCustomObject]$Data
    )

    $HelpLocaleFolder = Join-Path -Path $Data.ModuleFolder -ChildPath $Data.Locale
    if ((Test-Path -Path $HelpLocaleFolder -PathType Container) -eq $False) {
        New-Item -Path $HelpLocaleFolder -ItemType Container
    }
    New-ExternalHelp -Path $Data.ModuleMarkdownFolder -OutputPath $HelpLocaleFolder -Force | `
        Out-Null
    
    $Data
}