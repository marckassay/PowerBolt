using module .\..\dynamicparams\GetSettingsNameSet.ps1

function Set-PowerBoltSetting {
    [CmdletBinding(PositionalBinding = $true)]
    Param(
        [Parameter(Mandatory = $true)]
        [object]$Value,

        [Parameter(Mandatory = $false)]
        [String]$ConfigFilePath = $script:MKPowerShellConfigFilePath,

        [switch]
        $PassThru
    )

    DynamicParam {
        if (-not $ConfigFilePath) {
            $ConfigFilePath = $script:MKPowerShellConfigFilePath
        }
        return GetSettingsNameSet -ConfigFilePath $ConfigFilePath
    }

    begin {
        $Name = $PSBoundParameters['Name']
    }

    end {
       
        # make sure that bools get double-quotes
        if ($Value -match "^.?true.?`$") {
            $Value = "true"
        }
        elseif (($Value -match "^.?false.?`$")) {
            $Value = "false"
        }
        $Script:MKPowerShellConfig = Get-Content -Path $ConfigFilePath | `
            ConvertFrom-Json -AsHashtable
        $Script:MKPowerShellConfig[$Name] = $Value

        $Script:MKPowerShellConfig | `
            ConvertTo-Json | `
            Set-Content -Path $ConfigFilePath -PassThru:$PassThru.IsPresent

        # TODO: not sure if these are intended to be commented out
        #switch ($Name) {
        #TurnOnRememberLastLocation { Restore-RememberLastLocation }
        #TurnOnQuickRestart { Restore-QuickRestartSetting }
        #TurnOnHistoryRecording { Restore-TurnOnHistoryRecording }
        #TurnOnBackup
        #   Default {}
        #}
    }
}