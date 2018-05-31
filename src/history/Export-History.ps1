function Export-History {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $false)]
        [string]$Path = (Get-MKPowerShellSetting -Name 'HistoryLocation')
    )
    
    # we only want the new entries since Export-Csv call appends the file
    $CurrentHistory = Get-History

    $CurrentHistory | `
        Select-Object -Last ($CurrentHistory.Count - $script:ImportedSessionHistories.Count) | `
        Export-Csv -Path $Path -Append
}