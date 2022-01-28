<#
$counters = "\Network interface(intel[r] ethernet 10g 4p x550 rndc _4)\Bytes sent/sec"
Get-Counter -Counter $counters -MaxSamples 10 -SampleInterval 1 -ov d| 
Select-object -ExpandProperty CounterSamples | Select-Object -Property Timestamp,
@{Name="Computername";Expression = {[regex]::Match($_.path, "(?<=\\\\)\w+").Value.toUpper() }},
@{Name = "Counter"; Expression = { ($_.path -split "\\")[-1]}},
@{Name = "Network"; Expression = {$_.instancename}},
@{Name = "Count"; Expression = {$_.cookedValue}}
#>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$username = 'H1-System_Uploaded File'
$channelname = 'h1-system-監控群'
$weburl = 'https://hooks.slack.com/services/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'
$Webhook = "$($weburl)"
$ContentType= 'application/json; charset=utf-8'
$template = @"
    {
        "channel": "$($channelname)",
        "username": "$($username)",
        "text": "UPLOAD",
        "icon_emoji":":aws_icon:"

    }
"@
foreach ($i in (Get-Content D:\UploadFile\DBList\upload.txt)){
$sw = [Diagnostics.Stopwatch]::StartNew()
$sw.Stop()
$time=($sw.Elapsed).TotalSeconds
$time="{0:N0}" -f $time
$sbody = $template.Replace("UPLOAD","$($i) Upload use $($time) Seconds")
Invoke-RestMethod -uri $Webhook -Method Post -body $sbody -ContentType $ContentType
}