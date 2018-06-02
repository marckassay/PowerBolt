# NoExport: Get-ModuleInfo
function Get-ModuleInfo {
    [CmdletBinding()]
    [OutputType([PSObject])]
    Param
    (
        [Parameter(Mandatory = $True)]
        [string]
        $Path
    )

    $Path = Get-Item $Path | Select-Object -ExpandProperty FullName
    # if backslash is at the end and this value is used with Import-Module, it will fail to import
    $Path = $Path.TrimEnd('\')

    if ($(Test-Path $Path -PathType Leaf)) {
        $ModuleDirectory = Split-Path $Path -Parent
        $ModuleName = Split-Path $Path -LeafBase
    }
    else {
        $ModuleDirectory = $Path
        $ModuleName = Split-Path $Path -Leaf
    }

    $ManifestFilePath = Join-Path -Path $ModuleDirectory -ChildPath "$ModuleName.psd1"
    $Manifest = Test-ModuleManifest $ManifestFilePath
    $ModuleFilePath = $(Join-Path $ModuleDirectory -ChildPath $ModuleName'.psm1')

    [psobject]$ModuleInfo = @{
        Manifest         = $Manifest
        ManifestFilePath = $ManifestFilePath
        Name             = $ModuleName
        Directory        = $ModuleDirectory
        FilePath         = $ModuleFilePath
    }

    $ModuleInfo
}