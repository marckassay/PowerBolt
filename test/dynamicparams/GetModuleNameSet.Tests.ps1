using module ..\.\TestRunnerSupportModule.psm1

Describe "Test GetModuleNameSet" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new()
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }
    
    Context "Call with Position, ParameterSetName and Mandatory attributes" {
        It "Lame test here, can't seem to access `$Results; Should be type RuntimeDefinedParameterDictionary" {
            InModuleScope MK.PowerShell.4PS {
                $Results = GetModuleNameSet -Position 0 -ParameterSetName 'ByName' -Mandatory
                $Results | Should -BeOfType [System.Management.Automation.RuntimeDefinedParameterDictionary]
            }
        }
    }
}