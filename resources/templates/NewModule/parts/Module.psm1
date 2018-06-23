Param(
    [Parameter(Mandatory = $False)]
    [bool]$SUT = $False
)

$script:SUT = $SUT
if ($script:SUT -eq $False) {
    # Start-Mddule
}
