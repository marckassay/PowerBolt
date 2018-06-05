using module ..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'
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