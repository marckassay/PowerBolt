using module .\..\TestFunctions.psm1

Describe "Test Search-Items" {
    BeforeAll {
        $TestFunctions = [TestFunctions]::new()

        $TestFunctions.DescribeSetupUsingTestModule('MockModuleA')
    }
    
    AfterAll {
        $TestFunctions.DescribeTeardown()
    }
    
    Context "Call Search-Items" {

        Add-Content "$($TestFunctions.TestModuleDirectoryPath)\src\Get-AFunction.ps1" -Value @"
`n
# NoExport: Get-AFunction
"@

        Add-Content "$($TestFunctions.TestModuleDirectoryPath)\src\Get-BFunction.ps1" -Value @"
`n
# NoExport: Get-BFunction
"@
        It "Should find 'NoExport' tag in src folder contents" {
            $Results = Search-Items -Path $TestFunctions.TestModuleDirectoryPath  -Pattern "\#.?NoExport" -Recurse
            $Results.Count | Should -Be 2

            $Results[0].Match | Should -Be "# NoExport"
            $Results[0].MatchedLine | Should -Be "# NoExport: Get-AFunction"
            $Results[0].Item.Name | Should -Be "Get-AFunction.ps1"
        }

        It "Should match 'Get-AFunction' tag in src folder contents" {
            $Results = Search-Items -Path $TestFunctions.TestModuleDirectoryPath  -Pattern "(?<=NoExport:)\s*\w+-\w+" -Recurse
            $Results.Count | Should -Be 2

            $Results[0].Match | Should -Be "Get-AFunction"
            $Results[0].MatchedLine | Should -Be "# NoExport: Get-AFunction"
            $Results[0].Item.Name | Should -Be "Get-AFunction.ps1"
        }
    }
}