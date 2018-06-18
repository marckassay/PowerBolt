---
external help file: MK.PowerShell.4PS-help.xml
Module Name: MK.PowerShell.4PS
online version: https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Update-ReadmeFromPlatyPSMarkdown.md
schema: 2.0.0
---

# Update-ReadmeFromPlatyPSMarkdown

## SYNOPSIS
Adds or updates function's 'snippet' in README file from `PlatyPS` generated files.

## SYNTAX

### ByPath (Default)
```
Update-ReadmeFromPlatyPSMarkdown [[-Path] <String>] [[-MarkdownFolder] <String>] [-FileName <String>]
 [<CommonParameters>]
```

### ByPipe
```
Update-ReadmeFromPlatyPSMarkdown -DocInfo <MKDocumentationInfo> [[-MarkdownFolder] <String>]
 [-FileName <String>] [<CommonParameters>]
```

### ByName
```
Update-ReadmeFromPlatyPSMarkdown [[-MarkdownFolder] <String>] [-FileName <String>] -Name <String>
 [<CommonParameters>]
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

### -MarkdownFolder
{{Fill MarkdownFolder Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DocInfo
{{Fill DocInfo Description}}

```yaml
Type: MKDocumentationInfo
Parameter Sets: ByPipe
Aliases:

Required: True
Position: Named
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

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileName
{{Fill FileName Description}}

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

### MKPowerShellDocObject

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

- [Update-ReadmeFromPlatyPSMarkdown.ps1](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/src/documentation/Update-ReadmeFromPlatyPSMarkdown.ps1)
- [Update-ReadmeFromPlatyPSMarkdown.Tests.ps1](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/test/documentation/Update-ReadmeFromPlatyPSMarkdown.Tests.ps1)
- [`Build-Documentation`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Build-Documentation.md)
- [`Build-PlatyPSMarkdown`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Build-PlatyPSMarkdown.md)
- [`New-ExternalHelpFromPlatyPSMarkdown`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/New-ExternalHelpFromPlatyPSMarkdown.md)
