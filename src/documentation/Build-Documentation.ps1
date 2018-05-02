function Get-FileObject {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [switch]$WhatIf
    )

    $Data = [PsCustomObject]@{
        FileItem               = $null
        FileContent            = ''
        FileEOL                = ''
        FileEncoding           = $null
        EncodingNotCompatiable = $false
        SameEOLAsRequested     = $false
        EmptyFile              = $false
        EndsWithEmptyNewLine   = $false
        Modified               = $false
        WhatIf                 = $WhatIf.IsPresent
    }
    
    Write-Verbose ("Opening: " + $FilePath)
    $Data.FileItem = Get-Item -Path $FilePath

    # unicode: U+000D | byte (decimal): 13 | html: \r\n | powershell: `r`n
    [byte]$CR = 0x0D
    # unicode: U+000A | byte (decimal): 10 | html: \n | powershell: `n
    [byte]$LF = 0x0A
    # TODO: would be nice to pipe StreamReader into Test-Encoding...
    $Data.EncodingNotCompatiable = !(Test-Encoding -Path $Data.FileItem.FullName 'utf8')

    if ($Data.EncodingNotCompatiable -eq $false) {

        $StreamReader = New-Object -TypeName System.IO.StreamReader -ArgumentList $Data.FileItem.FullName
            
        $Data.FileEncoding = $StreamReader.CurrentEncoding
            
        if ($Data.FileEncoding -is [System.Text.UTF8Encoding]) {
            
            $Data.FileContent = $StreamReader.ReadToEnd()
            
            $FileAsBytes = [System.Text.Encoding]::UTF8.GetBytes($Data.FileContent)
            $FileAsBytesLength = $FileAsBytes.Length
        }

        $IndexOfLF = $FileAsBytes.IndexOf($LF)
        if (($IndexOfLF -ne -1) -and ($FileAsBytes[$IndexOfLF - 1] -ne $CR)) {
            $Data.FileEOL = 'LF'
            if ($FileAsBytesLength) {
                $Data.EndsWithEmptyNewLine = ($FileAsBytes.Get($FileAsBytesLength - 1) -eq $LF) -and `
                ($FileAsBytes.Get($FileAsBytesLength - 2) -eq $LF)
            }
        }
        elseif (($IndexOfLF -ne -1) -and ($FileAsBytes[$IndexOfLF - 1] -eq $CR)) {
            $Data.FileEOL = 'CRLF'
            if ($FileAsBytesLength) {
                $Data.EndsWithEmptyNewLine = ($FileAsBytes.Get($FileAsBytesLength - 1) -eq $LF) -and `
                ($FileAsBytes.Get($FileAsBytesLength - 3) -eq $LF)
            }
        }
        else {
            $Data.FileEOL = 'unknown'
        }
            
        $StreamReader.Close()
    }

    $Data
}

function Write-File {
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]$Data
    )

    if (($Data.EmptyFile -eq $false) -and `
        ($Data.EncodingNotCompatiable -eq $false)) {
 
        if ($Data.WhatIf -eq $false) {
            New-Object -TypeName System.IO.StreamWriter -ArgumentList $Data.FileItem.FullName -OutVariable StreamWriter | Out-null

            try {
                $StreamWriter.Write($Data.FileContent)
                $StreamWriter.Flush()
                $StreamWriter.Close()
            }
            catch {
                Write-Error ("EndOfLine threw an exception when writing to: " + $Data.FileItem.FullName)
            }
        }
        $Data.Modified = $true
    }
    # free-up memory; no longer need FileContent data
    $Data.FileContent = '[removed]'
    
    $Data
}