function Reset-ModuleInProfile {
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
        $ImportStatement = [regex]::Match($ProfileContent, "# Import-Module.*[\\|\/]$Name") | `
            Select-Object -ExpandProperty Value
        $ResetImportStatement = $ImportStatement.TrimStart('#').Trim()
    
        $ProfileContent.Replace($ImportStatement, $ResetImportStatement) | `
            Set-Content -Path $ProfilePath
    }
}