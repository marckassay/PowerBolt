using module .\src\documentation\Build-Documentation.ps1
using module .\src\documentation\Build-PlatyPSMarkdown.ps1
using module .\src\documentation\New-ExternalHelpFromPlatyPSMarkdown.ps1
using module .\src\documentation\Update-ReadmeFromPlatyPSMarkdown.ps1
using module .\src\module\Get-MKModuleInfo.ps1
using module .\src\module\manifest\Update-ManifestFunctionsToExportField.ps1
using module .\src\module\manifest\Update-SemVer.ps1
using module .\src\module\Update-ModuleExports.ps1
using module .\src\module\Update-RootModuleUsingStatements.ps1
using module .\src\profile\Add-ModuleToProfile.ps1
using module .\src\profile\Reset-ModuleInProfile.ps1
using module .\src\profile\Skip-ModuleInProfile.ps1
using module .\src\publish\Publish-ModuleToNuGetGallery.ps1
using module .\src\scaffolds\Install-Template.ps1
using module .\src\settings\Get-MKPowerShellSetting.ps1
using module .\src\settings\New-MKPowerShellConfigFile.ps1
using module .\src\settings\Set-MKPowerShellSetting.ps1
using module .\src\test\Invoke-TestSuiteRunner.ps1
using module .\src\utility\ConvertTo-EnumFlag.ps1
using module .\src\utility\Get-MergedPath.ps1
using module .\src\utility\Search-Items.ps1

using module .\src\management\Start-MKPowerShell.ps1

Param(
    [Parameter(Mandatory = $false)]
    [String]$ConfigFilePath = $([Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData) + "\MK.PowerShell\MK.PowerShell-config.json"),

    [Parameter(Mandatory = $false)]
    [bool]$SUT = $false
)

$script:MKPowerShellConfigFilePath = $script:ConfigFilePath
$script:MKPowerShellSUT = $script:SUT

if ($script:SUT -eq $false) {
    Start-MKPowerShell -ConfigFilePath $script:MKPowerShellConfigFilePath
}
