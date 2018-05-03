Describe "Test Update-ReadmeFromPlatyPSMarkdown" {
    BeforeAll {
        $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

        Set-Location -Path $SUT_MODULE_HOME
 
        # MK.PowerShell.4PS will copy config file to this path:
        $ConfigFilePath = "$TestDrive\MK.PowerShell\MK.PowerShell-config.ps1"
        
        Import-Module -Name '.\MK.PowerShell.4PS.psd1' -ArgumentList $ConfigFilePath -Verbose -Force

        Copy-Item -Path 'test\testresource\TestModuleB' -Destination $TestDrive -Container -Recurse -Force -Verbose

        Import-Module -Name "$TestDrive\TestModuleB\TestModuleB.psd1"
    }
    
    AfterAll {
        Get-Module MK.PowerShell.4PS | Remove-Module
        Get-Module MKPowerShellDocObject | Remove-Module
        Get-Module TestModuleB | Remove-Module

        Set-Alias sl Set-Location -Scope Global
    }

    Context "As a non-piped call, with a given Path modify existing empty README.md file." {

        New-Item -Path "$TestDrive\TestModuleB\README.md" -ItemType File

        Update-ReadmeFromPlatyPSMarkdown -Path "$TestDrive\TestModuleB"

        It "Should modify README.md file at line number <Index> with: {<Expected>} " -TestCases @(
            @{ Index = 0; Expected = "" },
            @{ Index = 1; Expected = "" },
            @{ Index = 2; Expected = "## Functions" },
            @{ Index = 3; Expected = "" },
            @{ Index = 4; Expected = "### [```Get-AFunction```]()" }
            @{ Index = 5; Expected = "" }
            @{ Index = 6; Expected = "    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam." }
            @{ Index = 7; Expected = " " }
            @{ Index = 8; Expected = "### [```Get-BFunction```]()" }
        ) {
            Param($Index, $Expected)
            $Actual = (Get-Content "$TestDrive\TestModuleB\README.md")[$Index]
            $Actual.Replace('```', '`') | Should -BeExactly $Expected
        }
    }

    Context "As a non-piped call, with a given Path modify existing README.md file with default boundary marks." {

        New-Item -Path "$TestDrive\TestModuleB\README.md" -ItemType File
        $NewContent = @"
# TestModuleB

Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus.

## Functions 

### [```Get-XFunction```]()

    um necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae.

## RoadMap
"@
        $NewContent | Set-Content -Path "$TestDrive\TestModuleB\README.md"

        Update-ReadmeFromPlatyPSMarkdown -Path "$TestDrive\TestModuleB"

        It "Should modify README.md file at line number <Index> with: {<Expected>} " -TestCases @(
            @{ Index = 0; Expected = "# TestModuleB" },
            @{ Index = 1; Expected = "" },
            @{ Index = 2; Expected = "Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus." },
            @{ Index = 3; Expected = "" },
            @{ Index = 4; Expected = "## Functions" },
            @{ Index = 5; Expected = "" },
            @{ Index = 6; Expected = "### [```Get-AFunction```]()" }
            @{ Index = 7; Expected = "" }
            @{ Index = 8; Expected = "    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam." }
            @{ Index = 9; Expected = " " }
            @{ Index = 10; Expected = "### [```Get-BFunction```]()" }
            @{ Index = 22; Expected = "## RoadMap" }
        ) {
            Param($Index, $Expected)

            $Actual = (Get-Content "$TestDrive\TestModuleB\README.md")[$Index]
            $Actual.Replace('```', '`') | Should -BeExactly $Expected
        }
    }
}