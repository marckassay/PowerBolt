function Reset-ModuleInProfile {
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
        return Get-ImportNameParameterSet -LineStatus 'Comment' -ProfilePath $ProfilePath 
    }

    begin {
        $Name = $PSBoundParameters['Name']
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