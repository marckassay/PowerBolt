Describe "Test New-MKPowerShellConfigFile" {
    $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

    BeforeEach {
        Push-Location
        Set-Location -Path $SUT_MODULE_HOME

        Import-Module -Name '.\MK.PowerShell.4PS.psd1' -Verbose -Force -Global
    }
    AfterEach {
        Pop-Location
    }

    Context "Call New-MKPowerShellConfigFile when no file exists" {
        BeforeEach {
            $FullName = Join-Path -Path $TestDrive -ChildPath '\MK.PowerShell\' -AdditionalChildPath 'MK.PowerShell-config.ps1'
        }
        AfterEach {

        }

        It "Should copy a new file to the destination folder ('MK.PowerShell')" {
            New-MKPowerShellConfigFile -Path $TestDrive -Verbose

            Get-Item $FullName | Should -Exist 
        }
    }
}