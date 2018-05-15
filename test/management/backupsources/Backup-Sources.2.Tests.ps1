using module ..\..\.\TestFunctions.psm1
using module .\Deploy-TestFakes.psm1

[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Backup-Sources.2" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup()
    }

    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'TestFunctions', 'Deploy-TestModifications'))
    }
    
    Context "With Backups field having 3 given file paths to same destination folder" {
        It "Should deploy all 3 files and 1 of them having UpdatePolicy of 'New'" -TestCases @(
            @{ 
                UpdatePolicy    = @("Overwrite", "New", "Overwrite");
                PathType        = @("ValidFile", "ValidFile", "ValidFile"); 
                DestinationType = @("ValidFolder", "ValidFolder", "ValidFolder")
            }
        ) {
            Param($PathType, $DestinationType, $UpdatePolicy)

            $TestDeploy = Deploy-TestFakes -ConfigFilePath $__.ConfigFilePath `
                -PathType $PathType `
                -DestinationType $DestinationType `
                -UpdatePolicy $UpdatePolicy

            Start-MKPowerShell -ConfigFilePath $__.ConfigFilePath

            $ConfigFileJson = Get-Content -Path $__.ConfigFilePath -Raw | ConvertFrom-Json -AsHashtable

            $ConfigFileJson.Backups.Count | Should -Be 3

            Get-Item $ConfigFileJson.Backups[0].Path | Select-Object -ExpandProperty Name -OutVariable TestFileName0
            Get-ChildItem $ConfigFileJson.Backups[0].Destination | Where-Object -Property Name -EQ $TestFileName0 | Should -BeOfType System.IO.FileInfo 

            Get-Item $ConfigFileJson.Backups[1].Path | Select-Object -ExpandProperty Name -OutVariable TestFileName1
            Get-ChildItem $ConfigFileJson.Backups[1].Destination | Where-Object -Property Name -Match "[$TestFileName1]\([1-9]\)\.txt" | Should -BeOfType System.IO.FileInfo 

            Get-Item $ConfigFileJson.Backups[2].Path | Select-Object -ExpandProperty Name -OutVariable TestFileName2
            Get-ChildItem $ConfigFileJson.Backups[2].Destination | Where-Object -Property Name -EQ $TestFileName2 | Should -BeOfType System.IO.FileInfo 
        }
    }
}