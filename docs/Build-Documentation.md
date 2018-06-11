---
external help file: MK.PowerShell.4PS-help.xml
Module Name: MK.PowerShell.4PS
online version: https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Build-Documentation.md
schema: 2.0.0
---

# Build-Documentation

## SYNOPSIS
Creates or updates help documentation files and module's README file.  Also creates a XML based help documentation file for PowerShell.

## SYNTAX

### ByName
```
Build-Documentation -Name <String> [-MarkdownFolder <String>] [-Locale <String>]
 [-OnlineVersionUrlTemplate <String>] [-OnlineVersionUrlPolicy <String>] [-NoReImportModule]
 [<CommonParameters>]
```

### ByPath
```
Build-Documentation [-Path] <String> [-MarkdownFolder <String>] [-Locale <String>]
 [-OnlineVersionUrlTemplate <String>] [-OnlineVersionUrlPolicy <String>] [-NoReImportModule]
 [<CommonParameters>]
```

## DESCRIPTION
With required [`PlatyPS`](https://github.com/PowerShell/platyPS) module, this function will generate Markdown help documentation files (such as the file where you are reading this from) and update or create a README.md file with new functions from the help docs.  Also this generates a new PowerShell help doc file that is used in the CLI.

This function simply takes the parameter values into an object and pipes it to the following:

## EXAMPLES

### Example 1
```powershell
PS C:\Users\Alice\PowerSploit> Build-Documentation
```

Builds documentation for the PowerSploit module with default parameters.

## PARAMETERS

### -Locale
The name of the folder where PowerShell XML file will reside.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: en-US
Accept pipeline input: False
Accept wildcard characters: False
```

### -MarkdownFolder
A relative path of module's folder where the Markdown files reside or will reside.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: docs
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
If the module is already imported, the value is the name of the module.

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

### -NoReImportModule
By default this function will re-import module to get the latest changes to that modules source code.

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

### -OnlineVersionUrlPolicy
{{Fill OnlineVersionUrlPolicy Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Auto, Omit

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnlineVersionUrlTemplate
{{Fill OnlineVersionUrlTemplate Description}}

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

### -Path
Folder that contains a module.

```yaml
Type: String
Parameter Sets: ByPath
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### MKPowerShellDocObject

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[`Build-PlatyPSMarkdown`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Build-PlatyPSMarkdown.md)

[`New-ExternalHelpFromPlatyPSMarkdown`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/New-ExternalHelpFromPlatyPSMarkdown.md)

[`Update-ReadmeFromPlatyPSMarkdown`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Update-ReadmeFromPlatyPSMarkdown.md)
