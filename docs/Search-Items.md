---
external help file: MK.PowerShell.4PS-help.xml
Module Name: MK.PowerShell.4PS
online version: https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Search-Items.md
schema: 2.0.0
---

# Search-Items

## SYNOPSIS
Recurses thru folders to find files that its content matches `Pattern`.  Outputs object(s) to console.

## SYNTAX

```
Search-Items [-Path] <String> [-Pattern] <String[]> [[-Include] <String[]>] [[-Exclude] <String[]>] [-Recurse]
 [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> Search-Items -Path C:\Users\Alice\MK.PowerShell.4PS -Pattern '.*TODO.*' -Recurse

Name                           Value
----                           -----
Item                           ConvertTo-EnumFlag.ps1
Match                          # TODO: look into EnumConverter to see if it can be used here
MatchedLine                    # TODO: look into EnumConverter to see if it can be used here
Item                           MKPowerShellDocObject.psm1
Match                          # TODO: need to have this functions arity better fitted for options
MatchedLine                        # TODO: need to have this functions arity better fitted for options
...
```

{{ Add example description here }}

## PARAMETERS

### -Exclude
{{Fill Exclude Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Include
{{Fill Include Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Pattern
{{Fill Pattern Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recurse
{{Fill Recurse Description}}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Search-Items.ps1](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/src/utility/Search-Items.ps1)

[Search-Items.Tests.ps1](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/test/utility/Search-Items.Tests.ps1)
