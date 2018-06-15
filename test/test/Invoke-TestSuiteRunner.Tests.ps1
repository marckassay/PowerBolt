using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Invoke-TestSuiteRunner" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new()
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }
    
    Context "Call Invoke-TestSuiteRunner with request 'Name' value" {

        It "Should of called PowerShellGet's Publish-Module with expected params" {

            Mock Invoke-Pester -ModuleName 'MK.PowerShell.4PS' {} -Verifiable

            Invoke-TestSuiteRunner -Name 'MK.PowerShell.4PS'
            
            Assert-MockCalled Invoke-Pester -ModuleName 'MK.PowerShell.4PS' -ParameterFilter {$Script -like "*\MK.PowerShell.4PS\test"}
        } -Skip
    }
}