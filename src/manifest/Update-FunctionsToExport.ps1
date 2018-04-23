# Update-ManifestFunctionsToExportField
function Update-FunctionsToExport {
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

    end {
        $ManifestFile = Get-Item -Path $ManifestUpdate.ManifestPath
        $FunctionNames = $ManifestUpdate.TargetFunctionsToExport.FunctionName
        Update-ModuleManifest -Path $ManifestFile -FunctionsToExport $FunctionNames 

        if ($PassThru) {
            $ManifestFile
        }
    }
}