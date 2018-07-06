---
external help file: PowerEquip-help.xml
Module Name: PowerEquip
online version: https://github.com/marckassay/PowerEquip/blob/0.0.4/docs/Get-MKPowerShellSetting.md
schema: 2.0.0
---

# Get-MKPowerShellSetting

## SYNOPSIS
Retrieves JSON data from `MK.PowerShell-config.json` or outputs file via `ShowAll` switch.

## SYNTAX

```
Get-MKPowerShellSetting [[-ConfigFilePath] <String>] [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ConfigFilePath
{{Fill ConfigFilePath Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
{{Fill Name Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: TurnOnBackup, LastLocation, Backups, TurnOnAutoUpdateSemVer, NuGetApiKey, TurnOnExtendedTypes, HistoryLocation, TurnOnQuickRestart, TurnOnExtendedFormats, TurnOnHistoryRecording, BackupPolicy, TurnOnRememberLastLocation, TurnOnAvailableUpdates

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Get-MKPowerShellSetting.ps1](https://github.com/marckassay/PowerEquip/blob/0.0.4/src/settings/Get-MKPowerShellSetting.ps1)

[Get-MKPowerShellSetting.Tests.ps1](https://github.com/marckassay/PowerEquip/blob/0.0.4/test/settings/Get-MKPowerShellSetting.Tests.ps1)

[`Set-MKPowerShellSetting`](https://github.com/marckassay/PowerEquip/blob/0.0.4/docs/Set-MKPowerShellSetting.md)
