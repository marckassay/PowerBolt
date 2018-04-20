function Update-FunctionsToExport {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True)]
        [string]$Path,

        [Parameter(Mandatory = $false)]
        [string]$ChildDirectory = '.\src',

        [Parameter(Mandatory = $false)]
        [string[]]$Include = '*.ps1',
 
        [Parameter(Mandatory = $false)]
        [string[]]$Exclude
    )
    $TargetDirectory = (Join-Path -Path $Path -ChildPath $ChildDirectory)
    $FunctionsToExport = Get-ChildItem -Path $TargetDirectory -Include $Include -Exclude $Exclude -Recurse | `
        Get-Content | `
        ForEach-Object {
        $FunctionMatches = [regex]::Matches($_, '(?<=function )[\w]*[-][\w]*')
        for ($i = 0; $i -lt $FunctionMatches.Count; $i++) {
            $FunctionMatches[$i].Value
        }
    }
    $ManifestFile = Get-Item -Path (Join-Path -Path $Path -ChildPath '*.psd1')
    Update-ModuleManifest -Path $ManifestFile -FunctionsToExport $FunctionsToExport -PassThru
}