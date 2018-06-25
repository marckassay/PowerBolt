using module .\..\dynamicparams\GetImportNameParameterSet.ps1
using module .\..\module\Get-MKModuleInfo.ps1

$script:ProfilePath

function Skip-ModuleInProfile {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, Position = 1)]
        [string]
        $ProfilePath
    )

    DynamicParam {
        if (-not $ProfilePath) {
            $ProfilePath = $(Get-Variable Profile -ValueOnly)
        }
        $script:ProfilePath = $ProfilePath

        return GetImportNameParameterSet -LineStatus 'Uncomment' -ProfilePath $script:ProfilePath -Mandatory
    }
    
    begin {
        $Name = $PSBoundParameters['Name']
    }

    end {
        $ProfileContent = Get-Content -Path $script:ProfilePath -Raw
        $ImportStatement = [regex]::Match($ProfileContent, "Import-Module.*[\\|\/]$Name") | `
            Select-Object -ExpandProperty Value
    
        $SkipImportStatement = $ImportStatement.Trim()
        $ProfileContent.Replace($ImportStatement, "# $SkipImportStatement") | `
            Set-Content -Path $script:ProfilePath
    }
}