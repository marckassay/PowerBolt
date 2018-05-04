Describe "Test Build-PlatyPSMarkdown" {
    BeforeAll {
        $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

        Set-Location -Path $SUT_MODULE_HOME

        $ConfigFilePath = "$TestDrive\MK.PowerShell\MK.PowerShell-config.ps1"
        
        Copy-Item -Path 'test\testresource\TestModuleB' -Destination $TestDrive -Container -Recurse -Force -Verbose
        # remove docs since ths test files is generating them.
        Remove-Item -Path "$TestDrive\TestModuleB\docs" -Recurse
        Import-Module -Name '.\MK.PowerShell.4PS.psd1' -ArgumentList $ConfigFilePath -Force
    }
    
    AfterAll {
        Remove-Module MK.PowerShell.4PS -Force
        Remove-Module MKPowerShellDocObject -Force
        
        Get-Module TestModuleB | Remove-Module

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

        It "Should modify Get-AFunction.md file at line number <Index> with: {<Expected>} " -TestCases @(
            @{ Index = 0; Expected = "---" },
            @{ Index = 1; Expected = "external help file: TestModuleB-help.xml" },
            @{ Index = 2; Expected = "Module Name: TestModuleB" },
            @{ Index = 3; Expected = "online version: https://github.com/marckassay/TestModuleB/blob/master/docs/Get-AFunction.md"},
            @{ Index = 4; Expected = "schema: 2.0.0" }
            @{ Index = 5; Expected = "---" }
            @{ Index = 6; Expected = "" }
            @{ Index = 7; Expected = "# Get-AFunction" }
            @{ Index = 8; Expected = "" }
            @{ Index = 9; Expected = "## SYNOPSIS" }
            @{ Index = 10; Expected = "{{Fill in the Synopsis}}" }
        ) {
            Param($Index, $Expected)
            $Actual = (Get-Content "$TestDrive\TestModuleB\docs\Get-AFunction.md")[$Index]
            $Actual.Replace('```', '`') | Should -BeExactly $Expected
        }

        # second consective call to Build-PlatyPSMarkdown so that Update- will be called.  these 
        # calls to Build-PlatyPSMarkdown must be in the same Context scope because Pester restores 
        # drive to same state as it was in the Describe scope.
        Build-PlatyPSMarkdown -Path "$TestDrive\TestModuleB"

        # TODO: unable to spy on any functions
        # Assert-MockCalled Update-MarkdownHelp -Times 1
    }
}
