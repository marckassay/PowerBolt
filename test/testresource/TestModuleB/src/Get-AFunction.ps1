function Get-AFunction {
    [CmdletBinding()]
    param (
        
    )
    
    Out-String -InputObject $("Hello, from Get-AFunction!")
}