using module ..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Backup-SelectedData" {
    BeforeAll {
        
        $CloudConfigFolderPath = New-Item -Path "TestDrive:\User\Bob\CloudDrive\PowerShell" -ItemType Directory | `
            Select-Object -ExpandProperty FullName
        
        # Start to modifying $ConfigFilePath...
        New-Item -Path "TestDrive:\User\Bob\AppData\Local\MK.PowerShell.4PS" -ItemType Directory
        $ConfigFilePath = Copy-Item -Path ([TestFunctions]::MODULE_FOLDER + "\resources\MK.PowerShell-config.json") -Destination "TestDrive:\User\Bob\AppData\Local\MK.PowerShell.4PS" -PassThru | Select-Object -ExpandProperty FullName

        $MKPowerShellConfig = Get-Content -Path $ConfigFilePath | `
            ConvertFrom-Json -AsHashtable

        $NewEntry = @{
            Path        = $ConfigFilePath
            Destination = $CloudConfigFolderPath
        }

        $MKPowerShellConfig['TurnOnBackup'] = $true
        $MKPowerShellConfig['BackupLocations'] = $NewEntry
        
        $MKPowerShellConfig | `
            ConvertTo-Json | `
            Set-Content -Path $ConfigFilePath
        # Finished to modify $ConfigFilePath...

        $__ = [TestFunctions]::DescribeSetupUsingTestConfigFile($ConfigFilePath)
    }

    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestFunctions'))
    }
    
    Context "When 'TurnOnBackup' set to 'true' and 'BackupPolicy' set to 'Auto' with valid values for 'BackupLocations'." {

        It "Should call Backup-SelectedData on PowerShell startup" {
            $ConfigFileSourceHash = Get-FileHash $ConfigFilePath | Select-Object -ExpandProperty Hash
            $CloudConfigFileHash = Get-ChildItem $CloudConfigFolderPath | Get-FileHash | Select-Object -ExpandProperty Hash
            $CloudConfigFileHash | Should -Be $ConfigFileSourceHash
        }
    }
}