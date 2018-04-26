function Get-MKPowerShellSetting {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True)]
        [string]$Path,

        [switch]
        $PassThru
    )
    
}