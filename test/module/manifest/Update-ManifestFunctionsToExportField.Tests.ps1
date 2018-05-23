using module ..\..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'
[TestFunctions]::AUTO_START = $true

Describe "Test Update-ManifestFunctionsToExportField" {
    
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetupUsingTestModule('TestModuleA')
    }
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestModuleA', 'TestFunctions'))
    }

    Context "Call Update-RootModuleUsingStatements and pipe result" {
        It "Should overwrite the default value ('@()') for FunctionsToExport field with 'using' statements" {
            Update-RootModuleUsingStatements -Path $__.TestModulePath | Update-ManifestFunctionsToExportField

            $FunctionNames = Test-ModuleManifest $__.TestManifestPath | `
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
        New-Item -Path 'TestDrive:\TestModuleA\src\D' -ItemType Directory
        New-Item -Path 'TestDrive:\TestModuleA\src\D\Set-DFunction.ps1' -ItemType File -Value @"
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
            Update-RootModuleUsingStatements -Path $__.TestModulePath | Update-ManifestFunctionsToExportField

            $FunctionNames = Test-ModuleManifest $__.TestManifestPath | `
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