using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Get-MKModuleInfo" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleB')
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }

    Context "Calling by 'ByPath' parameter set with path to directory" {
        $Results = Get-MKModuleInfo -Path $TestSupportModule.MockDirectoryPath

        It "Should return MKModuleInfo" {
            $Results.GetType().Name | Should -Be 'MKModuleInfo'
        }

        It "Should have MKModuleInfo instance set with expected values" {
            $Results.Path | Should -Be $TestSupportModule.MockDirectoryPath
            $Results.ManifestFilePath | Should -Be $TestSupportModule.MockManifestPath
            $Results.RootModuleFilePath | Should -Be $TestSupportModule.MockRootModulePath
            $Results.Version | Should -Be '0.0.1'
        }
    }

    Context "Calling by 'ByPath' parameter set with path to manifest file" {
        $Results = Get-MKModuleInfo -Path $TestSupportModule.MockManifestPath

        It "Should return MKModuleInfo" {
            $Results.GetType().Name | Should -Be 'MKModuleInfo'
        }

        It "Should have MKModuleInfo instance set with expected values" {
            $Results.Path | Should -Be $TestSupportModule.MockDirectoryPath
            $Results.ManifestFilePath | Should -Be $TestSupportModule.MockManifestPath
            $Results.RootModuleFilePath | Should -Be $TestSupportModule.MockRootModulePath
            $Results.Version | Should -Be '0.0.1'
        }
    }

    Context "Calling by 'ByPath' parameter set with path to module file" {
        $Results = Get-MKModuleInfo -Path $TestSupportModule.MockRootModulePath

        It "Should return MKModuleInfo" {
            $Results.GetType().Name | Should -Be 'MKModuleInfo'
        }

        It "Should have MKModuleInfo instance set with expected values" {
            $Results.Path | Should -Be $TestSupportModule.MockDirectoryPath
            $Results.ManifestFilePath | Should -Be $TestSupportModule.MockManifestPath
            $Results.RootModuleFilePath | Should -Be $TestSupportModule.MockRootModulePath
            $Results.Version | Should -Be '0.0.1'
        }
    }

    Context "Calling by 'ByPath' with no value for any parameters" {
        Push-Location
        Set-Location $TestSupportModule.MockDirectoryPath

        $Results = Get-MKModuleInfo
        
        Pop-Location

        It "Should return MKModuleInfo" {
            $Results.GetType().Name | Should -Be 'MKModuleInfo'
        }

        It "Should have MKModuleInfo instance set with expected values" {
            $Results.Path | Should -Be $TestSupportModule.MockDirectoryPath
            $Results.ManifestFilePath | Should -Be $TestSupportModule.MockManifestPath
            $Results.RootModuleFilePath | Should -Be $TestSupportModule.MockRootModulePath
            $Results.Version | Should -Be '0.0.1'
        }
    }

    Context "Calling by 'ByName' parameter set with given name value 'MockModuleB'" {
        $Results = Get-MKModuleInfo -Name 'MockModuleB'

        It "Should return MKModuleInfo" {
            $Results.GetType().Name | Should -Be 'MKModuleInfo'
        }

        It "Should have MKModuleInfo instance set with expected values" {
            $Results.Path | Should -Be $TestSupportModule.MockDirectoryPath
            $Results.ManifestFilePath | Should -Be $TestSupportModule.MockManifestPath
            $Results.RootModuleFilePath | Should -Be $TestSupportModule.MockRootModulePath
            $Results.Version | Should -Be '0.0.1'
        }
    }
}
