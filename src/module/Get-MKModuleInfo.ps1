using module .\..\dynamicparams\GetModuleNameSet.ps1
using module .\MKModuleInfo.psm1

function Get-MKModuleInfo {
    [CmdletBinding(PositionalBinding = $True, 
        DefaultParameterSetName = "ByPath")]
    [OutputType([MKModuleInfo])]
    Param
    (
        [Parameter(Mandatory = $False,
            Position = 0,
            ValueFromPipeline = $False, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.'
    )

    DynamicParam {
        return GetModuleNameSet -Mandatory
    }
    
    begin {
        $Name = $PSBoundParameters['Name']
    }
    
    end {
        if (-not $Name) {
            [MKModuleInfo]::new($Path, $null)
        }
        else {
            [MKModuleInfo]::new($null, $Name)
        }
    }
}