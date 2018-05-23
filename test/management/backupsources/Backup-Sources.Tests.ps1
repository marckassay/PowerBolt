using module ..\..\.\TestFunctions.psm1
using module .\Deploy-TestFakes.psm1

[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'
[TestFunctions]::AUTO_START = $true

$script:PreTicks
$script:ConfigFileJson

Describe "Test Backup-Sources" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup()
    }

    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'TestFunctions', 'Deploy-TestFakes'))
    }

    Context @"
With 'Backups' field having 2 given file paths and 2 folder paths to same destination folder.
Execute the following:
    - Invoke 'Backup-Sources',
    - modify a file and folder contents,
    - invoke 'Backup-Sources'
    - and make assertions.
"@ {
        It "Should execute Deploy-TestFakes so that the config file is in an expected state for the following 'It' blocks." -TestCases @(
            @{ 
                UpdatePolicy    = @("New", "New", "Overwrite", "Overwrite");
                PathType        = @("ValidFile", "ValidFolder", "ValidFile", "ValidFolder"); 
                DestinationType = @("ValidFolder", "ValidFolder", "ValidFolder", "ValidFolder")
            }
        ) {
            Param($PathType, $DestinationType, $UpdatePolicy)

            # setup filesystem and config file
            Deploy-TestFakes -ConfigFilePath $__.ConfigFilePath `
                -PathType $PathType `
                -DestinationType $DestinationType `
                -UpdatePolicy $UpdatePolicy

            $script:ConfigFileJson = Get-Content -Path $__.ConfigFilePath -Raw | `
                ConvertFrom-Json -AsHashtable
            
            $script:ConfigFileJson.Backups.Count | Should -Be 4
        }

        It "Continuing from previous 'It' block, it should structure filesystem in an expected state for the following 'It' blocks." {
            $script:ConfigFileJson.Backups[0].Path | Should -Exist
            $script:ConfigFileJson.Backups[1].Path | Should -Exist
            $script:ConfigFileJson.Backups[2].Path | Should -Exist
            $script:ConfigFileJson.Backups[3].Path | Should -Exist

            $script:ConfigFileJson.Backups[0].Destination | Should -Exist
        }

        It "Continuing from previous 'It' block, call 'Backup-Sources' for the first time with test config path as a parameter.  It should increment and overwrite items as specified from previous 'It' block." {
            Backup-Sources -ConfigFilePath $__.ConfigFilePath

            $script:ConfigFileJson = Get-Content -Path $__.ConfigFilePath -Raw | `
                ConvertFrom-Json -AsHashtable

            $TestItemName = Get-Item $script:ConfigFileJson.Backups[0].Path | Select-Object -ExpandProperty Name | Split-Path -LeafBase
            Get-ChildItem $script:ConfigFileJson.Backups[0].Destination | `
                Where-Object -Property Name -Match "$TestItemName[(][\d]+[)]\.txt" | Should -BeOfType System.IO.FileInfo

            $TestItemName = Get-Item $script:ConfigFileJson.Backups[1].Path | Select-Object -ExpandProperty Name
            Get-ChildItem $script:ConfigFileJson.Backups[1].Destination | `
                Where-Object -Property Name -Match "$TestItemName[(1)]" | Should -BeOfType System.IO.DirectoryInfo 

            $TestItemName = Get-Item $script:ConfigFileJson.Backups[2].Path | Select-Object -ExpandProperty Name 
            Get-ChildItem $script:ConfigFileJson.Backups[2].Destination | `
                Where-Object -Property Name -EQ $TestItemName | Should -BeOfType System.IO.FileInfo

            $script:PreTicks = Join-Path -Path $script:ConfigFileJson.Backups[2].Destination -ChildPath $TestItemName | `
                Get-Item | `
                Get-ItemPropertyValue -Name LastWriteTime | `
                Select-Object -ExpandProperty Ticks

            $TestItemName = Get-Item $script:ConfigFileJson.Backups[3].Path | Select-Object -ExpandProperty Name
            Get-ChildItem $script:ConfigFileJson.Backups[3].Destination | `
                Where-Object -Property Name -Match $TestItemName | Should -BeOfType System.IO.DirectoryInfo 
        }

        It "Continuing from previous 'It' block, after modifying item with 'New' type and calling Backup-Sources, it should only detect a change of one item.  And by modifying only one of two items of 'Overwrite', it should detect and update just that one item too." {
            
            $script:ConfigFileJson = Get-Content -Path $__.ConfigFilePath -Raw | `
                ConvertFrom-Json -AsHashtable

            # modify file and folder contents to update the LastWriteTime property
            Get-ChildItem $script:ConfigFileJson.Backups[1].Path -Recurse | ForEach-Object {Add-Content -Path $_.FullName -Value (New-Guid | Select-Object -ExpandProperty Guid)} 
            Add-Content -Path $script:ConfigFileJson.Backups[2].Path -Value (New-Guid | Select-Object -ExpandProperty Guid)

            Backup-Sources

            $TestItemName = Get-Item $script:ConfigFileJson.Backups[0].Path | Select-Object -ExpandProperty Name | Split-Path -LeafBase
            Get-ChildItem $script:ConfigFileJson.Backups[0].Destination | `
                Where-Object -Property Name -Match "$TestItemName[(][\d]+[)]\.txt" | Should -BeOfType System.IO.FileInfo
          
            $TestItemName = Get-Item $script:ConfigFileJson.Backups[1].Path | Select-Object -ExpandProperty Name
            Get-ChildItem $script:ConfigFileJson.Backups[1].Destination | `
                Where-Object -Property Name -Match "$TestItemName[(1)]" | Should -BeOfType System.IO.DirectoryInfo 
            Get-ChildItem $script:ConfigFileJson.Backups[1].Destination | `
                Where-Object -Property Name -Match "$TestItemName[(2)]" | Should -BeOfType System.IO.DirectoryInfo 

            $TestItemName = Get-Item $script:ConfigFileJson.Backups[2].Path | Select-Object -ExpandProperty Name 
            Get-ChildItem $script:ConfigFileJson.Backups[2].Destination | `
                Where-Object -Property Name -EQ $TestItemName | Should -BeOfType System.IO.FileInfo
            
            $PostTicks = Join-Path -Path $script:ConfigFileJson.Backups[2].Destination -ChildPath $TestItemName | `
                Get-Item | `
                Get-ItemPropertyValue -Name LastWriteTime | `
                Select-Object -ExpandProperty Ticks
            $PostTicks | Should -BeGreaterThan $script:PreTicks

            $TestItemName = Get-Item $script:ConfigFileJson.Backups[3].Path | Select-Object -ExpandProperty Name
            Get-ChildItem $script:ConfigFileJson.Backups[3].Destination | `
                Where-Object -Property Name -Match $TestItemName | Should -BeOfType System.IO.DirectoryInfo 
        }
    }
}