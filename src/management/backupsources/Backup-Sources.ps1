using module .\..\..\ConvertTo-EnumFlag.ps1
using module .\.\BackupPredicates.ps1


function Backup-Sources {
    [CmdletBinding(PositionalBinding = $False)]
    Param(
        [Parameter(Mandatory = $False)]
        [String]$ConfigFilePath,

        [switch]$Force,
        [switch]$Initialize
    )

    # TODO: need to create a config validator and use it at least here
    if ($ConfigFilePath) {
        [BackupPredicates]$Predicates = Test-Path $ConfigFilePath | ConvertTo-EnumFlag ([BackupPredicates]::IsConfigFileValid)
        $script:MKPowerShellConfigFilePath = $ConfigFilePath
    }
    else {
        [BackupPredicates]$Predicates = [BackupPredicates]::IsConfigFileValid
    }

    if ($Predicates -band [BackupPredicates]::IsConfigFileValid) {
        if (-not $Force.IsPresent) { 
            $Predicates += (Get-MKPowerShellSetting -Name 'TurnOnBackup') -eq $true | ConvertTo-EnumFlag ([BackupPredicates]::IsTurnOnBackupValid)

            # during startup, when Backup-Sources is called the 'BackupPolicy' needs to be considered.
            if ($Initialize.IsPresent) {
                $Predicates += (Get-MKPowerShellSetting -Name 'BackupPolicy') -eq 'Auto' | ConvertTo-EnumFlag ([BackupPredicates]::IsBackupPolicyValid)
            }
            else {
                $Predicates += [BackupPredicates]::IsBackupPolicyValid
            }
        }
        elseif ($Force.IsPresent) {
            $Predicates += [BackupPredicates]::IsTurnOnBackupValid
            $Predicates += [BackupPredicates]::IsBackupPolicyValid
        }
    }

    if ($Predicates -band [BackupPredicates]::IsPrecheckValid) {
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
                    $SourceItemTick = Get-ChildItem $_.Path -Recurse -ErrorAction SilentlyContinue| `
                        Sort-Object -Property LastWriteTime -Descending -Top 1 | `
                        Get-ItemPropertyValue -Name LastWriteTime | `
                        Select-Object -ExpandProperty Ticks
                }
            }
            catch {
                $SourceItemTick = $null
            }

            if ($SourceItemTick) {
                $Predicates += [BackupPredicates]::IsPathValid
            }

            try {
                $DestinationItemTick

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
                $Predicates += [BackupPredicates]::IsItemDirty
            }
            
            if ($Predicates -band [BackupPredicates]::IsItemDirty) {
                try {
                    if ($_.UpdatePolicy -eq "Overwrite") {
                        if ((Test-Path -Path $_.Destination) -eq $false) {
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
                        $Predicates += [BackupPredicates]::IsDestinationValid
                    }
                }
                catch {
                    $Predicates -= [BackupPredicates]::IsDestinationValid
                }
            }
            
            if ($Predicates -band [BackupPredicates]::AreSourcesReady) {
                if ($_.UpdatePolicy -eq "Overwrite") {
                    Copy-Item -Path $_.Path -Destination $_.Destination -Force -Recurse
                }
                elseif ($_.UpdatePolicy -eq "New") {
                    if ($IsAFile) {
                        Copy-Item -Path $_.Path -Destination $NewItem.FullName
                    }
                    else {
                        Copy-Item -Path $_.Path -Destination $NewItem.FullName -Recurse -Container
                    }
                }
                $Predicates += [BackupPredicates]::HasUpdatedSuccessfully
            }
            Write-SourceReport $Predicates $_
            # set $Predicates to value prior to entering into for-loop
            $Predicates = [BackupPredicates]::IsPrecheckValid
        }
    }
    else {
        # if called manually when 'TurnOnBackup' is false or config is invalid
        Write-SourceReport $Predicates
    }
}

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
    
    if (-not ($Predicates -band [BackupPredicates]::IsTurnOnBackupValid)) {
        Write-Host @"
'TurnOnBackup' is currently disabled. To enable call with -Force switch or enable by calling: 
    Set-MKPowerShellSetting -Name TurnOnBackup -Value '$true'
"@ -ForegroundColor Yellow
    }
    elseif (-not ($Predicates -band [BackupPredicates]::IsItemDirty)) {
        Write-Host "The following item for MKPowerShell's Backup module detected no changes: $ItemName" -ForegroundColor Green 
    }
    elseif (-not ($Predicates -band [BackupPredicates]::IsPathValid)) {
        Write-Host "The following item for MKPowerShell's Backup module cannot be found or accessed: $ItemName" -ForegroundColor Red
    }
    elseif (-not ($Predicates -band [BackupPredicates]::IsDestinationValid)) {
        Write-Host @"
The following item's destination folder for MKPowerShell's Backup module cannot be found or accessed: $ItemName
"@ -ForegroundColor Red
    }
    elseif ($Predicates -band [BackupPredicates]::HasUpdatedSuccessfully) {
        if ($SourceItem.UpdatePolicy -eq "Overwrite") {
            Write-Host "The following item for MKPowerShell's Backup module has been updated: $ItemName" -ForegroundColor Green 
        }
        elseif ($SourceItem.UpdatePolicy -eq "New") {
            Write-Host "The following item for MKPowerShell's Backup module has created an incremental copy: $ItemName" -ForegroundColor Green 
        }
    }
}