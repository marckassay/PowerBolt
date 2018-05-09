using module ..\events\Register-Shutdown.ps1
#values; '', 'open', 'runAs'

function Restart-PWSH {
    [CmdletBinding(PositionalBinding = $False)]
    Param()
    $Script:RestartPWSHas = 'open'
    exit
}

function Restart-PWSHAdmin {
    [CmdletBinding(PositionalBinding = $False)]
    Param()
    $Script:RestartPWSHas = 'runAs'
    exit
}