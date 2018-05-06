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
        if ($Value -match "(('|`")(T|t)rue('|`")|('|`")(F|f)alse('|`"))") {
            $StringValue = $Value.ToLower()
        }
        else {
            $StringValue = $Value
        }
        
        $EntryValue = @"
    $Name = '$StringValue'
"@

        (Get-Content -Path $ConfigFilePath) | `
            ForEach-Object {$_ -Replace "^\s*$Name(\s*\=\s*)[\w\W]*", $EntryValue} | `
            Set-Content -Path $ConfigFilePath -PassThru:$PassThru.IsPresent

        switch ($Name) {
            TurnOnRememberLastLocation { Restore-RememberLastLocation }
            #TurnOnHistoryRecording { Restore-TurnOnHistoryRecording }
            Default {}
        }
    }
}

# NoExport: Restore-RememberLastLocation
function Restore-RememberLastLocation {
    [CmdletBinding()]
    Param(
        [switch]$ExecutePostAction
    )

    if ((Get-MKPowerShellSetting -Name 'TurnOnRememberLastLocation') -eq $true) {
        Set-Alias sl Set-LocationAndStore -Scope Global -Force
        Write-Host "'sl' alias is now mapped to 'Set-LocationAndStore'." -ForegroundColor Green

        if ($ExecutePostAction.IsPresent) {
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