---
external help file: MK.PowerShell.Flow-help.xml
Module Name: MK.PowerShell.Flow
online version: https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.1/docs/Install-Template.md
schema: 2.0.0
---

# Install-Template

## SYNOPSIS
Scaffolds files based on the required [Plaster](https://github.com/PowerShell/Plaster) template.

## SYNTAX

```
Install-Template -PlasterTemplatePath <String> -ScriptCongruentPath <String> -ScriptName <String>
 [<CommonParameters>]
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

### -PlasterTemplatePath
A path value to a Plaster template (manifest) file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptCongruentPath
{{Fill ScriptCongruentPath Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptName
{{Fill ScriptName Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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

[Install-Template.ps1](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.1/src/scaffolds/Install-Template.ps1)

[Install-Template.Tests.ps1](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.1/test/scaffolds/Install-Template.Tests.ps1)

[Plaster - Creating A Manifest](https://github.com/PowerShell/Plaster/blob/master/docs/en-US/about_Plaster_CreatingAManifest.help.md)
