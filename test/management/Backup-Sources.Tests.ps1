using module ..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Backup-Sources" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup()

        $CloudFolderPath = New-Item -Path "TestDrive:\User\Bob\CloudDrive\PowerShell" -ItemType Directory | `
            Select-Object -ExpandProperty FullName
        
        New-Item -Path "TestDrive:\User\Bob\Passwords.csv" -Force -ItemType File -OutVariable TestFileA | `
            Add-Content -Value $(Get-Date)

        $TestFolderB = New-Item -Path "TestDrive:\User\Bob\Accounts" -Force -ItemType Directory

        New-Item -Path "TestDrive:\User\Bob\Accounts\audit.txt" -Force -ItemType File -OutVariable TestFileB | `
            Add-Content -Value $(Get-Date)
    }

    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'TestFunctions'))
    }
    
    Context "When valid Backups' Path, Destination and UpdatePolicy values." {

        $InputObject = @"
{
  "LastLocation": "",
  "TurnOnAvailableUpdates": "false",
  "HistoryLocation": "",
  "Backups": [{
    "Path": "$TestFileA",
    "Destination": "$CloudFolderPath",
    "UpdatePolicy": "Overwrite"
  }],
  "TurnOnQuickRestart": "false",
  "TurnOnBackup": "true",
  "BackupPolicy": "auto",
  "TurnOnRememberLastLocation": "false",
  "TurnOnHistoryRecording": "false",
  "NuGetApiKey": ""
}
"@
        Clear-Content -Path  $__.ConfigFilePath
        $InputObject -replace '\\', '\\' | Add-Content -Path $__.ConfigFilePath -Encoding utf8

        Start-MKPowerShell -ConfigFilePath $__.ConfigFilePath

        It "Should overwrite file in destination folder" {
            $ConfigFileJson = Get-Content -Path $__.ConfigFilePath -Raw | ConvertFrom-Json -AsHashtable
            
            $ConfigFileSourceHash = Get-FileHash ($ConfigFileJson.Backups[0]['Path']) | Select-Object -ExpandProperty Hash
            $CloudConfigFileHash = Get-ChildItem $CloudFolderPath | Get-FileHash | Select-Object -ExpandProperty Hash
            $CloudConfigFileHash | Should -Be $ConfigFileSourceHash
        }
    }
}