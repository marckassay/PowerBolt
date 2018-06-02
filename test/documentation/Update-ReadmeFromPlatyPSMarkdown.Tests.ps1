using module ..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'
[TestFunctions]::AUTO_START = $true

Describe "Test Update-ReadmeFromPlatyPSMarkdown" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetupUsingTestModule('TestModuleB')
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestModuleB', 'TestFunctions'))
    }
    
    Context "As a non-piped call, with a given Path modify existing empty README.md file." {

        New-Item -Path "$TestDrive\TestModuleB\README.md" -ItemType File

        Update-ReadmeFromPlatyPSMarkdown -Path "$TestDrive\TestModuleB"

        It "Should modify README.md file at line number <Index> with: {<Expected>} " -TestCases @(
            @{ Index = 0; Expected = "" },
            @{ Index = 1; Expected = "## API" },
            @{ Index = 2; Expected = "" },
            @{ Index = 3; Expected = "#### [``Get-AFunction``](https://github.com/marckassay/TestModuleB/blob/master/docs/Get-AFunction.md)" }
            @{ Index = 4; Expected = "" }
            @{ Index = 5; Expected = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam. " }
            @{ Index = 6; Expected = "" }
            @{ Index = 7; Expected = "#### [``Get-BFunction``](https://github.com/marckassay/TestModuleB/blob/master/docs/Get-BFunction.md)" }
        ) {
            Param($Index, $Expected)
            $Actual = (Get-Content "$TestDrive\TestModuleB\README.md")[$Index]
            $Actual.Replace('```', '`') | Should -BeExactly $Expected
        }
    }

    Context "As a non-piped call, with a given Path modify existing README.md file" {
        New-Item -Path "$TestDrive\TestModuleB\README.md" -ItemType File
        $NewContent = @"
# TestModuleB

Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus.

## API

#### [```Get-XFunction```](https://github.com/marckassay/TestModuleB/blob/master/docs/Get-XFunction.md)

um necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae.
"@
        $NewContent | Set-Content -Path "$TestDrive\TestModuleB\README.md"
        Update-ReadmeFromPlatyPSMarkdown -Path "$TestDrive\TestModuleB"
        It "Should modify README.md file at line number <Index> with: {<Expected>} " -TestCases @(
            @{ Index = 0; Expected = "# TestModuleB" },
            @{ Index = 1; Expected = "" },
            @{ Index = 2; Expected = "Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus." },
            @{ Index = 3; Expected = "" },
            @{ Index = 4; Expected = "## API" },
            @{ Index = 5; Expected = "" },
            @{ Index = 6; Expected = "#### [``Get-AFunction``](https://github.com/marckassay/TestModuleB/blob/master/docs/Get-AFunction.md)" }
            @{ Index = 7; Expected = "" }
            @{ Index = 8; Expected = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam. " }
            @{ Index = 9; Expected = "" }
            @{ Index = 10; Expected = "#### [``Get-BFunction``](https://github.com/marckassay/TestModuleB/blob/master/docs/Get-BFunction.md)" }
        ) {
            Param($Index, $Expected)
            $Actual = (Get-Content "$TestDrive\TestModuleB\README.md")[$Index]
            $Actual.Replace('```', '`') | Should -BeExactly $Expected
        }
    }
}