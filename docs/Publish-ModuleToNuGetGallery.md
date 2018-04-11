---
external help file: MKPowerShell-help.xml
Module Name: MKPowerShell
online version:
schema: 2.0.0
---

# Publish-ModuleToNuGetGallery

## SYNOPSIS
Streamlines publishing a module to PowerShellGet.

## SYNTAX

```
Publish-ModuleToNuGetGallery [[-Path] <String>] [[-NuGetApiKey] <String>] [[-Exclude] <String[]>] [-WhatIf]
 [<CommonParameters>]
```

## DESCRIPTION
Prior to calling you can store API key using Set-NuGetApiKey.  If not, you must assign it to the NuGetApiKey parameter.  When called this function will take the module's directory and will copy it to the first indexed PowerShell module directory from $PSModulePath where PowerShell will recongize it.  It will publish it to an online gallery and afterwards will delete the newly copied directory.

## EXAMPLES

### Example 1
```powershell
PS C:\EndOfLine> Publish-ModuleToNuGetGallery
```

Call this function without value to the Path parameter only if PowerShell is located in the module's directory.

## PARAMETERS

### -Exclude
Names of folders or files to exclude

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

### -NuGetApiKey
The NuGet API key that will be used.  This can be stored prior using Set-NuGetApiKey.

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

### -Path
Path to the module directory.

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

### -WhatIf
Shows what would happen if the cmdlet runs.  This will copy module's directory to the first directory indexed in $PSModulePath.

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

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Set-NuGetApiKey](https://github.com/marckassay/MKPowerShell/blob/master/docs/Set-NuGetApiKey.md)
