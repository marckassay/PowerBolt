$script:ConfigFileParentPath 
function Start-MKPowerShell {
    [CmdletBinding(PositionalBinding = $False)]
    Param(
        [Parameter(Mandatory = $False)]
        [String]$ConfigFilePath = $([Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData) + "\MK.PowerShell\MK.PowerShell-config.json")
    )
    
    if ((Test-Path -Path $ConfigFilePath) -eq $false) {
        $script:ConfigFileParentPath = $(Split-Path $ConfigFilePath -Parent)
        if ((Test-Path -Path $script:ConfigFileParentPath) -eq $false) {
            New-Item -Path $script:ConfigFileParentPath -ItemType Directory -Verbose
        }

        Copy-Item -Path "$PSScriptRoot\..\..\resources\MK.PowerShell-config.json" -Destination $script:ConfigFileParentPath -Verbose -PassThru
    }

    Restore-RememberLastLocation -Initialize
    Restore-QuickRestartSetting -Initialize
    Backup-Sources -Initialize
    Restore-History -Initialize

    Register-Shutdown
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

function Backup-Sources {
    [CmdletBinding()]
    Param(
        [switch]$Initialize
    )

    $IsTurnOnBackupEnabled = (Get-MKPowerShellSetting -Name 'TurnOnBackup') -eq $true

    if ($IsTurnOnBackupEnabled) {
        if ($Initialize.IsPresent) { 
            $PredicateAuto = (Get-MKPowerShellSetting -Name 'BackupPolicy') -eq 'Auto'
        }
        else {
            # if called manually, disregard BackupPolicy value 
            $PredicateAuto = $true
        }

        if ($PredicateAuto) {
            $Backups = Get-MKPowerShellSetting -Name 'Backups'

            try {
                $IsPathValid = Test-Path -Path $Backups.Path
            }
            catch {
                $IsPathValid = $false
            }
            
            try {
                if ($Backups.UpdatePolicy -eq "Overwrite") {
                    $IsDestinationValid = Test-Path -Path $Backups.Destination

                    if ($IsDestinationValid -eq $false) {
                        New-Item -Path $Backups.Destination -ItemType Directory
                    }

                    $IsDestinationValid = Test-Path -Path $Backups.Destination
                }
                elseif ($Backups.UpdatePolicy -eq "New") {
                    
                    $LastIndexedName = Get-ChildItem $Backups.Destination -Recurse | `
                        Where-Object Name -match '.*\(\d+\)' | `
                        Sort-Object -Descending | `
                        Select-Object Name -First 1 -ExpandProperty Name

                    [int]$LastIndexValue = [regex]::Match($LastIndexedName, "(?<=\()\d+(?=\))").Value
                    $NewIndexValue = $LastIndexValue++
                    
                    $LeafName = Split-Path -Path $Backups.Path -Leaf
                    $NewPath = Join-Path -Path $Backups.Destination -ChildPath "$LeafName($NewIndexValue)"

                    if ((Test-Path $Backups.Path -PathType Leaf) -eq $true) {
                        $LeafExt = Split-Path -Path -Extension
                        $NewFileName = New-Item "$NewPath.$LeafExt" -ItemType File
                        Copy-Item -Path $Backups.Path -Destination $NewFileName
                    }
                    else {
                        New-Item $NewPath -ItemType Directory
                        Copy-Item -Path $Backups.Path -Destination $NewPath -Recurse -Container
                    }
                    
                    Copy-Item -Path $Backups.Path -Destination $Backups.Destination -Force -Recurse
                }
            }
            catch {
                $IsDestinationValid = $false
            }

            if (($IsPathValid) -and ($IsDestinationValid)) {
                if ($Backups.UpdatePolicy -eq "Overwrite") {
                    Copy-Item -Path $Backups.Path -Destination $Backups.Destination -Force -Recurse
                    Write-Host "Backup data sources completed." -ForegroundColor Green
                }
                elseif ($Backups.UpdatePolicy -eq "New") {
                    Split-Path $Backups.Path -LeafBase
                    Copy-Item -Path $Backups.Path -Destination $Backups.Destination -Force -Recurse
                }
            }
            elseif ((-not $IsPathValid) -and (-not $IsDestinationValid)) {
                Write-Host "Backup data sources was not completed due to invalid entries for 'Backups' Path and Destination field.  To set a new value for 'Backups' call the following: Set-MKPowerShellSetting -Name Backups -Value @{Path: 'E:\file', Destination: 'E:\CloudFolder'}" -ForegroundColor Red 
            }
            elseif (-not $IsPathValid) {
                Write-Host "Backup data sources was not completed due to invalid entry (or entries) for 'Backups' Path field.  To set a new value for 'Backups' call the following: Set-MKPowerShellSetting -Name Backups -Value @{Path: 'E:\file', Destination: 'E:\CloudFolder'}" -ForegroundColor Red 
            }
            elseif (-not $IsDestinationValid) {
                Write-Host "Backup data sources was not completed due to invalid entry for 'Backups' Destination field.  To set a new value for 'Backups' call the following: Set-MKPowerShellSetting -Name Backups -Value @{Path: 'E:\file', Destination: 'E:\CloudFolder'}" -ForegroundColor Red 
            }
        }
    }
    else {
        # if called manually when 'TurnOnBackup' is false 
        if (-not $Initialize.IsPresent) { 
            Write-Host "'TurnOnBackup' is currently disabled.  To enable call: Set-MKPowerShellSetting -Name TurnOnBackup -Value '$true'." -ForegroundColor Yellow
        }
    }
}

function Restore-History {
    [CmdletBinding()]
    Param(
        [switch]$Initialize
    )

    $IsHistoryRecordingEnabled = (Get-MKPowerShellSetting -Name 'TurnOnHistoryRecording') -eq $true

    if ($IsHistoryRecordingEnabled) { 

        $HistoryLocation = Get-MKPowerShellSetting -Name 'HistoryLocation'
        if (($HistoryLocation -eq '') -or (Test-Path -Path $HistoryLocation -ErrorAction SilentlyContinue) -eq $false) {
            $SessionHistoriesPath = New-Item -Path $script:ConfigFileParentPath"\SessionHistories.csv" -ItemType File | Select-Object -ExpandProperty FullName

            Set-MKPowerShellSetting -Name 'HistoryLocation' -Value $SessionHistoriesPath
            
            Write-Host "History file has been created." -ForegroundColor Green
        }
        else {
            Import-History

            Write-Host "History is restored from previous session(s)." -ForegroundColor Green
        }
    }
}