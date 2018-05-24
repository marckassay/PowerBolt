function Get-LatestError {
    [CmdletBinding(PositionalBinding = $False)]
    Param()

    $E = $global:Error[0]
    if ($E) {
        $ExceptionMessage = ''
        if ($E.InvocationInfo.MyCommand) {
            $ExceptionMessage = "$($E.InvocationInfo.MyCommand)`n"
        }

        if ($E.Exception.Message.Contains(':')) {
            $ExceptionMessageContent = $E.Exception.Message.Split(':')
            $ExceptionMessage += "$($ExceptionMessageContent[0]):`n$($ExceptionMessageContent[1])"
        }
        else {
            $ExceptionMessage += $E.Exception.Message
        }

        $Result = @"
  $ExceptionMessage

Position: Ln $($E.InvocationInfo.ScriptLineNumber), Col $($E.InvocationInfo.OffsetInLine)
  $($E.InvocationInfo.Line)

ScriptStackTrace: 
  $($E.ScriptStackTrace)
"@

        Write-Host -Object $Result -ForegroundColor Red
    }
}