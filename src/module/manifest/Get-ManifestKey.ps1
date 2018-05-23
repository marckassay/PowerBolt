# TODO: this currently only works for 'FormatsToProcess'
function Get-ManifestKey {
    [CmdletBinding(PositionalBinding = $False)]
    Param(
        [Parameter(Mandatory = $False)]
        [String]$Path,

        [Parameter(Mandatory = $False)]
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
    
    $ManifestContents = Get-Content -Path $ManifestPath -Raw

    try {
        $FormatsToProcessRaw = [regex]::Match($ManifestContents, '(?<=FormatsToProcess)([\w\W]*?\))').Value
        # TODO: eh, can't match without '=' at this time
        $ResultsString = $FormatsToProcessRaw.Replace('=', '')
        $Results = Invoke-Expression $ResultsString
    }
    catch {
        
    }

    $Results
}