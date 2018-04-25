Describe "Test Add-ModuleToProfile" {
    $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

    BeforeEach {
        Push-Location

        Set-Location -Path $SUT_MODULE_HOME

        Import-Module -Name '.\MK.PowerShell.4PS.psd1' -Verbose -Force

        Copy-Item -Path 'test\manifest\resource\TestModule' -Destination "TestDrive:\" -Container -Recurse -Force -Verbose
        $TestProfilePath = New-Item -Path "TestDrive:\" -Name 'MK.PowerShell-profile.ps1' -ItemType File -Force | Select-Object -ExpandProperty FullName
    }
    AfterEach {
        Remove-Module MK.PowerShell.4PS
        Pop-Location
    }

    Context "Appending by importing module to profile" {

        It "Should add to profile" {

            $Before = Get-Content -Path $TestProfilePath
            $Before.Count | Should -BeExactly 0

            Add-ModuleToProfile -Path 'TestDrive:\TestModule' -ProfilePath $TestProfilePath

            [string]$After = Get-Content -Path $TestProfilePath -Raw
            $After | Should -Match 'Import-Module.*TestModule'
        }
        
        It "Should append to profile" {
            Set-Content -Path $TestProfilePath -Value ("Import-Module C:\temp\non\existing\NoModule") -NoNewline:$NoNewline.IsPresent
            
            [string]$Before = Get-Content -Path $TestProfilePath -Raw
            $Before | Should -Match '^Import-Module C\:\\temp\\non\\existing\\NoModule$'

            Add-ModuleToProfile -Path 'TestDrive:\TestModule' -ProfilePath $TestProfilePath

            [string]$After = Get-Content -Path $TestProfilePath -Raw
            $After | Should -Match 'Import-Module.*TestModule'
        }
    }
}