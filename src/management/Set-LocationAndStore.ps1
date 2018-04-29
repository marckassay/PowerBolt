function Set-LocationAndStore {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, Position = 0)]
        [string]$Path,

        [Parameter(Mandatory = $False)]
        [string]$LiteralPath,

        [switch]$PassThru
    )

    if ($Path) {
        Set-Location -Path $Path -Verbose:$Verbose.IsPresent
    }
    else {
        Set-Location -LiteralPath $LiteralPath -Verbose:$Verbose.IsPresent
    }

    $AbsolutePath = Get-Location | `
        Select-Object -ExpandProperty Path
    Set-MKPowerShellSetting -Name 'LastLocation' -Value $AbsolutePath 
}