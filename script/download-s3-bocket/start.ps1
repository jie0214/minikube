#Invoke-RestMethod : 要求已經中止: 無法建立 SSL/TLS 的安全通道
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 今日
$today = Get-Date -format "yyyy-MM-dd"
# 昨日
$dd = -1
$yesterday = (Get-Date).AddDays($dd).ToString('yyyy-MM-dd')
# 此刻
#$nowtime = Get-Date -format "yyyy-MM-dd hh:mm:ss"

# 目錄數量
#$foldercount = (Get-Content .\DBList\$($args[1]).txt | measure-object -line).Lines

# 遊戲系統對應頻道
if ($args[0] -match 'v1')
{
    # Webhook Template 變數
    $username='H1-System_Downloading File'
    $channelname='h1-system-監控群'
    $weburl='https://hooks.slack.com/services/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'
    # S3 Bocket
    $s3bocket='v1-db-backup'
}
elseif ($args[0] -match 'v2')
{
    # Webhook Template 變數
    $username='RCG-2nd_Downloading File'
    $channelname='rcg真人二點零-監控群'
    $weburl='https://hooks.slack.com/services/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'
    # S3 Bocket
    $s3bocket='v2-db-backup/DB-REPCURDB'
}
elseif ($args[0] -match 'maesot')
{
    # Webhook Template 變數
    $username='Maesot_Downloading File'
    $channelname='maesot-監控群'
    $weburl='https://hooks.slack.com/services/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'
    # S3 Bocket
    $s3bocket='maesot-db-backup'
}

# Webhook Template
$Webhook = "$($weburl)"
$ContentType = 'application/json; charset=utf-8'
$template = @"
     {
         "channel": "$($channelname)",
         "username": "$($username)",
         "text": "Status: download \nTime: DATETIME \nHostname: host \nDir: count Files"
     }
"@

