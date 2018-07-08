using module .\..\dynamicparams\GetSettingsNameSet.ps1
function Get-PowerBoltSetting {
    [CmdletBinding(PositionalBinding = $true)]
    Param(
        [Parameter(Mandatory = $false,
            Position = 1)]
        [String]$ConfigFilePath = $script:MKPowerShellConfigFilePath
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
        if ($Name) {
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