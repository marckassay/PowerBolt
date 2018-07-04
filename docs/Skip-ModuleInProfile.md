---
external help file: MK.PowerShell.Flow-help.xml
Module Name: MK.PowerShell.Flow
online version: https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.4/docs/Skip-ModuleInProfile.md
schema: 2.0.0
---

# Skip-ModuleInProfile

## SYNOPSIS
Prevents an `Import-Module` statement in `$PROFILE` from executing.

## SYNTAX

```
Skip-ModuleInProfile [[-ProfilePath] <String>] [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
With `Name` param being a dynamic valid set of module names in `$PROFILE`, when called with one of these names it will comment (`#`) the Import-Module statement for that module.

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
Accepted values: <ModuleName>

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

[Skip-ModuleInProfile.ps1](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.4/src/profile/Skip-ModuleInProfile.ps1)

[Skip-ModuleInProfile.Tests.ps1](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.4/test/profile/Skip-ModuleInProfile.Tests.ps1)

[`Add-ModuleToProfile`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.4/docs/Add-ModuleToProfile.md)

[`Reset-ModuleInProfile`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.4/docs/Reset-ModuleInProfile.md)
