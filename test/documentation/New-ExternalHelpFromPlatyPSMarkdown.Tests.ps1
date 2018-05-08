using module ..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test New-ExternalHelpFromPlatyPSMarkdown" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetupUsingTestModule('TestModuleB')
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestModuleB', 'TestFunctions'))
    }

    Context "As a non-piped call, with a given Path generate files from MarkdownFolder to OutputFolder folder." {

        New-ExternalHelpFromPlatyPSMarkdown -Path "$TestDrive\TestModuleB"

        It "Should generate a file in 'en-US' folder" {
            $HelpDocFile = Get-Item "$TestDrive\TestModuleB\en-US\*xml"
            $HelpDocFile | Should -Exist
        }
    }
}