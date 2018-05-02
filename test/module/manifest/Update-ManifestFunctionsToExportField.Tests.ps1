Describe "Test Update-ManifestFunctionsToExportField" {
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

    Context "Call Update-RootModuleUsingStatements and pipe result" {
        BeforeEach {
            Copy-Item -Path 'test\testresource\TestModuleA' -Destination $TestDrive -Container -Recurse -Force -Verbose
            $ManifestFile = Join-Path -Path $TestDrive -ChildPath '\TestModuleA\TestModuleA.psd1'
            $ModuleFile = Join-Path -Path $TestDrive -ChildPath '\TestModuleA\TestModuleA.psm1'
        }
        AfterEach {

        }

        It "Should overwrite the default value ('@()') for FunctionsToExport field with 'using' statements" {
            Update-RootModuleUsingStatements -Path $ModuleFile | Update-ManifestFunctionsToExportField

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