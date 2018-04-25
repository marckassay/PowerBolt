Get-Content -Path (Resolve-Path -Path .\src\script\Import-Script.ps1) -Raw | Invoke-Expression
. .\src\manifest\Update-ManifestFunctionsToExportField.ps1
. .\src\module\Update-RootModuleDotSourceImports.ps1
. .\src\settings\New-MKPowerShellConfigFile.ps1
. .\src\profile\Add-ModuleToProfile.ps1