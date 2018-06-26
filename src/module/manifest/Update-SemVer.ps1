using module .\..\Get-MKModuleInfo.ps1
using module .\Get-GitBranchName.ps1

# RegEx pattern is from here: https://regex101.com/r/gG8cK7/1
$script:SemVerRegEx = "^(?'MAJOR'0|(?:[1-9]\d*))\.(?'MINOR'0|(?:[1-9]\d*))\.(?'PATCH'0|(?:[1-9]\d*))(?:-(?'prerelease'(?:0|(?:[1-9A-Za-z-][0-9A-Za-z-]*))(?:\.(?:0|(?:[1-9A-Za-z-][0-9A-Za-z-]*)))*))?(?:\+(?'build'(?:0|(?:[1-9A-Za-z-][0-9A-Za-z-]*))(?:\.(?:0|(?:[1-9A-Za-z-][0-9A-Za-z-]*)))*))?$"

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
        
        [Parameter(Mandatory = $false, 
            ParameterSetName = "ByValue")]
        [ValidatePattern("^(?'MAJOR'0|(?:[1-9]\d*))\.(?'MINOR'0|(?:[1-9]\d*))\.(?'PATCH'0|(?:[1-9]\d*))(?:-(?'prerelease'(?:0|(?:[1-9A-Za-z-][0-9A-Za-z-]*))(?:\.(?:0|(?:[1-9A-Za-z-][0-9A-Za-z-]*)))*))?(?:\+(?'build'(?:0|(?:[1-9A-Za-z-][0-9A-Za-z-]*))(?:\.(?:0|(?:[1-9A-Za-z-][0-9A-Za-z-]*)))*))?$")]
        [Parameter(ParameterSetName = "ByPath")]
        [Parameter(ParameterSetName = "ByName")]
        [String]$Value,

        [Parameter(Mandatory = $false,
            Position = 1, 
            ParameterSetName = "ByNumbers")]
        [Parameter(Mandatory = $false,
            Position = 1, 
            ParameterSetName = "ByPath")]
        [Parameter(Mandatory = $false,
            Position = 1, 
            ParameterSetName = "ByName")]
        [int]$Major = -1,

        [Parameter(Mandatory = $false,
            Position = 2, 
            ParameterSetName = "ByNumbers")]
        [Parameter(Mandatory = $false,
            Position = 2, 
            ParameterSetName = "ByPath")]
        [Parameter(Mandatory = $false,
            Position = 2, 
            ParameterSetName = "ByName")]
        [int]$Minor = -1,

        [Parameter(Mandatory = $false,
            Position = 3, 
            ParameterSetName = "ByNumbers")]
        [Parameter(Mandatory = $false,
            Position = 3, 
            ParameterSetName = "ByPath")]
        [Parameter(Mandatory = $false,
            Position = 3, 
            ParameterSetName = "ByName")]
        [int]$Patch = -1,

        [Parameter(Mandatory = $False,
            Position = 4)]
        [string]$SourceFolderPath = 'src',

        [Parameter(ParameterSetName = "ByBumping")]
        [Parameter(ParameterSetName = "ByPath")]
        [Parameter(ParameterSetName = "ByName")]
        [switch]$BumpMajor,

        [Parameter(ParameterSetName = "ByBumping")]
        [Parameter(ParameterSetName = "ByPath")]
        [Parameter(ParameterSetName = "ByName")]
        [switch]$BumpMinor,
        
        [Parameter(ParameterSetName = "ByBumping")]
        [Parameter(ParameterSetName = "ByPath")]
        [Parameter(ParameterSetName = "ByName")]
        [switch]$BumpPatch,

        [Parameter(ParameterSetName = "ByAutoUpdateSemVer")]
        [Parameter(ParameterSetName = "ByPath")]
        [Parameter(ParameterSetName = "ByName")]
        [switch]$AutoUpdate
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

        # PowerShellGet's Update-ModuleManifest currently has a bug that is reverting previous 
        # changed values. https://github.com/PowerShell/PowerShell/issues/7181
        $ManifestContentRaw = Get-Content -Path $ModInfo.ManifestFilePath -Raw
            
        if ($AutoUpdate.IsPresent) {
            $CurrentBranchName = Get-GitBranchName -Path ($ModInfo.Path)

            if ($CurrentBranchName -match $script:SemVerRegEx) {
                $Version = $ModInfo.Version
                # using '-gt' comparison because developer may have bumped or explictly set semver
                # to something greater than what Git branch they are on. although if they explictly 
                # set a lower value it will be overwritten.
                if (($Matches.MAJOR -gt $Version.Major) -or `
                    ($Matches.MINOR -gt $Version.Minor) -or `
                    ($Matches.PATCH -gt $Version.Build)) {
                    $Value = $CurrentBranchName 
                }
            }
            
            # since $AutoUpdate is present, lets update URIs
            # Using Import-PowerShellDataFile for convenience to check keys
            $Manifest = Import-PowerShellDataFile -Path $ModInfo.ManifestFilePath
            
            $Name = $ModInfo.Name

            # expecting: ...<ModuleName>/tree/<AnyValue>
            if ($Manifest.ContainsKey('HelpInfoURI')) {
                if ($ManifestContentRaw -match "(?<=HelpInfoURI)(?:[\s]*[=][\s]*)(\'.*\')") {
                    $NuHelpInfoUri = [regex]::Replace($Matches[1].Trim(), "(?<=$Name[\\|\/]tree[\\|\/]).*(?=\')", $CurrentBranchName)
                    $ManifestContentRaw = [regex]::Replace($ManifestContentRaw, "(?<=HelpInfoURI)(?:[\s]*[=][\s]*)(\'.*\')", " = $NuHelpInfoUri")
                }
            }
    
            if ($Manifest.ContainsKey('PrivateData')) {
                $PSData = $Manifest.PrivateData.PSData

                # expecting: .../<AnyValue>/LICENSE
                if ($PSData.ContainsKey('LicenseUri')) {
                    if ($ManifestContentRaw -match "(?<=LicenseUri)(?:[\s]*[=][\s]*)(\'.*\')") {
                        $NuLicenseUri = [regex]::Replace($Matches[1].Trim(), "[^\\|\/]+?(?=[\\|\/]LICENSE)", $CurrentBranchName)
                        $ManifestContentRaw = [regex]::Replace($ManifestContentRaw, "(?<=LicenseUri)(?:[\s]*[=][\s]*)(\'.*\')", " = $NuLicenseUri")

                    }
                }

                # expecting: ...<ModuleName>/tree/<AnyValue>
                if ($PSData.ContainsKey('IconUri')) {
                    if ($ManifestContentRaw -match "(?<=IconUri)(?:[\s]*[=][\s]*)(\'.*\')") {
                        $NuIconUri = [regex]::Replace($Matches[1].Trim(), "(?<=$Name[\\|\/]tree[\\|\/]).*(?=\')", $CurrentBranchName)
                        $ManifestContentRaw = [regex]::Replace($ManifestContentRaw, "(?<=IconUri)(?:[\s]*[=][\s]*)(\'.*\')", " = $NuIconUri")
                    }
                }
            }
        }
        elseif (-not $Value) {
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

        if ($Value) {
            if ($ManifestContentRaw -match "(?<=ModuleVersion).*") {
                $ManifestContentRaw = [regex]::Replace($ManifestContentRaw, $Matches[0], " = '$Value'")
            }

            Set-Content -Path $ModInfo.ManifestFilePath -Value $ManifestContentRaw -NoNewline

            if ($AutoUpdate.IsPresent) {
                Write-Host "Module version has been changed to '$Value'" -ForegroundColor Green
            }
            else {
                $Value
            }
        }
    }
}