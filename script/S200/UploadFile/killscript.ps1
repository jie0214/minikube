$awsprocess = (Get-Process -Name aws | Measure-Object).Count

$interface = 'intel[r] ethernet 10g 4p x550 rndc _3'
$Mbps = ((Get-Counter -Counter "\Network Interface($interface)\Bytes Sent/sec" -SampleInterval 1 -MaxSamples 1 ).CounterSamples|%{$_.CookedValue}|sort|select -last 1)*8/1000/1000

if ($awsprocess -ge 1 -and ($Mbps -lt 1 -or $Mbps -gt 25) )
{
    Stop-Process -Name aws
    .\upLoadToS3.ps1
}