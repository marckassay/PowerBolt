using module .\..\module\manifest\Get-ManifestKey.ps1
using module .\..\events\Register-Shutdown.ps1

$script:ConfigFileParentPath
$script:ImportedSessionHistories

# NoExport: Start-MKPowerShell
function Start-MKPowerShell {
    [CmdletBinding(PositionalBinding = $False)]
    Param(
        [Parameter(Mandatory = $False)]
        [String]$ConfigFilePath
    )

    begin {
        # Environment var to reference this module's directory
        Set-Variable -Name FLOWPATH -Value ($script:PSScriptRoot) -Scope Global

        # Start-MKPowerShell may be called directly which may have a nothing value other then MKPowerShellConfigFilePath
        if ($ConfigFilePath) {
            $script:MKPowerShellConfigFilePath = $ConfigFilePath
        }
        else {
            $ConfigFilePath = $script:MKPowerShellConfigFilePath
        }
    }

    end {
        if ((Test-Path -Path $ConfigFilePath) -eq $false) {
            $script:ConfigFileParentPath = $(Split-Path $ConfigFilePath -Parent)
            if ((Test-Path -Path $script:ConfigFileParentPath) -eq $false) {
                New-Item -Path $script:ConfigFileParentPath -ItemType Directory -Verbose
            }
            
            Copy-Item -Path "$PSScriptRoot\..\..\resources\MK.PowerShell-config.json" -Destination $script:ConfigFileParentPath -Verbose -PassThru
        }
        else {
            $script:ConfigFileParentPath = (Split-Path $ConfigFilePath -Parent)
        }
        
        # Register-Shutdown
    }
}