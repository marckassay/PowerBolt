$Script:RestartPWSHas = ''

function Register-Shutdown {
    [CmdletBinding(PositionalBinding = $False)]
    Param()

    Unregister-Event -SourceIdentifier PowerShell.Exiting -ErrorAction SilentlyContinue
    Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
        $IsHistoryRecordingEnabled = (Get-MKPowerShellSetting -Name 'TurnOnHistoryRecording') -eq $true
        if ($IsHistoryRecordingEnabled) {
            Export-History
        }

        if ($Script:RestartPWSHas -ne '') {
            Start-Process -FilePath "pwsh.exe" -Verb $Script:RestartPWSHas
        }

    } | Out-Null
}  