---
external help file: PowerEquip-help.xml
Module Name: PowerEquip
online version: https://github.com/marckassay/PowerEquip/blob/0.0.4/docs/Update-ManifestFunctionsToExportField.md
schema: 2.0.0
---

# Update-ManifestFunctionsToExportField

## SYNOPSIS
Ideally having `Update-RootModuleUsingStatements` piped into this function, it will popluate a string array of function names and set it to the `FunctionsToExport`.

## SYNTAX

```
Update-ManifestFunctionsToExportField [-ManifestUpdate] <PSObject> [-PassThru] [<CommonParameters>]
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

### -ManifestUpdate
{{Fill ManifestUpdate Description}}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PassThru
{{Fill PassThru Description}}

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

### System.Management.Automation.PSObject

## OUTPUTS

### System.Management.Automation.PSModuleInfo

## NOTES

## RELATED LINKS

[Update-ManifestFunctionsToExportField.ps1](https://github.com/marckassay/PowerEquip/blob/0.0.4/src/module/manifest/Update-ManifestFunctionsToExportField.ps1)

[Update-ManifestFunctionsToExportField.Tests.ps1](https://github.com/marckassay/PowerEquip/blob/0.0.4/test/module/manifest/Update-ManifestFunctionsToExportField.Tests.ps1)

[`Update-RootModuleUsingStatements`](https://github.com/marckassay/PowerEquip/blob/0.0.4/docs/Update-RootModuleUsingStatements.md)
