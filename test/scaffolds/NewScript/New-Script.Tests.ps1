using module .\..\..\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'
[TestFunctions]::AUTO_START = $true

Describe "Test New-Script" {
    BeforeAll {
        [TestFunctions]::DescribeSetup()
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown()
    }
    
    Context "Call New-Script" {
        It "Should scaffold files to correct locations" {
            New-Script -Name 'Update-SemVer' -Path $TestDrive -SrcChildPath 'src/manifest'

            $UpdateSemVerSrcPath = Join-Path -Path $TestDrive -ChildPath 'src/manifest/Update-SemVer.ps1'
            $UpdateSemVerTestPath = Join-Path -Path $TestDrive -ChildPath 'test/manifest/Update-SemVer.Tests.ps1'

            $UpdateSemVerSrcPath | Should -Exist 
            $UpdateSemVerTestPath | Should -Exist 
        }
    }
}