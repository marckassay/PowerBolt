using module ..\.\TestFunctions.psm1
$MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Set-LocationAndStore" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup($MODULE_FOLDER, 'TestModuleB')
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestModuleB', 'TestFunctions'))
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
            $__.ConfigFilePath | Should -FileContentMatch ([regex]::Escape("LastLocation = '$Path'"))
        }
    }
}