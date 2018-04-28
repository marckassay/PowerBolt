$Script:MKPowerShellConfig

function Get-MKPowerShellSetting {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)]
        [String]$Path = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData)
    )

    DynamicParam {
        return Get-DynamicParameterValues -Path $Path
    }

    begin {
        $Name = $PSBoundParameters['Name']
    }

    end {
        ($Script:MKPowerShellConfig[$Name] -eq $true)
    }
}

function Get-DynamicParameterValues {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [String]$Path
    )
    
    # surfaces the $MKPowerShellConfig variable in the file of $Path
    Invoke-Expression -Command "using module $Path"

    $Script:MKPowerShellConfig = $MKPowerShellConfig
    $SettingNames = $Script:MKPowerShellConfig | ForEach-Object { $_.Keys }

    $ParamAttribute = New-Object Parameter
    $ParamAttribute.Mandatory = $true
    $ParamAttribute.ParameterSetName = '__AllParameterSets'

    $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
    $AttributeCollection.Add($ParamAttribute)
    $AttributeCollection.Add((New-Object ValidateSet(@($SettingNames))))

    $RuntimeParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Name', [string], $AttributeCollection)
    $RuntimeParamDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
    $RuntimeParamDictionary.Add('Name', $RuntimeParam)
  
    return $RuntimeParamDictionary
}