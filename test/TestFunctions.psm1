class ScriptPath {
    [string] GetPath() {
        return $PSCommandPath | Split-Path -Parent | Split-Path -Parent
    }
}

class TestFunctions {
    [string]$AutoStart = $true
    [string]$ModulePath
    [string]$ConfigFilePath 
    [string]$TestModuleDirectoryPath
    [string]$TestManifestPath
    [string]$TestModulePath 

    TestFunctions () {
        $this.ModulePath = [ScriptPath]::new().GetPath()
    }

    [void]DescribeSetup() {
        $this.DescribeSetup('', '')
    }

    [void]DescribeSetupUsingTestModule([string]$TestModuleName) {
        $this.DescribeSetup($TestModuleName, '')
    }

    [void]DescribeSetup ([string]$TestModuleName, [string]$TestConfigFilePath) {
        Set-Location -Path $this.ModulePath
        
        # if this is the first test, module may be in "production install" state, if so remove it.
        Split-Path $this.ModulePath -Leaf | `
            Get-Module | `
            Remove-Module -ErrorAction SilentlyContinue

        if ($TestConfigFilePath -eq '') {
            # MK.PowerShell.4PS will copy config file to this path:
            $this.ConfigFilePath = "TestDrive:\User\Bob\AppData\Local\MK.PowerShell.4PS\MK.PowerShell-config.json"
        }
        else {
            $this.ConfigFilePath = $TestConfigFilePath
        }

        # TODO: find all functions mark as exported and insert them into test version of .psd1 and .psm1 file
        #Search-Items .\src\ -Pattern "\#.?NoExport:" -Recurse | Where-Object {$_ -match '(?<=NoExport: )[\w]*[-][\w]*'}

        # ArgumentList: ConfigFilePath and switch for SUT var
        Get-Item '*.psd1' | Import-Module -ArgumentList @($this.ConfigFilePath, $true) -Global -Force

        if ($TestModuleName -ne '') {
            Copy-Item -Path ".\test\testresource\$TestModuleName" -Destination 'TestDrive:\' -Container -Recurse -Force

            Get-Item "TestDrive:\$TestModuleName\$TestModuleName.psd1" | Import-Module -Global -Force

            $this.TestModuleDirectoryPath = (Join-Path -Path 'TestDrive:\' -ChildPath $TestModuleName)
            $this.TestManifestPath = (Join-Path -Path 'TestDrive:\' -ChildPath "\$TestModuleName\$TestModuleName.psd1")
            $this.TestModulePath = (Join-Path -Path 'TestDrive:\' -ChildPath "\$TestModuleName\$TestModuleName.psm1")
        }

        if ($this.AutoStart -eq $true) {
            InModuleScope MK.PowerShell.4PS {
                Start-MKPowerShell -ConfigFilePath $this.ConfigFilePath
            }
        }
    }

    [void]DescribeTeardown() {
        $this.DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestModuleA', 'TestModuleB', 'TestFunctions'))
    }

    [void]DescribeTeardown([string[]]$ModuleName) {
        Get-Module -Name $ModuleName | Remove-Module -Force -ErrorAction SilentlyContinue
        Remove-Variable __ -ErrorAction SilentlyContinue
        Set-Alias sl Set-Location -Scope Global -Force -ErrorAction SilentlyContinue
    }
}