---
external help file: MK.PowerShell.Flow-help.xml
Module Name: MK.PowerShell.Flow
online version: https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.2/docs/Set-LocationAndStore.md
schema: 2.0.0
---

# Set-LocationAndStore

## SYNOPSIS
Records every time `sl` is called so that when new session launches, location will be the one last record. Default alias value for this function is `sl`.

## SYNTAX

```
Set-LocationAndStore [[-Path] <String>] [-LiteralPath <String>] [-PassThru] [<CommonParameters>]
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

### -LiteralPath
{{Fill LiteralPath Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
{{Fill PassThru Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
{{Fill Path Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

[Set-LocationAndStore.ps1](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.2/src/management/Set-LocationAndStore.ps1)

[Set-LocationAndStore.Tests.ps1](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.2/test/management/Set-LocationAndStore.Tests.ps1)
