using module ..\.\TestFunctions.psm1
$MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Set-MKPowerShellSetting" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup($MODULE_FOLDER, '')
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestFunctions'))
    }
    
    Context "Call Set-MKPowerShellSetting" {

        It "Should set field of '<Name>' to value of '<Value>'" -TestCases @(
            @{ Name = "TurnOnAvailableUpdates"; Value = "false" },
            @{ Name = "LastLocation"; Value = "c:\" }
        ) {
            Param($Name, $Value)
            Set-MKPowerShellSetting -Name $Name -Value $Value
            $__.ConfigFilePath | Should -FileContentMatch ([regex]::Escape("$Name = '$Value'"))
        }
    }
}