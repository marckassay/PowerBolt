using module ..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Get-MKPowerShellSetting" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup()
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestFunctions'))
    }
    
    Context "Call Get-MKPowerShellSetting" {

        It "Should accept dynamic param value and return correct boolean value" {
            $Setting = Get-MKPowerShellSetting -Name 'TurnOnAvailableUpdates'
            $Setting | Should -Be $true

            $Setting = Get-MKPowerShellSetting -Name 'TurnOnRememberLastLocation'
            $Setting | Should -Be $true
        }

        It "Should accept dynamic param value and return a hashtable" {
            $Setting = Get-MKPowerShellSetting -Name 'BackupLocations'
            $Setting | Should -BeOfType Hashtable
            $Setting.Keys -contains 'Path' | Should -Be $true 
            $Setting.Keys -contains 'Destination' | Should -Be $true 
        }
    }
}