using module .\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'
[TestFunctions]::AUTO_START = $true

Describe "Test Search-Items" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetupUsingTestModule('TestModuleA')
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestFunctions', 'TestModuleA'))
    }
    
    Context "Call Search-Items" {

        Add-Content "$($__.TestModuleDirectoryPath)\src\Get-AFunction.ps1" -Value @"
`n
# NoExport: Get-AFunction
"@

        Add-Content "$($__.TestModuleDirectoryPath)\src\Get-BFunction.ps1" -Value @"
`n
# NoExport: Get-BFunction
"@
        It "Should find 'NoExport' tag in src folder contents" {
            $Results = Search-Items -Path $__.TestModuleDirectoryPath  -Pattern "\#.?NoExport" -Recurse
            $Results.Count | Should -Be 2

            $Results[0].Match | Should -Be "# NoExport"
            $Results[0].MatchedLine | Should -Be "# NoExport: Get-AFunction"
            $Results[0].Item.Name | Should -Be "Get-AFunction.ps1"
        }

        It "Should match 'Get-AFunction' tag in src folder contents" {
            $Results = Search-Items -Path $__.TestModuleDirectoryPath  -Pattern "(?<=NoExport:)\s*\w+-\w+" -Recurse
            $Results.Count | Should -Be 2

            $Results[0].Match | Should -Be "Get-AFunction"
            $Results[0].MatchedLine | Should -Be "# NoExport: Get-AFunction"
            $Results[0].Item.Name | Should -Be "Get-AFunction.ps1"
        }
    }
}