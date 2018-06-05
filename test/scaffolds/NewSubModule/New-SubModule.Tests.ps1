using module .\..\..\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'
[TestFunctions]::AUTO_START = $true

Describe "Test New-SubModule" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetupUsingTestModule('TestModuleB')
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestFunctions'))
    }
    
    Context "Call New-SubModule" {

        It "Should scaffold files as expected" {
            $UpdateSemVerSrcPath = Join-Path -Path $__.TestModuleDirectoryPath -ChildPath 'src/module'
            $UpdateSemVerTestPath = Join-Path -Path $__.TestModuleDirectoryPath -ChildPath 'test/module'
            New-Item -Path $UpdateSemVerSrcPath, $UpdateSemVerTestPath -ItemType Directory

            #Set-Location $__.TestModuleDirectoryPath

            New-SubModule -Name 'Update-SemVer' -Path $__.TestModuleDirectoryPath

            Get-Item -Path $UpdateSemVerSrcPath | Should -Exist 
        }
    }
}