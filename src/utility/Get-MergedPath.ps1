<#
.SYNOPSIS
Returns a valid path from a parent of one of its children which overlaps that parent's path.

.DESCRIPTION
In set-theory this will be considered a relative complement. That is the directories
in ChildPath that are not in Path.

A diagram to illustrate what is mentioned above:
    A =        C:\Windows\diagnostics\system
    B =                 .\diagnostics\system\Keyboard\en-US\CL_LocalizationData.psd1
    B\A =                                  .\Keyboard\en-US\CL_LocalizationData.psd1
    R =        C:\Windows\diagnostics\system\Keyboard\en-US\CL_LocalizationData.psd1

The path 'R' is what will be returned if -IsValid is not switched otherwise $true 
will be returned.

.PARAMETER Path
Parent path of $ChildPath. This can be relative.

.PARAMETER ChildPath
Child path of $Path.

.PARAMETER IsValid
Returns true if function found a complement folder. False is returned if no complement was
found.

.EXAMPLE
Demonstration of using Get-MergedPath with truthly values

E:\Temp\AIT> Get-MergedPath E:\Temp\AIT\resources\ -ChildPath .\resources\android\AiT-Feature.jpg
E:\Temp\AIT\resources\android\AiT-Feature.jpg

E:\Temp\AIT> Get-MergedPath E:\Temp\AIT\resources\ -ChildPath .\resources\android\AiT-Feature.jpg -IsValid
True

.EXAMPLE
Demonstration of using Get-MergedPath with falsely values

E:\Temp\AIT> Get-MergedPath E:\Temp\AIT\resources\ -ChildPath .\reWWWources\android\AiT-Feature.jpg
E:\Temp\AIT> Get-MergedPath E:\Temp\AIT\resources\ -ChildPath .\reWWWources\android\AiT-Feature.jpg -IsValid
False

.LINK
https://gist.github.com/marckassay/2f54ae68779c9f27fd130b193374335c
#>
function Get-MergedPath {
    [CmdletBinding()]
    [OutputType([string])]
    [OutputType([bool])]
    Param
    (
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Path,

        [Parameter(Mandatory = $true,
            Position = 1,
            ValueFromPipeline = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ChildPath,

        [switch]$IsValid
    )

    $ParentBaseName = Get-Item $Path | Get-ItemPropertyValue -Name BaseName
    $ChildBaseName = Split-Path -Path $ChildPath

    if ($ChildBaseName.replace('\', '\\') -match $ParentBaseName ) {
        if ($IsValid.IsPresent) {
            $true
        }
        else {
            Join-Path $Path -ChildPath $($ChildPath.Split($ParentBaseName)[1])
        }
        
    }
    else {
        if ($IsValid.IsPresent) {
            $false
        }
    }
}