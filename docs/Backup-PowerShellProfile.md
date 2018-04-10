---
external help file: MKPowerShell-help.xml
Module Name: MKPowerShell
online version:
schema: 2.0.0
---

# Backup-PowerShellProfile

## SYNOPSIS
Internal function called by MKPowerShell that will copy the session's profile script ($PROFILE) to the value set with MKPowerShell\Set-BackupProfileLocation.

## SYNTAX

```
Backup-PowerShellProfile [-Destination <String>] [<CommonParameters>]
```

## DESCRIPTION
Interal function to retrieve value from previous call to Set-BackupProfileLocation which then is used by Back-PowerShellProfile to make a copy of profile page.

## PARAMETERS

### -Destination
The value from MKPowerShell\Set-BackupProfileLocation.  This needs to be a URI to a folder.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None


## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Set-BackupProfileLocation]
[Update-PowerShellProfile]
