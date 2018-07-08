---
external help file: PowerBolt-help.xml
Module Name: PowerBolt
online version: https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Get-PowerBoltSetting.md
schema: 2.0.0
---

# Get-PowerBoltSetting

## SYNOPSIS
Retrieves JSON data from `PowerBolt-config.json` or outputs file via `ShowAll` switch.

## SYNTAX

```
Get-PowerBoltSetting [[-ConfigFilePath] <String>] [[-Name] <String>] [<CommonParameters>]
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
Accepted values: TurnOnAutoUpdateSemVer, NuGetApiKey

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

[Get-PowerBoltSetting.ps1](https://github.com/marckassay/PowerBolt/blob/0.0.4/src/settings/Get-PowerBoltSetting.ps1)

[Get-PowerBoltSetting.Tests.ps1](https://github.com/marckassay/PowerBolt/blob/0.0.4/test/settings/Get-PowerBoltSetting.Tests.ps1)

[`Set-PowerBoltSetting`](https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Set-PowerBoltSetting.md)
