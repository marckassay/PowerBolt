class TestFunctions {
    
    static [string]$MODULE_FOLDER
    static [string]$AUTO_START

    static [PSObject]DescribeSetup() {
        return [TestFunctions]::DescribeSetup([TestFunctions]::MODULE_FOLDER, '', '')
    }

    <#     static [PSObject]DescribeSetupUsingTestFiles([string]$TestModuleName, [string]$TestConfigFile) {
        return [TestFunctions]::DescribeSetup([TestFunctions]::MODULE_FOLDER, $TestModuleName, $TestConfigFile)
    } #>

    static [PSObject]DescribeSetupUsingTestModule([string]$TestModuleName) {
        return [TestFunctions]::DescribeSetup([TestFunctions]::MODULE_FOLDER, $TestModuleName, '')
    }

    <#     static [PSObject]DescribeSetupUsingTestConfigFile([string]$TestConfigFile) {
        return [TestFunctions]::DescribeSetup([TestFunctions]::MODULE_FOLDER, '', $TestConfigFile)
    } #>

    static [PSObject]DescribeSetup([string]$ModuleFolder, [string]$TestModuleName, [string]$TestConfigFilePath) {
        Set-Location -Path $ModuleFolder
        
        # if this is the first test, module may be in "production install" state, if so remove it.
        Split-Path $ModuleFolder -Leaf | `
            Get-Module | `
            Remove-Module -ErrorAction SilentlyContinue

        if ($TestConfigFilePath -eq '') {
            # MK.PowerShell.4PS will copy config file to this path:
            $ConfigFilePath = "TestDrive:\User\Bob\AppData\Local\MK.PowerShell.4PS\MK.PowerShell-config.json"
        }
        else {
            $ConfigFilePath = $TestConfigFilePath
        }

        # TODO: find all functions mark as exported and insert them into test version of .psd1 and .psm1 file
        #Search-Items .\src\ -Pattern "\#.?NoExport:" -Recurse | Where-Object {$_ -match '(?<=NoExport: )[\w]*[-][\w]*'}

        # ArgumentList: ConfigFilePath and switch for SUT var
        Get-Item '*.psd1' | Import-Module -ArgumentList @($ConfigFilePath, $true) -Global -Force

        if ($TestModuleName -ne '') {
            Copy-Item -Path ".\test\testresource\$TestModuleName" -Destination 'TestDrive:\' -Container -Recurse

            Get-Item "TestDrive:\$TestModuleName\$TestModuleName.psd1" | Import-Module -Global -Force

            $__ = @{
                ConfigFilePath          = $ConfigFilePath
                TestModuleDirectoryPath = (Join-Path -Path 'TestDrive:\' -ChildPath $TestModuleName)
                TestManifestPath        = (Join-Path -Path 'TestDrive:\' -ChildPath "\$TestModuleName\$TestModuleName.psd1")
                TestModulePath          = (Join-Path -Path 'TestDrive:\' -ChildPath "\$TestModuleName\$TestModuleName.psm1")
            }
        }
        else {
            $__ = @{
                ConfigFilePath = $ConfigFilePath
            }
        }

        Set-Variable -Name __ -Value $__ -Scope global -Option AllScope

        if ([TestFunctions]::AUTO_START -eq $true) {
            InModuleScope MK.PowerShell.4PS {
                Start-MKPowerShell -ConfigFilePath $__.ConfigFilePath
            }
        }

        return $__
    }

    static [void]DescribeTeardown() {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestModuleA', 'TestModuleB', 'TestFunctions'))
    }

    static [void]DescribeTeardown([string[]]$ModuleName) {
        Get-Module -Name $ModuleName | Remove-Module -Force -ErrorAction SilentlyContinue
        Remove-Variable __ -ErrorAction SilentlyContinue
        Set-Alias sl Set-Location -Scope Global -Force -ErrorAction SilentlyContinue
    }
}