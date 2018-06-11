using module .\..\Get-ModuleInfo.ps1

# RegEx pattern is from here: https://regex101.com/r/gG8cK7/1
function Update-SemVer {
    [CmdletBinding(PositionalBinding = $true)]
    Param(
        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = "ByPath")]
        [string]$Path,
        
        [Parameter(Mandatory = $false)]
        [ValidatePattern("^(?'MAJOR'0|(?:[1-9]\d*))\.(?'MINOR'0|(?:[1-9]\d*))\.(?'PATCH'0|(?:[1-9]\d*))(?:-(?'prerelease'(?:0|(?:[1-9A-Za-z-][0-9A-Za-z-]*))(?:\.(?:0|(?:[1-9A-Za-z-][0-9A-Za-z-]*)))*))?(?:\+(?'build'(?:0|(?:[1-9A-Za-z-][0-9A-Za-z-]*))(?:\.(?:0|(?:[1-9A-Za-z-][0-9A-Za-z-]*)))*))?$")]
        [String]$Value,

        [Parameter(Mandatory = $false,
            Position = 1)]
        [int]$Major = -1,

        [Parameter(Mandatory = $false,
            Position = 2)]
        [int]$Minor = -1,

        [Parameter(Mandatory = $false,
            Position = 3)]
        [int]$Patch = -1,

        [switch]$BumpMajor,

        [switch]$BumpMinor,

        [switch]$BumpPatch
    )

    $ModuleInfo = Get-ModuleInfo -Path $Path
    $Path = ($ModuleInfo | Select-Object -ExpandProperty Values).Path

    if (-not $Value) {
        $Version = ($ModuleInfo | Select-Object -ExpandProperty Values).Version

        if ($Major -eq -1) {
            $Major = $Version.Major
        }

        if ($Minor -eq -1) {
            $Minor = $Version.Minor
        }

        if ($Patch -eq -1) {
            $Patch = $Version.Build
        }

        if ($BumpMajor.IsPresent) {
            $Major += 1
        }
        
        if ($BumpMinor.IsPresent) {
            $Minor += 1
        }
        
        if ($BumpPatch.IsPresent) {
            $Patch += 1
        }

        $Value = "$Major.$Minor.$Patch"
    }

    Update-ModuleManifest -Path $Path -ModuleVersion $Value | Out-Null

    # TODO: this should not be in this file; if its still needed make switch param to enable it
    Update-RootModuleUsingStatements -Path $Path -SourceDirectory '.\src\' | `
        Update-ManifestFunctionsToExportField

    $Value
}