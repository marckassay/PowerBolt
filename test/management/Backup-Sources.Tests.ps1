using module ..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Backup-Sources" {
    BeforeAll {
        $CloudConfigFolderPath = New-Item -Path "TestDrive:\User\Bob\CloudDrive\PowerShell" -ItemType Directory | `
            Select-Object -ExpandProperty FullName
        $TESTFILE = 'E:\temp\colors.csv\'
    }

    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'TestFunctions'))
    }
    
    Context "When 'TurnOnBackup' set to 'true' and 'BackupPolicy' set to 'Auto' with valid values for 'BackupLocations'." {

        $InputObject = @"
{
  "LastLocation": "",
  "TurnOnAvailableUpdates": "true",
  "HistoryLocation": "",
  "Backups": [{
    "Path": "$TESTFILE",
    "Destination": "$CloudConfigFolderPath",
    "UpdatePolicy": "Overwrite"
  }],
  "TurnOnQuickRestart": "true",
  "TurnOnBackup": "false",
  "BackupPolicy": "auto",
  "TurnOnRememberLastLocation": "true",
  "TurnOnHistoryRecording": "true",
  "NuGetApiKey": ""
}
"@
        New-Item -Path  "TestDrive:\User\Bob\AppData\Local\MK.PowerShell.4PS\MK.PowerShell-config.json" -Force -ItemType File
        Add-Content -Value $InputObject -Path "TestDrive:\User\Bob\AppData\Local\MK.PowerShell.4PS\MK.PowerShell-config.json" -Force

        $__ = [TestFunctions]::DescribeSetupUsingTestConfigFile($ConfigFilePath)

        It "Should call Backup-Sources on PowerShell startup" {
            $ConfigFileSourceHash = Get-FileHash $__.ConfigFilePath | Select-Object -ExpandProperty Hash
            $CloudConfigFileHash = Get-ChildItem $CloudConfigFolderPath | Get-FileHash | Select-Object -ExpandProperty Hash
            $CloudConfigFileHash | Should -Be $ConfigFileSourceHash
        }
    }
}