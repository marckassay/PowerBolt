using module ..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'
[TestFunctions]::AUTO_START = $true

Describe "Test Reset-ModuleInProfile" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetupUsingTestModule('TestModuleA')

        $TestProfilePath = New-Item -Path $TestDrive -Name 'MK.PowerShell-profile.ps1' -ItemType File -Force | Select-Object -ExpandProperty FullName
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestModuleA', 'TestFunctions'))
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