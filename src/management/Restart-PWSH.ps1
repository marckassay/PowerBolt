# TODO: look into PSReadline to add keychord command - https://docs.microsoft.com/en-us/powershell/module/psreadline/Set-PSReadlineKeyHandler?view=powershell-6
function Restart-PWSH {
    [CmdletBinding(PositionalBinding = $False)]
    Param() 

    Start-Process -FilePath "pwsh.exe" -Verb 'Open'

    $IsHistoryRecordingEnabled = (Get-MKPowerShellSetting -Name 'TurnOnHistoryRecording') -eq $true
    if ($IsHistoryRecordingEnabled) {
        Export-History
    } 

    Stop-Process -Id $PID
}