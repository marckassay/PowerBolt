---
external help file: PowerEquip-help.xml
Module Name: PowerEquip
online version: https://github.com/marckassay/PowerEquip/blob/0.0.4/docs/Reset-ModuleInProfile.md
schema: 2.0.0
---

# Reset-ModuleInProfile

## SYNOPSIS
Re-enables an `Import-Module` statement in `$PROFILE` to be executed. 

## SYNTAX

```
Reset-ModuleInProfile [[-ProfilePath] <String>] [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
With `Name` param being a dynamic valid set of module names in `$PROFILE`, when called with one of these names it will uncomment (remove the prefix `#`) from the Import-Module statement for that module.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Name
{{Fill Name Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: PowerShellGet, Plaster

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProfilePath
{{Fill ProfilePath Description}}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Reset-ModuleInProfile.ps1](https://github.com/marckassay/PowerEquip/blob/0.0.4/src/profile/Reset-ModuleInProfile.ps1)

[Reset-ModuleInProfile.Tests.ps1](https://github.com/marckassay/PowerEquip/blob/0.0.4/test/profile/Reset-ModuleInProfile.Tests.ps1)

[`Add-ModuleToProfile`](https://github.com/marckassay/PowerEquip/blob/0.0.4/docs/Add-ModuleToProfile.md)

[`Skip-ModuleInProfile`](https://github.com/marckassay/PowerEquip/blob/0.0.4/docs/Skip-ModuleInProfile.md)
