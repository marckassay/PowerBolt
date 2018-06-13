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