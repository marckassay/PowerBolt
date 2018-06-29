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

        $SilentStartupOutput = (Get-MKPowerShellSetting -Name 'TurnOnStartupOutput') -eq $false
        
        Restore-RememberLastLocation -Initialize -Silent:$SilentStartupOutput
        Restore-QuickRestartSetting -Initialize -Silent:$SilentStartupOutput
        Backup-Sources -Initialize -Silent:$SilentStartupOutput
        Restore-History -Initialize -Silent:$SilentStartupOutput
        Restore-Formats -Initialize -Silent:$SilentStartupOutput
        Restore-Types -Initialize -Silent:$SilentStartupOutput

        # Register-Shutdown
    }
}

# NoExport: Restore-RememberLastLocation
function Restore-RememberLastLocation {
    [CmdletBinding()]
    Param(
        [switch]$Initialize,
        [switch]$Silent
    )

    if ((Get-MKPowerShellSetting -Name 'TurnOnRememberLastLocation') -eq $true) {
        Set-Alias sl Set-LocationAndStore -Scope Global -Force
        if (($Initialize.IsPresent) -and -not($Silent.IsPresent)) {
            Write-Host "'sl' alias is now mapped to 'Set-LocationAndStore'." -ForegroundColor Green
        }

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
        if (($Initialize.IsPresent) -and -not($Silent.IsPresent)) {
            Write-Host "'sl' alias is now mapped to 'Set-Location'." -ForegroundColor Green
        }
    }
}

# NoExport: Restore-QuickRestartSetting
function Restore-QuickRestartSetting {
    [CmdletBinding()]
    Param(
        [switch]$Initialize,
        [switch]$Silent
    )

    if ((Get-MKPowerShellSetting -Name 'TurnOnQuickRestart') -eq $true) {
        Set-Alias pwsh Restart-PWSH -Scope Global
        if (($Initialize.IsPresent) -and -not($Silent.IsPresent)) {
            Write-Host "'pwsh' alias is now mapped to 'Restart-PWSH'." -ForegroundColor Green
        }

        Set-Alias pwsha Restart-PWSHAdmin -Scope Global
        if (($Initialize.IsPresent) -and -not($Silent.IsPresent)) {
            Write-Host "'pwsha' alias is now mapped to 'Restart-PWSHAdmin'." -ForegroundColor Green
        }
    }
    else {
        if (-not $Initialize.IsPresent) { 
            Remove-Alias pwsh -Scope Global
            if (($Initialize.IsPresent) -and -not($Silent.IsPresent)) {
                Write-Host "'pwsh' alias has been removed." -ForegroundColor Green
            }

            Remove-Alias pwsha -Scope Global
            if (($Initialize.IsPresent) -and -not($Silent.IsPresent)) {
                Write-Host "'pwsha' alias has been removed." -ForegroundColor Green
            }
        }
    }
}

# NoExport: Restore-History
function Restore-History {
    [CmdletBinding()]
    Param(
        [switch]$Initialize,
        [switch]$Silent
    )

    $IsHistoryRecordingEnabled = (Get-MKPowerShellSetting -Name 'TurnOnHistoryRecording') -eq $true

    if ($IsHistoryRecordingEnabled) { 

        $HistoryLocation = Get-MKPowerShellSetting -Name 'HistoryLocation'
        if (($HistoryLocation -eq '') -or (Test-Path -Path $HistoryLocation -ErrorAction SilentlyContinue) -eq $false) {
            $SessionHistoriesPath = New-Item -Path $script:ConfigFileParentPath"\SessionHistories.csv" -ItemType File | Select-Object -ExpandProperty FullName

            Set-MKPowerShellSetting -Name 'HistoryLocation' -Value $SessionHistoriesPath
            if (($Initialize.IsPresent) -and -not($Silent.IsPresent)) {
                Write-Host "History file has been created." -ForegroundColor Green
            }
        }
        else {
            Import-History
            if (($Initialize.IsPresent) -and -not($Silent.IsPresent)) {
                Write-Host "History is restored from previous session(s)." -ForegroundColor Green
            }
        }
    }
}

# NoExport: Restore-Formats
function Restore-Formats {
    [CmdletBinding()]
    Param(
        [switch]$Initialize,
        [switch]$Silent
    )
    
    # TODO: can't seem to have manifest's 'FormatsToProcess' key  to load files listed in it. So 
    # manually doing it for now.
    if ((Get-MKPowerShellSetting -Name 'TurnOnExtendedFormats') -eq $true) {
        # setting this to -1 to display/view all items for ListItems. For instance, Get-Module's 
        # ExportedFunction
        $global:FormatEnumerationLimit = -1

        $FormatFilePaths = Get-ManifestKey -Path $FLOWPATH -Key 'FormatsToProcess' | `
            ForEach-Object {Join-Path -Path $FLOWPATH -ChildPath $_}
        
        Update-FormatData -PrependPath $FormatFilePaths
    }
}

# NoExport: Restore-Types
function Restore-Types {
    [CmdletBinding()]
    Param(
        [switch]$Initialize,
        [switch]$Silent
    )
    
    if ((Get-MKPowerShellSetting -Name 'TurnOnExtendedTypes') -eq $false) {
        Remove-TypeData -Path $TypeFilePaths
    }
}