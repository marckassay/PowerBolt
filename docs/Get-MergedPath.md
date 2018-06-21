---
external help file: MK.PowerShell.Flow-help.xml
Module Name: MK.PowerShell.Flow
online version: https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.1/docs/Get-MergedPath.md
schema: 2.0.0
---

# Get-MergedPath

## SYNOPSIS
Returns a valid path from a parent of one of its children which overlaps that parent's path.

## SYNTAX

```
Get-MergedPath [-Path] <String[]> [-ChildPath] <String[]> [-IsValid] [<CommonParameters>]
```

## DESCRIPTION
In set-theory this will be considered a relative complement. 
That is the directories
in ChildPath that are not in Path.

A diagram to illustrate what is mentioned above:
    A =        C:\Windows\diagnostics\system
    B =                 .\diagnostics\system\Keyboard\en-US\CL_LocalizationData.psd1
    B\A =                                  .\Keyboard\en-US\CL_LocalizationData.psd1
    R =        C:\Windows\diagnostics\system\Keyboard\en-US\CL_LocalizationData.psd1

The path 'R' is what will be returned if -IsValid is not switched otherwise $true 
will be returned.

## EXAMPLES

### EXAMPLE 1
```
E:\Temp\AIT\> Get-MergedPath E:\Temp\AIT\resources\ -ChildPath .\resources\android\AiT-Feature.jpg
E:\Temp\AIT\resources\android\AiT-Feature.jpg

E:\Temp\AIT\> Get-MergedPath E:\Temp\AIT\resources\ -ChildPath .\resources\android\AiT-Feature.jpg -IsValid
True
```

Demonstration of using Get-MergedPath with truthly values

### EXAMPLE 2
```
E:\Temp\AIT\> Get-MergedPath E:\Temp\AIT\resources\ -ChildPath .\reWWWources\android\AiT-Feature.jpg
E:\Temp\AIT\> Get-MergedPath E:\Temp\AIT\resources\ -ChildPath .\reWWWources\android\AiT-Feature.jpg -IsValid
False
```

Demonstration of using Get-MergedPath with falsely values

## PARAMETERS

### -Path
Parent path of $ChildPath. 
This can be relative.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ChildPath
Child path of $Path.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsValid
Returns true if function found a complement folder. 
False is returned if no complement was
found.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String

### System.Boolean

## NOTES

## RELATED LINKS

[Get-MergedPath.ps1](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.1/src/utility/Get-MergedPath.ps1)

[https://gist.github.com/marckassay/2f54ae68779c9f27fd130b193374335c](https://gist.github.com/marckassay/2f54ae68779c9f27fd130b193374335c)
