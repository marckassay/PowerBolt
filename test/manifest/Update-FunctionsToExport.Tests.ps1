Describe "Test Update-FunctionsToExport" {
    $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

    BeforeEach {
        Push-Location
        Set-Location -Path $SUT_MODULE_HOME
        Import-Module -Name .\MK.PowerShell.4PS.psd1 -Verbose -Force -Global
    }
    AfterEach {
        Remove-Module -Name MK.PowerShell.4PS -Verbose -Force 
        Pop-Location
    }

    Context "[non-imported module] Recurse src directory for correct function files" {
        BeforeEach {
            $ManifestFile = 'TestDrive:\TestModule\TestModule.psd1'
        }
        AfterEach {
        }

        It "Should overwrite the default value ('@()') for FunctionsToExport field" {
            Copy-Item -Path 'test\manifest\resource\TestModule' -Destination "TestDrive:\" -Container -Recurse -Force -Verbose

            Set-Content -Path 'TestDrive:\TestModule\TestModule.psm1' -Value @"
. .\src\Get-AFunction.ps1
. .\src\Get-BFunction.ps1
. .\src\C\Get-CFunction.ps1
"@

            $Before = $(Test-ModuleManifest $ManifestFile | `
                    Select-Object -ExpandProperty ExportedCommands).Count
            # exclude this file in this It block, it will be used for testing in the following It block
            Update-FunctionsToExport -Path 'TestDrive:\TestModule' -Exclude 'Set-CFunction.ps1' 

            $After = $(Test-ModuleManifest $ManifestFile | `
                    Select-Object -ExpandProperty ExportedCommands).Count

            $FunctionNames = Test-ModuleManifest $ManifestFile | `
                Select-Object -ExpandProperty ExportedCommands | `
                Select-Object -ExpandProperty Values | `
                Select-Object -ExpandProperty Name

            $Before -ne $After | Should -Be $true
            $After | Should -BeExactly 3
            $FunctionNames -contains 'Get-AFunction' | Should -Be $true
            $FunctionNames -contains 'Get-BFunction' | Should -Be $true
            $FunctionNames -contains 'Get-CFunction' | Should -Be $true
        }

        It "Should overwrite generated values for FunctionsToExport field" {

            Set-Content -Path 'TestDrive:\TestModule\TestModule.psm1' -Value @"
. .\src\Get-AFunction.ps1
. .\src\Get-BFunction.ps1
. .\src\C\Get-CFunction.ps1
. .\src\C\Set-CFunction.ps1
"@

            $Before = $(Test-ModuleManifest $ManifestFile | `
                    Select-Object -ExpandProperty ExportedCommands).Count

            Update-FunctionsToExport -Path 'TestDrive:\TestModule'

            $After = $(Test-ModuleManifest $ManifestFile | `
                    Select-Object -ExpandProperty ExportedCommands).Count

            $FunctionNames = Test-ModuleManifest $ManifestFile | `
                Select-Object -ExpandProperty ExportedCommands | `
                Select-Object -ExpandProperty Values | `
                Select-Object -ExpandProperty Name

            $Before -ne $After | Should -Be $true
            $After | Should -BeExactly 4
            $FunctionNames -contains 'Get-AFunction' | Should -Be $true
            $FunctionNames -contains 'Get-BFunction' | Should -Be $true
            $FunctionNames -contains 'Get-CFunction' | Should -Be $true
            $FunctionNames -contains 'Set-CFunction' | Should -Be $true
        }
    }
    
    Context "[imported module] Recurse src directory for correct function files" {
        BeforeEach {
            $ManifestFile = 'TestDrive:\TestModule\TestModule.psd1'

            Copy-Item -Path 'test\manifest\resource\TestModule' -Destination "TestDrive:\TestModule" -Container -Recurse -Force -Verbose
            Set-Content -Path 'TestDrive:\TestModule\TestModule.psm1' -Value @"
function Get-AFunction {
    
}
"@
            Update-ModuleManifest -Path $ManifestFile -FunctionsToExport @('Get-AFunction')

            Import-Module -Name $ManifestFile -Verbose -Force -Global
        }
        AfterEach {
            Remove-Module -Name TestModule
        }

        It "Should overwrite the default value ('@()') for FunctionsToExport field" {

            #ensure that module exists followed by non-existing
            Get-Module TestModule | Remove-Module -Verbose
            Get-Module TestModule | Should -Be $null

            $Before = $(Test-ModuleManifest $ManifestFile | `
                    Select-Object -ExpandProperty ExportedCommands).Count

            Set-Content -Path 'TestDrive:\TestModule\TestModule.psm1' -Value @"
. .\src\Get-BFunction.ps1
. .\src\C\Get-CFunction.ps1
. .\src\C\Set-CFunction.ps1

function Get-AFunction {

}
"@

            # exclude this file in this It block, it will be used for testing in the following It block
            Update-FunctionsToExport -Path 'TestDrive:\TestModule' -Exclude 'Get-AFunction.ps1'

            $After = $(Test-ModuleManifest $ManifestFile | `
                    Select-Object -ExpandProperty ExportedCommands).Count

            $FunctionNames = Test-ModuleManifest $ManifestFile | `
                Select-Object -ExpandProperty ExportedCommands | `
                Select-Object -ExpandProperty Values | `
                Select-Object -ExpandProperty Name

            $Before -ne $After | Should -Be $true
            $Before | Should -BeExactly 1
            $After | Should -BeExactly 4
            $FunctionNames -contains 'Get-AFunction' | Should -Be $true
            $FunctionNames -contains 'Get-BFunction' | Should -Be $true
            $FunctionNames -contains 'Get-CFunction' | Should -Be $true
            $FunctionNames -contains 'Set-CFunction' | Should -Be $true
        }
    }
}