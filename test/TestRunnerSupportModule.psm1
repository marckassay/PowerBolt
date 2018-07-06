class ScriptPath {
    [string] GetPath() {
        return $PSCommandPath | Split-Path -Parent | Split-Path -Parent
    }
}

class TestRunnerSupportModule {
    # TODO: have these elements pushed into this array instead of hard-coded; make it accessible for when Deploy-TestFakes is created.
    [string[]]$MODULE_NAMES = @('PowerEquip', 'MKDocumentationInfo', 'MKModuleInfo', 'MockModuleA', 'MockModuleB', 'MockModuleC', 'TestRunnerSupportModule')
    [string]$AutoStart = $true
    [string]$TestDrivePath
    [string]$FixtureDirectoryPath
    [string]$FixtureManifestPath
    [string]$FixtureConfigFilePath
    [string]$MockDirectoryPath
    [string]$MockManifestPath
    [string]$MockRootModulePath

    TestRunnerSupportModule () {
        $this.Teardown()

        $this.TestDrivePath = Get-Item -Path 'TestDrive:\' | Select-Object -ExpandProperty FullName

        $this.FixtureDirectoryPath = [ScriptPath]::new().GetPath()
        Set-Location -Path $this.FixtureDirectoryPath
        $this.Setup('', '')
    }

    TestRunnerSupportModule ([bool]$AutoStart, [string]$MockModuleName) {
        $this.Teardown()

        $this.AutoStart = $AutoStart
        $this.TestDrivePath = Get-Item -Path 'TestDrive:\' | Select-Object -ExpandProperty FullName

        $this.FixtureDirectoryPath = [ScriptPath]::new().GetPath()
        Set-Location -Path $this.FixtureDirectoryPath
        $this.Setup($MockModuleName, '')
    }

    TestRunnerSupportModule ([string]$MockModuleName) {
        $this.Teardown()

        $this.TestDrivePath = Get-Item -Path 'TestDrive:\' | Select-Object -ExpandProperty FullName

        $this.FixtureDirectoryPath = [ScriptPath]::new().GetPath()
        Set-Location -Path $this.FixtureDirectoryPath
        $this.Setup($MockModuleName, '')
    }
 
    [void]Setup ([string]$MockModuleName, [string]$FixtureConfigFilePath) {
        # lets hope there is only one psd1 file in this directory
        $this.FixtureManifestPath = Get-Item '*.psd1' | Select-Object -First 1 | Select-Object -ExpandProperty FullName

        if (-not $FixtureConfigFilePath) {
            # MK.PowerShell module will copy config file to this path:
            $this.FixtureConfigFilePath = Join-Path -Path $this.TestDrivePath -ChildPath "\User\Bob\AppData\Roaming\MK.PowerShell\MK.PowerShell-config.json"
        }
        else {
            $this.FixtureConfigFilePath = $FixtureConfigFilePath
        }

        # ArgumentList: ConfigFilePath and switch for SUT var
        Import-Module $this.FixtureManifestPath -ArgumentList @($this.FixtureConfigFilePath, $true) -Global -Force

        if ($MockModuleName -ne '') {
            Copy-Item -Path ".\test\mocks\$MockModuleName" -Destination $this.TestDrivePath -Container -Recurse -Force
            $this.MockDirectoryPath = Join-Path -Path ($this.TestDrivePath) -ChildPath ($MockModuleName)

            # if this mockmodule directory has a 'git' folder, change it to '.git'
            $OriginalGit = $(Join-Path -Path ($this.MockDirectoryPath) -ChildPath "git")
            if (Test-Path -Path $OriginalGit) {
                Rename-Item -Path $OriginalGit -NewName ".git"
            }

            $this.MockManifestPath = Get-Item (Join-Path -Path ($this.MockDirectoryPath) -ChildPath ($MockModuleName + ".psd1")) | Select-Object -ExpandProperty FullName
            
            $this.MockRootModulePath = (Join-Path -Path ($this.MockDirectoryPath) -ChildPath ($MockModuleName + ".psm1"))

            Import-Module $this.MockManifestPath -Global -Force
        }

        if ($this.AutoStart -eq $true) {
            InModuleScope PowerEquip {
                Start-MKPowerShell -ConfigFilePath $this.FixtureConfigFilePath
            }
        }
    }

    [void]Teardown() {
        $this.TeardownModule($this.MODULE_NAMES)
        Set-Alias sl Set-Location -Scope Global -Force -ErrorAction SilentlyContinue
    }

    [void]TeardownModule([string[]]$ModuleName) {
        Get-Module -Name $ModuleName | Remove-Module -Force -ErrorAction SilentlyContinue
    }
}