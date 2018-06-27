using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Skip-ModuleInProfile" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleA')
        $MockProfilePath = Join-Path -Path ($TestSupportModule.TestDrivePath) -ChildPath "\User\Bob\Documents\PowerShell\" -AdditionalChildPath "MK.PowerShell-profile.ps1"
        New-Item -Path $MockProfilePath -ItemType File -Force | Select-Object -ExpandProperty FullName
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }
    
    Context "Skipping import module in profile" {

        It "Should skip Import-Module statement in profile" {

            $MockProfileContent = @"
Import-Module C:\Users\Bob\Foo
Import-Module C:\Users\Bob\Goo
Import-Module C:\Users\Bob\Plaster
"@
            Set-Content -Path $MockProfilePath -Value $MockProfileContent
            
            Skip-ModuleInProfile -Name 'Plaster' -ProfilePath $MockProfilePath

            $Results = Get-Content -Path $MockProfilePath
            $Results[2] | Should -eq '# Import-Module C:\Users\Bob\Plaster'
        }
    }
}