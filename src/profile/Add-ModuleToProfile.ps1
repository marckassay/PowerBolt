. .\src\core\GetModuleInfo.ps1
function Add-ModuleToProfile {
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        [Parameter(Mandatory = $True)]
        [string]
        $Path,

        [Parameter(Mandatory = $True)]
        [string]
        $ProfilePath = $(Get-Variable Profile -ValueOnly),

        [switch]
        $NoNewline
    )

    $ModuleInfo = GetModuleInfo -Path $Path
    $Builder = [System.Text.StringBuilder]::new()
    [string]$ProfileContent = Get-Content -Path $ProfilePath -Raw
    $Builder.AppendLine($ProfileContent)
    $Builder.AppendLine("Import-Module " + $ModuleInfo.Directory)
    
    Set-Content -Path $ProfilePath -Value $Builder.ToString() -NoNewline:$NoNewline.IsPresent
}