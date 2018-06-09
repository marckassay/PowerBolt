function Update-ManifestFunctionsToExportField {
    [CmdletBinding()]
    [OutputType([PSModuleInfo])]
    Param
    (
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True)]
        [PSObject]
        $ManifestUpdate,

        [switch]
        $PassThru
    )
    begin {
        # Prevents single space for each item in an iteration:
        # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-6#ofs
        $OFS = ''
    }
    
    # TODO: have $ManifestUpdate be typed.
    end {
        $ManifestFile = Get-Item -Path $ManifestUpdate.ManifestPath
        $FunctionNames = $ManifestUpdate.TargetFunctionsToExport.FunctionName
        
        Update-ModuleManifest -Path $ManifestFile -FunctionsToExport $FunctionNames

        # HACK: Perhaps its not possible to have Update-ModuleManifest -FunctionsToExport to be 
        # assigned an array.  So here manually edit it to have just that.
        $FunctionNames = $FunctionNames | ForEach-Object -Process {"'$_',`r`n"} | Sort-Object
        $Tail = $FunctionNames.Count - 1
        $FunctionNames[$Tail] = $FunctionNames[$Tail].Replace(",`r`n", "")

        [regex]$InsertPointRegEx = "(?(?<=(FunctionsToExport))([\w\W]*?)|($))(?(?=\#)(?=\#)|(CmdletsToExport))"
        $ManifestContents = Get-Content -Path $ManifestUpdate.ManifestPath -Raw -ReadCount 0
        $ManifestContents = $InsertPointRegEx.Replace($ManifestContents, @"
 = @(
$FunctionNames
)
`r`n
"@, 1)

        $ManifestContents | Set-Content -Path $ManifestUpdate.ManifestPath -NoNewline

        if ($PassThru) {
            $ManifestFile
        }

        $OFS = ' '
    }
}