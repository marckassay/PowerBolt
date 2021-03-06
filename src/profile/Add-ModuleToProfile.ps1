using module .\..\module\Get-MKModuleInfo.ps1

function Add-ModuleToProfile {
    [CmdletBinding(PositionalBinding = $true, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $false, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.',

        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        $ProfilePath = $(Get-Variable Profile -ValueOnly)
    )
    
    $ModuleDirectory = Get-MKModuleInfo -Path $Path | Select-Object -ExpandProperty Path

    if (Test-Path $ModuleDirectory) {
        $ProfileContent = Get-Content -Path $ProfilePath -Raw

        if ($ProfileContent) {
            $UpdatedProfileContent = $ProfileContent.Trim()
        }

        $UpdatedProfileContent = @"
$UpdatedProfileContent
Import-Module $ModuleDirectory
"@
        Set-Content -Path $ProfilePath -Value $UpdatedProfileContent
    }
}