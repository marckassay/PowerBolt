function Export-History {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $false)]
        [string]$Path = (Get-MKPowerShellSetting -Name 'HistoryLocation')

    )

    # TODO: check $MaximumHistoryCount; we shouldnt disregard that var
    $SessionHistory = Get-History
    $EntriesToExport = [math]::Abs($Script:SessionHistories.Count - $SessionHistory.Count)
    
    Get-History -Count $EntriesToExport | `
        Export-Csv -Path $Path
}