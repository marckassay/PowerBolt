function Set-LocationAndStore {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, Position = 1)]
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

    $MKPowerShellConfig.LastLocation 
    ##Set-ItemProperty -Path $RegistryKey -Name LastLocation -Value (Get-Location) -PassThru:$PassThru.IsPresent
}