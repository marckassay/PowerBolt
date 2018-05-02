Describe "Test Build-PlatyPSMarkdown" {
    BeforeAll {
        $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

        Set-Location -Path $SUT_MODULE_HOME

        $ConfigFilePath = "$TestDrive\MK.PowerShell\MK.PowerShell-config.ps1"
        
        Copy-Item -Path 'test\testresource\TestModule' -Destination "TestDrive:\" -Container -Recurse -Force -Verbose

        Import-Module -Name '.\MK.PowerShell.4PS.psd1' -ArgumentList $ConfigFilePath -Verbose -Force
    }
    AfterAll {
        Remove-Module MK.PowerShell.4PS -Force
        Set-Alias sl Set-Location -Scope Global
    }

    Context "non-piped usage" {
        It "Should generate markdown files with given Path" {
            Build-PlatyPSMarkdown -Path "$TestDrive\TestModule"
            "$TestDrive\TestModule\docs" | Should -Exist
        }
    }
}