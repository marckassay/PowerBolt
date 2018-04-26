Describe "Test Set-MKPowerShellSetting" {
    $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

    BeforeEach {
        Push-Location

        Set-Location -Path $SUT_MODULE_HOME

        Import-Module -Name '.\MK.PowerShell.4PS.psd1' -Verbose -Force
    }
    AfterEach {
        Remove-Module MK.PowerShell.4PS -Force

        Pop-Location
    }

    Context "Call Set-MKPowerShellSetting" {
        BeforeEach {
            Get-Module MK.PowerShell.4PS | `
                Select-Object -ExpandProperty FileList | `
                ForEach-Object {if ($_ -like '*MK.PowerShell-config.ps1') {$_}} -OutVariable ModuleConfigFile

            New-Item -Path "$TestDrive\MK.PowerShell" -ItemType Directory -OutVariable ModuleConfigFolder
            $FullName = Copy-Item -Path $ModuleConfigFile -Destination $ModuleConfigFolder.FullName -Verbose -PassThru | `
                Select-Object -ExpandProperty FullName
        }
        AfterEach {

        }

        It "Should set field of '<Name>' to value of '<Value>'" -TestCases @(
            @{ Name = "TurnOnAvailableUpdates"; Value = "false" }
        ) {
            Param($Name, $Value)
            Set-MKPowerShellSetting -Name $Name -Value $Value -Path $FullName
            $FullName | Should -FileContentMatch "^.*$Name.=.'$Value'$"
        }
    }
}