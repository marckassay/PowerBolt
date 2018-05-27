function Register-Shutdown {
    [CmdletBinding(PositionalBinding = $False)]
    Param()

    # TODO: the Action callback is never called below when 'pwsh' is executed.  Perhaps CIM detection
    # is more ideal. 
    $IsHistoryRecordingEnabled = (Get-MKPowerShellSetting -Name 'TurnOnHistoryRecording') -eq $true
    Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -MessageData $IsHistoryRecordingEnabled -Action {
        if ($Event.MessageData) {
            Export-History
        } 
    } -SupportEvent | Out-Null
}  