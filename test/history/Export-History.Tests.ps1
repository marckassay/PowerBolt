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
        $TestHistoryItemPath = Join-Path -Path $([TestFunctions]::MODULE_FOLDER) -ChildPath '.\test\history\TestHistory.csv'

        $SessionHistoriesPath = New-Item -Path "TestDrive:\SessionHistories.csv" -ItemType File | `
            Select-Object -ExpandProperty FullName

        It "Should export current session and expected something greater than 1." {

            Mock Get-History {
                # NOTE: this relative path sometimes causes an issue when running TestSuite.ps1
                #$TestHistory = Import-Csv -Path .\test\history\TestHistory.csv | Add-History
                $TestHistory = Import-Csv -Path $TestHistoryItemPath | Add-History
                return $TestHistory
            }
            
            Export-History -Path $SessionHistoriesPath

            $SessionHistories = Import-Csv -Path $SessionHistoriesPath
            $SessionHistories.Count | Should -BeGreaterThan 1
        } -Skip
    } 
} 