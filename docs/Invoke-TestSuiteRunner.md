---
external help file: MK.PowerShell.Flow-help.xml
Module Name: MK.PowerShell.Flow
online version: https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.2/docs/Invoke-TestSuiteRunner.md
schema: 2.0.0
---

# Invoke-TestSuiteRunner

## SYNOPSIS
Creates a PowerShell background job that calls [`Invoke-Pester`](https://github.com/pester/Pester/wiki/Invoke-Pester)

## SYNTAX

### ByPath (Default)
```
Invoke-TestSuiteRunner [[-Path] <String>] [[-TestFolderPath] <String>] [-Excludes <String[]>]
 [-Show <OutputTypes[]>] [-PassThru] [<CommonParameters>]
```

### ByName
```
Invoke-TestSuiteRunner [[-TestFolderPath] <String>] [-Excludes <String[]>] [-Show <OutputTypes[]>] [-PassThru]
 [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-TestSuiteRunner -Name PowerSploit
```

Using the `ByName` validation parameter set and since no `TestFolderPath` value has been assigned, it will use the relative path of `test`

## PARAMETERS

### -Name
{{Fill Name Description}}

```yaml
Type: String
Parameter Sets: ByName
Aliases:
Accepted values: CimCmdlets, Microsoft.PowerShell.Management, Microsoft.PowerShell.Utility, MK.PowerShell.Flow, Pester, Plaster, Plaster, platyPS, posh-git, PSReadLine

Required: True
Position: 0
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

### -TestFolderPath
{{Fill TestFolderPath Description}}

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

### -Excludes
{{Fill Excludes Description}}

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

### -Show
{{Fill Show Description}}

```yaml
Type: OutputTypes[]
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

[Invoke-TestSuiteRunner.ps1](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.2/src/test/Invoke-TestSuiteRunner.ps1)

[Invoke-TestSuiteRunner.Tests.ps1](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.2/test/test/Invoke-TestSuiteRunner.Tests.ps1)
