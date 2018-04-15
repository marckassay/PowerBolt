---
external help file: MKPowerShell-help.xml
Module Name: MKPowerShell
online version: https://github.com/marckassay/MKPowerShell/blob/master/docs/Export-History.md
schema: 2.0.0
---

# Export-History

## SYNOPSIS
Internal async function for MKPowerShell, to update CSV file of histories

## SYNTAX

```
Export-History [<CommonParameters>]
```

## DESCRIPTION
When PowerShell starts, it will load the previous CSV file (via Import-Csv) and concatnate (via Add-History) it to current session. 
Doing this allows you to reference previous command from any previous session using the Show-History.

## EXAMPLES

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[Show-History](https://github.com/marckassay/MKPowerShell/blob/master/docs/Show-History.md)
