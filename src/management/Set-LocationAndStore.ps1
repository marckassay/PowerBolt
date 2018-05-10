function Set-LocationAndStore {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, Position = 0)]
        [AllowEmptyString()]
        [AllowNull()]
        [string]$Path,

        [Parameter(Mandatory = $False)]
        [AllowEmptyString()]
        [AllowNull()]
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