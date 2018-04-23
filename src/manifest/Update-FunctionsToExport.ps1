function Update-FunctionsToExport {
    [CmdletBinding()]
    [OutputType([PSModuleInfo])]
    Param
    (
        [Parameter(Mandatory = $True)]
        [string]$Path,

        [Parameter(Mandatory = $false)]
        [string]$ChildDirectory = '.\src',

        [Parameter(Mandatory = $false)]
        [string[]]$Include = '*.ps1',
 
        [Parameter(Mandatory = $false)]
        [string[]]$Exclude = '*.Tests.ps1',

        [switch]
        $PassThru
    )

    # TODO: now add functions that are in rootmodule to $FunctionsToExport

    $ManifestFile = Get-Item -Path (Join-Path -Path $Path -ChildPath '*.psd1')
    Update-ModuleManifest -Path $ManifestFile -FunctionsToExport @($FunctionsToExport)

    if ($PassThru) {
        Get-Module $ManifestFile.BaseName
    }
}