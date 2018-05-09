function Import-History {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $false)]
        [string]$Path = (Get-MKPowerShellSetting -Name 'HistoryLocation')
    )

    $SessionHistories = Import-Csv -Path $Path
    $Script:SessionHistoriesCount = $SessionHistories.Count;

    $SessionHistories | Add-History
}