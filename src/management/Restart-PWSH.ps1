function Restart-PWSH {
    [CmdletBinding(PositionalBinding = $False)]
    Param()
    Unregister-Event -SourceIdentifier PowerShell.Exiting -ErrorAction SilentlyContinue
    Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
        Start-Process -FilePath "pwsh.exe" -Verb open
    } | Out-Null
    exit
}

function Restart-PWSHAdmin {
    [CmdletBinding(PositionalBinding = $False)]
    Param()
    Unregister-Event -SourceIdentifier PowerShell.Exiting -ErrorAction SilentlyContinue
    Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
        Start-Process -FilePath "pwsh.exe" -Verb runAs
    } | Out-Null
    exit
}