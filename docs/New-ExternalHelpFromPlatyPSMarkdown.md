---
external help file: MK.PowerShell.4PS-help.xml
Module Name: MK.PowerShell.4PS
online version: https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/New-ExternalHelpFromPlatyPSMarkdown.md
schema: 2.0.0
---

# New-ExternalHelpFromPlatyPSMarkdown

## SYNOPSIS
Calls `New-ExternalHelp` from `PlatyPS` module.  This functions will read the files in the folder 
from `Build-PlatyPSMarkdown`.

## SYNTAX

```
New-ExternalHelpFromPlatyPSMarkdown [[-Data] <MKPowerShellDocObject>] [[-Path] <String>]
 [[-MarkdownFolder] <String>] [[-OutputFolder] <String>] [<CommonParameters>]
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
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

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

### -OutputFolder
{{Fill OutputFolder Description}}

```yaml
Type: String
Parameter Sets: (All)
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
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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

[`Build-Documentation`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Build-Documentation.md)

[`Build-PlatyPSMarkdown`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Build-PlatyPSMarkdown.md)

[`Update-ReadmeFromPlatyPSMarkdown`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Update-ReadmeFromPlatyPSMarkdown.md)
