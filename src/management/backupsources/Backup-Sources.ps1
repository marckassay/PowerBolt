using module .\BackupPredicateEnum.psm1

function Backup-Sources {
    [CmdletBinding(PositionalBinding = $False)]
    Param(
        [Parameter(Mandatory = $False)]
        [String]$ConfigFilePath,

        [switch]$Force,
        [switch]$Initialize,
        [switch]$Silent
    )

    # TODO: need to create a config validator and use it at least here
    if ($ConfigFilePath) {
        $script:MKPowerShellConfigFilePath = $ConfigFilePath
    }
    
    try {
        $ProbeBackups = Get-MKPowerShellSetting -Name 'Backups'
        $Predicates = $ProbeBackups[0] -is [hashtable] | ConvertTo-EnumFlag ([BackupPredicateEnum]::IsConfigFileValid)

        # doing deeper test against Backups
        if ($Predicates -band [BackupPredicateEnum]::IsConfigFileValid) {
            if (
                ($ProbeBackups.Path[0] -eq "") -or 
                ($ProbeBackups.Destination[0] -eq "") -or 
                (
                    ($ProbeBackups.UpdatePolicy[0] -ne "New") -and ($ProbeBackups.UpdatePolicy[0] -ne "Overwrite")
                )
            ) {
                $Predicates = 0
            }
        }
    }
    catch {
        $Predicates = 0
    }
    
    if ($Predicates -band [BackupPredicateEnum]::IsConfigFileValid) {
        if (-not $Force.IsPresent) { 
            $Predicates += (Get-MKPowerShellSetting -Name 'TurnOnBackup') -eq $true | ConvertTo-EnumFlag ([BackupPredicateEnum]::IsTurnOnBackupValid)

            # during startup, when Backup-Sources is called the 'BackupPolicy' needs to be considered.
            if ($Initialize.IsPresent) {
                $Predicates += (Get-MKPowerShellSetting -Name 'BackupPolicy') -eq 'Auto' | ConvertTo-EnumFlag ([BackupPredicateEnum]::IsBackupPolicyValid)
            }
            else {
                $Predicates += [BackupPredicateEnum]::IsBackupPolicyValid
            }
        }
        elseif ($Force.IsPresent) {
            $Predicates += [BackupPredicateEnum]::IsTurnOnBackupValid
            $Predicates += [BackupPredicateEnum]::IsBackupPolicyValid
        }
    }

    if ($Predicates -band [BackupPredicateEnum]::IsPrecheckValid) {
        Get-MKPowerShellSetting -Name 'Backups' | ForEach-Object {
            try {
                $IsAFile = (Test-Path $_.Path -PathType Leaf) -eq $true
                $Leaf = Split-Path -Path $_.Path -Leaf

                if ($IsAFile) {
                    $SourceItemTick = Get-Item $_.Path -ErrorAction SilentlyContinue | `
                        Get-ItemPropertyValue -Name LastWriteTime | `
                        Select-Object -ExpandProperty Ticks
                }
                else {
                    $SourceItemTick = Get-ChildItem $_.Path -Recurse -ErrorAction SilentlyContinue | `
                        Sort-Object -Property LastWriteTime -Descending -Top 1 | `
                        Get-ItemPropertyValue -Name LastWriteTime | `
                        Select-Object -ExpandProperty Ticks
                }
            }
            catch {
                $SourceItemTick = $null
            }

            if ($SourceItemTick) {
                $Predicates += [BackupPredicateEnum]::IsPathValid
            }

            try {
                # if running for this source for first time, this path will not exist.
                if (Test-Path -Path $_.Destination) {
                    if ($IsAFile) {
                        $DestinationItemTick = Join-Path -Path $_.Destination -ChildPath $Leaf | `
                            Get-Item -ErrorAction SilentlyContinue | `
                            Get-ItemPropertyValue -Name LastWriteTime | `
                            Select-Object -ExpandProperty Ticks
                    }
                    else {
                        $DestinationItemTick = Join-Path -Path $_.Destination -ChildPath $Leaf | `
                            Get-ChildItem -Recurse -ErrorAction SilentlyContinue | `
                            Sort-Object -Property LastWriteTime -Descending -Top 1 | `
                            Get-ItemPropertyValue -Name LastWriteTime | `
                            Select-Object -ExpandProperty Ticks
                    }
                }
            }
            catch {
                $DestinationItemTick = $null
            }
            
            if (($SourceItemTick -ne $DestinationItemTick) -or ((-not $SourceItemTick) -and (-not $DestinationItemTick))) {
                $Predicates += [BackupPredicateEnum]::IsItemDirty
            }
            
            if ($Predicates -band [BackupPredicateEnum]::IsItemDirty) {
                try {
                    if ($_.UpdatePolicy -eq "Overwrite") {
                        if ((Test-Path -Path $_.Destination) -eq $false) {
                            New-Item -Path $_.Destination -ItemType Directory
                        }

                        $Predicates += [BackupPredicateEnum]::IsDestinationValid
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
                            # NOTE: if a folder is created for a directory items, the Copy-Item will move
                            # a folder inside a folder, which is not want we want; hence no New-Item for 
                            # folder items
                            $NewItem = @{FullName = ''}
                            $NewItem.FullName = $NewPath
                        }

                        $_.Destination = $NewItem.FullName
                        $Predicates += [BackupPredicateEnum]::IsDestinationValid
                    }
                }
                catch {
                    Write-Error $Error
                }
            }
            
            if ($Predicates -band [BackupPredicateEnum]::AreSourcesReady) {
                if ($_.UpdatePolicy -eq "Overwrite") {
                    Copy-Item -Path $_.Path -Destination $_.Destination -Force -Recurse
                }
                elseif ($_.UpdatePolicy -eq "New") {
                    if ($IsAFile) {
                        Copy-Item -Path $_.Path -Destination $NewItem.FullName
                    }
                    else {
                        Copy-Item -Path $_.Path -Destination $NewItem.FullName -Recurse -Container -Force
                    }
                }
                $Predicates += [BackupPredicateEnum]::HasUpdatedSuccessfully
            }

            if (($Initialize.IsPresent) -and -not($Silent.IsPresent)) {
                Write-SourceReport $Predicates $_
            }

            # set $Predicates to value prior to entering into for-loop
            $Predicates = [BackupPredicateEnum]::IsPrecheckValid
        }
    }
    else {
        if ($Silent.IsPresent -eq $False) {
            # if called manually when 'TurnOnBackup' is false or config is invalid
            Write-SourceReport $Predicates
        }
    }
}

