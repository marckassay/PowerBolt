using module ..\..\.\TestFunctions.psm1
using module .\Deploy-TestFakes.psm1

[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Backup-Sources.2" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup()
    }

    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'TestFunctions', 'Deploy-TestFakes'))
    }
    
    Context "With 'Backups' field having 3 given file paths to same destination folder" {
        It "Should deploy 2 files with UpdatePolicy of 'Overwrite' and the other a value of 'New'" -TestCases @(
            @{ 
                UpdatePolicy    = @("Overwrite", "New", "Overwrite");
                PathType        = @("ValidFile", "ValidFile", "ValidFile"); 
                DestinationType = @("ValidFolder", "ValidFolder", "ValidFolder")
            }
        ) {
            Param($PathType, $DestinationType, $UpdatePolicy)

            Deploy-TestFakes -ConfigFilePath $__.ConfigFilePath `
                -PathType $PathType `
                -DestinationType $DestinationType `
                -UpdatePolicy $UpdatePolicy

            Start-MKPowerShell -ConfigFilePath $__.ConfigFilePath

            $ConfigFileJson = Get-Content -Path $__.ConfigFilePath -Raw | ConvertFrom-Json -AsHashtable

            $ConfigFileJson.Backups.Count | Should -Be 3

            $TestItemName0 = Get-Item $ConfigFileJson.Backups[0].Path | Select-Object -ExpandProperty Name
            Get-ChildItem $ConfigFileJson.Backups[0].Destination | Where-Object -Property Name -EQ $TestItemName0 | Should -BeOfType System.IO.FileInfo 

            $TestItemName1 = Get-Item $ConfigFileJson.Backups[1].Path | Select-Object -ExpandProperty Name | Split-Path -LeafBase
            Get-ChildItem $ConfigFileJson.Backups[1].Destination | Where-Object -Property Name -Match "$TestItemName1[(][\d]+[)]\.txt" | Should -BeOfType System.IO.FileInfo 

            $TestItemName2 = Get-Item $ConfigFileJson.Backups[2].Path | Select-Object -ExpandProperty Name
            Get-ChildItem $ConfigFileJson.Backups[2].Destination | Where-Object -Property Name -EQ $TestItemName2 | Should -BeOfType System.IO.FileInfo 
        }
    }
    
    Context "With 'Backups' field having 2 given file paths and 1 folder path to same destination folder" {
        It "Should deploy 2 files with UpdatePolicy of 'Overwrite' and the other a value of 'New'" -TestCases @(
            @{ 
                UpdatePolicy    = @("New", "New", "Overwrite");
                PathType        = @("ValidFile", "ValidFolder", "ValidFile"); 
                DestinationType = @("ValidFolder", "ValidFolder", "ValidFolder")
            }
        ) {
            Param($PathType, $DestinationType, $UpdatePolicy)

            Deploy-TestFakes -ConfigFilePath $__.ConfigFilePath `
                -PathType $PathType `
                -DestinationType $DestinationType `
                -UpdatePolicy $UpdatePolicy

            Start-MKPowerShell -ConfigFilePath $__.ConfigFilePath

            $ConfigFileJson = Get-Content -Path $__.ConfigFilePath -Raw | ConvertFrom-Json -AsHashtable

            $ConfigFileJson.Backups.Count | Should -Be 3

            $TestItemName0 = Get-Item $ConfigFileJson.Backups[0].Path | Select-Object -ExpandProperty Name | Split-Path -LeafBase
            Get-ChildItem $ConfigFileJson.Backups[0].Destination | Where-Object -Property Name -Match "$TestItemName0[(][\d]+[)]\.txt" | Should -BeOfType System.IO.FileInfo 

            $TestItemName1 = Get-Item $ConfigFileJson.Backups[1].Path | Select-Object -ExpandProperty Name
            Get-ChildItem $ConfigFileJson.Backups[1].Destination | Where-Object -Property Name -Match "$TestItemName1[(][\d]+[)]" | Should -BeOfType System.IO.DirectoryInfo 

            $TestItemName2 = Get-Item $ConfigFileJson.Backups[2].Path | Select-Object -ExpandProperty Name 
            Get-ChildItem $ConfigFileJson.Backups[2].Destination | Where-Object -Property Name -EQ $TestItemName2 | Should -BeOfType System.IO.FileInfo 
        }
    }
    
    Context "With 'Backups' field having 2 given file paths and 1 folder path to same destination folder and then 'Start-MKPowerShell' and 'Backup-Sources' are called. " {
        It "Should deploy 1 file with UpdatePolicy of 'Overwrite' and the others a value of 'New'.  And seeing 2 sets of versions." -TestCases @(
            @{ 
                UpdatePolicy    = @("New", "New", "Overwrite");
                PathType        = @("ValidFile", "ValidFolder", "ValidFile"); 
                DestinationType = @("ValidFolder", "ValidFolder", "ValidFolder")
            }
        ) {
            Param($PathType, $DestinationType, $UpdatePolicy)

            Deploy-TestFakes -ConfigFilePath $__.ConfigFilePath `
                -PathType $PathType `
                -DestinationType $DestinationType `
                -UpdatePolicy $UpdatePolicy

            Start-MKPowerShell -ConfigFilePath $__.ConfigFilePath

            Backup-Sources

            $ConfigFileJson = Get-Content -Path $__.ConfigFilePath -Raw | ConvertFrom-Json -AsHashtable

            $ConfigFileJson.Backups.Count | Should -Be 3
            Get-ChildItem -Path $ConfigFileJson.Backups[0].Destination | ForEach-Object -Begin {$Items = 0} -Process {$Items++} -End {return $Items} | Should -Be 5

            $TestItemName0 = Get-Item $ConfigFileJson.Backups[0].Path | Select-Object -ExpandProperty Name | Split-Path -LeafBase
            Get-ChildItem $ConfigFileJson.Backups[0].Destination | Where-Object -Property Name -Match "$TestItemName0[(][\d]+[)]\.txt" | Should -BeOfType System.IO.FileInfo
             
            $TestItemName1 = Get-Item $ConfigFileJson.Backups[1].Path | Select-Object -ExpandProperty Name
            Get-ChildItem $ConfigFileJson.Backups[1].Destination | Where-Object -Property Name -Match "$TestItemName1[(2)]" | Should -BeOfType System.IO.DirectoryInfo 

            $TestItemName2 = Get-Item $ConfigFileJson.Backups[2].Path | Select-Object -ExpandProperty Name 
            Get-ChildItem $ConfigFileJson.Backups[2].Destination | Where-Object -Property Name -EQ $TestItemName2 | Should -BeOfType System.IO.FileInfo 
        }
    }
}