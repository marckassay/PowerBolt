using module ..\events\Register-Shutdown.ps1

function Restart-PWSH {
    [CmdletBinding(PositionalBinding = $False)]
    Param(
        [parameter(Mandatory = $False)]
        [ValidateSet("Open", "RunAs")]
        [String]
        $RestartVerb = 'Open'
    ) 
    
    Start-Process -FilePath "pwsh.exe" -Verb $RestartVerb
    Stop-Process -Id $PID
}