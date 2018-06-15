using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Update-ModuleExports" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleB')
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }

    Context "Call with given Path value" {
        It "Should have same results as if its 2 internal functions are piped" {

        } -Skip
    }
}
