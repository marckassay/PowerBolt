using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Install-Template" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleB')

        $AlicesTemplates = New-Item -Path (Join-Path $TestSupportModule.TestDrivePath "AlicesTemplates") -ItemType Directory

        Copy-Item -Path (Join-Path -Path $TestSupportModule.FixtureDirectoryPath -ChildPath 'resources\templates\NewModule') -Destination $AlicesTemplates -Recurse
        $MockNewModuleTemplatePath = Join-Path -Path $AlicesTemplates -ChildPath 'NewModule\plasterManifest_en-US.xml'
   
        Copy-Item -Path (Join-Path -Path $TestSupportModule.FixtureDirectoryPath -ChildPath 'resources\templates\NewScript') -Destination $AlicesTemplates -Recurse
        $MockNewScriptTemplatePath = Join-Path -Path $AlicesTemplates -ChildPath 'NewScript\plasterManifest_en-US.xml'

        Push-Location -StackName 'InstallTemplateTest'
    }
    
    AfterAll {
        Pop-Location -StackName 'InstallTemplateTest'

        $TestSupportModule.Teardown()
    }
    
    Context "Call Install-Template with built-in template 'NewModule' and then with 'NewScript'" {

        Set-Location $TestSupportModule.TestDrivePath

        Mock Add-ModuleToProfile {} -ModuleName MK.PowerShell.Flow

        Install-Template -TemplateName 'NewModule' '.' 'MockModuleC' 'Alice' 

        $MockModuleCPath = (Join-Path -Path '.' -ChildPath 'MockModuleC')

        Assert-MockCalled Add-ModuleToProfile -ModuleName MK.PowerShell.Flow -Times 1 -ParameterFilter {
            $Path -eq $MockModuleCPath
        }

        $ScaffoldModuleFolder = Join-Path -Path $TestSupportModule.TestDrivePath -ChildPath 'MockModuleC'
        $ScaffoldManifestPath = Join-Path $ScaffoldModuleFolder -ChildPath 'MockModuleC.psd1'
        $ScaffoldRootModulePath = Join-Path $ScaffoldModuleFolder -ChildPath 'MockModuleC.psm1'

        It "Should scaffold module folder" {
            $ScaffoldModuleFolder | Should -Exist 
        }

        It "Should scaffold manifest and root module" {
            $ScaffoldManifestPath | Should -FileContentMatch ([regex]::Escape('Alice'))
            $ScaffoldManifestPath | Should -FileContentMatch ([regex]::Escape('MockModuleC'))
            $ScaffoldManifestPath | Should -FileContentMatch ([regex]::Escape('0.0.1'))

            $ScaffoldRootModulePath | Should -Exist 
        }

        Set-Location $ScaffoldModuleFolder

        Install-Template -TemplateName 'NewScript' 'utils/io' 'Get-FileExtension'

        $GetFileExtensionSrcPath = Join-Path -Path '.' -ChildPath 'src/utils/io/Get-FileExtension.ps1'
        $GetFileExtensionTestPath = Join-Path -Path '.' -ChildPath 'test/utils/io/Get-FileExtension.Tests.ps1'
        
        It "Should scaffold files to correct locations" {
            $GetFileExtensionSrcPath | Should -Exist 
            $GetFileExtensionTestPath | Should -Exist 
        }

        It "Should modify the scaffold src file as expected" {
            $GetFileExtensionSrcPath | Should -FileContentMatch ([regex]::Escape('function Get-FileExtension'))
        }

        It "Should modify the scaffold test file as expected" {
            $GetFileExtensionTestPath | Should -FileContentMatch ([regex]::Escape('Describe "Test Get-FileExtension"'))
        }
    }
    
    Context "Call Install-Template with explict paths to templates" {

        Set-Location $TestSupportModule.TestDrivePath
        Install-Template -TemplatePath $MockNewModuleTemplatePath  '.' 'MockModuleC' 'Alice' 

        $ScaffoldModuleFolder = Join-Path -Path $TestSupportModule.TestDrivePath -ChildPath 'MockModuleC'
        $ScaffoldManifestPath = Join-Path $ScaffoldModuleFolder -ChildPath 'MockModuleC.psd1'
        $ScaffoldRootModulePath = Join-Path $ScaffoldModuleFolder -ChildPath 'MockModuleC.psm1'

        It "Should scaffold module folder" {
            $ScaffoldModuleFolder | Should -Exist 
        }

        It "Should scaffold manifest and root module" {
            $ScaffoldManifestPath | Should -FileContentMatch ([regex]::Escape('Alice'))
            $ScaffoldManifestPath | Should -FileContentMatch ([regex]::Escape('MockModuleC'))
            $ScaffoldManifestPath | Should -FileContentMatch ([regex]::Escape('0.0.1'))

            $ScaffoldRootModulePath | Should -Exist 
        }

        Set-Location $ScaffoldModuleFolder
        Install-Template -TemplatePath $MockNewScriptTemplatePath 'utils/io' 'Get-FileExtension'

        $GetFileExtensionSrcPath = Join-Path -Path '.' -ChildPath 'src/utils/io/Get-FileExtension.ps1'
        $GetFileExtensionTestPath = Join-Path -Path '.' -ChildPath 'test/utils/io/Get-FileExtension.Tests.ps1'
        
        It "Should scaffold files to correct locations" {
            $GetFileExtensionSrcPath | Should -Exist 
            $GetFileExtensionTestPath | Should -Exist 
        }

        It "Should modify the scaffold src file as expected" {
            $GetFileExtensionSrcPath | Should -FileContentMatch ([regex]::Escape('function Get-FileExtension'))
        }

        It "Should modify the scaffold test file as expected" {
            $GetFileExtensionTestPath | Should -FileContentMatch ([regex]::Escape('Describe "Test Get-FileExtension"'))
        }
    }
}