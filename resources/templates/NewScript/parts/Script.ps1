function <%=$PLASTER_PARAM_ScriptName%>
{
    Param(
        # Specifies a path to one or more locations.
        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = "ParameterSetName",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $false)]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Path
    )

    Write-Error "The following file has only been scaffold: '$PSCommandPath'" -Category NotImplemented
}