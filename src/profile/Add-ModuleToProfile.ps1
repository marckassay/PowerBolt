function Add-ModuleToProfile {
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        [Parameter(Mandatory = $True)]
        [string]
        $Path,

        [Parameter(Mandatory = $False)]
        [string]
        $ProfilePath = $(Get-Variable Profile -ValueOnly),

        [switch]
        $NoNewline
    )

    $ModuleDirectory = (Get-ModuleInfo -Path $Path).Directory

    Add-Content -Path $ProfilePath -Value "Import-Module $ModuleDirectory" -NoNewline:$NoNewline.IsPresent
}