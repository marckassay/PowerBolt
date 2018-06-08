using module .\..\dynamicparameter\GetSettingsNameSet.ps1
function Get-MKPowerShellSetting {
    [CmdletBinding(PositionalBinding = $True)]
    Param(
        [Parameter(Mandatory = $False)]
        [String]$ConfigFilePath = $script:MKPowerShellConfigFilePath,

        [switch]
        $ShowAll
    )

    DynamicParam {
        if (-not $ConfigFilePath) {
            $ConfigFilePath = $script:MKPowerShellConfigFilePath
        }
        return GetSettingsNameSet -ConfigFilePath $ConfigFilePath
    }

    begin {
        if (-not $ShowAll.IsPresent) {
            $Name = $PSBoundParameters['Name']
        }
    }

    end {
        if (-not $ShowAll.IsPresent) {
            $Value = $Script:MKPowerShellConfig[$Name]
        
            if ($Value -match "((T|t)rue|(F|f)alse)") {
                ($Value -eq $true)
            }
            else {
                if ($Value -is [string]) {
                    $Value = $Value -replace "\'", ""
                }

                $Value
            }
        }
        else {
            Write-Output $ConfigFilePath":"
            Write-Output ''
            Get-Content -Path $ConfigFilePath | Write-Output
        }
    }
}