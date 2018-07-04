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
            $Setting = Get-MKPowerShellSetting -Name 'NuGetApiKey'
            $Setting | Should -Be ''

            $Setting = Get-MKPowerShellSetting -Name 'TurnOnAutoUpdateSemVer'
            $Setting | Should -Be $true
        }

        It "Should accept dynamic param value and return a hashtable" {
            $Setting = Get-MKPowerShellSetting -Name 'Backups'
            $Setting | Should -BeOfType Hashtable
            $Setting.Keys -contains 'Path' | Should -Be $true 
            $Setting.Keys -contains 'Destination' | Should -Be $true 
            $Setting.Keys -contains 'UpdatePolicy' | Should -Be $true 
        } -Skip
    }
}