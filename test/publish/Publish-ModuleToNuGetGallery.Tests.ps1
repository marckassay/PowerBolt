using module ..\.\TestRunnerSupportModule.psm1
$script:TestPowerShellModulePath 

Describe "Test Publish-ModuleToNuGetGallery" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleB')
        $script:PriorEnvPSModulePath = $Env:PSModulePath
        $script:TestPowerShellModulePath = Join-Path -Path $TestSupportModule.TestDrivePath -ChildPath 'PowerShell\TestModules'
        $Env:PSModulePath = $script:TestPowerShellModulePath + ";" + $Env:PSModulePath
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
        # restore $Env:PSModulePath 
        $Env:PSModulePath = $script:PriorEnvPSModulePath
    }
    
    Context "Call Publish-ModuleToNuGetGallery with NuGetApiKey value from config file." {

        Mock Publish-Module -ModuleName MK.PowerShell.Flow
        
        Publish-ModuleToNuGetGallery -Path ($TestSupportModule.MockManifestPath) -NuGetApiKey 'd2a2cea9-624f-451d-acd2-cdcd2110ab5e' -DoNotConfirm

        It "Should of called PowerShellGet's Publish-Module with expected params" {
            
            # TODO: test against $Path using regex so that this can be ran on someone elses computer
            Assert-MockCalled Publish-Module -ParameterFilter {
                $NuGetApiKey -eq 'd2a2cea9-624f-451d-acd2-cdcd2110ab5e' -and `
                    $Path -like '*TestModules*'
            } -ModuleName MK.PowerShell.Flow
        }
    }
}