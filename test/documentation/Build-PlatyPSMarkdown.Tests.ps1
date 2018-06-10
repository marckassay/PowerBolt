using module ..\.\TestFunctions.psm1

$script:Files
$script:FileNames

Describe "Test Build-PlatyPSMarkdown" {

    BeforeAll {
        $TestFunctions = [TestFunctions]::new()

        $TestFunctions.DescribeSetupUsingTestModule('MockModuleB')
        
        # this test file needs the .git repo but not the docs folder
        Remove-Item -Path "$TestDrive\MockModuleB\docs" -Recurse

        $script:Files = "Get-AFunction.md", "Get-BFunction.md", "Get-CFunction.md", "Set-CFunction.md" | `
            Sort-Object
    }
    
    AfterAll {
        $TestFunctions.DescribeTeardown()
    }

    Context "As a non-piped call, with a given Path value to create files and then to update files 
    with a second call." {

        It "Should generate correct number of files." {
            # NOTE: if this functions re-imports, it will import into a different scope or session.  
            # Although it will still pass, it will write warnings and errors
            Build-PlatyPSMarkdown -Path "$TestDrive\MockModuleB" -NoReImportModule

            $script:FileNames = Get-ChildItem "$TestDrive\MockModuleB\docs" -Recurse | `
                ForEach-Object {$_.Name} | `
                Sort-Object
            
            $script:FileNames.Count | Should -Be 4
        }

        It "Should generate exactly filenames." {
            $FileNames | Should -BeExactly $script:Files
        }

        It "Should *create* Get-AFunction.md file at line number <Index> with: {<Expected>}" -TestCases @(
            @{ Index = 0; Expected = "---" },
            @{ Index = 1; Expected = "external help file: MockModuleB-help.xml" },
            @{ Index = 2; Expected = "Module Name: MockModuleB" },
            @{ Index = 3; Expected = "online version: https://github.com/marckassay/MockModuleB/blob/master/docs/Get-AFunction.md"},
            @{ Index = 4; Expected = "schema: 2.0.0" }
            @{ Index = 5; Expected = "---" }
            @{ Index = 6; Expected = "" }
            @{ Index = 7; Expected = "# Get-AFunction" }
            @{ Index = 8; Expected = "" }
            @{ Index = 9; Expected = "## SYNOPSIS" }
            @{ Index = 10; Expected = "{{Fill in the Synopsis}}" }
        ) {
            Param($Index, $Expected)
            $Actual = (Get-Content "$TestDrive\MockModuleB\docs\Get-AFunction.md")[$Index]
            $Actual.Replace('```', '`') | Should -BeExactly $Expected
        }

        It "Should *update* Get-AFunction.md file with new parameter and preserve md modification." {
            $NewSynopsisContent = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam."

            # modifiy Get-AFunction.md by adding a new parameter
            $NewGetAFunctionMDContent = Get-Item -Path "$TestDrive\MockModuleB\docs\Get-AFunction.md" | `
                Get-Content -Raw 

            $NewGetAFunctionMDContent = $NewGetAFunctionMDContent.Replace("{{Fill in the Synopsis}}", $NewSynopsisContent)

            Set-Content -Path "$TestDrive\MockModuleB\docs\Get-AFunction.md" -Value $NewGetAFunctionMDContent


            # modifiy Get-AFunction.md by adding a synopsis
            Clear-Content "$TestDrive\MockModuleB\src\Get-AFunction.ps1"

            $NewGetAFunctionPS1Content = @"
function Get-AFunction {
    [CmdletBinding(PositionalBinding = `$False)]
    Param(
        [Parameter(Mandatory = `$False)]
        [String]`$Path,

        [Parameter(Mandatory = `$False)]
        [String]`$Key
    )
    
    Out-String -InputObject `$("Hello, from Get-AFunction!")
}
"@
            Set-Content "$TestDrive\MockModuleB\src\Get-AFunction.ps1" -Value $NewGetAFunctionPS1Content
            
            New-ExternalHelpFromPlatyPSMarkdown -Path "$TestDrive\MockModuleB"

            Build-PlatyPSMarkdown -Path "$TestDrive\MockModuleB" 

            $SynopsisContent = (Get-Content "$TestDrive\MockModuleB\docs\Get-AFunction.md")[10]
            $SynopsisContent | Should -Be $NewSynopsisContent

            $GetAFunctionSyntax = (Get-Content "$TestDrive\MockModuleB\docs\Get-AFunction.md")[15]
            $GetAFunctionSyntax | Should -Be "Get-AFunction [-Path <String>] [-Key <String>] [<CommonParameters>]"
        }
    }
}