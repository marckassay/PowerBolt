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

    Context "As a non-piped call, with a given Path value to create files and then to update files 
    with a second call." {

        $Files = "Get-AFunction.md", "Get-BFunction.md", "Get-CFunction.md", "Set-CFunction.md" | `
            Sort-Object

        Build-PlatyPSMarkdown -Path "$TestDrive\TestModuleB"

        $FileNames = Get-ChildItem "$TestDrive\TestModuleB\docs" -Recurse | `
            ForEach-Object {$_.Name} | `
            Sort-Object

        It "Should generate correct number of files." {
            $FileNames.Count | Should -Be 4
        }

        It "Should generate exactly filenames." {
            $FileNames | Should -BeExactly $Files
        }

        It "Should contain the expected head of Get-AFunction.md file." {
            $ExpectedHead = @"
---
external help file: TestModuleB-help.xml
Module Name: TestModuleB
online version: https://github.com/marckassay/TestModule/blob/master/docs/Get-AFunction.md
schema: 2.0.0
---

# Get-AFunction

## SYNOPSIS
{{Fill in the Synopsis}}
"@
            $ActualHead = (Get-Content "$TestDrive\TestModuleB\docs\Get-AFunction.md" -Raw).Substring(0, 243)
            $ActualHead | Should -BeExactly $ExpectedHead
        }

        # second consective call to Build-PlatyPSMarkdown so that Update- will be called.  these 
        # calls to Build-PlatyPSMarkdown must be in the same Context scope because Pester restores 
        # drive to same state as it was in the Describe scope.
        Build-PlatyPSMarkdown -Path "$TestDrive\TestModuleB"

        # TODO: unable to spy on any functions
        # Assert-MockCalled Update-MarkdownHelp -Times 1
    }
}
