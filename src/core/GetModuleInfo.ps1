function GetModuleInfo($Path) {
    $Path = Get-Item $Path | Select-Object -ExpandProperty FullName

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

    return @{
        Manifest         = $Manifest
        ManifestFilePath = $ManifestFilePath
        Name             = $ModuleName
        Directory        = $ModuleDirectory
        FilePath         = $ModuleFilePath
    }
}