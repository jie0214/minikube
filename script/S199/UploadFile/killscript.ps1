$awsprocess = (Get-Process -Name aws | Measure-Object).Count

$interface = 'intel[r] ethernet 10g 4p x550 rndc _4'
$Mbps = ((Get-Counter -Counter "\Network Interface($interface)\Bytes Sent/sec" -SampleInterval 1 -MaxSamples 1 ).CounterSamples|%{$_.CookedValue}|sort|select -last 1)*8/1000/1000

if ($awsprocess -ge 1 -and ($Mbps -lt 2 -or $Mbps -gt 15) )
{
    Stop-Process -Name aws
    .\uploadToS3.ps1
}