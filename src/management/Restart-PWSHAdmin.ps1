function Restart-PWSHAdmin {
    [CmdletBinding(PositionalBinding = $False)]
    Param() 
    
    Start-Process -FilePath "pwsh.exe" -Verb 'RunAs'
    Stop-Process -Id $PID
}