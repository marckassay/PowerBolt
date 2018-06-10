using module ..\.\TestFunctions.psm1

Describe "Test New-ExternalHelpFromPlatyPSMarkdown" {
    BeforeAll {
        $TestFunctions = [TestFunctions]::new()
        $TestFunctions.DescribeSetupUsingTestModule('MockModuleB')
    }
    
    AfterAll {
        $TestFunctions.DescribeTeardown()
    }

    Context "As a non-piped call, with a given Path generate files from MarkdownFolder to OutputFolder folder." {

        New-ExternalHelpFromPlatyPSMarkdown -Path "$TestDrive\MockModuleB"

        It "Should generate a file in 'en-US' folder" {
            $HelpDocFile = Get-Item "$TestDrive\MockModuleB\en-US\*xml"
            $HelpDocFile | Should -Exist
        }
    }
}