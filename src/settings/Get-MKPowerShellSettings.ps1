function Get-MKPowerShellSettings {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True)]
        [string]$Path,

        [switch]
        $PassThru
    )
    
}