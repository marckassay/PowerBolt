#Update-RootModuleDotSourceImports
function Update-ModuleDotSourceFunctions {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True)]
        [string]$Path,

        [Parameter(Mandatory = $false)]
        [string]$SourceDirectory,

        [Parameter(Mandatory = $false)]
        [string[]]$Include = @('*.ps1', '*.psm1'),
 
        [Parameter(Mandatory = $false)]
        [string[]]$Exclude = '*.Tests.ps1',

        [switch]
        $PassThru
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
    $Manifest = Test-ModuleManifest $ManifestPath
    $ModulePath = $(Join-Path $ModuleDirectory -ChildPath $FileName'.psm1')
    if (-not $SourceDirectory) {
        $TargetDirectory = $ModuleDirectory
    }
    else {
        $TargetDirectory = (Join-Path -Path $ModuleDirectory -ChildPath $SourceDirectory)
    }

    # cleaned as in dot-source lines removed
    $ModuleContentsCleaned = Get-Content $ModulePath | `
        ForEach-Object -Begin {$DotSourceLinesCount = 0} -Process {
        if ($_ -match '(?<=(\. \.\\)).*(?=(\.ps1))') {
            $DotSourceLinesCount++
        }
        else {
            $_
        }
    }

    $TargetFunctionsToExport = Get-ChildItem -Path $TargetDirectory -Include $Include -Exclude $Exclude -Recurse | `
        Get-Item -Include $Include -PipelineVariable File | `
        Get-Content | `
        ForEach-Object {
        $FunctionMatches = [regex]::Matches($_, '(?<=function )[\w]*[-][\w]*')
        for ($i = 0; $i -lt $FunctionMatches.Count; $i++) {
            @{
                FilePath     = $File
                FunctionName = $FunctionMatches[$i].Value
            }
        }
    }

    if ($DotSourceLinesCount -gt 0) {
        Write-Verbose "Update-ModuleDotSourceFunctions: A total of $DotSourceLinesCount was removed in $($Manifest.RootModule)."
    }
    
    $DotSourcedFiles = $TargetFunctionsToExport.FilePath.FullName | `
        Sort-Object -Unique | `
        ForEach-Object {
        if ($_ -ne $ModulePath) {
            @"
. .$($_.Split($ModuleDirectory)[1])`r`n
"@
        }
    }
    
    if ($ModuleContentsCleaned -eq $null) {
        $UpdatedModuleContent = @"
$DotSourcedFiles
"@
    }
    elseif ($ModuleContentsCleaned -ne $null) {
        $UpdatedModuleContent = @"
$DotSourcedFiles
$ModuleContentsCleaned
"@
    }

    @{
        ManifestPath            = $ManifestPath
        TargetFunctionsToExport = $TargetFunctionsToExport
    }
    
    Set-Content -Path $ModulePath -Value $UpdatedModuleContent -PassThru:$PassThru.IsPresent -Encoding UTF8 -NoNewline
}