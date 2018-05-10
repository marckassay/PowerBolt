function Register-Shutdown {
    [CmdletBinding(PositionalBinding = $False)]
    Param()

    $IsHistoryRecordingEnabled = (Get-MKPowerShellSetting -Name 'TurnOnHistoryRecording') -eq $true
    Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -MessageData $IsHistoryRecordingEnabled -Action {
        if ($Event.MessageData) {
            Export-History
        } 
    } -SupportEvent | Out-Null
}  