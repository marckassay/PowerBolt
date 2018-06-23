---
external help file: MK.PowerShell.Flow-help.xml
Module Name: MK.PowerShell.Flow
online version: https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.2/docs/Update-RootModuleUsingStatements.md
schema: 2.0.0
---

# Update-RootModuleUsingStatements

## SYNOPSIS
Prepends module found in `Path` with `using module ...` statements. Those statements are unique PS1 file paths that contain functions.

## SYNTAX

### ByPath (Default)
```
Update-RootModuleUsingStatements [[-Path] <String>] [-SourceFolderPath <String>] [-Include <String[]>]
 [-Exclude <String[]>] [-PassThru] [<CommonParameters>]
```

### ByPipe
```
Update-RootModuleUsingStatements [[-ModInfo] <MKModuleInfo>] [-SourceFolderPath <String>] [-Include <String[]>]
 [-Exclude <String[]>] [-PassThru] [<CommonParameters>]
```

### ByName
```
Update-RootModuleUsingStatements [-SourceFolderPath <String>] [-Include <String[]>] [-Exclude <String[]>]
 [-PassThru] [-Name] <String> [<CommonParameters>]
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

### -Exclude
{{Fill Exclude Description}}

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

### -ModInfo
{{Fill ModInfo Description}}

```yaml
Type: MKModuleInfo
Parameter Sets: ByPipe
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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

[Update-RootModuleUsingStatements.ps1](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.2/src/module/Update-RootModuleUsingStatements.ps1)

[Update-RootModuleUsingStatements.Tests.ps1](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.2/test/module/Update-RootModuleUsingStatements.Tests.ps1)

[`Update-ManifestFunctionsToExportField`](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.2/docs/Update-ManifestFunctionsToExportField.md)
