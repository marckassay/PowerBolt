using module ..\.\TestFunctions.psm1

Describe "Test Restart-PWSH" {
    BeforeAll {
        $TestFunctions = [TestFunctions]::new()

        $TestFunctions.DescribeSetup()
    }
    
    AfterAll {
        $TestFunctions.DescribeTeardown()
    }
    
    Context "Call PWSH when 'TurnOnHistoryRecording' is set to false" {
        It "Should call Restart-PWSH" {
            
            Mock Start-Process {} -ModuleName MK.PowerShell.4PS
            Mock Stop-Process {} -ModuleName MK.PowerShell.4PS

            Restart-PWSH

            Assert-MockCalled Start-Process -ModuleName MK.PowerShell.4PS -Times 1 -ParameterFilter {
                $FilePath -eq "pwsh.exe" -and `
                    $Verb -eq 'Open'
            }

            Assert-MockCalled Stop-Process -ModuleName MK.PowerShell.4PS -Times 1 -ParameterFilter {
                $Id -eq $PID
            }
        }
    }
}