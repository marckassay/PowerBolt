using module .\..\module\Get-MKModuleInfo.ps1

function Add-ModuleToProfile {
    [CmdletBinding(PositionalBinding = $True)]
    [OutputType([String])]
    Param
    (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]
        $Path,

        [Parameter(Mandatory = $False, Position = 1)]
        [string]
        $ProfilePath = $(Get-Variable Profile -ValueOnly)
    )

    $ModuleDirectory = (Get-MKModuleInfo -Path $Path).ModuleBase

    Add-Content -Path $ProfilePath -Value "Import-Module $ModuleDirectory"
}