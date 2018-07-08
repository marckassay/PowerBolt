using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Get-PowerBoltSetting" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new()
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }
    
    Context "Call Get-PowerBoltSetting" {

        It "Should accept dynamic param value and return correct boolean value" {
            $Setting = Get-PowerBoltSetting -Name 'NuGetApiKey'
            $Setting | Should -Be ''

            $Setting = Get-PowerBoltSetting -Name 'TurnOnAutoUpdateSemVer'
            $Setting | Should -Be $true
        }

        It "Should accept dynamic param value and return a hashtable" {
            $Setting = Get-PowerBoltSetting -Name 'Backups'
            $Setting | Should -BeOfType Hashtable
            $Setting.Keys -contains 'Path' | Should -Be $true 
            $Setting.Keys -contains 'Destination' | Should -Be $true 
            $Setting.Keys -contains 'UpdatePolicy' | Should -Be $true 
        } -Skip
    }
}