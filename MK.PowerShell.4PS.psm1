using module .\src\profile\Add-ModuleToProfile.ps1
using module .\src\module\manifest\Update-ManifestFunctionsToExportField.ps1
using module .\src\module\Update-RootModuleUsingStatements.ps1
using module .\src\settings\New-MKPowerShellConfigFile.ps1
using module .\src\settings\Get-MKPowerShellSetting.ps1
using module .\src\settings\Set-MKPowerShellSetting.ps1
using module .\src\module\Get-ModuleInfo.ps1
using module .\src\management\Set-LocationAndStore.ps1

[String]$MKPowerShellConfigFilePath = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData) + "\MK.PowerShell\MK.PowerShell-config.ps1"
if ((Test-Path -Path $MKPowerShellConfigFilePath) -eq $true) {
    if ((Get-MKPowerShellSetting -Path $MKPowerShellConfigFilePath -Name 'TurnOnRememberLastLocation') -eq $true) {
        Set-Alias sl Set-LocationAndStore -Scope Global -Force
        Write-Host "'sl' alias is now mapped to 'Set-LocationAndStore'." -ForegroundColor Green
    }
}
else {
    $MKPowerShellConfigFolderPath = $(Split-Path $MKPowerShellConfigFilePath -Parent)
    New-Item -Path $MKPowerShellConfigFolderPath -ItemType Directory

    $ModuleConfigFilePath = "$PSScriptRoot\resources\MK.PowerShell-config.ps1"
    Copy-Item -Path $ModuleConfigFilePath -Destination $MKPowerShellConfigFolderPath -Verbose -PassThru
}