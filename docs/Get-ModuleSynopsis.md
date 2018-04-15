---
external help file: MKPowerShell-help.xml
Module Name: MKPowerShell
online version: https://github.com/marckassay/MKPowerShell/blob/master/docs/Get-ModuleSynopsis.md
schema: 2.0.0
---

# Get-ModuleSynopsis

## SYNOPSIS
Lists all available functions for a module, with the synopsis of the functions.

## SYNTAX

```
Get-ModuleSynopsis -Name <String> [<CommonParameters>]
```

## DESCRIPTION
Lists all available functions of a module using Get-Command and Get-Help.

## EXAMPLES

### EXAMPLE 1

```
E:\\> Get-ModuleSynopsis Microsoft.PowerShell.Utility


Name                      Synopsis
----                      --------
ConvertFrom-SddlString
Format-Hex                Displays a file or other input as hexadecimal.
Get-FileHash              Computes the hash value for a file by using a specified hash algorithm.
Import-PowerShellDataFile
New-Guid                  Creates a GUID.
New-TemporaryFile         Creates a temporary file.
Add-Member                Adds custom properties and methods to an instance of a Windows PowerShell object.
Add-Type                  Adds a.NET Framework type (a class) to a Windows PowerShell session.
```

## PARAMETERS

### -Name
Dynamic parameter the retrieves the name of available modules

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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

### PSCustomObject

## NOTES

## RELATED LINKS

[Get-Module](https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Core/Get-Module)
