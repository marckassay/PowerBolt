using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Export-History" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new()
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }

    Context "Lame testing here, ideally need to find out how to have Get-History return mock object since pester history interfers." {
        $TestHistoryItemPath = Join-Path -Path ($TestSupportModule.FixtureDirectoryPath) -ChildPath 'test\history\TestHistory.csv'

        $SessionHistoriesPath = New-Item -Path "TestDrive:\SessionHistories.csv" -ItemType File | `
            Select-Object -ExpandProperty FullName

        It "Should export current session and expected something greater than 1." {
            # TODO: it would better to Mock Get-History to return entries and Mock Add-History to
            # to do nothing; for that it will not confilict with testing.  the real testing is calculating
            # how many entries are needed.
            Mock Get-History {
                $TestHistory = Import-Csv -Path $TestHistoryItemPath | Add-History
                return $TestHistory
            }
            
            Export-History -Path $SessionHistoriesPath

            $SessionHistories = Import-Csv -Path $SessionHistoriesPath
            $SessionHistories.Count | Should -BeGreaterThan 1
        }
    } 
} 