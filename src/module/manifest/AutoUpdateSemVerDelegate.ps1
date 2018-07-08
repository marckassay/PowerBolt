function AutoUpdateSemVerDelegate ([string]$Path) {
    if ((Get-PowerBoltSetting -Name 'TurnOnAutoUpdateSemVer') -eq $true) {
        return Update-SemVer -Path $Path -AutoUpdate
    }
}