Describe "Test Set-LocationAndStore" {
    $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

    BeforeAll {
        Push-Location

        Set-Location -Path $SUT_MODULE_HOME

        Import-Module -Name '.\MK.PowerShell.4PS.psd1' -Verbose -Force

        Get-Module MK.PowerShell.4PS | `
            Select-Object -ExpandProperty FileList | `
            ForEach-Object {if ($_ -like '*MK.PowerShell-config.ps1') {$_}} -OutVariable ModuleConfigFile

        New-Item -Path "$TestDrive\MK.PowerShell" -ItemType Directory -OutVariable ModuleConfigFolder
        Copy-Item -Path $ModuleConfigFile -Destination $ModuleConfigFolder.FullName -Verbose -PassThru | `
            Select-Object -ExpandProperty FullName
    }

    AfterAll {
        Remove-Module MK.PowerShell.4PS -Force
        
        Pop-Location
    }

    Context "When 'TurnOnRememberLastLocation' is set to true" {
        BeforeEach {
            Push-Location
        }
        AfterEach {
            Pop-Location
        }
        
        It "Should (by default) set the alias of 'sl' to Set-LocationAndStore on PowerShell startup" {
            Get-Alias -Name 'sl' | `
                Select-Object -ExpandProperty ReferencedCommand | `
                Select-Object -ExpandProperty Name | Should -Be 'Set-LocationAndStore'
        }

        It "Should change and store this location: '<Path>'" -TestCases @(
            @{ Path = "C:\"}
        ) {
            Param($Path)

            Set-LocationAndStore -Path $Path
            Get-Location | Should -Be $Path

            # surfaces the $MKPowerShellConfig variable in the file of $Path
            Invoke-Expression -Command "using module $ModuleConfigFile"
            $MKPowerShellConfig.LastLocation | Should -Be $Path
        }
    }
}