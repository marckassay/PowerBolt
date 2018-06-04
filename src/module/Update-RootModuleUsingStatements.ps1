function Update-RootModuleUsingStatements {
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
    # TODO: from this line to line 41, replace with Get-ModuleInfo
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

    # cleaned as in existing 'using' statements removed
    $UsingStatements = 0

    # stop matching when there is a break of consecutive 'using module' statements.  a break with 
    # additional statements means that developer manually added that line; so keep it.
    $StopMatchingImportStatements = $false
    
    $ModuleContentsCleaned = Get-Content $ModulePath | `
        ForEach-Object -Process {
        if ((-not $StopMatchingImportStatements) -and ($_ -match '(?<=(using module \.\\)).*(?=(\.ps1))')) {
            $UsingStatements++
        }
        elseif ($_.Count -ge 1) {
            "$_`n"
            $StopMatchingImportStatements = $true
        }
        else {
            $StopMatchingImportStatements = $true
        }
    }

    $TargetFunctionsToExport = Get-ChildItem -Path $TargetDirectory -Include $Include -Exclude $Exclude -Recurse | `
        Get-Item -Include $Include -PipelineVariable File | `
        Get-Content -Raw | `
        ForEach-Object {
        $NoExportMatches = [regex]::Matches($_, '(?<=NoExport)(?:[:\s]*?)(?<sanitized>\w*-\w*)')
        $FunctionMatches = [regex]::Matches($_, '(?<=function )[\w]*[-][\w]*')
        for ($i = 0; $i -lt $FunctionMatches.Count; $i++) {
            $FunctionName = $FunctionMatches[$i].Value
            if (($NoExportMatches | ForEach-Object {$_.Groups['sanitized'].Value}) -notcontains $FunctionName) {
                @{
                    FilePath     = $File
                    FunctionName = $FunctionName
                }
            }
        }
    }

    $UniqueSourceFiles = $TargetFunctionsToExport.FilePath.FullName | `
        Sort-Object -Unique | `
        Group-Object -Property {$_.Split('src\')[1]} | `
        Select-Object -ExpandProperty Group | `
        ForEach-Object {
        if ($_ -ne $ModulePath) {
            Write-Output "using module .$($_.Split($ModuleDirectory)[1])`n"
        }
    }
    
    if ($ModuleContentsCleaned -eq $null) {
        $UpdatedModuleContent = @"
$UniqueSourceFiles
"@
    }
    elseif ($ModuleContentsCleaned -ne $null) {
        $UpdatedModuleContent = @"
$UniqueSourceFiles
$ModuleContentsCleaned
"@
    }

    @{
        ManifestPath            = $ManifestPath
        TargetFunctionsToExport = $TargetFunctionsToExport
    }
    
    Set-Content -Path $ModulePath -Value $UpdatedModuleContent -PassThru:$PassThru.IsPresent -Encoding UTF8 -NoNewline
}