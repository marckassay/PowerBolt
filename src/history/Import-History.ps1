function Import-History {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $false)]
        [string]$Path = (Get-MKPowerShellSetting -Name 'HistoryLocation')
    )

    $script:SessionHistories = Import-Csv -Path $Path

    Add-History -InputObject $script:SessionHistories
}