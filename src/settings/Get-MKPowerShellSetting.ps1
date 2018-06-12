using module .\..\dynamicparams\GetSettingsNameSet.ps1
function Get-MKPowerShellSetting {
    [CmdletBinding(PositionalBinding = $True)]
    Param(
        <# DynamicParam: 
        [Parameter(Mandatory = $False,
            Position = 0)]
        [string]$Name
        #>

        [Parameter(Mandatory = $False,
            Position = 1)]
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