using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Update-ModuleExports" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleB')
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }

    Context "Call with given Name value" {
        Push-Location
        Set-Location $TestSupportModule.MockDirectoryPath

        It "Should update Uris in manifest file" {
            Invoke-Expression -Command 'git checkout -b 3.0.1'

            Update-ModuleExports -Path ($TestSupportModule.MockManifestPath)
            $Manifest = Import-PowerShellDataFile -Path $TestSupportModule.MockManifestPath

            $Manifest.HelpInfoUri | Should -Be "https://github.com/marckassay/MockModuleB/tree/3.0.1"

            $PSData = $Manifest.PrivateData.PSData
            $PSData.LicenseUri | Should -Be "https://raw.githubusercontent.com/marckassay/MockModuleB/3.0.1/LICENSE"
        }
        
        Pop-Location
    }
}
