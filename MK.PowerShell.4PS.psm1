using module .\src\documentation\Build-Documentation.ps1
using module .\src\documentation\Build-PlatyPSMarkdown.ps1
using module .\src\documentation\New-ExternalHelpFromPlatyPSMarkdown.ps1
using module .\src\documentation\Update-ReadmeFromPlatyPSMarkdown.ps1
using module .\src\error\Get-LatestError.ps1
using module .\src\history\Export-History.ps1
using module .\src\history\Import-History.ps1
using module .\src\management\backupsources\Backup-Sources.ps1
using module .\src\management\Restart-PWSH.ps1
using module .\src\management\Restart-PWSHAdmin.ps1
using module .\src\management\Set-LocationAndStore.ps1
using module .\src\module\Get-ModuleInfo.ps1
using module .\src\module\manifest\Update-ManifestFunctionsToExportField.ps1
using module .\src\module\manifest\Update-SemVer.ps1
using module .\src\module\Update-ModuleExports.ps1
using module .\src\module\Update-RootModuleUsingStatements.ps1
using module .\src\profile\Add-ModuleToProfile.ps1
using module .\src\profile\Reset-ModuleInProfile.ps1
using module .\src\profile\Skip-ModuleInProfile.ps1
using module .\src\publish\Publish-ModuleToNuGetGallery.ps1
using module .\src\scaffolds\New-Script.ps1
using module .\src\settings\Get-MKPowerShellSetting.ps1
using module .\src\settings\New-MKPowerShellConfigFile.ps1
using module .\src\settings\Set-MKPowerShellSetting.ps1
using module .\src\utility\ConvertTo-EnumFlag.ps1
using module .\src\utility\Get-MergedPath.ps1
using module .\src\utility\Search-Items.ps1

using module .\src\management\Start-MKPowerShell.ps1

Param(
    [Parameter(Mandatory = $False)]
    [String]$ConfigFilePath = $([Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData) + "\MK.PowerShell\MK.PowerShell-config.json"),

    [Parameter(Mandatory = $False)]
    [bool]$SUT = $False
)

$script:MKPowerShellConfigFilePath = $script:ConfigFilePath
$script:MKPowerShellSUT = $script:SUT
if ($script:SUT -eq $False) {
    Start-MKPowerShell -ConfigFilePath $script:MKPowerShellConfigFilePath
}
