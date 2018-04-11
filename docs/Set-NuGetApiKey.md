---
external help file: MKPowerShell-help.xml
Module Name: MKPowerShell
online version:
schema: 2.0.0
---

# Set-NuGetApiKey

## SYNOPSIS
Stores NuGet API key to be used with Publish-ModuleToNuGetGallery

## SYNTAX

```
Set-NuGetApiKey [-Value] <String> [<CommonParameters>]
```

## DESCRIPTION
Stores NuGet API key in the registry so that when Publish-ModuleToNuGetGallery is called it will retrieve this value without prompting you for it.

## EXAMPLES

### EXAMPLE 1
```
PS C:\EndOfLine> Set-NuGetApiKey 'a1b2c3d4-e5f6-g7h8-i9j1-0k11l12m13n1'

PS C:\EndOfLine> Publish-ModuleToNuGetGallery
```

## PARAMETERS

### -Value
Obtained by online service such as: [powershellgallery.com](https://www.powershellgallery.com/)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[Publish-ModuleToNuGetGallery](https://github.com/marckassay/MKPowerShell/blob/master/docs/Publish-ModuleToNuGetGallery.md)
