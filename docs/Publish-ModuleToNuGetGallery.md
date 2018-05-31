---
external help file: MK.PowerShell.4PS-help.xml
Module Name: MK.PowerShell.4PS
online version: https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Publish-ModuleToNuGetGallery.md
schema: 2.0.0
---

# Publish-ModuleToNuGetGallery

## SYNOPSIS
Streamlines publishing a module using `Publish-Module`.

## SYNTAX

```
Publish-ModuleToNuGetGallery [[-Path] <String>] [[-NuGetApiKey] <String>] [[-Exclude] <String[]>] [-WhatIf]
 [<CommonParameters>]
```

## DESCRIPTION
When `MK.PowerShell-config.json` has valid `NuGetApiKey`, it will deploy locally module to a 
temp folder, removing specified items via `Exclude`, prompt user to confirm publishing and will 
"teardown" setup items after confirming.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Exclude
{{Fill Exclude Description}}

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
{{Fill NuGetApiKey Description}}

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
{{Fill Path Description}}

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
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

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
