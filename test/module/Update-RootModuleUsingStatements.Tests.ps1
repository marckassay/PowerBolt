using module ..\.\TestFunctions.psm1

Describe "Test Update-RootModuleUsingStatements" {
    BeforeAll {
        $TestFunctions = [TestFunctions]::new()
        $TestFunctions.DescribeSetupUsingTestModule('MockModuleA')
    }
    
    AfterAll {
        $TestFunctions.DescribeTeardown()
    }
    
    Context "Recurse src directory for correct function files" {

        It "Should modify empty root module 'using' statments" {
            Update-RootModuleUsingStatements -Path 'TestDrive:\MockModuleA'
            $Results = Get-Content -Path 'TestDrive:\MockModuleA\MockModuleA.psm1'
            $Results.Count | Should -Be 4

            $Assert = $Results[0] 
            $Assert | Should -Be 'using module .\src\C\Get-CFunction.ps1'

            $Assert = $Results[1] 
            $Assert | Should -Be ' using module .\src\C\Set-CFunction.ps1'

            $Assert = $Results[2] 
            $Assert | Should -Be ' using module .\src\Get-AFunction.ps1'

            $Assert = $Results[3] 
            $Assert | Should -Be ' using module .\src\Get-BFunction.ps1'
        }

        It "Should modify root module which declares a function with 'using' statements" {
            Set-Content -Path 'TestDrive:\MockModuleA\MockModuleA.psm1' -Value @"
function Remove-CFunction {
    [CmdletBinding()]
    param (
        
    )
    
}
"@

            Update-RootModuleUsingStatements -Path 'TestDrive:\MockModuleA'
            $Results = Get-Content -Path 'TestDrive:\MockModuleA\MockModuleA.psm1'
            $Results.Count | Should -Be 12

            $Assert = $Results[0] 
            $Assert | Should -Be 'using module .\src\C\Get-CFunction.ps1'

            $Assert = $Results[1] 
            $Assert | Should -Be ' using module .\src\C\Set-CFunction.ps1'

            $Assert = $Results[2] 
            $Assert | Should -Be ' using module .\src\Get-AFunction.ps1'

            $Assert = $Results[3] 
            $Assert | Should -Be ' using module .\src\Get-BFunction.ps1'

            $Assert = $Results[4] 
            $Assert | Should -Be ''
        }

        It "Should modify root module which declares a function and contains a 'using' statement with more statements" {
            Set-Content -Path 'TestDrive:\MockModuleA\MockModuleA.psm1' -Value @"
using module .\src\C\New-CFunction.ps1'
function Remove-CFunction {
    [CmdletBinding()]
    param (
        
    )
    
}
"@ 

            Update-RootModuleUsingStatements -Path 'TestDrive:\MockModuleA'
            $Results = Get-Content -Path 'TestDrive:\MockModuleA\MockModuleA.psm1'
            $Results.Count | Should -Be 12

            $Assert = $Results[0] 
            $Assert | Should -Be 'using module .\src\C\Get-CFunction.ps1'

            $Assert = $Results[1] 
            $Assert | Should -Be ' using module .\src\C\Set-CFunction.ps1'

            $Assert = $Results[2] 
            $Assert | Should -Be ' using module .\src\Get-AFunction.ps1'

            $Assert = $Results[3] 
            $Assert | Should -Be ' using module .\src\Get-BFunction.ps1'

            $Assert = $Results[4] 
            $Assert | Should -Be ''
        }

        It "Should modify root module which declares a function and contains a 'using' statement with more statements and one of the files it finds has a '# NoExport:' tag" {
            Set-Content -Path 'TestDrive:\MockModuleA\MockModuleA.psm1' -Value @"
using module .\src\C\New-CFunction.ps1'
function Remove-CFunction {
    [CmdletBinding()]
    param (
        
    )
    
}
"@
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

            Update-RootModuleUsingStatements -Path 'TestDrive:\MockModuleA'

            'TestDrive:\MockModuleA\MockModuleA.psm1' | Should -not -FileContentMatch ([regex]::Escape('Remove-DFunction')) 

            $Results = Get-Content -Path 'TestDrive:\MockModuleA\MockModuleA.psm1'
            $Results.Count | Should -Be 13

            $Assert = $Results[0] 
            $Assert | Should -Be 'using module .\src\C\Get-CFunction.ps1'

            $Assert = $Results[1] 
            $Assert | Should -Be ' using module .\src\C\Set-CFunction.ps1'

            $Assert = $Results[2] 
            $Assert | Should -Be ' using module .\src\D\Set-DFunction.ps1'

            $Assert = $Results[3] 
            $Assert | Should -Be ' using module .\src\Get-AFunction.ps1'

            $Assert = $Results[4] 
            $Assert | Should -Be ' using module .\src\Get-BFunction.ps1'

            $Assert = $Results[5] 
            $Assert | Should -Be ''
        }
    }
}