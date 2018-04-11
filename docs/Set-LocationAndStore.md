---
external help file: MKPowerShell-help.xml
Module Name: MKPowerShell
online version:
schema: 2.0.0
---

# Set-LocationAndStore

## SYNOPSIS
Stores last location and restores that location when PowerShell restarts

## SYNTAX

```
Set-LocationAndStore [[-Path] <String>] [-LiteralPath <String>] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION
Stores last value of and restores that location when PowerShell restarts so that it continues in the directory you last were in previous session. This will override the alias 'sl' (Set-Location).

# .ALIAS
sl

## EXAMPLES

### EXAMPLE 1
```
PS C:\> sl .\projects
```

PS C:\projects\> sl..

## PARAMETERS

### -Path
Passed directly to Set-Location
```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LiteralPath
Passed directly to Set-Location

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
Passed directly to Set-Location

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Management.Automation.PathInfo, System.Management.Automation.PathInfoStack

## NOTES

## RELATED LINKS

[Set-Location](https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Management/Set-Location)
