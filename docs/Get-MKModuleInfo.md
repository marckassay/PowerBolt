---
external help file: PowerBolt-help.xml
Module Name: PowerBolt
online version: https://github.com/marckassay/PowerBolt/blob/0.0.4/docs/Get-MKModuleInfo.md
schema: 2.0.0
---

# Get-MKModuleInfo

## SYNOPSIS
Outputs information about a module with given name or path.

## SYNTAX

### ByPath (Default)
```
Get-MKModuleInfo [[-Path] <String>] [<CommonParameters>]
```

### ByName
```
Get-MKModuleInfo [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
Valid `Path` parameter values are to a manifest (.psd1) file, module (.psm1) file and root module directory. And valid `Name` parameter values are constricted to modules installed locally. With those possible values information about the module with be returned.

## EXAMPLES

### Example 1
```
PS C:\> Get-MKModuleInfo -Name Plaster

Name               : Plaster
Path               : E:\Plaster\Release\Plaster
PathFolderName     : Plaster
ManifestFilePath   : E:\Plaster\Release\Plaster\Plaster.psd1
RootModuleFilePath : E:\Plaster\Release\Plaster\Plaster.psm1
Version            : 1.1.4
```

With Plaster being installed locally, it is valid value in the parameter set.

## PARAMETERS

### -Name
A dynamic parameter with its valid set being confined to locally installed modules.

```yaml
Type: String
Parameter Sets: ByName
Aliases:
Accepted values: CimCmdlets, Microsoft.PowerShell.Management, Microsoft.PowerShell.Utility, Pester, Plaster, platyPS, posh-git, PowerBolt, PSReadLine

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Valid values are to a manifest (.psd1) file, module (.psm1) file and root module directory.

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

### None

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

[Get-MKModuleInfo.ps1](https://github.com/marckassay/PowerBolt/blob/0.0.4/src/module/Get-MKModuleInfo.ps1)

[Get-MKModuleInfo.Tests.ps1](https://github.com/marckassay/PowerBolt/blob/0.0.4/test/module/Get-MKModuleInfo.Tests.ps1)
