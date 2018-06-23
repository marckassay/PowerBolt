using module ..\.\TestFunctions.psm1

Describe "Test <%=$PLASTER_PARAM_ScriptName%>" {
    BeforeAll {
        $TestFunctions = [TestFunctions]::new()

        $TestFunctions.DescribeSetup()
    }
    
    AfterAll {
        $TestFunctions.DescribeTeardown()
    }

    Context "Post executing New-Script" {
        It "Should have command accessable" {
            $Results = Get-Command <%=$PLASTER_PARAM_ScriptName%> | Select-Object -ExpandProperty CommandType
            $Results | Should -Be 'Function'
        }
    }
}