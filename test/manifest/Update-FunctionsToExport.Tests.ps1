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

    Context "Recurse src directory for correct function files" {
        BeforeEach {
            Copy-Item -Path 'test\manifest\resource\TestModule' -Destination "TestDrive:\" -Container -Recurse -Force -Verbose
        }
        AfterEach {
        }

        It "Should export functions that were found in the src directory" {

            $Before = $(Test-ModuleManifest 'TestDrive:\TestModule\TestModule.psd1' | `
                    Select-Object -ExpandProperty ExportedCommands).Count

            Update-FunctionsToExport -Path 'TestDrive:\TestModule'

            $After = $(Test-ModuleManifest 'TestDrive:\TestModule\TestModule.psd1' | `
                    Select-Object -ExpandProperty ExportedCommands).Count

            $FunctionNames = Test-ModuleManifest 'TestDrive:\TestModule\TestModule.psd1' | `
                Select-Object -ExpandProperty ExportedCommands | `
                Select-Object -ExpandProperty Values | `
                Select-Object -ExpandProperty Name

            $Before -ne $After | Should -Be $true
            $After | Should -BeExactly 3
            $FunctionNames -contains 'Get-AFunction' | Should -Be $true
            $FunctionNames -contains 'Get-BFunction' | Should -Be $true
            $FunctionNames -contains 'Get-CFunction' | Should -Be $true
        }
    }
    <#
    Context "Import module that got modified" {
        BeforeEach {
            Copy-Item -Path 'test\manifest\resource\TestModule' -Destination "TestDrive:\" -Container -Recurse -Force -Verbose
            Import-Module -Name TestDrive:\TestModule\TestModule.psd1 -Verbose -Force -Global
        }
    
        AfterEach {
            Remove-Module -Name TestModule -Verbose -Force
            Pop-Location
        }

        It "Should export functions that were found in the src directory" {
            $Before = Get-Module "TestModule" | `
                Select-Object -ExpandProperty ExportedCommands | `
                Select-Object -ExpandProperty Values | `
                Select-Object -ExpandProperty Name
            
            Update-FunctionsToExport -Path 'TestDrive:\TestModule'

            $After = Get-Module "TestModule" | `
                Select-Object -ExpandProperty ExportedCommands | `
                Select-Object -ExpandProperty Values | `
                Select-Object -ExpandProperty Name

            $Before -ne $After | Should -Be $true
        }
    } 
    #>
}