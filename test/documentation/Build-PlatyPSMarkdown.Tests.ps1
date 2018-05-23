using module ..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'
[TestFunctions]::AUTO_START = $true

Describe "Test Build-PlatyPSMarkdown" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetupUsingTestModule('TestModuleB')
        
        # this test file needs the .git repo but not the docs folder
        Remove-Item -Path "$TestDrive\TestModuleB\docs" -Recurse
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestModuleB', 'TestFunctions'))
    }

    Context "As a non-piped call, with a given Path value to create files and then to update files 
    with a second call." {

        $Files = "Get-AFunction.md", "Get-BFunction.md", "Get-CFunction.md", "Set-CFunction.md" | `
            Sort-Object
            
        # NOTE: if this functions re-imports, it will import into a different scope or session.  
        # Although it will still pass, it will write warnings and errors
        Build-PlatyPSMarkdown -Path "$TestDrive\TestModuleB" -NoReImportModule

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
        # Build-PlatyPSMarkdown -Path "$TestDrive\TestModuleB"

        # TODO: unable to spy on any functions
        # Assert-MockCalled Update-MarkdownHelp -Times 1
    }
}
