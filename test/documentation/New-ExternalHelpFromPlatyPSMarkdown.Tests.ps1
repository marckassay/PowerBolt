using module ..\.\TestRunnerSupportModule.psm1

Describe "Test New-ExternalHelpFromPlatyPSMarkdown" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleB')
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }

    Context "As a non-piped call, with a given Path generate files from MarkdownFolder to OutputFolder folder." {

        New-ExternalHelpFromPlatyPSMarkdown -Path ($TestSupportModule.MockDirectoryPath)

        It "Should generate a file in 'en-US' folder" {
            $HelpDocFile = Get-Item (($TestSupportModule.MockDirectoryPath) + "\en-US\*xml")
            $HelpDocFile | Should -Exist
        }
    }
}