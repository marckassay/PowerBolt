using module ..\.\TestRunnerSupportModule.psm1

Describe "Test New-Script" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleB')
        $PlasterTemplatePath = Join-Path -Path $TestSupportModule.MockDirectoryPath -ChildPath 'resources\plasterManifest_en-US.xml'

        Set-Location $TestSupportModule.MockDirectoryPath
    }
    
    AfterAll {
        # This will throw an exception: 
        # Remove-Item : Cannot remove the item at 'C:\Users\Marc\AppData\Local\Temp\6f248999-9933-46c8-966a-30c661214cdd' because it is in use.
        $TestSupportModule.Teardown()
    }
    
    Context "Call New-Script" {

        New-Script -PlasterTemplatePath $PlasterTemplatePath 'io' 'Get-FileExtension'

        $GetFileExtensionSrcPath = Join-Path -Path $TestSupportModule.MockDirectoryPath -ChildPath 'src/io/Get-FileExtension.ps1'
        $GetFileExtensionTestPath = Join-Path -Path $TestSupportModule.MockDirectoryPath -ChildPath 'test/io/Get-FileExtension.Tests.ps1'
        
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