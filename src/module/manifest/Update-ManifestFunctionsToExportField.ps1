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
        
        $FunctionNames = $FunctionNames | ForEach-Object -Process {"'$_',`r`n"} | Sort-Object
        
        if ($FunctionNames -is [Object[]]) {
            $Tail = $FunctionNames.Count - 1
            $FunctionNames[$Tail] = $FunctionNames[$Tail].TrimEnd().TrimEnd(',')
        } 
        elseif ($FunctionNames -is [String]) {
            $FunctionNames = $FunctionNames.Trim().TrimEnd(',')
        }

        [regex]$InsertPointRegEx = "(?(?<=(FunctionsToExport))([\w\W]*?)|($))(?(?=\#)(?=\#)|(CmdletsToExport))"
        # PowerShellGet's Update-ModuleManifest currently has a bug that is reverting previous 
        # changed values. Because of that, using Content commands.
        # https://github.com/PowerShell/PowerShell/issues/7181
        $ManifestContents = Get-Content -Path $ManifestUpdate.ManifestPath -Raw 
        $ManifestContents = $InsertPointRegEx.Replace($ManifestContents, @"
 = @(
$FunctionNames
)
`r`n
"@, 1)

        Set-Content -Path $ManifestUpdate.ManifestPath -Value $ManifestContents -NoNewline

        if ($PassThru) {
            $ManifestFile
        }

        $OFS = ' '
    }
}