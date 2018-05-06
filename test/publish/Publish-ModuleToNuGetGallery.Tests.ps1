using module ..\.\TestFunctions.psm1
$MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Publish-ModuleToNuGetGallery" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup($MODULE_FOLDER, 'TestModuleB')
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestModuleB', 'TestFunctions'))
    }
    
    Context "Call Publish-ModuleToNuGetGallery with NuGetApiKey value from config file." {

        Mock Publish-Module {} -ModuleName MK.PowerShell.4PS

        Publish-ModuleToNuGetGallery -Path $__.TestManifestPath -NuGetApiKey 'd2a2cea9-624f-451d-acd2-cdcd2110ab5e'

        It "Should of called PowerShellGet's Publish-Module with expected params" {
            
            Assert-MockCalled Publish-Module -ModuleName MK.PowerShell.4PS -Times 1 -ParameterFilter {
                $NuGetApiKey -eq 'd2a2cea9-624f-451d-acd2-cdcd2110ab5e'
            }
            
            # test against $Path using regex so that this can be ran on someone elses computer
            Assert-MockCalled Publish-Module -ModuleName MK.PowerShell.4PS -Times 1 -ParameterFilter {
                $Path -eq 'C:\Users\Marc\Documents\PowerShell\Modules\TestModuleB'
            } 
        }
    }
}