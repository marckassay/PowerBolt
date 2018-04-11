---
external help file: MKPowerShell-help.xml
Module Name: MKPowerShell
online version:
schema: 2.0.0
---

# Set-BackupProfileLocation

## SYNOPSIS
To be used to set the value of a folder so MKPowerShell backs-up the sessions profile script ($PROFILE)
## SYNTAX

```
Set-BackupProfileLocation [-Value] <String> [<CommonParameters>]
```

## DESCRIPTION
Upon PowerShell startup, the session's profile script ($PROFILE) will be copied to the value set by this function.

## EXAMPLES

### EXAMPLE 1
```
Set-BackupProfileLocation 'D:\Google Drive\Documents\PowerShell'
```

## PARAMETERS

### -Value
Path to a folder

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[Backup-PowerShellProfile](https://github.com/marckassay/MKPowerShell/blob/master/docs/Backup-PowerShellProfile.md)

[Update-PowerShellProfile](https://github.com/marckassay/MKPowerShell/blob/master/docs/Update-PowerShellProfile.md)
