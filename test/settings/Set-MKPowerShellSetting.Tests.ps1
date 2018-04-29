Describe "Test Set-MKPowerShellSetting" {

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

    Context "Call Set-MKPowerShellSetting" {

        It "Should set field of '<Name>' to value of '<Value>'" -TestCases @(
            @{ Name = "TurnOnAvailableUpdates"; Value = "false" },
            @{ Name = "LastLocation"; Value = "c:\" }
        ) {
            Param($Name, $Value)
            Set-MKPowerShellSetting -Name $Name -Value $Value
            $ConfigFilePath | Should -FileContentMatch ([regex]::Escape("$Name = '$Value'"))
        }
    }
}