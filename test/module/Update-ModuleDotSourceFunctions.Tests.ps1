Describe "Test Update-ModuleDotSourceFunctions" {
    $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

    BeforeEach {
        Push-Location

        Set-Location -Path $SUT_MODULE_HOME

        Import-Module -Name '.\MK.PowerShell.4PS.psd1' -Verbose -Force -Global

        Copy-Item -Path 'test\manifest\resource\TestModule' -Destination "TestDrive:\" -Container -Recurse -Force -Verbose
    }
    AfterEach {
        Pop-Location
    }

    Context "Recurse src directory for correct function files" {

        It "Should modify empty root module with dot-source files" {
            Update-ModuleDotSourceFunctions -Path 'TestDrive:\TestModule'
            $Results = Get-Content -Path 'TestDrive:\TestModule\TestModule.psm1'
            $Results.Count | Should -Be 4

            $Assert = $Results[0] 
            $Assert | Should -Be '. .\src\C\Get-CFunction.ps1'

            $Assert = $Results[1] 
            $Assert | Should -Be ' . .\src\C\Set-CFunction.ps1'

            $Assert = $Results[2] 
            $Assert | Should -Be ' . .\src\Get-AFunction.ps1'

            $Assert = $Results[3] 
            $Assert | Should -Be ' . .\src\Get-BFunction.ps1'
        }

        It "Should modify root module that contains a function with dot-source file imports" {
            Set-Content -Path 'TestDrive:\TestModule\TestModule.psm1' -Value @"
function Remove-CFunction {
    [CmdletBinding()]
    param (
        
    )
    
}
"@

            Update-ModuleDotSourceFunctions -Path 'TestDrive:\TestModule'
            $Results = Get-Content -Path 'TestDrive:\TestModule\TestModule.psm1'
            $Results.Count | Should -Be 6

            $Assert = $Results[0] 
            $Assert | Should -Be '. .\src\C\Get-CFunction.ps1'

            $Assert = $Results[1] 
            $Assert | Should -Be ' . .\src\C\Set-CFunction.ps1'

            $Assert = $Results[2] 
            $Assert | Should -Be ' . .\src\Get-AFunction.ps1'

            $Assert = $Results[3] 
            $Assert | Should -Be ' . .\src\Get-BFunction.ps1'

            $Assert = $Results[4] 
            $Assert | Should -Be ''
        }

        It "Should modify root module that contains a function and dot-source file import with more dot-source imports" {
            Set-Content -Path 'TestDrive:\TestModule\TestModule.psm1' -Value @"
. .\src\C\New-CFunction.ps1'
function Remove-CFunction {
    [CmdletBinding()]
    param (
        
    )
    
}
"@ 

            Update-ModuleDotSourceFunctions -Path 'TestDrive:\TestModule'
            $Results = Get-Content -Path 'TestDrive:\TestModule\TestModule.psm1'
            $Results.Count | Should -Be 6

            $Assert = $Results[0] 
            $Assert | Should -Be '. .\src\C\Get-CFunction.ps1'

            $Assert = $Results[1] 
            $Assert | Should -Be ' . .\src\C\Set-CFunction.ps1'

            $Assert = $Results[2] 
            $Assert | Should -Be ' . .\src\Get-AFunction.ps1'

            $Assert = $Results[3] 
            $Assert | Should -Be ' . .\src\Get-BFunction.ps1'

            $Assert = $Results[4] 
            $Assert | Should -Be ''
        }
    }
}