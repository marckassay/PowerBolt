
using module .\New-DynamicParam.ps1

function GetSettingsNameSet {
    [CmdletBinding(PositionalBinding = $False)]
    Param(
        [Parameter(Mandatory = $true)]
        [String]$ConfigFilePath
    )

    $Script:MKPowerShellConfig = Get-Content -Path $ConfigFilePath | ConvertFrom-Json -AsHashtable
    $SettingNames = $Script:MKPowerShellConfig | ForEach-Object { $_.Keys }

    New-DynamicParam -Name 'Name' -Mandatory -Position 0 -ValidateSet $SettingNames
}