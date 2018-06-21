using module ..\..\.\TestRunnerSupportModule.psm1

Describe "Test Get-ManifestKey" {
    
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleA')

        # need to copy format files over to mock folder so that MockModuleA manifest will not throw 
        # an error when imported
        $FormatDirectory = New-Item -Path "TestDrive:\MockModuleA\resources\formats\" -ItemType Directory
        $HistoryInfoformatps1xml = Join-Path -Path . -ChildPath "resources\formats\HistoryInfo.format.ps1xml"
        $PSModuleInfoformatps1xml = Join-Path -Path . -ChildPath "resources\formats\PSModuleInfo.format.ps1xml"
        Copy-Item -Path $HistoryInfoformatps1xml, $PSModuleInfoformatps1xml -Destination $FormatDirectory -Force
    }
    AfterAll {
        $TestSupportModule.Teardown()
    }

    Context "Call Get-ManifestKey with known valid value for 'FormatsToProcess' key" {
        It "Should return expected values" {
            Update-ModuleManifest -Path $TestSupportModule.MockManifestPath -FormatsToProcess @(
                '.\resources\formats\HistoryInfo.format.ps1xml',
                '.\resources\formats\PSModuleInfo.format.ps1xml'
            ) 

            InModuleScope -ModuleName MK.PowerShell.Flow {
                $Results = Get-ManifestKey -Path 'TestDrive:\MockModuleA' -Key 'FormatsToProcess'
                $Results.Count | Should -Be 2
                $Results[0] | Should -Be 'resources\formats\HistoryInfo.format.ps1xml'
                $Results[1] | Should -Be 'resources\formats\PSModuleInfo.format.ps1xml'
            }
        }
    }
}