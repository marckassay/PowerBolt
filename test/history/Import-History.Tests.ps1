using module ..\.\TestFunctions.psm1
[TestFunctions]::MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Import-History" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup()

        Push-Location -StackName History
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestFunctions'))

        Pop-Location -StackName History
    }

    Context "Using default value for Path, PWSH history session should be imported as expected." {

        It "Should import previous session as expected." {

        } -Skip
    } 
} 