Describe "Test New-MKPowerShellConfigFile" {
    $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

    BeforeEach {
        Push-Location
        Set-Location -Path $SUT_MODULE_HOME

        Import-Module -Name '.\MK.PowerShell.4PS.psd1' -Verbose -Force -Global
    }
    AfterEach {
        Pop-Location
    }

    Context "Call New-MKPowerShellConfigFile when no file exists" {
        BeforeEach {
            $FullName = Join-Path -Path $TestDrive -ChildPath '\MK.PowerShell\' -AdditionalChildPath 'MK.PowerShell-config.ps1'
        }
        AfterEach {

        }

        It "Should copy a new file to the destination folder ('MK.PowerShell')" {
            New-MKPowerShellConfigFile -Path $TestDrive -Verbose

            Get-Item $FullName | Should -Exist 
        }
    }

    InModuleScope MK.PowerShell.4PS {
        Context "Call New-MKPowerShellConfigFile when file exists" {
            BeforeEach {
                $FullName = Join-Path -Path $TestDrive -ChildPath '\MK.PowerShell\' -AdditionalChildPath 'MK.PowerShell-config.ps1'
                Get-Module MK.PowerShell.4PS | `
                    Select-Object -ExpandProperty FileList | `
                    ForEach-Object {if ($_ -like '*MK.PowerShell-config.ps1') {$_}} -OutVariable ModuleConfigFile
            
                New-Item -Path "$TestDrive\MK.PowerShell" -ItemType Directory -OutVariable ModuleConfigFolder

                Copy-Item -Path $ModuleConfigFile -Destination $ModuleConfigFolder.FullName -Verbose 
            }
            AfterEach {
                Remove-Item -Path "$TestDrive\MK.PowerShell" -Recurse
            }
        
            It "Should prompt user about exisiting file" {
                Mock WriteWarningWrapper { $true }

                Get-Item $FullName | Should -Exist 

                New-MKPowerShellConfigFile -Path $TestDrive -Verbose

                Assert-MockCalled WriteWarningWrapper 1

                Get-Item $FullName | Should -Exist 
            }
        
            It "Should not prompt user about exisiting file" {
                Mock WriteWarningWrapper { $true }

                Get-Item $FullName | Should -Exist 

                New-MKPowerShellConfigFile -Path $TestDrive -Force -Verbose

                Assert-MockCalled WriteWarningWrapper 1

                Get-Item $FullName | Should -Exist 
            }
        }
    }
}