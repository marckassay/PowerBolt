Describe 'Test <%=$PLASTER_PARAM_ScriptName%>' {
    BeforeAll {
        $ModuleHome = <%=$PLASTER_ModuleHomeDeclarationCode%>

        # Reimports '<%=$PLASTER_ModuleName%>'.  If its not currently import just silently continue
        Remove-Module -Name '<%=$PLASTER_ModuleName%>' -ErrorAction SilentlyContinue
        Import-Module $ModuleHome

        InModuleScope '<%=$PLASTER_ModuleName%>' {
            $script:SUT = $true
        }
    }
    
    AfterAll {
        InModuleScope '<%=$PLASTER_ModuleName%>' {
            $script:SUT = $false
        }
    }

    Context 'Post executing New-Script' {
        It 'Should have command accessible' {
            $Results = Get-Command <%=$PLASTER_PARAM_ScriptName%> | Select-Object -ExpandProperty CommandType
            $Results | Should -Be 'Function'
        }
    }
}
