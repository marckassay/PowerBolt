using module ..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Restart-PWSH" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup()
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestFunctions'))
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