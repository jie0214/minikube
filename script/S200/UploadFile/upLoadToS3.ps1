[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#taskkill /IM aws.exe /f
$time = Get-Date -Format 'yyyy-MM-dd'
$dd = -2
$yesterday = (Get-Date).AddDays($dd).ToString('yyyy-MM-dd')
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
    $date = Get-Date -format "yyyy-MM-dd-HH-mm"
    $sw = [Diagnostics.Stopwatch]::StartNew()
    aws s3 sync D:\UploadFile\DBList\$i s3://v1-db-backup/S200/$i
    $sw.Stop()
    $time=($sw.Elapsed).TotalSeconds
    $time="{0:N0}" -f $time
    $sbody = $template.Replace("UPLOAD","S200 $($i) Upload use $($time) Seconds")
    #Invoke-RestMethod -uri $Webhook -Method Post -body $sbody -ContentType $ContentType
    Write-Output "Total Use '$($time)' Seconds"
    if ($time -lt 3){
        Write-Output "$($date)_$($i)_Upload Failed" >> D:\UploadFile\UploadLog.txt
    }else{
        Write-Output "$($date)_$($i)_Upload Complete" >> D:\UploadFile\UploadLog.txt
    }

}
Invoke-RestMethod -uri $Webhook -Method Post -body $sbody -ContentType $ContentType
#$sw.Stop()
#$time=($sw.Elapsed).TotalSeconds
#Write-Output "Total Use '$($time)' Seconds"