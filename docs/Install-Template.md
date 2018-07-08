---
external help file: PowerBolt-help.xml
Module Name: PowerBolt
online version: https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Install-Template.md
schema: 2.0.0
---

# Install-Template

## SYNOPSIS
Scaffolds files based on the required [Plaster](https://github.com/PowerShell/Plaster) template.

## SYNTAX

### ByTemplatePath (Default)
```
Install-Template [-TemplatePath] <String> [-ScriptCongruentPath] <String> [-ScriptName] <String>
 [<CommonParameters>]
```

### ByTemplateName
```
Install-Template [-TemplateName] <String> [<CommonParameters>]
```

## DESCRIPTION
When `PlasterTemplatePath` is set to a Plaster template, this script will inspect the template for variables that will become additional parameters. Those variables must be in the form of the Plaster style variables. For an example: 'PLASTER_PARAM_CongruentPath', where 'CongruentPath' is the variable that will appear as an additional parameter.

If calling this method by script and not thru the CLI, positional binding is enabled so that can be done.

## EXAMPLES

### Example 1
```powershell
PS C:\> Install-Template -PlasterTemplatePath 'C:\Users\Alice\PlasterTemplates\NewMVC\plasterManifest_en-US.xml' -AppName 'CoffeeApp'
```

One can deduce that the variable 'PLASTER_PARAM_AppName' is in the template file, which is used in this example to assign a name value to the app being scaffold.

## PARAMETERS

### -ScriptCongruentPath
{{Fill ScriptCongruentPath Description}}

```yaml
Type: String
Parameter Sets: ByTemplatePath
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptName
{{Fill ScriptName Description}}

```yaml
Type: String
Parameter Sets: ByTemplatePath
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TemplateName
{{Fill TemplateName Description}}

```yaml
Type: String
Parameter Sets: ByTemplateName
Aliases:
Accepted values: NewScript, NewModuleProject

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TemplatePath
A path value to a Plaster template (manifest) file.

```yaml
Type: String
Parameter Sets: ByTemplatePath
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

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Install-Template.ps1](https://github.com/marckassay/PowerBolt/blob/0.0.4/src/scaffolds/Install-Template.ps1)

[Install-Template.Tests.ps1](https://github.com/marckassay/PowerBolt/blob/0.0.4/test/scaffolds/Install-Template.Tests.ps1)

[Plaster - Creating A Manifest](https://github.com/PowerShell/Plaster/blob/master/docs/en-US/about_Plaster_CreatingAManifest.help.md)
