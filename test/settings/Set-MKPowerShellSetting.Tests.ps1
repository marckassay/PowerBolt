using module ..\.\TestFunctions.psm1
$MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Set-MKPowerShellSetting" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup($MODULE_FOLDER, '')
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestFunctions'))
    }
    
    Context "Setting TurnOnRememberLastLocation" {

        Mock Restore-RememberLastLocation {} -ModuleName MK.PowerShell.4PS

        It "Should set TurnOnRememberLastLocation to '<Value>' in config file" -TestCases @(
            @{ Value = $true}
            @{ Value = $false}
        ) {
            Param($Value)

            Set-MKPowerShellSetting -Name 'TurnOnRememberLastLocation' -Value $Value
            $__.ConfigFilePath | Should -FileContentMatch "TurnOnRememberLastLocation = '$Value'"
            Assert-MockCalled Restore-RememberLastLocation -ModuleName MK.PowerShell.4PS -Times 1
        }
    }
}