using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Add-ModuleToProfile" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleA')
        $MockProfilePath = Join-Path -Path ($TestSupportModule.TestDrivePath) -ChildPath "\User\Bob\Documents\PowerShell\" -AdditionalChildPath "MK.PowerShell-profile.ps1"
        New-Item -Path $MockProfilePath -ItemType File -Force | Select-Object -ExpandProperty FullName
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }
    
    Context "Appending by importing module to profile" {

        It "Should add to profile" {

            $Before = Get-Content -Path $MockProfilePath
            $Before.Count | Should -BeExactly 0

            Add-ModuleToProfile -Path 'TestDrive:\MockModuleA' -ProfilePath $MockProfilePath

            [string]$After = Get-Content -Path $MockProfilePath -Raw
            $After | Should -Match 'Import-Module.*MockModuleA'
        }
        
        It "Should append to profile" {
            Set-Content -Path $MockProfilePath -Value ("Import-Module C:\temp\non\existing\NoModule") -NoNewline
            
            [string]$Before = Get-Content -Path $MockProfilePath -Raw
            $Before | Should -Match '^Import-Module C\:\\temp\\non\\existing\\NoModule$'

            Add-ModuleToProfile -Path 'TestDrive:\MockModuleA' -ProfilePath $MockProfilePath

            [string]$After = Get-Content -Path $MockProfilePath -Raw
            $After | Should -Match 'Import-Module.*MockModuleA'
        }
    }
}