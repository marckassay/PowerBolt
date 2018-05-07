function Start-MKPowerShell {
    [CmdletBinding(PositionalBinding = $False)]
    Param(
        [Parameter(Mandatory = $False)]
        [String]$ConfigFilePath = $([Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData) + "\MK.PowerShell\MK.PowerShell-config.json")
    )

    if ((Test-Path -Path $ConfigFilePath) -eq $false) {
        $ConfigFileParentPath = $(Split-Path $ConfigFilePath -Parent)
        if ((Test-Path -Path $ConfigFileParentPath) -eq $false) {
            New-Item -Path $ConfigFileParentPath -ItemType Directory -Verbose
        }

        Copy-Item -Path "$PSScriptRoot\..\..\resources\MK.PowerShell-config.json" -Destination $ConfigFileParentPath -Verbose -PassThru
    }

    Restore-RememberLastLocation -Initialize
    Restore-QuickRestartSetting -Initialize
    #  Backup-SelectedData -Initialize
}


# NoExport: Restore-RememberLastLocation
function Restore-RememberLastLocation {
    [CmdletBinding()]
    Param(
        [switch]$Initialize
    )

    if ((Get-MKPowerShellSetting -Name 'TurnOnRememberLastLocation') -eq $true) {
        Set-Alias sl Set-LocationAndStore -Scope Global -Force
        Write-Host "'sl' alias is now mapped to 'Set-LocationAndStore'." -ForegroundColor Green

        if ($Initialize.IsPresent) {
            $LastLocation = Get-MKPowerShellSetting -Name 'LastLocation'
            if ($LastLocation -ne '') {
                Set-LocationAndStore -Path $LastLocation
            }
            else {
                Set-LocationAndStore -Path $(Get-Location)
            }
        }
    }
    else {
        Set-Alias sl Set-Location -Scope Global -Force
        Write-Host "'sl' alias is now mapped to 'Set-Location'." -ForegroundColor Green
    }
}

# NoExport: Restore-QuickRestartSetting
function Restore-QuickRestartSetting {
    [CmdletBinding()]
    Param(
        [switch]$Initialize
    )

    if ((Get-MKPowerShellSetting -Name 'TurnOnQuickRestart') -eq $true) {
        Set-Alias pwsh Restart-PWSH -Scope Global
        Write-Host "'pwsh' alias is now mapped to 'Restart-PWSH'." -ForegroundColor Green

        Set-Alias pwsha Restart-PWSHAdmin -Scope Global
        Write-Host "'pwsha' alias is now mapped to 'Restart-PWSHAdmin'." -ForegroundColor Green
    }
    else {
        if (-not $Initialize.IsPresent) { 
            Remove-Alias pwsh -Scope Global
            Write-Host "'pwsh' alias has been removed." -ForegroundColor Green

            Remove-Alias pwsha -Scope Global
            Write-Host "'pwsha' alias has been removed." -ForegroundColor Green
        }
    }
}

function Backup-SelectedData {
    [CmdletBinding()]
    Param(
        [switch]$Initialize
    )

    $PredicateEnabled = (Get-MKPowerShellSetting -Name 'TurnOnBackup') -eq $true
    $PredicateAuto = (Get-MKPowerShellSetting -Name 'BackupPolicy') -eq 'Auto'
    $BackupLocations = Get-MKPowerShellSetting -Name 'BackupLocations'

    if ($PredicateEnabled) {
        if ($PredicateAuto -and $($BackupLocations.Destination -ne '')) {
            Write-Host "Backup data sources completed." -ForegroundColor Green
            Copy-Item -Path $BackupLocations.Path -Destination $BackupLocations.Destination
        }
        else {
            Write-Host "Backup data sources was not completed due to incomplete entry for 'BackupLocations'." -ForegroundColor Red
        }
    }
    else {
        if (-not $Initialize.IsPresent) { 
            Write-Host "'TurnOnBackup' is currently disabled.  To enable call: Set-MKPowerShellSetting -Name TurnOnBackup -Value $true." -ForegroundColor Red
        }
    }
}