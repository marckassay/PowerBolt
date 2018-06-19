---
external help file: MK.PowerShell.4PS-help.xml
Module Name: MK.PowerShell.4PS
online version: https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Get-MKModuleInfo.md
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
Valid `Path` parameter values are to a manifest (.psd1) file, module (.psm1) file and root module directory.  And valid `Name` parameter values are constricted to modules installed locally.  With those possible values information about the module with be returned.

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
Accepted values: Add-ModuleToProfile, BackupPredicateEnum, Backup-Sources, Build-Documentation, Build-PlatyPSMarkdown, ConvertTo-EnumFlag, Export-History, Get-LatestError, Get-ManifestKey, Get-MergedPath, Get-MKPowerShellSetting, Get-MKModuleInfo, GetModuleNameSet, GetSettingsNameSet, Import-History, Invoke-TestSuiteRunner, Microsoft.PowerShell.Management, Microsoft.PowerShell.Utility, MK.PowerShell.4PS, MKPowerShellDocObject, New-DynamicParam, New-ExternalHelpFromPlatyPSMarkdown, New-MKPowerShellConfigFile, New-Script, Plaster, platyPS, posh-git, PSReadLine, Publish-ModuleToNuGetGallery, Register-Shutdown, Reset-ModuleInProfile, Restart-PWSH, Restart-PWSHAdmin, Search-Items, Set-LocationAndStore, Set-MKPowerShellSetting, Skip-ModuleInProfile, Start-MKPowerShell, Update-ManifestFunctionsToExportField, Update-ModuleExports, Update-ReadmeFromPlatyPSMarkdown, Update-RootModuleUsingStatements, Update-SemVer

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

[Get-MKModuleInfo.ps1](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/src/module/Get-MKModuleInfo.ps1)

[Get-MKModuleInfo.Tests.ps1](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/test/module/Get-MKModuleInfo.Tests.ps1)