# NoExport: Write-SourceReport
function Write-SourceReport {
    [CmdletBinding(PositionalBinding = $true)]
    Param(
        [Parameter(Mandatory = $true)]
        [int]$Predicates,

        [Parameter(Mandatory = $false)]
        [psobject]$SourceItem
    )
    
    if ($SourceItem) {
        $ItemName = Split-Path -Path $SourceItem.Path -Leaf
    }

    if (-not ([BackupPredicateEnum]$Predicates -band [BackupPredicateEnum]::IsTurnOnBackupValid)) {
        Write-Host @"
'TurnOnBackup' is currently disabled. To enable call with -Force switch or enable by calling: 
    Set-MKPowerShellSetting -Name TurnOnBackup -Value '$true'
"@ -ForegroundColor Yellow
    }
    elseif (-not ([BackupPredicateEnum]$Predicates -band [BackupPredicateEnum]::IsItemDirty)) {
        Write-Host "The following item for MKPowerShell's Backup module detected no changes: $ItemName" -ForegroundColor Green 
    }
    elseif (-not ([BackupPredicateEnum]$Predicates -band [BackupPredicateEnum]::IsPathValid)) {
        Write-Host "The following item for MKPowerShell's Backup module cannot be found or accessed: $ItemName" -ForegroundColor Red
    }
    elseif (-not ([BackupPredicateEnum]$Predicates -band [BackupPredicateEnum]::IsDestinationValid)) {
        Write-Host @"
The following item's destination folder for MKPowerShell's Backup module cannot be found or accessed: $ItemName
This may be due to initial Backup execution.
"@ -ForegroundColor Yellow
    }
    elseif ([BackupPredicateEnum]$Predicates -band [BackupPredicateEnum]::HasUpdatedSuccessfully) {
        if ($SourceItem.UpdatePolicy -eq "Overwrite") {
            Write-Host "The following item for MKPowerShell's Backup module has been updated: $ItemName" -ForegroundColor Green 
        }
        elseif ($SourceItem.UpdatePolicy -eq "New") {
            Write-Host "The following item for MKPowerShell's Backup module has created an incremental copy: $ItemName" -ForegroundColor Green 
        }
    }
}