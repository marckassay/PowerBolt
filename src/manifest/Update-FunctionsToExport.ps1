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

    $TargetDirectory = (Join-Path -Path $Path -ChildPath $ChildDirectory)
    $FunctionsToExport = Get-ChildItem -Path $TargetDirectory -Include $Include -Exclude $Exclude -Recurse | `
        Get-Item -Include $Include -PipelineVariable File | `
        Get-Content | `
        ForEach-Object {
        $FunctionMatches = [regex]::Matches($_, '(?<=function )[\w]*[-][\w]*')
        for ($i = 0; $i -lt $FunctionMatches.Count; $i++) {
            $FunctionMatches[$i].Value
        }
    }
    $ManifestFile = Get-Item -Path (Join-Path -Path $Path -ChildPath '*.psd1')
    Update-ModuleManifest -Path $ManifestFile -FunctionsToExport @($FunctionsToExport)

    if ($PassThru) {
        Get-Module $ManifestFile.BaseName
    }
}