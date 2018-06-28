using module .\..\module\Get-MKModuleInfo.ps1

function Add-ModuleToProfile {
    [CmdletBinding(PositionalBinding = $True, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $False,
            Position = 0,
            ValueFromPipeline = $False, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.',

        [Parameter(Mandatory = $False, Position = 1)]
        [string]
        $ProfilePath = $(Get-Variable Profile -ValueOnly)
    )
    
    $ModuleDirectory = Get-MKModuleInfo -Path $Path | Select-Object -ExpandProperty Path

    if (Test-Path $ModuleDirectory) {
        Add-Content -Path $ProfilePath -Value "Import-Module $ModuleDirectory`n"
    }
}