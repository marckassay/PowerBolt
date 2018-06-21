---
external help file: MK.PowerShell.4PS-help.xml
Module Name: MK.PowerShell.4PS
online version: https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Backup-Sources.md
schema: 2.0.0
---

# Backup-Sources

## SYNOPSIS
The `Backups` object defined in `MK.PowerShell-config.json` will copy items to their destination location.

## SYNTAX

```
Backup-Sources [-ConfigFilePath <String>] [-Force] [-Initialize] [<CommonParameters>]
```

## DESCRIPTION
When called with the `Force` switch param, it will disregard `TurnOnBackup` and `BackupPolicy` object in `MK.PowerShell-config.json` and continue to attempt to backup sources that are define in `Backups` object.

 `BackupPolicy` key is set to 'auto' by default and `TurnOnBackup` is set false. Ideally, when `TurnOnBackup` key is set to true prior to importing `MK.PowerShell.4PS`, this will be called and attempt to backup sources.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-MKPowerShellSetting -Name TurnOnBackup -Value $true
PS C:\> $BackupObject = @(
     @{
      UpdatePolicy = "Overwrite",
      Path = "C:\\Users\\Marc\\AppData\\Roaming\\Code\\User\\keybindings.json",
      Destination = "D:\\Google Drive\\Documents\\PowerShell\\"
    }
PS C:\> Set-MKPowerShellSetting -Name Backups -Value $BackupObject
)
```

This example enables `TurnOnBackup` and assigns one backup object to `Backups`. When `MK.PowerShell.4PS` imported next, it will attempt to overwrite the keybindings.json file if its in the `$Destination` folder. If there is no file in that folder it will simpily move it there. If `UpdatePolicy` had a value of `New`, it will move the file and to add an intger to its basename. For instance, for this example keybindings.json file will be keybindings(1).json.

## PARAMETERS

### -ConfigFilePath
The config file for `MK.PowerShell.4PS`.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $([Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData) + "\MK.PowerShell\MK.PowerShell-config.json")
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Will disregard values for `TurnOnBackup` and `BackupPolicy`.

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

### -Initialize
For internal for `MK.PowerShell.4PS` module.

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

[Backup-Sources.ps1](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/src/management/backupsources/Backup-Sources.ps1)

[Backup-Sources.Tests.ps1](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/test/management/backupsources/Backup-Sources.Tests.ps1)

[`Get-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Get-MKPowerShellSetting.md)

[`Set-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Set-MKPowerShellSetting.md)

[`New-MKPowerShellConfigFile`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/New-MKPowerShellConfigFile.md)
