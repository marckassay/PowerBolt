---
external help file: PowerEquip-help.xml
Module Name: PowerEquip
online version: https://github.com/marckassay/PowerEquip/blob/0.0.4/docs/New-ExternalHelpFromPlatyPSMarkdown.md
schema: 2.0.0
---

# New-ExternalHelpFromPlatyPSMarkdown

## SYNOPSIS
Calls `New-ExternalHelp` from `PlatyPS` module. This functions will read the files in the folder from `Build-PlatyPSMarkdown`.

## SYNTAX

### ByPath (Default)
```
New-ExternalHelpFromPlatyPSMarkdown [[-Path] <String>] [-MarkdownFolder <String>] [-OutputFolder <String>]
 [<CommonParameters>]
```

### ByPipe
```
New-ExternalHelpFromPlatyPSMarkdown [-DocInfo] <MKDocumentationInfo> [-MarkdownFolder <String>]
 [-OutputFolder <String>] [<CommonParameters>]
```

### ByName
```
New-ExternalHelpFromPlatyPSMarkdown [-MarkdownFolder <String>] [-OutputFolder <String>] [-Name] <String>
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

### -DocInfo
{{Fill DocInfo Description}}

```yaml
Type: MKDocumentationInfo
Parameter Sets: ByPipe
Aliases:

Required: True
Position: 1
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
Position: Named
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
Accepted values: CimCmdlets, Microsoft.PowerShell.Management, Microsoft.PowerShell.Utility, PowerEquip, Pester, Plaster, Plaster, platyPS, posh-git, PSReadLine

Required: True
Position: 0
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### MKPowerShellDocObject

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[New-ExternalHelpFromPlatyPSMarkdown.ps1](https://github.com/marckassay/PowerEquip/blob/0.0.4/src/documentation/New-ExternalHelpFromPlatyPSMarkdown.ps1)

[New-ExternalHelpFromPlatyPSMarkdown.Tests.ps1](https://github.com/marckassay/PowerEquip/blob/0.0.4/test/documentation/New-ExternalHelpFromPlatyPSMarkdown.Tests.ps1)

[`Build-Documentation`](https://github.com/marckassay/PowerEquip/blob/0.0.4/docs/Build-Documentation.md)

[`Build-PlatyPSMarkdown`](https://github.com/marckassay/PowerEquip/blob/0.0.4/docs/Build-PlatyPSMarkdown.md)

[`Update-ReadmeFromPlatyPSMarkdown`](https://github.com/marckassay/PowerEquip/blob/0.0.4/docs/Update-ReadmeFromPlatyPSMarkdown.md)
