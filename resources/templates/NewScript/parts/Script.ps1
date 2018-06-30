# using module .\.\Get-ScriptFile.ps1

function <%=$PLASTER_PARAM_ScriptName%>
{
    [CmdletBinding(DefaultParameterSetName = "ParameterSetName",
        # ConfirmImpact = <String>,
        # HelpURI = <URI>,
        # SupportsPaging = $false,
        # SupportsShouldProcess = $false,
        PositionalBinding = $true)]
    [OutputType([string], ParameterSetName = "ParameterSetName")]
    Param(
        # Specifies a path to one or more locations. Wildcards are permitted.
        [Parameter(Mandatory = $true,
            ParameterSetName = "ParameterSetName",
            # ValueFromPipeline = $true,
            # ValueFromPipelineByPropertyName = $true,
            #HelpMessage = "Path to one or more locations.",
            Position = 0)]
        # [AllowNull()]
        # [AllowEmptyString()]
        # [AllowEmptyCollection()]
        # [ValidateCount(1, 5)]
        # [ValidateLength(1, 10)]
        # [ValidatePattern("[0-9][0-9][0-9][0-9]")]
        # [ValidateRange(0, 10)]
        # [ValidateScript( {$_ -ge (Get-Date)})]
        # [ValidateSet("Low", "Average", "High")]
        [ValidateNotNull()]
        # [ValidateNotNullOrEmpty()]
        # [ValidateDrive("C", "D", "Variable", "Function")]
        # [ValidateUserDrive()]
        [string[]]
        $Path

        # [Switch]
        # $Confirm
    )
    <#
    DynamicParam {
        if ($path -match ".HKLM.:") {
            $attributes = New-Object -Type `
                System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = "__AllParameterSets"
            $attributes.Mandatory = $false
            $attributeCollection = New-Object `
                -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)

            $dynParam1 = New-Object -Type `
                System.Management.Automation.RuntimeDefinedParameter("dp1", [Int32],
                $attributeCollection)

            $paramDictionary = New-Object `
                -Type System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add("dp1", $dynParam1)
            return $paramDictionary
        }
    }
    #>
    begin {
    }
    
    process {
    }
    
    end {
        Write-Error "The following file has only been scaffold and not implemented: '$PSCommandPath'" -Category NotImplemented
    }
}