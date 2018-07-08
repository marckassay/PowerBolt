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

        Mock Start-Job {} -ModuleName PowerBolt
        
        Publish-ModuleToNuGetGallery -Path ($TestSupportModule.MockManifestPath) -NuGetApiKey 'd2a2cea9-624f-451d-acd2-cdcd2110ab5e' -DoNotConfirm

        It "Should of called PowerShellGet's Publish-Module with expected params" {
            
            Assert-MockCalled Start-Job -ParameterFilter {
                $Name -eq "JobPowerShellGet"
            } -ModuleName PowerBolt -Times 1
            
            Assert-MockCalled Start-Job -ParameterFilter {
                $ArgumentList[0].DestinationDirectory -like '*MockModuleB*'
            } -ModuleName PowerBolt -Times 1
            
            Assert-MockCalled Start-Job -ParameterFilter {
                $ArgumentList[0].NuGetApiKey -like 'd2a2cea9-624f-451d-acd2-cdcd2110ab5e'
            } -ModuleName PowerBolt -Times 1
        }
    }
}