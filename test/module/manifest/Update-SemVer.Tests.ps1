using module ..\..\.\TestFunctions.psm1

Describe "Test Update-SemVer" {
    BeforeAll {
        $TestFunctions = [TestFunctions]::new()

        $TestFunctions.DescribeSetupUsingTestModule('TestModuleB')
    }
    
    AfterAll {
        $TestFunctions.DescribeTeardown()
    }

    Context "Calling Update-SemVer with Path to module directory" {
        #$CurrentVersion = $(Import-PowerShellDataFile -Path ($TestFunctions.TestManifestPath))['ModuleVersion']
        #$Results = Update-SemVer -Path ($TestFunctions.TestModuleDirectoryPath) -BumpMajor

        It "Should currently have the expected version number" {
            $CurrentVersion = $(Import-PowerShellDataFile -Path ($TestFunctions.TestManifestPath))['ModuleVersion']
            $CurrentVersion | Should -Be '0.0.1'
        }

        It "Should bump Major" {
            $Results = Update-SemVer -Path ($TestFunctions.TestModuleDirectoryPath) -BumpMajor
            $Results | Should -Be '1.0.1'
        }

        It "Should bump Patch" {
            $Results = Update-SemVer -Path ($TestFunctions.TestModuleDirectoryPath) -BumpPatch
            $Results | Should -Be '1.0.2'
        }

        It "Should bump Minor and Patch" {
            $Results = Update-SemVer -Path ($TestFunctions.TestModuleDirectoryPath) -BumpPatch -BumpMinor
            $Results | Should -Be '1.1.3'
        }

        It "Should change version to explict value" {
            $Results = Update-SemVer -Path ($TestFunctions.TestModuleDirectoryPath) -Value '2.0.0'
            $Results | Should -Be '2.0.0'
        }
    }
}
