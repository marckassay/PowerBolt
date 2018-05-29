using module ..\..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'
[TestFunctions]::AUTO_START = $true

Describe "Test Get-ManifestKey" {
    
    BeforeAll {
        # need to copy files over to import TestModuleA with them listed in the manifest
        Set-Location -Path ([TestFunctions]::MODULE_FOLDER)
        $FormatDirectory = New-Item -Path "TestDrive:\TestModuleA\src\format" -ItemType Directory
        Copy-Item -Path .\src\format\HistoryInfo.format.ps1xml -Destination $FormatDirectory -Force
        Copy-Item -Path .\src\format\PSModuleInfo.format.ps1xml -Destination $FormatDirectory -Force
        
        $__ = [TestFunctions]::DescribeSetupUsingTestModule('TestModuleA')
    }
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestModuleA', 'TestFunctions'))
    }

    Context "Call Get-ManifestKey with known valid value for 'FormatsToProcess' key" {
        It "Should return expected values" {
            Update-ModuleManifest -Path $__.TestManifestPath -FormatsToProcess @(
                '.\src\format\HistoryInfo.format.ps1xml',
                '.\src\format\PSModuleInfo.format.ps1xml'
            ) 

            InModuleScope MK.PowerShell.4PS {
                $Results = Get-ManifestKey -Path $__.TestManifestPath -Key 'FormatsToProcess'

                $Results.Count | Should -Be 2
                $Results[0] | Should -Be 'src\format\HistoryInfo.format.ps1xml'
                $Results[1] | Should -Be 'src\format\PSModuleInfo.format.ps1xml'
            }
        }
    }
}