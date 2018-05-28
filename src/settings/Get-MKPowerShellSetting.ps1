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
        return Get-DynamicParameterValues -ConfigFilePath $ConfigFilePath
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

# NoExport: Get-DynamicParameterValues
function Get-DynamicParameterValues {
    [CmdletBinding(PositionalBinding = $False)]
    Param(
        [Parameter(Mandatory = $true)]
        [String]$ConfigFilePath
    )

    $Script:MKPowerShellConfig = Get-Content -Path $ConfigFilePath | ConvertFrom-Json -AsHashtable

    $SettingNames = $Script:MKPowerShellConfig | ForEach-Object { $_.Keys }

    $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
    $ParamAttribute = New-Object Parameter
    $ParamAttribute.Mandatory = $false
    $ParamAttribute.Position = 0
    $AttributeCollection.Add($ParamAttribute)

    $ValidateSet = New-Object ValidateSet(@($SettingNames))
    $AttributeCollection.Add($ValidateSet)

    $RuntimeParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Name', [string], $AttributeCollection)
    $RuntimeParamDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
    $RuntimeParamDictionary.Add('Name', $RuntimeParam)
  
    return $RuntimeParamDictionary
}