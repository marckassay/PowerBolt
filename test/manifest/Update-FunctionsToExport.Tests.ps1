Describe "Test Update-FunctionsToExport" {
    $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

    BeforeEach {
        Push-Location
        Set-Location -Path $SUT_MODULE_HOME

        Import-Module -Name '.\MK.PowerShell.4PS.psd1' -Verbose -Force -Global
    }
    AfterEach {
        Pop-Location
    }

    Context "Call Update-ModuleDotSourceFunctions and pipe result" {
        BeforeEach {
            Copy-Item -Path 'test\manifest\resource\TestModule' -Destination $TestDrive -Container -Recurse -Force -Verbose
            $ManifestFile = Join-Path -Path $TestDrive -ChildPath '\TestModule\TestModule.psd1'
            $ModuleFile = Join-Path -Path $TestDrive -ChildPath '\TestModule\TestModule.psm1'
        }
        AfterEach {

        }

        It "Should overwrite the default value ('@()') for FunctionsToExport field with dot-source imports" {
            Update-ModuleDotSourceFunctions -Path $ModuleFile | Update-FunctionsToExport

            $FunctionNames = Test-ModuleManifest $ManifestFile | `
                Select-Object -ExpandProperty ExportedCommands | `
                Select-Object -ExpandProperty Values | `
                Select-Object -ExpandProperty Name

            $FunctionNames -contains 'Get-AFunction' | Should -Be $true
            $FunctionNames -contains 'Get-BFunction' | Should -Be $true
            $FunctionNames -contains 'Get-CFunction' | Should -Be $true
            $FunctionNames -contains 'Set-CFunction' | Should -Be $true
        }
    }
}