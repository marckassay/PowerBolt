using module ..\.\TestFunctions.psm1

Describe "Test Update-ModuleExports" {
    BeforeAll {
        $TestFunctions = [TestFunctions]::new()

        $TestFunctions.DescribeSetup()
    }
    
    AfterAll {
        $TestFunctions.DescribeTeardown()
    }

    Context "Post executing New-Script" {
        It "Should have command accessable" {
            $Results = Get-Command Update-ModuleExports | Select-Object -ExpandProperty CommandType
            $Results | Should -Be 'Function'
        }
    }
}
