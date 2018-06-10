using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Get-MKPowerShellSetting" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new()
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }
    
    Context "Call Get-MKPowerShellSetting" {

        It "Should accept dynamic param value and return correct boolean value" {
            $Setting = Get-MKPowerShellSetting -Name 'TurnOnAvailableUpdates'
            $Setting | Should -Be $true

            $Setting = Get-MKPowerShellSetting -Name 'TurnOnRememberLastLocation'
            $Setting | Should -Be $true
        }

        It "Should accept dynamic param value and return a hashtable" {
            $Setting = Get-MKPowerShellSetting -Name 'Backups'
            $Setting | Should -BeOfType Hashtable
            $Setting.Keys -contains 'Path' | Should -Be $true 
            $Setting.Keys -contains 'Destination' | Should -Be $true 
            $Setting.Keys -contains 'UpdatePolicy' | Should -Be $true 
        }
    }
}