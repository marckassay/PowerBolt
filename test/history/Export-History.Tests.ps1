using module ..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Export-History" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup()

        Push-Location -StackName History
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestFunctions'))

        Pop-Location -StackName History
    }

    Context "Using default value for Path, PWSH history session should be exported as expected." {

        It "Should export current session as expected." {
            $SessionHistoriesPath = New-Item -Path "TestDrive:\SessionHistories.csv" -ItemType File | Select-Object -ExpandProperty FullName
            
            # TODO: perhaps try DATA{} directive
            Mock Get-History {
                $Session = @"
"1","exit","Completed","5/9/2018 2:55:51 PM","5/9/2018 2:55:51 PM"
"2","sl e:\","Completed","5/9/2018 2:56:02 PM","5/9/2018 2:56:02 PM"
}
"@
            }
            
            Export-History -Path $SessionHistoriesPath

            $SessionHistories = Import-Csv -Path $Path
            $SessionHistories.Count | Should -BeGreaterThan 1
        } -Skip
    } 
} 