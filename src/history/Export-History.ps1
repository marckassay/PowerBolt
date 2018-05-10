function Export-History {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $false)]
        [string]$Path = (Get-MKPowerShellSetting -Name 'HistoryLocation')

    )

    # TODO: check $MaximumHistoryCount; we shouldnt disregard that var
    $SessionHistory = Get-History
    $SessionHistory[$Script:SessionHistories.Count..$SessionHistory.Count] | `
        Export-Csv -Path $Path
}