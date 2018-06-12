
using module .\New-DynamicParam.ps1

function GetSettingsNameSet {
    [CmdletBinding(PositionalBinding = $False)]
    Param(
        [Parameter(Mandatory = $true)]
        [String]$ConfigFilePath,

        [Parameter(Mandatory = $False)]
        [int]$Position = 0,

        [switch]$Mandatory
    )

    $Script:MKPowerShellConfig = Get-Content -Path $ConfigFilePath | ConvertFrom-Json -AsHashtable
    $SettingNames = $Script:MKPowerShellConfig | ForEach-Object { $_.Keys }

    New-DynamicParam -Name 'Name' -Mandatory:$Mandatory.IsPresent -Position $Position -ValidateSet $SettingNames
}