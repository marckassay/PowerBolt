using module ..\.\TestFunctions.psm1

Describe "Test Reset-ModuleInProfile" {
    BeforeAll {
        $TestFunctions = [TestFunctions]::new()

        $TestFunctions.DescribeSetupUsingTestModule('TestModuleA')

        $TestProfilePath = New-Item -Path $TestDrive -Name 'MK.PowerShell-profile.ps1' -ItemType File -Force | Select-Object -ExpandProperty FullName
    }
    
    AfterAll {
        $TestFunctions.DescribeTeardown()
    }
    
    Context "Resetting import module in profile" {

        It "Should reset Import-Module statement in profile" {

            $TestProfileContent = @"
Import-Module C:\Users\Alice\Foo
# Import-Module C:\Users\Alice\Plaster
Import-Module C:\Users\Alice\Goo
"@
            Set-Content -Path $TestProfilePath -Value $TestProfileContent

            Reset-ModuleInProfile -Name 'Plaster' -ProfilePath $TestProfilePath

            $Results = Get-Content -Path $TestProfilePath
            $Results[1] | Should -eq 'Import-Module C:\Users\Alice\Plaster'
        }
    }
}