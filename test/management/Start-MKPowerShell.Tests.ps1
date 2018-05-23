using module ..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'
[TestFunctions]::AUTO_START = $false

Describe "Test Start-MKPowerShell" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup()
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestFunctions'))
    }

    Context "Test Restore-Formats when 'TurnOnBetterFormats' is set to true" {
        Mock Restore-RememberLastLocation {} -ModuleName MK.PowerShell.4PS
        Mock Restore-QuickRestartSetting {} -ModuleName MK.PowerShell.4PS
        Mock Backup-Sources {} -ModuleName MK.PowerShell.4PS
        Mock Restore-History {} -ModuleName MK.PowerShell.4PS
        # Mock Restore-Formats {} -ModuleName MK.PowerShell.4PS
        Mock Register-Shutdown {} -ModuleName MK.PowerShell.4PS

        Mock Update-FormatData -MockWith {return $PrependPath } -ModuleName MK.PowerShell.4PS 

        Start-MKPowerShell

        It "Should set global 'FormatEnumerationLimit' variable to -1." {
            $global:FormatEnumerationLimit | Should -Be -1
        }

        It "Should call 'Update-FormatData' with expected files." {
            Assert-MockCalled Update-FormatData -ParameterFilter { $PrependPath.Count -eq 2 } -ModuleName MK.PowerShell.4PS 
        } 
    } 
} 