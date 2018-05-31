---
external help file: MK.PowerShell.4PS-help.xml
Module Name: MK.PowerShell.4PS
online version: https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Build-PlatyPSMarkdown.md
schema: 2.0.0
---

# Build-PlatyPSMarkdown

## SYNOPSIS
With required `PlatyPS` module, will call `New-MarkdownHelp` or `Update-MarkdownHelp` just once.

## SYNTAX

```
Build-PlatyPSMarkdown [-Data <MKPowerShellDocObject>] [[-Name] <String>] [-Path <String>]
 [-MarkdownFolder <String>] [-Locale <String>] [-OnlineVersionUrlTemplate <String>]
 [-OnlineVersionUrlPolicy <String>] [-ReadMeBeginBoundary <String>] [-ReadMeEndBoundary <String>]
 [-MarkdownSnippetCollection <String>] [-NoReImportModule] [<CommonParameters>]
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

### -Data
{{Fill Data Description}}

```yaml
Type: MKPowerShellDocObject
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Locale
{{Fill Locale Description}}

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

### -MarkdownFolder
{{Fill MarkdownFolder Description}}

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

### -MarkdownSnippetCollection
{{Fill MarkdownSnippetCollection Description}}

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

### -Name
{{Fill Name Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoReImportModule
{{Fill NoReImportModule Description}}

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
{{Fill Path Description}}

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

### -ReadMeBeginBoundary
{{Fill ReadMeBeginBoundary Description}}

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

### -ReadMeEndBoundary
{{Fill ReadMeEndBoundary Description}}

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

* [`Build-Documentation`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Build-Documentation.md)

* [`New-ExternalHelpFromPlatyPSMarkdown`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/New-ExternalHelpFromPlatyPSMarkdown.md)

* [`Update-ReadmeFromPlatyPSMarkdown`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Update-ReadmeFromPlatyPSMarkdown.md)
