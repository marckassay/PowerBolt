$Script:MKPowerShellConfig

function Set-MKPowerShellSetting {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [String]$Value,

        [Parameter(Mandatory = $False)]
        [String]$Path = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData),

        [switch]
        $PassThru
    )

    DynamicParam {
        return Get-DynamicParameterValues -Path $Path
    }

    begin {
        $Name = $PSBoundParameters['Name']
    }

    end {
        # cast to bool, make all chars lowercase...
        $StringValue = "$Value".ToLower()
        $EntryValue = @"
    $Name = '$StringValue'
"@

        (Get-Content -Path $Path) | ForEach-Object {$_ -Replace "^.*$Name.*$", $EntryValue} | Set-Content -Path $Path -PassThru:$PassThru.IsPresent
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