# 主程式
# 確認版本
if ($args[0] -match 'v1')
{
    # 主機名稱
    $dbname=(Get-Content .\DBList\$($args[0]).txt |findstr "$($args[1])")
    # 確認主機
    if ($args[1] -eq $dbname)
    {
        # 此刻
        $nowtime = Get-Date -format "yyyy-MM-dd hh:mm:ss"
        # 下載完成，修改Webhook Template
        $body=$template.Replace("Status: download \nTime: DATETIME \nHostname: host \nDir: count Files", "-----Download Start-----")
        # 傳送slack
        Invoke-RestMethod -uri $Webhook -Method Post -body $body -ContentType $ContentType
        echo '程式下載開始'
        
        # 該主機所有目錄
        foreach($file in (Get-Content .\DBList\$($args[1]).txt))
        {
            # 該目錄所有檔案
            foreach($filedir in (Get-Content .\DBList\$($args[1])\$file.txt))
            {
                # 清理內容
                Clear-Content -Path .\download.ps1
                Clear-Content -Path .\Completed_Log.txt
                # 確認目的數量
                #  $CheckToday=(aws s3 ls s3://v1-db-backup/$($args[1])/$file/$($filedir)_$($today) | Measure-Object -Line).Lines
                #  $CheckYesterday=(aws s3 ls s3://v1-db-backup/$($args[1])/$file/$($filedir)_$($yesterday) | Measure-Object -Line).Lines
                $CheckToday=(aws s3 ls s3://$($s3bocket)/$($args[1])/$file/$($filedir)_$($today) | Measure-Object -Line).Lines
                $CheckYesterday=(aws s3 ls s3://$($s3bocket)/$($args[1])/$file/$($filedir)_$($yesterday) | Measure-Object -Line).Lines
                $CheckCounts=$CheckToday + $CheckYesterday
                # 開始進行下載，修改Webhook Template
                $nowtime = Get-Date -format "yyyy-MM-dd hh:mm:ss"
                $body=$template.Replace("download", "Downloading File").Replace("DATETIME",$nowtime).Replace("host", "$($args[1])").Replace("Dir", "S3.$($file).$filedir").Replace("count", "$CheckCounts")
                # 傳送slack
                Invoke-RestMethod -uri $Webhook -Method Post -body $body -ContentType $ContentType
                # 增加內容
                #  Add-Content .\download.ps1 -Value "aws s3 cp s3://v1-db-backup/$($args[1])/$file .\$($args[1])\$file --recursive --exclude=* --include=$($filedir)_$today* --include=$($filedir)_$yesterday*"
                Add-Content .\download.ps1 -Value "aws s3 cp s3://$($s3bocket)/$($args[1])/$file .\$($args[1])\$file --recursive --exclude=* --include=$($filedir)_$today* --include=$($filedir)_$yesterday*"
                # 顯示內容
                Get-Content .\download.ps1
                # 運作檔案
                .\download.ps1
                # 確認下載數量
                $CheckToday=(dir .\$($args[1])\$file\ |findstr "$($filedir)_$($today)" | Measure-Object -Line).Lines
                $CheckYesterday=(dir .\$($args[1])\$file\ |findstr "$($filedir)_$($yesterday)" | Measure-Object -Line).Lines
                $CheckCounts=$CheckToday + $CheckYesterday
                # 此刻
                $nowtime = Get-Date -format "yyyy-MM-dd hh:mm:ss"
                # 下載完成，修改Webhook Template
                $body=$template.Replace("download", "Download Completed").Replace("DATETIME",$nowtime).Replace("host", "$($args[1])").Replace("Dir", "Local.$($file).$filedir").Replace("count", "$CheckCounts")
                # 傳送slack
                Invoke-RestMethod -uri $Webhook -Method Post -body $body -ContentType $ContentType
            }
        }
        # 此刻
        $nowtime = Get-Date -format "yyyy-MM-dd hh:mm:ss"
        # 下載完成，修改Webhook Template
        $body=$template.Replace("Status: download \nTime: DATETIME \nHostname: host \nDir: count Files", "-----Download End-----")
        # 傳送slack
        Invoke-RestMethod -uri $Webhook -Method Post -body $body -ContentType $ContentType
        echo '程式下載結束'
    }
    else
    {
        echo '主機有誤，請確認主機名稱'
        break
    }
}
elseif ($args[0] -match 'v2')
{
    # 主機名稱
    $dbname=(Get-Content .\DBList\$($args[0]).txt |findstr "$($args[1])")
    # 確認主機
    if ($args[1] -eq $dbname)
    {
        # 此刻
        $nowtime = Get-Date -format "yyyy-MM-dd hh:mm:ss"
        # 下載完成，修改Webhook Template
        $body=$template.Replace("Status: download \nTime: DATETIME \nHostname: host \nDir: count Files", "-----Download Start-----")
        # 傳送slack
        Invoke-RestMethod -uri $Webhook -Method Post -body $body -ContentType $ContentType
        echo '程式下載開始'
        
        # 該主機所有目錄
        foreach($file in (Get-Content .\DBList\$($args[1]).txt))
        {
            # 清理內容
            Clear-Content -Path .\download.ps1
            Clear-Content -Path .\Completed_Log.txt
            # 確認目的數量
            #  $CheckToday=(aws s3 ls s3://v2-db-backup/DB-REPCURDB/$file/$($file)_$($today) |Measure-Object -Line).Lines
            #  $CheckYesterday=(aws s3 ls s3://v2-db-backup/DB-REPCURDB/$file/$($file)_$($yesterday) |Measure-Object -Line).Lines
            $CheckToday=(aws s3 ls s3://$($s3bocket)/$file/$($file)_$($today) |Measure-Object -Line).Lines
            $CheckYesterday=(aws s3 ls s3://$($s3bocket)/$file/$($file)_$($yesterday) |Measure-Object -Line).Lines
            $CheckCounts=($CheckToday + $CheckYesterday)
            # 此刻
            $nowtime = Get-Date -format "yyyy-MM-dd hh:mm:ss"
            # 開始進行下載，修改Webhook Template
            $body=$template.Replace("download", "Downloading File").Replace("DATETIME",$nowtime).Replace("host", "$($args[1])").Replace("Dir", "S3.$($file).$file").Replace("count", "$CheckCounts")
            # 傳送slack
            Invoke-RestMethod -uri $Webhook -Method Post -body $body -ContentType $ContentType
            # 增加內容
            #  Add-Content .\download.ps1 -Value "aws s3 cp s3://v2-db-backup/DB-REPCURDB/$file .\$($args[1])\$file --recursive --exclude=* --include=$($file)_$today* --include=$($file)_$yesterday*"
            Add-Content .\download.ps1 -Value "aws s3 cp s3://$($s3bocket)/$file .\$($args[1])\$file --recursive --exclude=* --include=$($file)_$today* --include=$($file)_$yesterday*"
            # 顯示內容
            Get-Content .\download.ps1
            # 運作檔案
            .\download.ps1
            # 確認下載數量
            $CheckToday=(dir .\$($args[1])\$file\ |findstr "$($file)_$($today)" | Measure-Object -Line).Lines
            $CheckYesterday=(dir .\$($args[1])\$file\ |findstr "$($file)_$($yesterday)" | Measure-Object -Line).Lines
            $CheckCounts=$CheckToday + $CheckYesterday
            # 此刻
            $nowtime = Get-Date -format "yyyy-MM-dd hh:mm:ss"
            # 下載完成，修改Webhook Template
            $body=$template.Replace("download", "Download Completed").Replace("DATETIME",$nowtime).Replace("host", "$($args[1])").Replace("Dir", "Local.$($file)").Replace("count", "$CheckCounts")
            # 傳送slack
            Invoke-RestMethod -uri $Webhook -Method Post -body $body -ContentType $ContentType
        }
        # 此刻
        $nowtime = Get-Date -format "yyyy-MM-dd hh:mm:ss"
        # 下載完成，修改Webhook Template
        $body=$template.Replace("Status: download \nTime: DATETIME \nHostname: host \nDir: count Files", "-----Download End-----")
        # 傳送slack
        Invoke-RestMethod -uri $Webhook -Method Post -body $body -ContentType $ContentType
        echo '程式下載結束'
    }
    else
    {
        echo '主機有誤，請確認主機名稱'
        break
    }
}
elseif ($args[0] -match 'maesot')
{
    # 主機名稱
    $dbname=(Get-Content .\DBList\$($args[0]).txt |findstr "$($args[1])")
    # 確認主機
    if ($args[1] -eq $dbname)
    {
        # 此刻
        $nowtime = Get-Date -format "yyyy-MM-dd hh:mm:ss"
        # 下載完成，修改Webhook Template
        $body=$template.Replace("Status: download \nTime: DATETIME \nHostname: host \nDir: count Files", "-----Download Start-----")
        # 傳送slack
        Invoke-RestMethod -uri $Webhook -Method Post -body $body -ContentType $ContentType
        echo '程式下載開始'
        
        # 該主機所有目錄
        foreach($file in (Get-Content .\DBList\$($args[1]).txt))
        {
            # 清理內容
            Clear-Content -Path .\download.ps1
            Clear-Content -Path .\Completed_Log.txt
            # 確認目的數量
            #  $CheckToday=(aws s3 ls s3://maesot-db-backup/$file/$($file)_$($today) |Measure-Object -Line).Lines
            #  $CheckYesterday=(aws s3 ls s3://maesot-db-backup/$file/$($file)_$($yesterday) |Measure-Object -Line).Lines
            $CheckToday=(aws s3 ls s3://$($s3bocket)/$($args[1])/$($file)_$($today) |Measure-Object -Line).Lines
            $CheckYesterday=(aws s3 ls s3://$($s3bocket)/$($args[1])/$($file)_$($yesterday) |Measure-Object -Line).Lines
            $CheckCounts=($CheckToday + $CheckYesterday)
            # 此刻
            $nowtime = Get-Date -format "yyyy-MM-dd hh:mm:ss"
            # 開始進行下載，修改Webhook Template
            $body=$template.Replace("download", "Downloading File").Replace("DATETIME",$nowtime).Replace("host", "$($args[1])").Replace("Dir", "S3.$($file)").Replace("count", "$CheckCounts")
            # 傳送slack
            Invoke-RestMethod -uri $Webhook -Method Post -body $body -ContentType $ContentType
            # 增加內容
            #  Add-Content .\download.ps1 -Value "aws s3 cp s3://maesot-db-backup/$file .\$($args[1]) --recursive --exclude=* --include=$($file)_$today* --include=$($file)_$yesterday*"
            Add-Content .\download.ps1 -Value "aws s3 cp s3://$($s3bocket)/$($args[1]) .\$($args[1]) --recursive --exclude=* --include=$($file)_$today* --include=$($file)_$yesterday*"
            # 顯示內容
            Get-Content .\download.ps1
            # 運作檔案
            .\download.ps1
            # 確認下載數量
            $CheckToday=(dir .\$($args[1])\ |findstr "$($file)_$($today)" | Measure-Object -Line).Lines
            $CheckYesterday=(dir .\$($args[1])\ |findstr "$($file)_$($yesterday)" | Measure-Object -Line).Lines
            $CheckCounts=$CheckToday + $CheckYesterday
            # 此刻
            $nowtime = Get-Date -format "yyyy-MM-dd hh:mm:ss"
            # 下載完成，修改Webhook Template
            $body=$template.Replace("download", "Download Completed").Replace("DATETIME",$nowtime).Replace("host", "$($args[1])").Replace("Dir", "Local.$($file)").Replace("count", "$CheckCounts")
            # 傳送slack
            Invoke-RestMethod -uri $Webhook -Method Post -body $body -ContentType $ContentType
        }
        # 此刻
        $nowtime = Get-Date -format "yyyy-MM-dd hh:mm:ss"
        # 下載完成，修改Webhook Template
        $body=$template.Replace("Status: download \nTime: DATETIME \nHostname: host \nDir: count Files", "-----Download End-----")
        # 傳送slack
        Invoke-RestMethod -uri $Webhook -Method Post -body $body -ContentType $ContentType
        echo '程式下載結束'
    }
    else
    {
        echo '主機有誤，請確認主機名稱'
        break
    }
}
else
{
    echo '版本有誤，請確認版本'
    break
}