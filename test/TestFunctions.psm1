class ScriptPath {
    [string] GetPath() {
        return $PSCommandPath | Split-Path -Parent | Split-Path -Parent
    }
}

# TODO:
# - need name for MKPowerShellDoc module's  :: fixtureSource
# - need name for the instance of MKPowerShellDoc module :: fixture
# - need name for MockModuleA  :: mock 
class TestFunctions {
    [string[]]$MODULE_NAMES = @('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'MockModuleA', 'MockModuleB', 'TestFunctions', 'Deploy-TestFakes')
    [string]$AutoStart = $true
    [string]$FixtureDirectoryPath
    [string]$FixtureConfigFilePath
    [string]$MockDirectoryPath
    [string]$MockManifestPath
    [string]$MockRootModulePath

    TestFunctions () {
        $this.FixtureDirectoryPath = [ScriptPath]::new().GetPath()
    }

    [void]DescribeSetup() {
        $this.DescribeSetup('', '')
    }

    [void]DescribeSetupUsingTestModule([string]$MockModuleName) {
        $this.DescribeSetup($MockModuleName, '')
    }

    [void]DescribeSetup ([string]$MockModuleName, [string]$FixtureConfigFilePath) {
        Set-Location -Path $this.FixtureDirectoryPath
        Write-Host $(Get-Location) -ForegroundColor Blue
        # if this is the first test, module may be in "production install" state, if so remove it.
        Split-Path $this.FixtureDirectoryPath -Leaf | `
            Get-Module | `
            Remove-Module -ErrorAction SilentlyContinue

        if (-not $FixtureConfigFilePath) {
            # MK.PowerShell module will copy config file to this path:
            $this.FixtureConfigFilePath = Join-Path -Path $this.FixtureDirectoryPath -ChildPath "\User\Bob\AppData\Roaming\MK.PowerShell\MK.PowerShell-config.json"
        }
        else {
            $this.FixtureConfigFilePath = $FixtureConfigFilePath
        }

        # TODO: find all functions mark as exported and insert them into test version of .psd1 and .psm1 file
        # Search-Items .\src\ -Pattern "\#.?NoExport:" -Recurse | `
        #   Where-Object {$_ -match '(?<=NoExport: )[\w]*[-][\w]*'}

        # ArgumentList: ConfigFilePath and switch for SUT var
        Get-Item '*.psd1' | Import-Module -ArgumentList @($this.FixtureConfigFilePath, $true) -Global -Force

        if ($MockModuleName -ne '') {
            $TestDrivePath = Get-Item -Path 'TestDrive:\' | Select-Object -ExpandProperty FullName

            Copy-Item -Path ".\test\testresource\$MockModuleName" -Destination $TestDrivePath -Container -Recurse -Force
            $this.MockDirectoryPath = "$TestDrivePath\$MockModuleName\"

            $TestManifestItem = Get-Item (Join-Path -Path ($this.MockDirectoryPath) -ChildPath ($MockModuleName + ".psd1"))
            $TestManifestItem | Import-Module -Global -Force

            $this.MockManifestPath = $TestManifestItem.FullName
            $this.MockRootModulePath = (Join-Path -Path ($this.MockDirectoryPath) -ChildPath ($MockModuleName + ".psm1"))
        }

        if ($this.AutoStart -eq $true) {
            InModuleScope MK.PowerShell.4PS {
                Start-MKPowerShell -ConfigFilePath $this.FixtureConfigFilePath
            }
        }
    }

    [void]DescribeTeardown() {
        $this.DescribeTeardownModule($this.MODULE_NAMES)
        Remove-Variable __ -ErrorAction SilentlyContinue
        Set-Alias sl Set-Location -Scope Global -Force -ErrorAction SilentlyContinue
    }

    [void]DescribeTeardownModule([string[]]$ModuleName) {
        Get-Module -Name $ModuleName | Remove-Module -Force -ErrorAction SilentlyContinue
    }
}