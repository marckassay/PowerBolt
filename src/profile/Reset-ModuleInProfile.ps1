function Reset-ModuleInProfile {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, Position = 1)]
        [string]
        $ProfilePath = $(Get-Variable Profile -ValueOnly),

        [switch]$ByPassForDocumentation
    )

    DynamicParam {
        # if no $ProfilePath then, platyPS likely is calling 
        if ($ProfilePath) {
            return GetImportNameParameterSet -LineStatus 'Comment' -ProfilePath $ProfilePath
        }
        else {
            return GetImportNameParameterSet -LineStatus 'Comment' -ByPassForDocumentation
        }
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