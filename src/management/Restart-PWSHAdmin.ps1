function Restart-PWSHAdmin {
    [CmdletBinding(PositionalBinding = $False)]
    Param() 
    
    Start-Process -FilePath "pwsh.exe" -Verb 'RunAs'
    
    $IsHistoryRecordingEnabled = (Get-MKPowerShellSetting -Name 'TurnOnHistoryRecording') -eq $true
    if ($IsHistoryRecordingEnabled) {
        Export-History
    } 

    Stop-Process -Id $PID
}