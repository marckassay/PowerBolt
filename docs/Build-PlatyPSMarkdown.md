---
external help file: PowerEquip-help.xml
Module Name: PowerEquip
online version: https://github.com/marckassay/PowerEquip/blob/0.0.4/docs/Build-PlatyPSMarkdown.md
schema: 2.0.0
---

# Build-PlatyPSMarkdown

## SYNOPSIS
With required [`PlatyPS`](https://github.com/PowerShell/platyPS) module, calls [`New-MarkdownHelp`](https://github.com/PowerShell/platyPS/blob/master/docs/New-MarkdownHelp.md) or [`Update-MarkdownHelpModule`](https://github.com/PowerShell/platyPS/blob/master/docs/Update-MarkdownHelpModule.md).

## SYNTAX

### ByPath (Default)
```
Build-PlatyPSMarkdown [[-Path] <String>] [-MarkdownFolder <String>] [-Locale <String>]
 [-OnlineVersionUrlTemplate <String>] [-OnlineVersionUrlPolicy <String>] [-RemoveSourceAndTestLinks]
 [-NoReImportModule] [-Force] [<CommonParameters>]
```

### ByPipe
```
Build-PlatyPSMarkdown [-DocInfo] <MKDocumentationInfo> [-MarkdownFolder <String>] [-Locale <String>]
 [-OnlineVersionUrlTemplate <String>] [-OnlineVersionUrlPolicy <String>] [-RemoveSourceAndTestLinks]
 [-NoReImportModule] [-Force] [<CommonParameters>]
```

### ByName
```
Build-PlatyPSMarkdown [-MarkdownFolder <String>] [-Locale <String>] [-OnlineVersionUrlTemplate <String>]
 [-OnlineVersionUrlPolicy <String>] [-RemoveSourceAndTestLinks] [-NoReImportModule] [-Force] [-Name] <String>
 [<CommonParameters>]
```

## DESCRIPTION
If no Markdown files are in `MarkdownFolder`, this function will call `New-MarkdownHelp`. Else it will call `Update-MarkdownHelpModule`. After `New-MarkdownHelp` is executed it will iterate thru the newly Markdown files and add the online version url to file. This value, by default, is retrieved from a .git directory (if there is one) of the module.

## EXAMPLES

### Example 1
```powershell
PS C:\> Build-PlatyPSMarkdown -Path C:\Users\Alice\PowerSploit -NoReImportModule
```

With specified `Path` value and `NoReImportModule` switched, this will generate (new or update) files for PowerSploit module. The `NoReImportModule` prevents re-importing PowerSploit so the current state of this imported module is used. In otherwords, if changes to the source code of PowerSploit has been made it will not be available until it is imported again. And because of that `NoReImportModule` is typically not switched.

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
Accepted values: CimCmdlets, Microsoft.PowerShell.Management, Microsoft.PowerShell.Utility, PowerEquip, Pester, Plaster, Plaster, platyPS, posh-git, PSReadLine

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoReImportModule
Prevents re-importing module prior to executing PlatyPS's `New-MarkdownHelp` or `Update-MarkdownHelpModule`.

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

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
{{Fill Force Description}}

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

### -RemoveSourceAndTestLinks
{{Fill RemoveSourceAndTestLinks Description}}

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

### MKPowerShellDocObject

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Build-PlatyPSMarkdown.ps1](https://github.com/marckassay/PowerEquip/blob/0.0.4/src/documentation/Build-PlatyPSMarkdown.ps1)

[Build-PlatyPSMarkdown.Tests.ps1](https://github.com/marckassay/PowerEquip/blob/0.0.4/test/documentation/Build-PlatyPSMarkdown.Tests.ps1)

[`Build-Documentation`](https://github.com/marckassay/PowerEquip/blob/0.0.4/docs/Build-Documentation.md)

[`New-ExternalHelpFromPlatyPSMarkdown`](https://github.com/marckassay/PowerEquip/blob/0.0.4/docs/New-ExternalHelpFromPlatyPSMarkdown.md)

[`Update-ReadmeFromPlatyPSMarkdown`](https://github.com/marckassay/PowerEquip/blob/0.0.4/docs/Update-ReadmeFromPlatyPSMarkdown.md)
