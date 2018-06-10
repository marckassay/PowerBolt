using module ..\..\.\TestFunctions.psm1

Describe "Test Update-ManifestFunctionsToExportField" {
    
    BeforeAll {
        $TestFunctions = [TestFunctions]::new()
        $TestFunctions.AutoStart = $false
        $TestFunctions.DescribeSetupUsingTestModule('MockModuleA')
    }
    AfterAll {
        $TestFunctions.DescribeTeardown()
    }

    Context "Call Update-RootModuleUsingStatements and pipe result" {
        It "Should overwrite the default value ('@()') for FunctionsToExport field with 'using' statements" {
            Update-RootModuleUsingStatements -Path $TestFunctions.TestModulePath | Update-ManifestFunctionsToExportField

            $FunctionNames = Test-ModuleManifest $TestFunctions.TestManifestPath | `
                Select-Object -ExpandProperty ExportedCommands | `
                Select-Object -ExpandProperty Values | `
                Select-Object -ExpandProperty Name

            'Get-AFunction' | Should -BeIn $FunctionNames
            'Get-BFunction' | Should -BeIn $FunctionNames
            'Get-CFunction' | Should -BeIn $FunctionNames
            'Set-CFunction' | Should -BeIn $FunctionNames
        }
    }

    Context "Call Update-RootModuleUsingStatements and pipe result that contains a 'NoExport' tag in one of the files" {
        New-Item -Path 'TestDrive:\MockModuleA\src\D' -ItemType Directory
        New-Item -Path 'TestDrive:\MockModuleA\src\D\Set-DFunction.ps1' -ItemType File -Value @"
using module ..\C\New-CFunction.ps1'

function Set-DFunction {
    [CmdletBinding()]
    param (
        
    )
    
}

# NoExport: Remove-DFunction
function Remove-DFunction {
    [CmdletBinding()]
    param (
        
    )
    
}

function Get-DFunction {
    [CmdletBinding()]
    param (
        
    )
    
}
"@ 

        It "Should overwrite the default value ('@()') for FunctionsToExport field with 'using' statements" {
            Update-RootModuleUsingStatements -Path $TestFunctions.TestModulePath | Update-ManifestFunctionsToExportField

            $FunctionNames = Test-ModuleManifest $TestFunctions.TestManifestPath | `
                Select-Object -ExpandProperty ExportedCommands | `
                Select-Object -ExpandProperty Values | `
                Select-Object -ExpandProperty Name

            'Get-AFunction' | Should -BeIn $FunctionNames
            'Get-BFunction' | Should -BeIn $FunctionNames
            'Get-CFunction' | Should -BeIn $FunctionNames
            'Set-CFunction' | Should -BeIn $FunctionNames
            'Get-DFunction' | Should -BeIn $FunctionNames
            'Set-DFunction' | Should -BeIn $FunctionNames
            'Remove-DFunction' | Should -not -BeIn $FunctionNames
        }
    }
}