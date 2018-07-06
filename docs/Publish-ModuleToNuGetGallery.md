---
external help file: PowerEquip-help.xml
Module Name: PowerEquip
online version: https://github.com/marckassay/PowerEquip/blob/0.0.4/docs/Publish-ModuleToNuGetGallery.md
schema: 2.0.0
---

# Publish-ModuleToNuGetGallery

## SYNOPSIS
Streamlines publishing a module using `Publish-Module`.

## SYNTAX

### ByPath (Default)
```
Publish-ModuleToNuGetGallery [[-Path] <String>] [-NuGetApiKey <String>] [-Exclude <String[]>] [-DoNotConfirm]
 [-WhatIf] [<CommonParameters>]
```

### ByName
```
Publish-ModuleToNuGetGallery [-NuGetApiKey <String>] [-Exclude <String[]>] [-DoNotConfirm] [-WhatIf]
 [-Name] <String> [<CommonParameters>]
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

### -DoNotConfirm
{{Fill DoNotConfirm Description}}

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

### -Exclude
{{Fill Exclude Description}}

```yaml
Type: String[]
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
Accepted values: CimCmdlets, Microsoft.PowerShell.Management, Microsoft.PowerShell.Utility, Pester, Plaster, platyPS, posh-git, PowerEquip, PSReadLine

Required: True
Position: 0
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

[Publish-ModuleToNuGetGallery.ps1](https://github.com/marckassay/PowerEquip/blob/0.0.4/src/publish/Publish-ModuleToNuGetGallery.ps1)

[Publish-ModuleToNuGetGallery.Tests.ps1](https://github.com/marckassay/PowerEquip/blob/0.0.4/test/publish/Publish-ModuleToNuGetGallery.Tests.ps1)
