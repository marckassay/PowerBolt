using module .\..\dynamicparameter\GetSettingsNameSet.ps1

function Set-MKPowerShellSetting {
    [CmdletBinding(PositionalBinding = $True)]
    Param(
        [Parameter(Mandatory = $True)]
        [object]$Value,

        [Parameter(Mandatory = $False)]
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
       
        $Script:MKPowerShellConfig = Get-Content -Path $ConfigFilePath | `
            ConvertFrom-Json -AsHashtable
        $Script:MKPowerShellConfig[$Name] = $Value

        $Script:MKPowerShellConfig | `
            ConvertTo-Json | `
            Set-Content -Path $ConfigFilePath -PassThru:$PassThru.IsPresent

        switch ($Name) {
            TurnOnRememberLastLocation { Restore-RememberLastLocation }
            TurnOnQuickRestart { Restore-QuickRestartSetting }
            # TODO: not sure if these are intended to be commented out
            #TurnOnHistoryRecording { Restore-TurnOnHistoryRecording }
            #TurnOnBackup
            Default {}
        }
    }
}