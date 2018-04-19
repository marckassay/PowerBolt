function Get-LatestError {
    $Error[0] | Format-List -Property * -Force
}