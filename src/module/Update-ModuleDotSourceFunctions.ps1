function Update-ModuleDotSourceFunctions {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [PSModuleInfo]
        $Manifest
    )

    if ($Manifest.ExportedFunctions) {
        $ManifestWithNoDotSourceLines = Get-Content $Manifest.Path | `
            ForEach-Object -Begin {$DotSourceLinesCount = 0} -Process {
            if ($_ -match '(?<=(\. \.\\)).*(?=(\.ps1))') {
                $DotSourceLinesCount++
            }
            else {
                $_
            }
        }

        # if there are any existing dot-source functions in this module...
        if ($DotSourceLinesCount -gt 0) {
            Write-Verbose @"
Update-ModuleDotSourceFunctions: A total of $DotSourceLinesCount was removed in $($Manifest.RootModule).
"@
            $Manifest.ExportedFunctions | ForEach-Object { ". .\$_"}
            $ManifestWithNoDotSourceLines
            $Manifest.ExportedFunctions
        }
    }
}