function AutoUpdateSemVerDelegate ([string]$Path) {
    if ((Get-MKPowerShellSetting -Name 'TurnOnAutoUpdateSemVer') -eq $true) {
        return Update-SemVer -Path $Path -AutoUpdate
    }
}