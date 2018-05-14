using module ..\..\.\TestFunctions.psm1
using module .\Deploy-TestModifications.psm1

[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Backup-Sources" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup()
    }

    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'TestFunctions', 'Deploy-TestModifications'))
    }
    
    Context "With Backups' Path given a file path" {
        It "Should, first, create new file in destination folder and then depending on UpdatePolicy overwrite it by a sequent call."  -TestCases @(
            @{ BackupPathType = "ValidFile"; UpdatePolicy = "Overwrite" }
            @{ BackupPathType = "ValidFile"; UpdatePolicy = "New" }
        ) {
            Param($BackupPathType, $UpdatePolicy)

            $TestDeploy = Deploy-TestModifications -ConfigFilePath $__.ConfigFilePath -BackupPathType $BackupPathType -UpdatePolicy $UpdatePolicy

            $ConfigFileJson = Get-Content -Path $__.ConfigFilePath -Raw | ConvertFrom-Json -AsHashtable

            Start-MKPowerShell -ConfigFilePath $__.ConfigFilePath
            
            $ConfigFileSourceHash = Get-FileHash ($ConfigFileJson.Backups[0]['Path']) | Select-Object -ExpandProperty Hash
            $CloudConfigFileHash = Get-ChildItem $TestDeploy.CloudFolderPath | Get-FileHash | Select-Object -ExpandProperty Hash
            $CloudConfigFileHash | Should -Be $ConfigFileSourceHash
        
            Start-MKPowerShell -ConfigFilePath $__.ConfigFilePath

            $ConfigFileJson.Backups[0]['Destination'] | Should -Exist

            if ($UpdatePolicy -eq "Overwrite") {
                $ExpectedNumberOfItems = 1
            }
            else {
                $ExpectedNumberOfItems = 2
            }
            
            $(Get-ChildItem $TestDeploy.CloudFolderPath -Recurse).Count | Should -BeExactly $ExpectedNumberOfItems
        }
    }
    
    Context "With Backups' Path given a folder path" {
        It "Should, first, create new folder in destination folder and then depending on UpdatePolicy overwrite it by a sequent call."  -TestCases @(
            @{ BackupPathType = "ValidFolder"; UpdatePolicy = "Overwrite" }
            @{ BackupPathType = "ValidFolder"; UpdatePolicy = "New" }
        ) {
            Param($BackupPathType, $UpdatePolicy)

            $TestDeploy = Deploy-TestModifications -ConfigFilePath $__.ConfigFilePath -BackupPathType $BackupPathType -UpdatePolicy $UpdatePolicy

            $ConfigFileJson = Get-Content -Path $__.ConfigFilePath -Raw | ConvertFrom-Json -AsHashtable

            Start-MKPowerShell -ConfigFilePath $__.ConfigFilePath
            
            $ConfigFileJson.Backups[0]['Destination'] | Should -Exist

            Start-MKPowerShell -ConfigFilePath $__.ConfigFilePath

            $ConfigFileJson.Backups[0]['Destination'] | Should -Exist

            if ($UpdatePolicy -eq "Overwrite") {
                $ExpectedNumberOfItems = 2
            }
            else {
                $ExpectedNumberOfItems = 6
            }
            
            $(Get-ChildItem $TestDeploy.CloudFolderPath -Recurse).Count | Should -BeExactly $ExpectedNumberOfItems
        }
    }
}