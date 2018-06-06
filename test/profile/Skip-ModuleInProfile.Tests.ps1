using module ..\.\TestFunctions.psm1

Describe "Test Skip-ModuleInProfile" {
    BeforeAll {
        $TestFunctions = [TestFunctions]::new()

        $TestFunctions.DescribeSetupUsingTestModule('TestModuleA')

        $TestProfilePath = New-Item -Path $TestDrive -Name 'MK.PowerShell-profile.ps1' -ItemType File -Force | Select-Object -ExpandProperty FullName
    }
    
    AfterAll {
        $TestFunctions.DescribeTeardown()
    }
    
    Context "Skipping import module in profile" {

        It "Should skip Import-Module statement in profile" {

            $TestProfileContent = @"
Import-Module C:\Users\Alice\Foo
Import-Module C:\Users\Alice\Goo
Import-Module C:\Users\Alice\Plaster
"@
            Set-Content -Path $TestProfilePath -Value $TestProfileContent

            Skip-ModuleInProfile -Name 'Plaster' -ProfilePath $TestProfilePath

            $Results = Get-Content -Path $TestProfilePath
            $Results[2] | Should -eq '# Import-Module C:\Users\Alice\Plaster'
        }
    }
}