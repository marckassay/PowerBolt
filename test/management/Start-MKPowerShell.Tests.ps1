using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Start-MKPowerShell" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new()
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }

    Context "Test Restore-Formats when 'TurnOnExtendedFormats' is set to true" {
        Mock Restore-RememberLastLocation {} -ModuleName MK.PowerShell.Flow
        Mock Restore-QuickRestartSetting {} -ModuleName MK.PowerShell.Flow
        Mock Backup-Sources {} -ModuleName MK.PowerShell.Flow
        Mock Restore-History {} -ModuleName MK.PowerShell.Flow
        # Mock Restore-Formats {} -ModuleName MK.PowerShell.Flow
        Mock Register-Shutdown {} -ModuleName MK.PowerShell.Flow

        Mock Update-FormatData -MockWith {return $PrependPath } -ModuleName MK.PowerShell.Flow 

        InModuleScope MK.PowerShell.Flow {
            Start-MKPowerShell
        }
        
        It "Should set global 'FormatEnumerationLimit' variable to -1." {
            $global:FormatEnumerationLimit | Should -Be -1
        }

        It "Should call 'Update-FormatData' with expected files." {
            Assert-MockCalled Update-FormatData -ParameterFilter { $PrependPath.Count -eq 2 } -ModuleName MK.PowerShell.Flow 
        } 
    } 
} 