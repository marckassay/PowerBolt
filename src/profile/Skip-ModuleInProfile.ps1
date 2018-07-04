using module .\..\dynamicparams\GetImportNameParameterSet.ps1
using module .\..\module\Get-MKModuleInfo.ps1

$script:ProfilePath

function Skip-ModuleInProfile {
    [CmdletBinding(PositionalBinding = $true)]
    Param
    (
        [Parameter(Mandatory = $false, Position = 1)]
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
        
        $ImportStatementLine = [regex]::Match($ProfileContent, ".*(?:Import-Module).*(?=$Name).*") | `
            Select-Object -ExpandProperty Value
        
        $ImportStatementPath = [regex]::Match($ImportStatementLine, "(?<=Import-Module).*$") | `
            Select-Object -ExpandProperty Value

        $ImportStatementPath = $ImportStatementPath.Trim()

        $UpdatedProfileContent = [regex]::Replace($ProfileContent, ".*(?:Import-Module).*(?=$Name).*", "# Import-Module $ImportStatementPath")

        $UpdatedProfileContent = $UpdatedProfileContent.Trim()

        Set-Content -Path $script:ProfilePath -Value $UpdatedProfileContent
    }
}