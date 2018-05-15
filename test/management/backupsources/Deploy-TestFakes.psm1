function Deploy-TestFakes {
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ConfigFilePath,

        [Parameter(Mandatory = $true)]
        [ValidateSet("ValidFile", "ValidFolder", "InvalidFile", "InvalidFolder")]
        [string[]]
        $PathType,

        [Parameter(Mandatory = $true)]
        [ValidateSet("ValidFolder", "InvalidFolder")]
        [string[]]
        $DestinationType,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Overwrite", "New")]
        [string[]]
        $UpdatePolicy
    )
    
    if ((Test-Path -Path "TestDrive:\User\Bob\CloudDrive\PowerShell") -eq $true) {
        Get-ChildItems -Path "TestDrive:\User\Bob\CloudDrive\PowerShell" | `
            Remove-Item -Recurse -Force
        
        $CloudFolderPath = Get-Item -Path "TestDrive:\User\Bob\CloudDrive\PowerShell" | `
            Select-Object -ExpandProperty FullName
    }
    else {
        $CloudFolderPath = New-Item -Path "TestDrive:\User\Bob\CloudDrive\PowerShell" -ItemType Directory | `
            Select-Object -ExpandProperty FullName
    }

    # create test files A-G; eg. 'TestFolder_A'
    65..72 | `
        ForEach-Object { Write-Output ("TestDrive:\User\Bob\TestFolder_$([System.Text.Encoding]::UTF8.GetChars($_))") } -OutVariable TestFolderNames | `
        ForEach-Object {New-Item $_ -ItemType Directory -Force} | Out-Null
    $TestFolderNames.Add("TestDrive:\User\Bob")

    # create test files a-z inside ; eg. 'TestFile_a.txt'
    97..122 | `
        ForEach-Object { Write-Output ("TestFile_$([System.Text.Encoding]::UTF8.GetChars($_)).txt") } | `
        ForEach-Object {
        New-Item -Path (Join-Path -Path (Get-Random -InputObject $TestFolderNames) -ChildPath $_) -Value (New-Guid) -ItemType File -Force 
    } -OutVariable TestFileNames | `
        ForEach-Object { 
        $_.LastWriteTime = (Get-Date -Year (Get-Random -Minimum 2001 -Maximum (Get-Date).Year) -Month (Get-Random -Minimum 1 -Maximum 12) -Day (Get-Random -Minimum 1 -Maximum 28)) 
    }

    $Backups = New-Object System.Collections.ArrayList

    for ($i = 0; $i -lt $UpdatePolicy.Count; $i++) {

        switch ($PathType[$i]) {
            "ValidFile" {
                $Path = Get-Random -InputObject $TestFileNames -OutVariable SelectedFile
                $TestFileNames.Remove($SelectedFile)
            }
            "ValidFolder" {
                $Path = Get-Random -InputObject $TestFolderNames -OutVariable SelectedFolder
                $TestFolderNames.Remove($SelectedFolder)
            }
            "InvalidFile" {$Path = "TestDrive:\User\Bob\TestFile_xxx.txt"}
            "InvalidFolder" {$Path = "TestDrive:\User\Bob\TestFolder_XXX" }
        }
        
        switch ($DestinationType[$i]) {
            "ValidFolder" { $Destination = $CloudFolderPath }
            "InvalidFolder" {$Destination = "TestDrive:\User\Bob\CloudDrive\PowerSheXXXll" }
        }

        $Backups.Add(@{Path = "$Path"; Destination = "$Destination"; UpdatePolicy = "$($UpdatePolicy[$i])"})
    }

    $BackupJsonString = $Backups | ConvertTo-Json

    $TestConfig = @"
{0}
  "LastLocation": "",
  "TurnOnAvailableUpdates": "false",
  "HistoryLocation": "",
  "Backups": {1},
  "TurnOnQuickRestart": "false",
  "TurnOnBackup": "true",
  "BackupPolicy": "auto",
  "TurnOnRememberLastLocation": "false",
  "TurnOnHistoryRecording": "false",
  "NuGetApiKey": ""
{2}
"@
    Clear-Content -Path $ConfigFilePath

    $TestConfig -f "{", $BackupJsonString, "}" | `
        Add-Content -Path $ConfigFilePath -Encoding utf8
}