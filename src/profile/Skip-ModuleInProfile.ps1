using module .\..\module\Get-MKModuleInfo.ps1

function Skip-ModuleInProfile {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, Position = 1)]
        [string]
        $ProfilePath = $(Get-Variable Profile -ValueOnly)
    )

    DynamicParam {
        if (-not $ProfilePath) {
            $ProfilePath = $(Get-Variable Profile -ValueOnly)
        }
        return Get-ImportNameParameterSet -LineStatus 'Uncomment' -ProfilePath $ProfilePath 
    }
    
    begin {
        $Name = $PSBoundParameters['Name']
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
    [CmdletBinding(PositionalBinding = $True)]
    Param(
        [Parameter(Mandatory = $True)]
        [ValidateSet("Uncomment", "Comment")]
        [String[]]
        $LineStatus,

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
        if ($LineStatus -eq "Uncomment") {
            $ModuleBases = [regex]::Matches($ProfileRaw, "(?<=Import-Module ).*\\(\S*)") | ForEach-Object {$_.Groups[1].Value}
        }
        else {
            $ModuleBases = [regex]::Matches($ProfileRaw, "(?<=\# Import-Module ).*\\(\S*)") | ForEach-Object {$_.Groups[1].Value}
        }
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