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
        $ProfilePath = $(Get-Variable Profile -ValueOnly),

        [switch]
        $NoNewline
    )

    $ModuleDirectory = (Get-ModuleInfo -Path $Path).Directory

    Add-Content -Path $ProfilePath -Value "Import-Module $ModuleDirectory" -NoNewline:$NoNewline.IsPresent
}