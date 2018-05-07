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
        if ($Value) {
            # cast to bool, make all chars lowercase...
            if ($Value -match "^(T|t)rue|(F|f)alse$") {
                $StringValue = $Value.ToLower()
            }
            else {
                $StringValue = $Value
            }
        
            $EntryValue = @"
    $Name = '$StringValue'
"@

            $ModifiedContent = (Get-Content -Path $ConfigFilePath) | `
                ForEach-Object {$_ -Replace "^\s*$Name(\s*\=\s*)[\w\W]*", $EntryValue}
            Set-Content -Path $ConfigFilePath -Value $ModifiedContent -PassThru:$PassThru.IsPresent
        }
        <#         else if ($Data) {
            (Get-Content -Path $ConfigFilePath)
            Invoke-Command -ScriptBlock {
            .\marckassay\MK.PowerShell\MK.PowerShell.4PS\resources\MK.PowerShell-config.ps1
            $MKPowerShellConfig.BackUpLocations = $Data
            }
        } #>

        switch ($Name) {
            TurnOnRememberLastLocation { Restore-RememberLastLocation }
            TurnOnQuickRestart { Restore-QuickRestartSetting }
            #TurnOnHistoryRecording { Restore-TurnOnHistoryRecording }
            #TurnOnBackup
            Default {}
        }
    }
}