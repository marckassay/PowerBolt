using module ..\.\TestFunctions.psm1

Describe "Test Publish-ModuleToNuGetGallery" {
    BeforeAll {
        $TestFunctions = [TestFunctions]::new()

        $TestFunctions.DescribeSetupUsingTestModule('MockModuleB')
    }
    
    AfterAll {
        $TestFunctions.DescribeTeardown()
    }
    
    Context "Call Publish-ModuleToNuGetGallery with NuGetApiKey value from config file." {

        Mock Publish-Module {} -ModuleName MK.PowerShell.4PS

        Publish-ModuleToNuGetGallery -Path $TestFunctions.TestManifestPath -NuGetApiKey 'd2a2cea9-624f-451d-acd2-cdcd2110ab5e'

        It "Should of called PowerShellGet's Publish-Module with expected params" {
            
            # TODO: test against $Path using regex so that this can be ran on someone elses computer
            Assert-MockCalled Publish-Module -ModuleName MK.PowerShell.4PS -Times 1 -ParameterFilter {
                $NuGetApiKey -eq 'd2a2cea9-624f-451d-acd2-cdcd2110ab5e' -and `
                    $Path -eq 'C:\Users\Marc\Documents\PowerShell\Modules\MockModuleB'
            }
        }
    }
}