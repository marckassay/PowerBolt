---
external help file: MK.PowerShell.Flow-help.xml
Module Name: MK.PowerShell.Flow
online version: https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.2/docs/ConvertTo-EnumFlag.md
schema: 2.0.0
---

# ConvertTo-EnumFlag

## SYNOPSIS
With `InputObject` tested for equality via `-eq`, will `Write-Output` `Value` only when equality operator returns `true`.

## SYNTAX

```
ConvertTo-EnumFlag -InputObject <PSObject> [-Value] <Enum> [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> $LifeEvents += (Get-Date) -ge (Get-Date -Year 2061) | ConvertTo-EnumFlag -Value ([CosmicEvents]::WatchHalley)
```

The `-ge` assertation will pipe a bool value in `ConvertTo-EnumFlag` which will increment `$LifeEvents`
 with `[CosmicEvents]::WatchHalley` if the assertation is `true`. If the piped value is `false`, `ConvertTo-EnumFlag` will 
 `Write-Output` with `0`.

## PARAMETERS

### -InputObject
{{Fill InputObject Description}}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Value
{{Fill Value Description}}

```yaml
Type: Enum
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject

## OUTPUTS

### System.Int32

## NOTES

## RELATED LINKS

[ConvertTo-EnumFlag.ps1](https://github.com/marckassay/MK.PowerShell.Flow/blob/0.0.2/src/utility/ConvertTo-EnumFlag.ps1)
