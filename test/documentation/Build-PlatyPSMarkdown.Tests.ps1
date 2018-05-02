Describe "Test Build-PlatyPSMarkdown" {
    BeforeAll {
        $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

        Set-Location -Path $SUT_MODULE_HOME

        $ConfigFilePath = "$TestDrive\MK.PowerShell\MK.PowerShell-config.ps1"
        
        Copy-Item -Path 'test\testresource\TestModuleB' -Destination "TestDrive:\" -Container -Recurse -Force -Verbose

        Import-Module -Name '.\MK.PowerShell.4PS.psd1' -ArgumentList $ConfigFilePath -Verbose -Force
    }
    AfterAll {
        Remove-Module MK.PowerShell.4PS -Force
        Remove-Module MKPowerShellDocObject -Force
        Set-Alias sl Set-Location -Scope Global
    }

    Context "non-piped usage" {

        It "Should generate correct number of files." {

            Build-PlatyPSMarkdown -Path "$TestDrive\TestModuleB"

            $FileNames = Get-ChildItem "$TestDrive\TestModuleB\docs" -Recurse | `
                ForEach-Object {$_.Name} | `
                Sort-Object
            $FileNames.Count | Should -Be 4

            $Files = "Get-AFunction.md", "Get-BFunction.md", "Get-CFunction.md", "Set-CFunction.md" | `
                Sort-Object
            $FileNames | Should -BeExactly $Files
        }
    }
}