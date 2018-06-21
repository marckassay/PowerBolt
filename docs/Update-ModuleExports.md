---
external help file: MK.PowerShell.4PS-help.xml
Module Name: MK.PowerShell.4PS
online version: https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Update-ModuleExports.md
schema: 2.0.0
---

# Update-ModuleExports

## SYNOPSIS
Updates root-module and manifest file with commands to be exported.

## SYNTAX

### ByPath (Default)
```
Update-ModuleExports [[-Path] <String>] [-SourceFolderPath <String>] [[-Include] <String[]>]
 [[-Exclude] <String[]>] [-PassThru] [<CommonParameters>]
```

### ByName
```
Update-ModuleExports [-SourceFolderPath <String>] [[-Include] <String[]>] [[-Exclude] <String[]>] [-PassThru]
 -Name <String> [<CommonParameters>]
```

## DESCRIPTION
When called, it will search for .ps1 files in the `SourceDirectory` and update the root module with `using module` statements with the files it has found. If anywhere in the file a `# NoExport: <Command>` comment is found, it will omit that command from being listed in the manifest file. Also all commands that are intended to be exported must follow the PowerShell convention of `<verb>-<noun>`.

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

### -Name
{{Fill Name Description}}

```yaml
Type: String
Parameter Sets: ByName
Aliases:

Required: True
Position: Named
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

[Update-ModuleExports.ps1](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/src/module/Update-ModuleExports.ps1)

[Update-ModuleExports.Tests.ps1](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/test/module/Update-ModuleExports.Tests.ps1)
