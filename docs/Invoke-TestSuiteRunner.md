---
external help file: MK.PowerShell.4PS-help.xml
Module Name: MK.PowerShell.4PS
online version: https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Invoke-TestSuiteRunner.md
schema: 2.0.0
---

# Invoke-TestSuiteRunner

## SYNOPSIS
Creates a PowerShell background job that calls [`Invoke-Pester`](https://github.com/pester/Pester/wiki/Invoke-Pester)

## SYNTAX

### ByPath (Default)
```
Invoke-TestSuiteRunner [[-Path] <String>] [[-TestFolderPath] <String>] [-TestName <String[]>] [-EnableExit]
 [-Tag <String[]>] [-ExcludeTag <String[]>] [-PassThru] [-CodeCoverage <Object[]>]
 [-CodeCoverageOutputFile <String>] [-CodeCoverageOutputFileFormat <String>] [-Strict] [-Quiet]
 [-PesterOption <Object>] [-Show <String>] [<CommonParameters>]
```

### NewOutputSet
```
Invoke-TestSuiteRunner [[-TestFolderPath] <String>] [-TestName <String[]>] [-EnableExit] [-Tag <String[]>]
 [-ExcludeTag <String[]>] [-PassThru] [-CodeCoverage <Object[]>] [-CodeCoverageOutputFile <String>]
 [-CodeCoverageOutputFileFormat <String>] [-Strict] -OutputFile <String> [-OutputFormat <String>] [-Quiet]
 [-PesterOption <Object>] [-Show <String>] [<CommonParameters>]
```

### ByName
```
Invoke-TestSuiteRunner [[-TestFolderPath] <String>] [-TestName <String[]>] [-EnableExit] [-Tag <String[]>]
 [-ExcludeTag <String[]>] [-PassThru] [-CodeCoverage <Object[]>] [-CodeCoverageOutputFile <String>]
 [-CodeCoverageOutputFileFormat <String>] [-Strict] [-Quiet] [-PesterOption <Object>] [-Show <String>]
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
Accepted values: Microsoft.PowerShell.Management, Microsoft.PowerShell.Utility, MK.PowerShell.4PS, PackageManagement, Plaster, platyPS, posh-git, PowerShellGet, PSReadLine

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

### -CodeCoverage
{{Fill CodeCoverage Description}}

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CodeCoverageOutputFile
{{Fill CodeCoverageOutputFile Description}}

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

### -CodeCoverageOutputFileFormat
{{Fill CodeCoverageOutputFileFormat Description}}

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

### -EnableExit
{{Fill EnableExit Description}}

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

### -ExcludeTag
{{Fill ExcludeTag Description}}

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

### -OutputFile
{{Fill OutputFile Description}}

```yaml
Type: String
Parameter Sets: NewOutputSet
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputFormat
{{Fill OutputFormat Description}}

```yaml
Type: String
Parameter Sets: NewOutputSet
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

### -PesterOption
{{Fill PesterOption Description}}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Quiet
{{Fill Quiet Description}}

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
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Strict
{{Fill Strict Description}}

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

### -Tag
{{Fill Tag Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Tags

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestName
{{Fill TestName Description}}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
