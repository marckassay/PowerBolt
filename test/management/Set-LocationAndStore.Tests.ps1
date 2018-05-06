using module ..\.\TestFunctions.psm1
$MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Set-LocationAndStore" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup($MODULE_FOLDER, 'TestModuleB')

        Push-Location -StackName LocationAndStoreTest
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestModuleB', 'TestFunctions'))

        Pop-Location -StackName LocationAndStoreTest
    }
    
    Context "When 'TurnOnHistoryRecording' is set to true" {
        Set-MKPowerShellSetting -Name 'TurnOnRememberLastLocation' -Value $true 
        Set-MKPowerShellSetting -Name 'TurnOnHistoryRecording' -Value $true 

        Mock Set-MKPowerShellSetting -ModuleName MK.PowerShell.4PS

        It "Should change and store this location: '<Val>'" -TestCases @(
            @{ Path = "C:\"; Val = "C:\"},
            @{ Path = "C:\Temp"; Val = "C:\Temp"}
            @{ Path = "..\"; Val = "C:\"}
        ) {
            Param($Path, $Val)

            Set-LocationAndStore -Path $Path

            Get-Location | Should -Be $Val
    
            Assert-MockCalled Set-MKPowerShellSetting -ModuleName MK.PowerShell.4PS -Times 1 -ParameterFilter { 
                $Name -eq 'LastLocation' -and $Value -like $Val
            }
        }
    }
}