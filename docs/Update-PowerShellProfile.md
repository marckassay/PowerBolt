---
external help file: MKPowerShell-help.xml
Module Name: MKPowerShell
online version:
schema: 2.0.0
---

# Update-PowerShellProfile

## SYNOPSIS
Internal function that updates other PowerShell profiles with the session's profile script ($PROFILE)

## SYNTAX

```
Update-PowerShellProfile [-Path <String>] [-Include <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Currently this is hard-coded to only update VSCode profile. 
Obviously this will need to be changed
to live up to its name.

## EXAMPLES

### EXAMPLE 1
```

```

## PARAMETERS

### -Path
Paths to PowerShell profiles.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: "$args\Microsoft.VSCode_profile.ps1"
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

### None

## NOTES
$args is being used here for for Register-ObjectEvent scope

## RELATED LINKS

[Backup-PowerShellProfile](https://github.com/marckassay/MKPowerShell/blob/master/docs/Backup-PowerShellProfile.md)

[Set-BackupProfileLocation](https://github.com/marckassay/MKPowerShell/blob/master/docs/Set-BackupProfileLocation.md)
