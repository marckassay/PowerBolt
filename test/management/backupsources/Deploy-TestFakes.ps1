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

    # create test files A-H; eg. 'TestFolder_A'
    65..72 | `
        ForEach-Object { Write-Output ("TestDrive:\User\Bob\TestFolder_$([System.Text.Encoding]::UTF8.GetChars($_))") } -OutVariable TestFolderNames | `
        ForEach-Object {New-Item $_ -ItemType Directory -Force} | Out-Null
        
    [System.Collections.ArrayList]$TFolderNames = [System.Collections.ArrayList]::new()
    $TFolderNames.Add("TestDrive:\User\Bob")
    $TestFolderNames | ForEach-Object {
        $TFolderNames.Add($_)
    }

    # create test files a-z inside ; eg. 'TestFile_a.txt'
    97..122 | `
        ForEach-Object { Write-Output ("TestFile_$([System.Text.Encoding]::UTF8.GetChars($_)).txt") } | `
        ForEach-Object {
        New-Item -Path (Join-Path -Path (Get-Random -InputObject $TestFolderNames) -ChildPath $_) -Value (New-Guid) -ItemType File -Force 
    } -OutVariable TestFileNames | `
        ForEach-Object { 
        $_.LastWriteTime = (Get-Date -Year (Get-Random -Minimum 2001 -Maximum (Get-Date).Year) -Month (Get-Random -Minimum 1 -Maximum 12) -Day (Get-Random -Minimum 1 -Maximum 28)) 
    }

    [System.Collections.ArrayList]$TFileNames = [System.Collections.ArrayList]::new()
    $TestFileNames | ForEach-Object {
        # match the guid in absolute path, and take everything right of it.
        if ($_ -match "(?<=[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}).*$") {
            $TFileNames.Add((Join-Path -Path 'TestDrive:' -ChildPath $Matches[0]))
        }
    }

    $Backups = New-Object System.Collections.ArrayList

    # TODO: this algorhythm can be cleaned, just be mindful that I had issues calling Remove() directly
    # hence the IndexOf and RemoveAt calls.
    for ($i = 0; $i -lt $UpdatePolicy.Count; $i++) {

        switch ($PathType[$i]) {
            "ValidFile" {
                $Path = Get-Random -InputObject $TFileNames -OutVariable SelectedFile
                $DeletedIndex1 = $TFileNames.IndexOf($Path)
                $TFileNames.RemoveAt($DeletedIndex1)

                if ($TFolderNames -contains (Split-Path -Path $SelectedFile -Parent -OutVariable SelectedParentFolder)) {
                    $DeletedIndex2 = $TFolderNames.IndexOf($SelectedParentFolder[0])
                    $TFolderNames.RemoveAt($DeletedIndex2)
                }

                $Path = Get-Item $Path | Select-Object -ExpandProperty FullName
            }
            "ValidFolder" {
                $Path = $TFolderNames | `
                    Get-Item | `
                    Where-Object {$_.GetFiles() -ne $null} | `
                    Get-Random -OutVariable SelectedFolder

                if ($Path -match "(?<=[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}).*$") {
                    $DeletedIndex3 = $TFolderNames.IndexOf($(Join-Path -Path 'TestDrive:' -ChildPath $Matches[0]))
                    $TFolderNames.RemoveAt($DeletedIndex3)
                }

                Get-ChildItem -Path $Path -Recurse | ForEach-Object {
                    if (($_.FullName -match "(?<=[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}).+") ) {
                        $DeletedIndex4 = $TFileNames.IndexOf($(Join-Path -Path 'TestDrive:' -ChildPath $Matches[0]))
                        $TFileNames.RemoveAt($DeletedIndex4)
                    }
                }
            }
            "InvalidFile" {$Path = "TestDrive:\User\Bob\TestFile_xxx.txt"}
            "InvalidFolder" {$Path = "TestDrive:\User\Bob\TestFolder_XXX" }
        }
        
        switch ($DestinationType[$i]) {
            "ValidFolder" { $Destination = $CloudFolderPath }
            "InvalidFolder" {$Destination = "TestDrive:\User\Bob\CloudDrive\PowerSSShell" }
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