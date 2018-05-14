function Deploy-TestModifications {
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ConfigFilePath,

        [Parameter(Mandatory = $true)]
        [ValidateSet("ValidFile", "ValidFolder", "InvalidFile", "InvalidFolder")]
        [string]
        $BackupPathType,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Overwrite", "New")]
        [string]
        $UpdatePolicy,

        [Parameter(Mandatory = $false)]
        [int]
        $NumberOfBackups = 1
    )
    
    if ((Test-Path -Path "TestDrive:\User\Bob\CloudDrive\PowerShell") -eq $true) {
        Remove-Item -Path "TestDrive:\User\Bob\CloudDrive\PowerShell" -Recurse
    }

    $CloudFolderPath = New-Item -Path "TestDrive:\User\Bob\CloudDrive\PowerShell" -ItemType Directory | `
        Select-Object -ExpandProperty FullName
        
    New-Item -Path "TestDrive:\User\Bob\TestFileA.csv" -Force -ItemType File -OutVariable TestFileA | `
        Add-Content -Value $(Get-Date)

    $TestFolderB = New-Item -Path "TestDrive:\User\Bob\TestFolderB" -Force -ItemType Directory

    New-Item -Path "TestDrive:\User\Bob\TestFolderB\TestFileB.txt" -Force -ItemType File -OutVariable TestFileB | `
        Add-Content -Value $(Get-Date)

    Clear-Content -Path $ConfigFilePath

    switch ($BackupPathType) {
        "ValidFile" { $BackupPathValue = $TestFileA }
        "ValidFolder" { $BackupPathValue = $TestFolderB }
        Default {}
    }

    $TestConfig = @"
{
  "LastLocation": "",
  "TurnOnAvailableUpdates": "false",
  "HistoryLocation": "",
  "Backups": [{
    "Path": "$BackupPathValue",
    "Destination": "$CloudFolderPath",
    "UpdatePolicy": "$UpdatePolicy"
  }],
  "TurnOnQuickRestart": "false",
  "TurnOnBackup": "true",
  "BackupPolicy": "auto",
  "TurnOnRememberLastLocation": "false",
  "TurnOnHistoryRecording": "false",
  "NuGetApiKey": ""
}
"@
    $TestConfig -replace '\\', '\\' | Add-Content -Path $ConfigFilePath -Encoding utf8

    return @{
        CloudFolderPath   = $CloudFolderPath
        TestConfigContent = $TestConfig
        TestFileA         = $TestFileA
        TestFileB         = $TestFileB
        TestFolderB       = $TestFolderB
    }
}