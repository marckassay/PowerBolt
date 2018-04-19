<#
.DESCRIPTION 
To extract the contents of a PS1 file which is then piped into Invoke-Expression.
#>
function Import-Script {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True)]
        [ValidatePattern('(.ps1)$')]
        [ValidateScript( {Test-Path -Path $_ -PathType Leaf })]
        [string]$Path,

        [switch]$WhatIf
    )

    try {
        [string]$Content = Get-Content -Path $Path -Raw -Verbose
        Invoke-Expression -Command @"
$Content
"@ -Verbose

    }
    catch {
        Write-Error "Failed to import '$Path'"
    }
}