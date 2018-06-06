using module ..\.\TestFunctions.psm1

Describe "Test Add-ModuleToProfile" {
    BeforeAll {
        $TestFunctions = [TestFunctions]::new()

        $TestFunctions.DescribeSetupUsingTestModule('TestModuleA')

        $TestProfilePath = New-Item -Path $TestDrive -Name 'MK.PowerShell-profile.ps1' -ItemType File -Force | Select-Object -ExpandProperty FullName
    }
    
    AfterAll {
        $TestFunctions.DescribeTeardown()
    }
    
    Context "Appending by importing module to profile" {

        It "Should add to profile" {

            $Before = Get-Content -Path $TestProfilePath
            $Before.Count | Should -BeExactly 0

            Add-ModuleToProfile -Path 'TestDrive:\TestModuleA' -ProfilePath $TestProfilePath

            [string]$After = Get-Content -Path $TestProfilePath -Raw
            $After | Should -Match 'Import-Module.*TestModuleA'
        }
        
        It "Should append to profile" {
            Set-Content -Path $TestProfilePath -Value ("Import-Module C:\temp\non\existing\NoModule") -NoNewline
            
            [string]$Before = Get-Content -Path $TestProfilePath -Raw
            $Before | Should -Match '^Import-Module C\:\\temp\\non\\existing\\NoModule$'

            Add-ModuleToProfile -Path 'TestDrive:\TestModuleA' -ProfilePath $TestProfilePath

            [string]$After = Get-Content -Path $TestProfilePath -Raw
            $After | Should -Match 'Import-Module.*TestModuleA'
        }
    }
}