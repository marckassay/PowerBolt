using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Invoke-TestSuiteRunner" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleB')
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }
    
    Context "Call Invoke-TestSuiteRunner with request 'Path' value" {

        It "Should of called Start-Job which in-turn calls Invoke-Pester" {

            Mock Start-Job -ModuleName MK.PowerShell.Flow

            Invoke-TestSuiteRunner -Path ($TestSupportModule.MockDirectoryPath)
            
            Assert-MockCalled Start-Job -ParameterFilter {
                $Name -eq "JobPester"
            } -ModuleName MK.PowerShell.Flow -Times 1
            
            Assert-MockCalled Start-Job -ParameterFilter {
                $ArgumentList[0].Script -like '*MockModuleB*test*'
            } -ModuleName MK.PowerShell.Flow -Times 1
        }
    }
}