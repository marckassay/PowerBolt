using module ..\.\TestRunnerSupportModule.psm1

Describe "Test GetPlasterTemplateVarSet" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleB')

        $AlicesTemplates = New-Item -Path (Join-Path $TestSupportModule.TestDrivePath "AlicesTemplates") -ItemType Directory
    
        Copy-Item -Path (Join-Path -Path $TestSupportModule.FixtureDirectoryPath -ChildPath 'resources\templates\NewScript') -Destination $AlicesTemplates -Recurse

        Set-Variable -Name MockNewScriptTemplatePath -Value $(Join-Path -Path $AlicesTemplates -ChildPath 'NewScript\plasterManifest_en-US.xml') -Scope Global
    }
    
    AfterAll {
        Remove-Variable -Name MockNewScriptTemplatePath -Scope Global
        $TestSupportModule.Teardown()
    }
    
    Context "Call with path to a plaster template file" {
        It "`$Result should have entries matching variable names" {
            InModuleScope PowerBolt {
                $Results = GetPlasterTemplateVarSet -Path $MockNewScriptTemplatePath
                $Results.Keys -Contains "ScriptCongruentPath" | Should -Be $true
                $Results.Keys -Contains "ScriptName" | Should -Be $true
            }
        }
    }
}