function Import-History {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $false)]
        [string]$Path = (Get-MKPowerShellSetting -Name 'HistoryLocation')
    )

    $CurrentHistoryCount = Get-History | Measure-Object | Select-Object -ExpandProperty Count
    
    $script:ImportedSessionHistories = Import-Csv -Path $Path | Select-Object -Last ($MaximumHistoryCount - $CurrentHistoryCount)

    Add-History -InputObject $script:ImportedSessionHistories
}