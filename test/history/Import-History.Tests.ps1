using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Import-History" {
    BeforeAll {
        Push-Location -StackName History

        $TestSupportModule = [TestRunnerSupportModule]::new()
    }
    
    AfterAll {
        $TestSupportModule.Teardown()

        Pop-Location -StackName History
    }

    Context "Lame testing here, ideally need to find out how to have Add-History return mock object since pester history interfers." {
   
        It "Should import previous session as expected." {
            # TODO: it would better to Mock Get-History to return entries and Mock Add-History to
            # to do nothing; for that it will not confilict with testing.  the real testing is calculating
            # how many entries are needed.
            Mock Add-History -ModuleName MK.PowerShell.Flow
            # $SessionHistories = Import-Csv -Path .\test\history\TestHistory.csv

            Import-History -Path .\test\history\TestHistory.csv

            Assert-MockCalled Add-History -ModuleName MK.PowerShell.Flow -Times 1
        }
    } 
} 