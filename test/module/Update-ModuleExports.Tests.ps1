using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Update-ModuleExports" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new()
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }

    Context "Post executing New-Script" {
        It "Should have command accessable" {
            $Results = Get-Command Update-ModuleExports | Select-Object -ExpandProperty CommandType
            $Results | Should -Be 'Function'
        }
    }
}
