using module ..\..\.\TestFunctions.psm1

Describe "Test Get-ManifestKey" {
    
    BeforeAll {
        $TestFunctions = [TestFunctions]::new()

        # need to copy files over to import MockModuleA with them listed in the manifest
        Set-Location -Path $TestFunctions.ModulePath

        $FormatDirectory = New-Item -Path "TestDrive:\MockModuleA\resources\formats\" -ItemType Directory
        $HistoryInfoformatps1xml = Join-Path -Path $TestFunctions.ModulePath -ChildPath "resources\formats\HistoryInfo.format.ps1xml"
        $PSModuleInfoformatps1xml = Join-Path -Path $TestFunctions.ModulePath -ChildPath "resources\formats\PSModuleInfo.format.ps1xml"

        Copy-Item -Path $HistoryInfoformatps1xml, $PSModuleInfoformatps1xml -Destination $FormatDirectory -Force
        
        $TestFunctions.DescribeSetupUsingTestModule('MockModuleA')
    }
    AfterAll {
        $TestFunctions.DescribeTeardown()
    }

    Context "Call Get-ManifestKey with known valid value for 'FormatsToProcess' key" {
        It "Should return expected values" {
            Update-ModuleManifest -Path $TestFunctions.TestManifestPath -FormatsToProcess @(
                '.\resources\formats\HistoryInfo.format.ps1xml',
                '.\resources\formats\PSModuleInfo.format.ps1xml'
            ) 

            InModuleScope -ModuleName MK.PowerShell.4PS {
                $Results = Get-ManifestKey -Path 'TestDrive:\MockModuleA' -Key 'FormatsToProcess'
                $Results.Count | Should -Be 2
                $Results[0] | Should -Be 'resources\formats\HistoryInfo.format.ps1xml'
                $Results[1] | Should -Be 'resources\formats\PSModuleInfo.format.ps1xml'
            }
        }
    }
}