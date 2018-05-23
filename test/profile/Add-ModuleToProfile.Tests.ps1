using module ..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'
[TestFunctions]::AUTO_START = $true

Describe "Test Add-ModuleToProfile" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetupUsingTestModule('TestModuleA')

        $TestProfilePath = New-Item -Path $TestDrive -Name 'MK.PowerShell-profile.ps1' -ItemType File -Force | Select-Object -ExpandProperty FullName
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestModuleA', 'TestFunctions'))
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