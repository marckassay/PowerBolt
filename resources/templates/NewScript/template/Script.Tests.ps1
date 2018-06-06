using module ..\.\TestFunctions.psm1
[TestFunctions]::AUTO_START = $true

Describe "Test <%=$PLASTER_PARAM_ScriptName%>" {
    BeforeAll {
        [TestFunctions]::DescribeSetup()
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown()
    }

    Context "Appending by importing module to profile" {
        It "Should add to profile" {
            $Results = Get-Command <%=$PLASTER_PARAM_ScriptName%> | Select-Object -ExpandProperty CommandType
            $Results | Should -Be 'Function'
        }
    }
}