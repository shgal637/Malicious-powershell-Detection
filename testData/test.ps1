if(-not (Test-Path $Profile.AllUsersAllHosts)) {
    New-Item -Type File $Profile.AllUsersAllHosts
}
Set-ExecutionPolicy Unrestricted
$pstext = 'Write-Host "Invoke-Expression has been hooked. pid=$pid"
$logdir="C:\Users\ASUS\Documents\log\"
$logfile="C:\Users\ASUS\Documents\log\logfile.$pid.txt"
New-Item -Type File -force $logfile | Out-null
"Time: $(Get-Date -format ''yyyy-MM-dd HH:mm:ss'')" | Out-File $logfile -Append 
"Current Process: $((Get-Process -pid $pid).Path)" | Out-File $logfile -Append
"Current Process ID: $pid" | Out-File $logfile -Append 
function Invoke-Expression{$arg=($args -join '' '');"========`n$arg" | Out-File -Append $logfile;Microsoft.PowerShell.Utility\Invoke-Expression $arg;}'
$pstext | Out-File $Profile.AllUsersAllHosts -Append
