function Reset-ModuleInProfile {
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

        return GetImportNameParameterSet -LineStatus 'Comment' -ProfilePath $script:ProfilePath -Mandatory
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
        
        $UpdatedProfileContent = [regex]::Replace($ProfileContent, ".*(?:Import-Module).*(?=$Name).*", "Import-Module $ImportStatementPath")
        
        $UpdatedProfileContent = $UpdatedProfileContent.Trim()

        Set-Content -Path $script:ProfilePath -Value $UpdatedProfileContent
    }
}