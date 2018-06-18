---
external help file: MK.PowerShell.4PS-help.xml
Module Name: MK.PowerShell.4PS
online version: https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Add-ModuleToProfile.md
schema: 2.0.0
---

# Add-ModuleToProfile

## SYNOPSIS
Appends content of the PowerShell session's profile with an `Import-Module` statement.

## SYNTAX

```
Add-ModuleToProfile [[-Path] <String>] [[-ProfilePath] <String>] [<CommonParameters>]
```

## DESCRIPTION
Appends content of `$PROFILE` file (or content of  `ProfilePath` parameter if is used) with an `Import-Module` statement that imports the module found with `Path`.

## EXAMPLES

### Example 1
```powershell
PS C:\> Add-ModuleToProfile -Path C:\Users\Alice\PowerSploit
PS C:\> Get-Content $PROFILE
Import-Module C:\Users\Alice\Documents\PowerShell\Modules\posh-git\0.7.1\posh-git.psd1
Import-Module C:\Users\Alice\PowerSploit

PS C:\>
```

The module found in PowerSploit folder will have an `Import-Module` statement added to the default profile ($PROFILE) item.

## PARAMETERS

### -Path
Path to module folder.

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

### -ProfilePath
`$PROFILE` is default profile value.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $(Get-Variable Profile -ValueOnly)
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS

- [Add-ModuleToProfile.ps1](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/src/profile/Add-ModuleToProfile.ps1)
- [Add-ModuleToProfile.Tests.ps1](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/test/profile/Add-ModuleToProfile.Tests.ps1)
- [`Skip-ModuleInProfile`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Skip-ModuleInProfile.md)
- [`Reset-ModuleInProfile`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Reset-ModuleInProfile.md)