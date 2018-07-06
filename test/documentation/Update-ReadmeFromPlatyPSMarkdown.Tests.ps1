using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Update-ReadmeFromPlatyPSMarkdown" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleB')
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }
    
    Context "As a non-piped call, with a given Path modify existing empty README.md file." {

        New-Item -Path "$TestDrive\MockModuleB\README.md" -ItemType File

        Update-ReadmeFromPlatyPSMarkdown -Path "$TestDrive\MockModuleB"

        It "Should modify README.md file at line number <Index> with: {<Expected>} " -TestCases @(
            @{ Index = 0; Expected = "" },
            @{ Index = 1; Expected = "## API" },
            @{ Index = 2; Expected = "" },
            @{ Index = 3; Expected = "#### [``Get-AFunction``](https://github.com/marckassay/MockModuleB/blob/master/docs/Get-AFunction.md)" }
            @{ Index = 4; Expected = "" }
            @{ Index = 5; Expected = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam. " }
            @{ Index = 6; Expected = "" }
            @{ Index = 7; Expected = "#### [``Get-BFunction``](https://github.com/marckassay/MockModuleB/blob/master/docs/Get-BFunction.md)" }
        ) {
            Param($Index, $Expected)
            $Actual = (Get-Content "$TestDrive\MockModuleB\README.md")[$Index]
            $Actual.Replace('```', '`') | Should -BeExactly $Expected
        }
    }

    Context "As a non-piped call, with a given Path modify existing README.md file" {
        New-Item -Path "$TestDrive\MockModuleB\README.md" -ItemType File
        $NewContent = @"
# MockModuleB

Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus.

## API

#### [```Get-XFunction```](https://github.com/marckassay/MockModuleB/blob/master/docs/Get-XFunction.md)

um necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae.
"@
        $NewContent | Set-Content -Path "$TestDrive\MockModuleB\README.md"
        Update-ReadmeFromPlatyPSMarkdown -Path "$TestDrive\MockModuleB"
        It "Should modify README.md file at line number <Index> with: {<Expected>} " -TestCases @(
            @{ Index = 0; Expected = "# MockModuleB" },
            @{ Index = 1; Expected = "" },
            @{ Index = 2; Expected = "Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus." },
            @{ Index = 3; Expected = "" },
            @{ Index = 4; Expected = "## API" },
            @{ Index = 5; Expected = "" },
            @{ Index = 6; Expected = "#### [``Get-AFunction``](https://github.com/marckassay/MockModuleB/blob/master/docs/Get-AFunction.md)" }
            @{ Index = 7; Expected = "" }
            @{ Index = 8; Expected = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam. " }
            @{ Index = 9; Expected = "" }
            @{ Index = 10; Expected = "#### [``Get-BFunction``](https://github.com/marckassay/MockModuleB/blob/master/docs/Get-BFunction.md)" }
        ) {
            Param($Index, $Expected)
            $Actual = (Get-Content "$TestDrive\MockModuleB\README.md")[$Index]
            $Actual.Replace('```', '`') | Should -BeExactly $Expected
        }
    }

    # this context can be seen here: https://regex101.com/r/FAGS9U/1
    Context "As a non-piped call, with a given Path modify existing README.md file where content after last command is cannot be deleted." {
        New-Item -Path "$TestDrive\MockModuleB\README.md" -ItemType File
        $NewContent = @"
# MockModuleB

Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus.

## API

#### [```Get-XFunction```](https://github.com/marckassay/MockModuleB/blob/master/docs/Get-XFunction.md)

um necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae.

## Q&A

### Lorem ipsum dolor sit amet?

Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.

### Lorem ipsum tempor dolor sit?

Duis aute irure dolor in reprehenderit in voluptate!  Velit esse cillum dolore eu fugiat nulla pariatur.

"@
        $NewContent | Set-Content -Path "$TestDrive\MockModuleB\README.md"
        Update-ReadmeFromPlatyPSMarkdown -Path "$TestDrive\MockModuleB"
        It "Should modify README.md file at line number <Index> with: {<Expected>} " -TestCases @(
            @{ Index = 0; Expected = "# MockModuleB" },
            @{ Index = 1; Expected = "" },
            @{ Index = 2; Expected = "Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus." },
            @{ Index = 3; Expected = "" },
            @{ Index = 4; Expected = "## API" },
            @{ Index = 5; Expected = "" },
            @{ Index = 6; Expected = "#### [``Get-AFunction``](https://github.com/marckassay/MockModuleB/blob/master/docs/Get-AFunction.md)" }
            @{ Index = 7; Expected = "" }
            @{ Index = 8; Expected = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam. " }
            @{ Index = 9; Expected = "" }
            @{ Index = 10; Expected = "#### [``Get-BFunction``](https://github.com/marckassay/MockModuleB/blob/master/docs/Get-BFunction.md)" }
            @{ Index = 11; Expected = "" }
            @{ Index = 12; Expected = "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati. " }
            @{ Index = 13; Expected = "" }

            @{ Index = 22; Expected = "## Q&A" }
            @{ Index = 23; Expected = "" }
            @{ Index = 24; Expected = "### Lorem ipsum dolor sit amet?" }
            @{ Index = 25; Expected = "" }
            @{ Index = 26; Expected = "Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam." }
            @{ Index = 27; Expected = "" }
            @{ Index = 28; Expected = "### Lorem ipsum tempor dolor sit?" }
            @{ Index = 29; Expected = "" }
            @{ Index = 30; Expected = "Duis aute irure dolor in reprehenderit in voluptate!  Velit esse cillum dolore eu fugiat nulla pariatur." }
        ) {
            Param($Index, $Expected)
            $Actual = (Get-Content "$TestDrive\MockModuleB\README.md")[$Index]
            $Actual.Replace('```', '`') | Should -BeExactly $Expected
        }
    }
}