<#
.DESCRIPTION 
To extract the contents of a PS1 file which is then piped into Invoke-Expression.
#>
function Import-Script {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True)]
        [String]$Path,

        [Switch]$WhatIf
    )

    try {
        #Invoke-Expression ". '$Path'" 
        # Export-ModuleMember -Function 'Update-ManifestFunctionsToExportField'
        Invoke-Command {. $Path} -NoNewScope
    }
    catch {
        Write-Error "Failed to import '$Path'"
    }
}