function Start-MKPowerShell {
    [CmdletBinding(PositionalBinding = $False)]
    Param(
        [Parameter(Mandatory = $False)]
        [String]$ConfigFilePath = $([Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData) + "\MK.PowerShell\MK.PowerShell-config.ps1")
    )

    if ((Test-Path -Path $ConfigFilePath) -eq $false) {
        $ConfigFileParentPath = $(Split-Path $ConfigFilePath -Parent)
        if ((Test-Path -Path $ConfigFileParentPath) -eq $false) {
            New-Item -Path $ConfigFileParentPath -ItemType Directory -Verbose
        }

        Copy-Item -Path "$PSScriptRoot\..\..\resources\MK.PowerShell-config.ps1" -Destination $ConfigFileParentPath -Verbose -PassThru
    }

    Restore-RememberLastLocation -ExecutePostAction
}