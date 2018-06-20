using module .\..\Get-MKModuleInfo.ps1

# RegEx pattern is from here: https://regex101.com/r/gG8cK7/1
function Update-SemVer {
    [CmdletBinding(PositionalBinding = $True, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $False,
            Position = 0,
            ValueFromPipeline = $False, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.',
        
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

        [Parameter(Mandatory = $False,
            Position = 4)]
        [string]$SourceFolderPath = 'src',

        [switch]$BumpMajor,

        [switch]$BumpMinor,

        [switch]$BumpPatch
    )

    
    DynamicParam {
        return GetModuleNameSet -Position 0 -Mandatory 
    }

    begin {
        $Name = $PSBoundParameters['Name']
    }

    end {
        if ($PSBoundParameters.Name) {
            $ModInfo = Get-MKModuleInfo -Name $Name
        }
        else {
            $ModInfo = Get-MKModuleInfo -Path $Path
        }

        if (-not $Value) {
            $Version = $ModInfo.Version

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

        Update-ModuleManifest -Path ($ModInfo.ManifestFilePath) -ModuleVersion $Value | Out-Null

        # TODO: this should not be in this file; if its still needed make switch param to enable it
        Update-RootModuleUsingStatements -Path ($ModInfo.Path) -SourceFolderPath $SourceFolderPath | `
            Update-ManifestFunctionsToExportField

        $Value
    }
}