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

    Context @"
With 'Backups' field having 2 given file paths and 2 folder paths to same destination folder.
Execute the following:
    - Invoke 'Start-MKPowerShell',
    - modify a file and folder contents,
    - invoke 'Backup-Sources'
    - and make assertions.
"@ {
        It "Should deploy a pair of files with '(1)' appended to their filename and another pair with '(2)'.  A total of 5 items in destination folder." -TestCases @(
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

            $ConfigFileJson = Get-Content -Path $__.ConfigFilePath -Raw | ConvertFrom-Json -AsHashtable
            $ConfigFileJson.Backups.Count | Should -Be 4
            
            Backup-Sources -ConfigFilePath $__.ConfigFilePath

            Get-ChildItem -Path $ConfigFileJson.Backups[0].Destination | ForEach-Object -Begin {$Items = 0} -Process {$Items++} -End {$Items} | Should -Be 4

            $TestItemName = Get-Item $ConfigFileJson.Backups[0].Path | Select-Object -ExpandProperty Name | Split-Path -LeafBase
            Get-ChildItem $ConfigFileJson.Backups[0].Destination | Where-Object -Property Name -Match "$TestItemName[(][\d]+[)]\.txt" | Should -BeOfType System.IO.FileInfo

            $TestItemName = Get-Item $ConfigFileJson.Backups[1].Path | Select-Object -ExpandProperty Name
            Get-ChildItem $ConfigFileJson.Backups[1].Destination | Where-Object -Property Name -Match "$TestItemName[(1)]" | Should -BeOfType System.IO.DirectoryInfo 

            $TestItemName = Get-Item $ConfigFileJson.Backups[2].Path | Select-Object -ExpandProperty Name 
            Get-ChildItem $ConfigFileJson.Backups[2].Destination | Where-Object -Property Name -EQ $TestItemName | Should -BeOfType System.IO.FileInfo
            $PreTicks = Join-Path -Path $ConfigFileJson.Backups[2].Destination -ChildPath $TestItemName | `
                Get-Item | `
                Get-ItemPropertyValue -Name LastWriteTime | `
                Select-Object -ExpandProperty Ticks

            $TestItemName = Get-Item $ConfigFileJson.Backups[3].Path | Select-Object -ExpandProperty Name
            Get-ChildItem $ConfigFileJson.Backups[3].Destination | Where-Object -Property Name -Match $TestItemName | Should -BeOfType System.IO.DirectoryInfo 


            # modify file and folder contents to update the LastWriteTime property
            Get-ChildItem $ConfigFileJson.Backups[1].Path -Recurse | ForEach-Object {Add-Content -Path $_.FullName -Value (New-Guid | Select-Object -ExpandProperty Guid)} 
            Add-Content -Path $ConfigFileJson.Backups[2].Path -Value (New-Guid | Select-Object -ExpandProperty Guid)

            # call Backup-Sources to have files deployed to destination folder
            Backup-Sources


            Get-ChildItem -Path $ConfigFileJson.Backups[0].Destination | ForEach-Object -Begin {$Items = 0} -Process {$Items++} -End {$Items} | Should -Be 6

            $TestItemName = Get-Item $ConfigFileJson.Backups[0].Path | Select-Object -ExpandProperty Name | Split-Path -LeafBase
            Get-ChildItem $ConfigFileJson.Backups[0].Destination | Where-Object -Property Name -Match "$TestItemName[(][\d]+[)]\.txt" | Should -BeOfType System.IO.FileInfo
          
            $TestItemName = Get-Item $ConfigFileJson.Backups[1].Path | Select-Object -ExpandProperty Name
            Get-ChildItem $ConfigFileJson.Backups[1].Destination | Where-Object -Property Name -Match "$TestItemName[(1)]" | Should -BeOfType System.IO.DirectoryInfo 
            Get-ChildItem $ConfigFileJson.Backups[1].Destination | Where-Object -Property Name -Match "$TestItemName[(2)]" | Should -BeOfType System.IO.DirectoryInfo 

            $TestItemName = Get-Item $ConfigFileJson.Backups[2].Path | Select-Object -ExpandProperty Name 
            Get-ChildItem $ConfigFileJson.Backups[2].Destination | Where-Object -Property Name -EQ $TestItemName | Should -BeOfType System.IO.FileInfo
            $PostTicks = Join-Path -Path $ConfigFileJson.Backups[2].Destination -ChildPath $TestItemName | `
                Get-Item | `
                Get-ItemPropertyValue -Name LastWriteTime | `
                Select-Object -ExpandProperty Ticks
            $PostTicks | Should -BeGreaterThan $PreTicks

            $TestItemName = Get-Item $ConfigFileJson.Backups[3].Path | Select-Object -ExpandProperty Name
            Get-ChildItem $ConfigFileJson.Backups[3].Destination | Where-Object -Property Name -Match $TestItemName | Should -BeOfType System.IO.DirectoryInfo 
        }
    }
}