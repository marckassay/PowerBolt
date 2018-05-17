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
            Get-MKPowerShellSetting -Name 'Backups' | ForEach-Object {
                try {
                    $IsPathValid = Test-Path -Path $_.Path
                }
                catch {
                    $IsPathValid = $false
                }
                
                $IsAFile = (Test-Path $_.Path -PathType Leaf) -eq $true
                $Leaf = Split-Path -Path $_.Path -Leaf

                try {
                    if ($IsAFile) {
                        $SourceItemTicks = Get-Item $_.Path | `
                            Get-ItemPropertyValue -Name LastWriteTime | `
                            Select-Object -ExpandProperty Ticks
                    }
                    else {
                        $SourceItemTicks = Get-ChildItem $_.Path -Recurse | `
                            Sort-Object -Property LastWriteTime -Descending -Top 1 | `
                            Get-ItemPropertyValue -Name LastWriteTime | `
                            Select-Object -ExpandProperty Ticks
                    }
                }
                catch {
                    $SourceItemTicks = $null
                }

                try {
                    if ($IsAFile) {
                        $DestinationItemTicks = Join-Path -Path $_.Destination -ChildPath $Leaf | `
                            Get-Item -ErrorAction SilentlyContinue | `
                            Get-ItemPropertyValue -Name LastWriteTime | `
                            Select-Object -ExpandProperty Ticks
                    }
                    else {
                        $DestinationItemTicks = Join-Path -Path $_.Destination -ChildPath $Leaf | `
                            Get-ChildItem -Recurse | `
                            Sort-Object -Property LastWriteTime -Descending -Top 1 | `
                            Get-ItemPropertyValue -Name LastWriteTime | `
                            Select-Object -ExpandProperty Ticks
                    }
                }
                catch {
                    $DestinationItemTicks = $null
                }

                if (-not $SourceItemTicks) {
                    $IsPathValid = $false
                }
                else {
                    $NilDiff = $SourceItemTicks -eq $DestinationItemTicks
                }

                if ((-not $NilDiff) -and ($IsPathValid)) {
                    try {
                        if ($_.UpdatePolicy -eq "Overwrite") {
                            $IsDestinationValid = Test-Path -Path $_.Destination

                            if ($IsDestinationValid -eq $false) {
                                New-Item -Path $_.Destination -ItemType Directory
                            }
                        }
                        elseif ($_.UpdatePolicy -eq "New") {
                            $LeafName = Split-Path -Path $_.Path -LeafBase
                            $LeafEx = Split-Path -Path $_.Path -Extension

                            $Items = Get-ChildItem $_.Destination -Recurse
                            if ($Items) {

                                if ($IsAFile) {
                                    $ItemNamePattern = "[$LeafName].*[$LeafEx]"
                                    $ItemModePattern = '.*[a].*'
                                }
                                else {
                                    $ItemNamePattern = "[$LeafName].*"
                                    $ItemModePattern = '.*[d].*'
                                }
                                    
                                $LastIndexedName = $Items | `
                                    Where-Object Name -match $ItemNamePattern | `
                                    Where-Object Mode -match $ItemModePattern | `
                                    Where-Object Name -match '.*\(\d+\)' | `
                                    Sort-Object -Descending | `
                                    Select-Object Name -First 1 -ExpandProperty Name

                                if ($LastIndexedName) {
                                    [int]$LastIndexValue = [regex]::Match($LastIndexedName, "(?<=\()\d+(?=\))").Value
                                    $NewIndexValue = ++$LastIndexValue
                                }
                                else {
                                    $NewIndexValue = 1
                                }
                            }
                            else {
                                $NewIndexValue = 1
                            }
                    
                            $NewName = "$LeafName($NewIndexValue)$LeafEx"

                            $NewPath = Join-Path -Path $_.Destination -ChildPath $NewName

                            if ($IsAFile) {
                                $NewItem = New-Item $NewPath -ItemType File
                            }
                            else {
                                $NewItem = New-Item $NewPath -ItemType Directory
                            }

                            $_.Destination = $NewItem.FullName
                            $IsDestinationValid = Test-Path -Path $NewItem
                        }
                    }
                    catch {
                        $IsDestinationValid = $false
                    }
                }

                if ($NilDiff) {
                    Write-Host "Backup data sources has no changes." -ForegroundColor Green 
                }
                elseif (($IsPathValid) -and ($IsDestinationValid)) {
                    if ($_.UpdatePolicy -eq "Overwrite") {
                        Copy-Item -Path $_.Path -Destination $_.Destination -Force -Recurse
                        Write-Host "Backup data sources completed." -ForegroundColor Green
                    }
                    elseif ($_.UpdatePolicy -eq "New") {
                        if ((Test-Path $_.Path -PathType Leaf) -eq $true) {
                            Copy-Item -Path $_.Path -Destination $NewItem.FullName
                        }
                        else {
                            Copy-Item -Path $_.Path -Destination $NewItem.FullName -Recurse -Container
                        }
                    }
                }
                elseif ((-not $IsPathValid) -and (-not $IsDestinationValid)) {
                    Write-Host "Backup data sources was not completed due to invalid entries for 'Backups' Path and Destination field. To set a new value for 'Backups' call the following: Set-MKPowerShellSetting -Name Backups -Value @{Path: 'E:\file', Destination: 'E:\CloudFolder'}" -ForegroundColor Red 
                }
                elseif (-not $IsPathValid) {
                    Write-Host "Backup data sources was not completed due to invalid entry (or entries) for 'Backups' Path field. To set a new value for 'Backups' call the following: Set-MKPowerShellSetting -Name Backups -Value @{Path: 'E:\file', Destination: 'E:\CloudFolder'}" -ForegroundColor Red 
                }
                elseif (-not $IsDestinationValid) {
                    Write-Host "Backup data sources was not completed due to invalid entry for 'Backups' Destination field. To set a new value for 'Backups' call the following: Set-MKPowerShellSetting -Name Backups -Value @{Path: 'E:\file', Destination: 'E:\CloudFolder'}" -ForegroundColor Red 
                }
            }
        }
    }
    else {
        # if called manually when 'TurnOnBackup' is false 
        if (-not $Initialize.IsPresent) { 
            Write-Host "'TurnOnBackup' is currently disabled. To enable call: Set-MKPowerShellSetting -Name TurnOnBackup -Value '$true'." -ForegroundColor Yellow
        }
    }
}