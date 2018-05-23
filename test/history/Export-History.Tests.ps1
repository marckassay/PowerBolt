using module ..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'
[TestFunctions]::AUTO_START = $true

Describe "Test Export-History" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup()

        Push-Location -StackName History
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestFunctions'))

        Pop-Location -StackName History
    }

    Context "Lame testing here, ideally need to find out how to have Get-History return mock object since pester history interfers." {
        It "Should export current session and expected something greater than 1." {
            $SessionHistoriesPath = New-Item -Path "TestDrive:\SessionHistories.csv" -ItemType File | `
                Select-Object -ExpandProperty FullName
            
            Mock Get-History {
                $TestHistory = Import-Csv -Path .\test\history\TestHistory.csv | Add-History
                return $TestHistory
            }
            
            Export-History -Path $SessionHistoriesPath

            $SessionHistories = Import-Csv -Path $SessionHistoriesPath
            $SessionHistories.Count | Should -BeGreaterThan 1
        }
    } 
} 