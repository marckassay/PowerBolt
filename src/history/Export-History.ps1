function Export-History {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $false)]
        [string]$Path = (Get-MKPowerShellSetting -Name 'HistoryLocation')

    )

    # TODO: check $MaximumHistoryCount; we shouldnt disregard that var
    $SessionHistory = Get-History 
    
    # we only want the new entries since Export-Csv appends the file and not overwrite it
    $SessionHistory[$script:SessionHistories.Count..$SessionHistory.Count] | `
        Export-Csv -Path $Path -Append
}