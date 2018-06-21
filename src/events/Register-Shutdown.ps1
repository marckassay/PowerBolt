# NoExport: Register-Shutdown
function Register-Shutdown {
    [CmdletBinding(PositionalBinding = $False)]
    Param()

    # callback when Remove-Module is called on this module
    $OnRemoveScript = {

    }
    $ExecutionContext.SessionState.Module.OnRemove += $OnRemoveScript

    # TODO: the Action callback is never called below when 'pwsh' is executed. Perhaps CIM detection
    # is more ideal. 
    $IsHistoryRecordingEnabled = (Get-MKPowerShellSetting -Name 'TurnOnHistoryRecording') -eq $true
    Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -MessageData $IsHistoryRecordingEnabled -Action {
        if ($Event.MessageData) {
            # Export-History
        } 
        $OnRemoveScript
    } -SupportEvent | Out-Null
}  