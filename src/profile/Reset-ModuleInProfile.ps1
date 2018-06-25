function Reset-ModuleInProfile {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, Position = 1)]
        [string]
        $ProfilePath,

        [switch]$ByPassForDocumentation
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
        $ProfileContent = Get-Content -Path $ProfilePath -Raw
        $ImportStatement = [regex]::Match($ProfileContent, "# Import-Module.*[\\|\/]$Name") | `
            Select-Object -ExpandProperty Value
        $ResetImportStatement = $ImportStatement.TrimStart('#').Trim()
    
        $ProfileContent.Replace($ImportStatement, $ResetImportStatement) | `
            Set-Content -Path $ProfilePath
    }
}