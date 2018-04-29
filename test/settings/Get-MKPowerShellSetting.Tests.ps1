Describe "Test Get-MKPowerShellSetting" {
    BeforeAll {
        $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

        Push-Location

        Set-Location -Path $SUT_MODULE_HOME

        $ConfigFilePath = "$TestDrive\MK.PowerShell\MK.PowerShell-config.ps1"
        
        Import-Module -Name '.\MK.PowerShell.4PS.psd1' -ArgumentList $ConfigFilePath -Verbose -Force
    }
    AfterAll {
        Remove-Module MK.PowerShell.4PS -Force

        Pop-Location
    }

    Context "Call Get-MKPowerShellSetting" {

        It "Should return value of dynamic param value given" {
            $Setting = Get-MKPowerShellSetting -Name 'TurnOnAvailableUpdates'
            $Setting | Should -Be $true

            $Setting = Get-MKPowerShellSetting -Name 'TurnOnRememberLastLocation'
            $Setting | Should -Be $true
        }
    }
}