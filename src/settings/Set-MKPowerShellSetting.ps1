function Set-MKPowerShellSetting {
    [CmdletBinding(PositionalBinding = $True)]
    Param(
        [Parameter(Mandatory = $True)]
        [String]$Value,

        [Parameter(Mandatory = $False)]
        [String]$ConfigFilePath = $script:MKPowerShellConfigFilePath,

        [switch]
        $PassThru
    )

    DynamicParam {
        if (-not $ConfigFilePath) {
            $ConfigFilePath = $script:MKPowerShellConfigFilePath
        }
        return Get-DynamicParameterValues -ConfigFilePath $ConfigFilePath
    }

    begin {
        $Name = $PSBoundParameters['Name']
    }

    end {
        # cast to bool, make all chars lowercase...
        if ($Value -match "^(T|t)rue|(F|f)alse$") {
            $Value = $Value.ToLower()
        }
       
        $Script:MKPowerShellConfig = Get-Content -Path $ConfigFilePath | `
            ConvertFrom-Json -AsHashtable
        $Script:MKPowerShellConfig[$Name] = $Value

        $Script:MKPowerShellConfig | `
            ConvertTo-Json | `
            Set-Content -Path $ConfigFilePath -PassThru:$PassThru.IsPresent

        switch ($Name) {
            TurnOnRememberLastLocation { Restore-RememberLastLocation }
            TurnOnQuickRestart { Restore-QuickRestartSetting }
            #TurnOnHistoryRecording { Restore-TurnOnHistoryRecording }
            #TurnOnBackup
            Default {}
        }
    }
}