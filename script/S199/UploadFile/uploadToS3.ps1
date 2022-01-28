[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#taskkill /IM aws.exe /f
$time = Get-Date -Format 'yyyy-MM-dd'
$dd = -2
$yesterday = (Get-Date).AddDays($dd).ToString('yyyy-MM-dd')
#$sw = [Diagnostics.Stopwatch]::StartNew()
$username = 'H1-System_Uploaded File'
$channelname = 'h1-system-監控群'
$weburl = 'https://hooks.slack.com/services/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'
$Webhook = "$($weburl)"
$ContentType= 'application/json; charset=utf-8'
$template = @"
    {-
        "channel": "$($channelname)",
        "username": "$($username)",
        "text": "UPLOAD",
        "icon_emoji":":aws_icon:"

    }
"@
foreach ($i in (Get-Content D:\UploadFile\DBList\upload.txt)){
    #Get-ChildItem D:\UploadFile\$i -Include *$yesterday* -Recurse |Remove-Item
    #Get-ChildItem D:\FTP_Root\$i -Recurse -Filter "*$($time)*.bak" |Copy-Item -Destination D:\UploadFile\$i
    $sw = [Diagnostics.Stopwatch]::StartNew()
    aws s3 sync D:\UploadFile\DBList\$i s3://v1-db-backup/S199/$i
    $sw.Stop()
    $time=($sw.Elapsed).TotalSeconds
    $time = "{0:N0}" -f $time
    #Write-Output "Total Use '$($time)' Seconds"
    $sbody = $template.Replace("UPLOAD","S199 $($i) Upload use $($time) Seconds")
    Invoke-RestMethod -uri $Webhook -Method Post -body $sbody -ContentType $ContentType
    $date = Get-Date -format "yyyy-MM-dd-HH-mm"
    Write-Output "$($date)_$($i)_Upload Complete" >> D:\UploadFile\UploadLog.txt
}

#$sw.Stop()
#$time=($sw.Elapsed).TotalSeconds
#Write-Output "Total Use '$($time)' Seconds"