Describe "Test Set-LocationAndStore" {
    BeforeAll {
        $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

        Push-Location -StackName PriorTest1

        Set-Location -Path $SUT_MODULE_HOME

        $ConfigFilePath = "$TestDrive\MK.PowerShell\MK.PowerShell-config.ps1"
        
        Import-Module -Name '.\MK.PowerShell.4PS.psd1' -ArgumentList $ConfigFilePath -Verbose -Force
    }
    AfterAll {
        Remove-Module MK.PowerShell.4PS -Force
        Set-Alias sl Set-Location -Scope Global
        Pop-Location -StackName PriorTest1
    }

    Context "When 'TurnOnRememberLastLocation' is set to true" {
        
        It "Should (by default) set the alias of 'sl' to Set-LocationAndStore on PowerShell startup" {
            Get-Alias -Name 'sl' -Scope Global | `
                Select-Object -ExpandProperty ReferencedCommand | `
                Select-Object -ExpandProperty Name | Should -Be 'Set-LocationAndStore'
        }

        It "Should change and store this location: '<Path>'" -TestCases @(
            @{ Path = "C:\"}
        ) {
            Param($Path)

            # TODO: need to have this method accepth $SUT environment condition. 
            # Set-MKPowerShellSetting 
            #Mock Set-MKPowerShellSetting { return @{FullName = "B_File.TXT"} } -ParameterFilter { $Path -eq "$env:temp\me" }

            Set-LocationAndStore -Path $Path
            Get-Location | Should -Be $Path
            $ConfigFilePath | Should -FileContentMatch ([regex]::Escape("LastLocation = '$Path'"))
        }
    }
}