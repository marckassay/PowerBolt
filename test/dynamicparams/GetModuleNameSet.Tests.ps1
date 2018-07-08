using module ..\.\TestRunnerSupportModule.psm1

Describe "Test GetModuleNameSet" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new()
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }
    
    Context "Call with Position, ParameterSetName and Mandatory attributes" {
        It "Lame test here, can't seem to access `$Results fully to retrieve expected module names" {
            InModuleScope PowerBolt {
                $Results = GetModuleNameSet -Position 0 -ParameterSetName 'ByName' -Mandatory
                $Results.Keys | Should -Be 'Name'
                $Results | Should -BeOfType [System.Management.Automation.RuntimeDefinedParameterDictionary]
            }
        }
    }
}