using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Restart-PWSH" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new()
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }
    
    Context "Call PWSH when 'TurnOnHistoryRecording' is set to false" {
        It "Should call Restart-PWSH" {
            
            Mock Start-Process {} -ModuleName MK.PowerShell.Flow
            Mock Stop-Process {} -ModuleName MK.PowerShell.Flow

            Restart-PWSH

            Assert-MockCalled Start-Process -ModuleName MK.PowerShell.Flow -Times 1 -ParameterFilter {
                $FilePath -eq "pwsh.exe" -and `
                    $Verb -eq 'Open'
            }

            Assert-MockCalled Stop-Process -ModuleName MK.PowerShell.Flow -Times 1 -ParameterFilter {
                $Id -eq $PID
            }
        }
    }
}