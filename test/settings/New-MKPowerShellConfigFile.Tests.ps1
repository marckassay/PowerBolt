Describe "Test New-MKPowerShellConfigFile" {
    $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

    BeforeEach {
        Push-Location

        Set-Location -Path $SUT_MODULE_HOME

        Import-Module -Name '.\MK.PowerShell.4PS.psd1' -Verbose -Force
    }
    AfterEach {
        Remove-Module MK.PowerShell.4PS -Force

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

    Context "Call New-MKPowerShellConfigFile when file exists" {
        It "Should prompt user about exisiting file" {
            InModuleScope MK.PowerShell.4PS {
                ### HACK: Before and After block is inside here since Pester seems to not like 
                # nested Before and After
                ### Before
                $FullName = Join-Path -Path $TestDrive -ChildPath '\MK.PowerShell\' -AdditionalChildPath 'MK.PowerShell-config.ps1'
                Get-Module MK.PowerShell.4PS | `
                    Select-Object -ExpandProperty FileList | `
                    ForEach-Object {if ($_ -like '*MK.PowerShell-config.ps1') {$_}} -OutVariable ModuleConfigFile
                New-Item -Path "$TestDrive\MK.PowerShell" -ItemType Directory -OutVariable ModuleConfigFolder
                Copy-Item -Path $ModuleConfigFile -Destination $ModuleConfigFolder.FullName -Verbose 

                ### TEST
                Mock WriteWarningWrapper { $true }
                
                Get-Item $FullName | Should -Exist 
                
                New-MKPowerShellConfigFile -Path $TestDrive -Verbose
                
                Assert-MockCalled WriteWarningWrapper 1
                
                Get-Item $FullName | Should -Exist

                ### After
                Remove-Item -Path "$TestDrive\MK.PowerShell" -Recurse
            }
        }

        It "Should not prompt user about exisiting file" {
            InModuleScope MK.PowerShell.4PS {
                ### HACK: Before and After block is inside here since Pester seems to not like 
                # nested Before and After

                ### Before
                $FullName = Join-Path -Path $TestDrive -ChildPath '\MK.PowerShell\' -AdditionalChildPath 'MK.PowerShell-config.ps1'
                Get-Module MK.PowerShell.4PS | `
                    Select-Object -ExpandProperty FileList | `
                    ForEach-Object {if ($_ -like '*MK.PowerShell-config.ps1') {$_}} -OutVariable ModuleConfigFile
                New-Item -Path "$TestDrive\MK.PowerShell" -ItemType Directory -OutVariable ModuleConfigFolder
                Copy-Item -Path $ModuleConfigFile -Destination $ModuleConfigFolder.FullName -Verbose 

                ### TEST
                Mock WriteWarningWrapper { $true }

                Get-Item $FullName | Should -Exist 

                New-MKPowerShellConfigFile -Path $TestDrive -Force -Verbose
                # NOTE: although this mock wasnt called '1' time in this 'It', this is from the 
                # previous 'It' block
                Assert-MockCalled WriteWarningWrapper 1

                Get-Item $FullName | Should -Exist
                
                ### After
                Remove-Item -Path "$TestDrive\MK.PowerShell" -Recurse
            } 
        }
    }
}