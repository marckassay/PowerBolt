using module .\..\module\Get-ModuleInfo.ps1

function Skip-ModuleInProfile {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, Position = 1)]
        [string]
        $ProfilePath = $(Get-Variable Profile -ValueOnly)
    )

    DynamicParam {
        return Get-ImportNameParameterSet -ProfilePath $ProfilePath
    }

    end {
        $ProfileContent = Get-Content -Path $ProfilePath -Raw
        $ImportStatement = [regex]::Match($ProfileContent, "Import-Module.*[\\|\/]$Name") | `
            Select-Object -ExpandProperty Value
    
        $SkipImportStatement = $ImportStatement.Trim()
        $ProfileContent.Replace($ImportStatement, "# $SkipImportStatement") | `
            Set-Content -Path $ProfilePath
    }
}

# NoExport: Get-ImportNameParameterSet
function Get-ImportNameParameterSet {
    [CmdletBinding(PositionalBinding = $False)]
    Param(
        [Parameter(Mandatory = $False)]
        [String]$ProfilePath = $(Get-Variable Profile -ValueOnly)
    )

    $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
    $ParamAttribute = New-Object Parameter
    $ParamAttribute.Mandatory = $True
    $ParamAttribute.Position = 0
    $AttributeCollection.Add($ParamAttribute)
        
    if ($ProfilePath) {
        # regex below returns the last directory in Path value for Import-Module
        $ProfileRaw = Get-Content -Path $ProfilePath -Raw
        $ModuleBases = [regex]::Matches($ProfileRaw, "(?<=Import-Module ).*\\(\S*)") | ForEach-Object {$_.Groups[1].Value}
    }
    else {
        $ModuleBases = '<ModuleName>'
    }

    $ValidateSet = New-Object ValidateSet(@($ModuleBases))

    $AttributeCollection.Add($ValidateSet)
    $RuntimeParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Name', [string], $AttributeCollection)
    $RuntimeParamDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
    $RuntimeParamDictionary.Add('Name', $RuntimeParam)
  
    return $RuntimeParamDictionary
}