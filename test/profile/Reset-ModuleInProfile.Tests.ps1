using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Reset-ModuleInProfile" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleA')
        $MockProfilePath = Join-Path -Path ($TestSupportModule.TestDrivePath) -ChildPath "\User\Bob\Documents\PowerShell\" -AdditionalChildPath "MK.PowerShell-profile.ps1"
        New-Item -Path $MockProfilePath -ItemType File -Force | Select-Object -ExpandProperty FullName
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }
    
    Context "Resetting import module in profile" {

        It "Should reset Import-Module statement in profile" {

            $MockProfileContent = @"
Import-Module C:\Users\Bob\Foo
# Import-Module C:\Users\Bob\Plaster
Import-Module C:\Users\Bob\Goo
"@
            Set-Content -Path $MockProfilePath -Value $MockProfileContent

            Reset-ModuleInProfile -Name 'Plaster' -ProfilePath $MockProfilePath

            $Results = Get-Content -Path $MockProfilePath
            $Results[1] | Should -eq 'Import-Module C:\Users\Bob\Plaster'
        }
    }
}