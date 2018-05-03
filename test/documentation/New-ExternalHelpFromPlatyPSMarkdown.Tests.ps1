Describe "Test New-ExternalHelpFromPlatyPSMarkdown" {
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
        Remove-Module MK.PowerShell.4PS -Force
        Remove-Module MKPowerShellDocObject -Force
        
        Get-Module TestModuleB | Remove-Module

        Set-Alias sl Set-Location -Scope Global
    }

    Context "As a non-piped call, with a given Path generate files from MarkdownFolder to OutputFolder folder." {

        New-ExternalHelpFromPlatyPSMarkdown -Path "$TestDrive\TestModuleB"

        It "Should generate a file in 'en-US' folder" {
            $HelpDocFile = Get-Item "$TestDrive\TestModuleB\en-US\*xml"
            $HelpDocFile | Should -Exist
        }
    }
}