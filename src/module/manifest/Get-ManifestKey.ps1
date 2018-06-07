# NoExport: Get-ManifestKey
function Get-ManifestKey {
    [CmdletBinding(PositionalBinding = $False)]
    Param(
        [Parameter(Mandatory = $False)]
        [String]$Path,

        [Parameter(Mandatory = $False)]
        [ValidateSet("AliasesToExport", "FunctionsToExport", "RootModule", "TypesToProcess", "CmdletsToExport", "PrivateData", "FileList", "Author", "ModuleVersion", "CompanyName", "FormatsToProcess", "GUID", "Copyright")]
        [String]$Key
    )

    $Path = Get-Item $Path | Select-Object -ExpandProperty FullName

    if ($(Test-Path $Path -PathType Leaf)) {
        $ModuleDirectory = Split-Path $Path -Parent
        $FileName = Split-Path $Path -LeafBase
    }
    else {
        $ModuleDirectory = $Path
        $FileName = Split-Path $Path -Leaf
    }

    $ManifestPath = Join-Path -Path $ModuleDirectory -ChildPath "$FileName.psd1"
    
    try {
        $Results = (Import-PowerShellDataFile -Path $ManifestPath)[$Key]
    }
    catch {
        
    }

    $Results
}