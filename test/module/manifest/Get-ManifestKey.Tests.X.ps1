using module ..\..\.\TestFunctions.psm1

Describe "Test Get-ManifestKey" {
    
    BeforeAll {
        $TestFunctions = [TestFunctions]::new()

        # need to copy files over to import TestModuleA with them listed in the manifest
        Set-Location -Path $TestFunctions.ModulePath

        $FormatDirectory = New-Item -Path "TestDrive:\TestModuleA\src\format" -ItemType Directory

        $R = Join-Path -Path $TestFunctions.ModulePath -ChildPath "src\format\HistoryInfo.format.ps1xml"
        Copy-Item -Path $R -Destination $FormatDirectory -Force
        $S = Join-Path -Path $TestFunctions.ModulePath -ChildPath "src\format\PSModuleInfo.format.ps1xml"
        Copy-Item -Path $S -Destination $FormatDirectory -Force
        
        $TestFunctions.DescribeSetupUsingTestModule('TestModuleA')
    }
    AfterAll {
        $TestFunctions.DescribeTeardown()
    }

    Context "Call Get-ManifestKey with known valid value for 'FormatsToProcess' key" {
        It "Should return expected values" {
            Update-ModuleManifest -Path $TestFunctions.TestManifestPath -FormatsToProcess @(
                '.\src\format\HistoryInfo.format.ps1xml',
                '.\src\format\PSModuleInfo.format.ps1xml'
            ) 

            $Results = Get-ManifestKey -Path $TestFunctions.TestManifestPath -Key 'FormatsToProcess'

            $Results.Count | Should -Be 2
            $Results[0] | Should -Be 'src\format\HistoryInfo.format.ps1xml'
            $Results[1] | Should -Be 'src\format\PSModuleInfo.format.ps1xml'
            
        } -Skip
    }
}