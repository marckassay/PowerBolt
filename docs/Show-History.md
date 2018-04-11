---
external help file: MKPowerShell-help.xml
Module Name: MKPowerShell
online version:
schema: 2.0.0
---

# Show-History

## SYNOPSIS
Concatnates PowerShell session histories so that you can reference previous commands from previous sessions.

## SYNTAX

```
Show-History [<CommonParameters>]
```

## DESCRIPTION
Displays history of commands with Id and date of execution.  Items will be group by the day in ascending order.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> Show-History

...
111 4:36 PM       $(Get-Date).Hour
112 4:36 PM       $(Get-Date).TimeOfDay
113 4:39 PM
                  $sorts = @{
                      Name     = ':'
                      Expression = {$_.EndExecutionTime.DayOfWeek}
                  }
                  Get-History -Count 3 | Format-Table -GroupBy $sorts @{Label = "ExecutionTime"; Expression = {
                          ($_.EndExecutionTime.DateTime).toString('t')
                      }; Alignment = 'Left'}
114 4:39 PM
                  $sorts = @{
                      Name     = ':'
                      Expression = {$_.EndExecutionTime.DayOfWeek}
                  }
                  Get-History -Count 3 | Format-Table -GroupBy $sorts @{Label = "ExecutionTime"; Expression = {
                          $_.EndExecutionTime.toString('t')
                      }; Alignment = 'Left'}
115 4:39 PM       pwsh
116 4:40 PM       Show-History
120 4:50 PM       pwsh


   :: Wednesday

Id  ExecutionTime CommandLine
--  ------------- -----------
121 6:21 AM       Get-Module
122 6:26 AM       Get-Help Get-Module
123 6:47 AM       Get-Help Get-Module -Component
125 7:20 AM       $PSCommandPath
127 7:22 AM       sl env:
128 7:22 AM       ls
129 7:33 AM       sl e:\
130 7:33 AM       sl .\marckassay\MKPowerShell\
131 7:36 AM       Publish-ModuleToNuGetGallery

PS C:\> Invoke-History 112
```

This function is advantageous when trying to recall a previous command.  Using Invoke-History usefull with this function.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[Invoke-History](https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Core/Invoke-History)