---
external help file: MK.PowerShell.Flow-help.xml
Module Name: MK.PowerShell.Flow
online version: https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.2/docs/Update-SemVer.md
schema: 2.0.0
---

# Update-SemVer

## SYNOPSIS
Updates the module's semantic version value in the manifest file.

## SYNTAX

### ByPath (Default)
```
Update-SemVer [[-Path] <String>] [-Value <String>] [[-Major] <Int32>] [[-Minor] <Int32>] [[-Patch] <Int32>]
 [[-SourceFolderPath] <String>] [-BumpMajor] [-BumpMinor] [-BumpPatch] [-AutoUpdate] [<CommonParameters>]
```

### ByName
```
Update-SemVer [-Value <String>] [[-Major] <Int32>] [[-Minor] <Int32>] [[-Patch] <Int32>]
 [[-SourceFolderPath] <String>] [-BumpMajor] [-BumpMinor] [-BumpPatch] [-AutoUpdate] [-Name] <String>
 [<CommonParameters>]
```

### ByValue
```
Update-SemVer [-Value <String>] [[-SourceFolderPath] <String>] [<CommonParameters>]
```

### ByNumbers
```
Update-SemVer [[-Major] <Int32>] [[-Minor] <Int32>] [[-Patch] <Int32>] [[-SourceFolderPath] <String>]
 [<CommonParameters>]
```

### ByBumping
```
Update-SemVer [[-SourceFolderPath] <String>] [-BumpMajor] [-BumpMinor] [-BumpPatch] [<CommonParameters>]
```

### ByAutoUpdateSemVer
```
Update-SemVer [[-SourceFolderPath] <String>] [-AutoUpdate] [<CommonParameters>]
```

## DESCRIPTION
With given values by Path or Name, it will change the ModuleVersion key in the module's manifest file.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AutoUpdate
{{Fill AutoUpdate Description}}

```yaml
Type: SwitchParameter
Parameter Sets: ByPath, ByName, ByAutoUpdateSemVer
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BumpMajor
{{Fill BumpMajor Description}}

```yaml
Type: SwitchParameter
Parameter Sets: ByPath, ByName, ByBumping
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BumpMinor
{{Fill BumpMinor Description}}

```yaml
Type: SwitchParameter
Parameter Sets: ByPath, ByName, ByBumping
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BumpPatch
{{Fill BumpPatch Description}}

```yaml
Type: SwitchParameter
Parameter Sets: ByPath, ByName, ByBumping
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Major
{{Fill Major Description}}

```yaml
Type: Int32
Parameter Sets: ByPath, ByName, ByNumbers
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Minor
{{Fill Minor Description}}

```yaml
Type: Int32
Parameter Sets: ByPath, ByName, ByNumbers
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
{{Fill Name Description}}

```yaml
Type: String
Parameter Sets: ByName
Aliases:
Accepted values: CimCmdlets, Microsoft.PowerShell.Management, Microsoft.PowerShell.Utility, MK.PowerShell.Flow, Pester, Plaster, Plaster, platyPS, posh-git, PSReadLine

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Patch
{{Fill Patch Description}}

```yaml
Type: Int32
Parameter Sets: ByPath, ByName, ByNumbers
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
{{Fill Path Description}}

```yaml
Type: String
Parameter Sets: ByPath
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceFolderPath
{{Fill SourceFolderPath Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
{{Fill Value Description}}

```yaml
Type: String
Parameter Sets: ByPath, ByName, ByValue
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

[Update-SemVer.ps1](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.2/src/module/manifest/Update-SemVer.ps1)

[Update-SemVer.Tests.ps1](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.2/test/module/manifest/Update-SemVer.Tests.ps1)
