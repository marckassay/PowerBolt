using module .\src\documentation\Build-Documentation.ps1
using module .\src\documentation\Build-PlatyPSMarkdown.ps1
using module .\src\documentation\New-ExternalHelpFromPlatyPSMarkdown.ps1
using module .\src\documentation\Update-ReadmeFromPlatyPSMarkdown.ps1
using module .\src\error\Get-LatestError.ps1
using module .\src\management\Set-LocationAndStore.ps1
using module .\src\module\Get-ModuleInfo.ps1
using module .\src\module\manifest\Update-ManifestFunctionsToExportField.ps1
using module .\src\module\Update-RootModuleUsingStatements.ps1
using module .\src\profile\Add-ModuleToProfile.ps1
using module .\src\settings\Get-MKPowerShellSetting.ps1 
using module .\src\settings\New-MKPowerShellConfigFile.ps1
using module .\src\settings\Set-MKPowerShellSetting.ps1
using module .\src\publish\Publish-ModuleToNuGetGallery.ps1
using module .\src\management\Start-MKPowerShell.ps1
using module .\src\events\Register-Shutdown.ps1
using module .\src\management\Restart-PWSH.ps1
using module .\src\management\Restart-PWSHAdmin.ps1
using module .\src\history\Export-History.ps1
using module .\src\history\Import-History.ps1

Param(
    [Parameter(Mandatory = $False)]
    [String]$ConfigFilePath = $([Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData) + "\MK.PowerShell\MK.PowerShell-config.json")
)

$script:MKPowerShellConfigFilePath = $ConfigFilePath

Start-MKPowerShell -ConfigFilePath $script:MKPowerShellConfigFilePath