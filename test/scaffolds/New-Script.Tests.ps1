using module ..\.\TestFunctions.psm1

Describe "Test New-Script" {
    BeforeAll {
        $TestFunctions = [TestFunctions]::new()

        $TestFunctions.DescribeSetup()
    }
    
    AfterAll {
        $TestFunctions.DescribeTeardown()
    }
    
    Context "Call New-Script" {
        New-Script -Name 'Update-SemVer' -Path $TestDrive -SrcChildPath 'src/manifest'

        $UpdateSemVerSrcPath = Join-Path -Path $TestDrive -ChildPath 'src/manifest/Update-SemVer.ps1'
        $UpdateSemVerTestPath = Join-Path -Path $TestDrive -ChildPath 'test/manifest/Update-SemVer.Tests.ps1'
            
        It "Should scaffold files to correct locations" {
            $UpdateSemVerSrcPath | Should -Exist 
            $UpdateSemVerTestPath | Should -Exist 
        }

        It "Should modify the scaffold src file as expected" {
            $UpdateSemVerSrcPath | Should -FileContentMatch ([regex]::Escape('function Update-SemVer'))
        }

        It "Should modify the scaffold test file as expected" {
            $UpdateSemVerTestPath | Should -FileContentMatch ([regex]::Escape('Describe "Test Update-SemVer"'))
        }
    }
}