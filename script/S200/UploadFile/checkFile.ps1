#Invoke-RestMethod : 要求已經中止: 無法建立 SSL/TLS 的安全通道
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#日期格式
$today = Get-Date -Format "yyyy-MM-dd-HH-mm"
$stoday = Get-Date -Format "yyyy-MM-dd"
$dd = -1
$yesterday = (Get-Date).AddDays($dd).ToString('yyyy-MM-dd')
#Full Backup Log 儲存
$Bak = [System.Collections.Generic.List[string]]::new()
#Trn Backup Log 儲存
#$Trn = [System.Collections.Generic.List[string]]::new()
#Full Backup 數量計算儲存
$BakTotel = [System.Collections.Generic.List[string]]::new()
#Trn Log 數量計算儲存
#$TrnTotel = [System.Collections.Generic.List[string]]::new()
#執行參數2變數
$s = $args[1]
#計算FullBackup
$bakCon = 0
# 撈取一代DB清單寫查詢S3檔案及數量
if ($args[0] -match "v1"){
    $username = 'H1-System_Uploaded File'
    $channelname = 'h1-system-監控群'
    $weburl = 'https://hooks.slack.com/services/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'
    foreach ($i in (Get-Content D:\UploadFile\DBList\$s.txt)){
        $awsBak = (aws s3 ls s3://v1-db-backup/$s/$i/ |findstr "$yesterday" |findstr ".bak").Count
        $localBak = (Get-ChildItem -Path D:\FTP_Root\$i *$yesterday*.bak -recurse).Count
        #計算數量
        $Count = 0
        #$TrnCount = 0
        #S3如果無昨日bak檔案
        if ($awsBak -ne $localBak){
            #$upTrn = (aws s3 ls s3://v1-db-backup/$s/$i/ |findstr "$yesterday" |findstr ".trn").Count
            $upBak = (aws s3 ls s3://v1-db-backup/$s/$i/ |findstr "$yesterday" |findstr ".bak").Count
            #Count
            $fai = Write-Output "$($i): Full_Backup = $upBak"
            $Bak.Add($fai)
            #$trnfai = Write-Output "$($i): Trn_Log = $upTrn"
            #$Trn.Add($trnfai)
            $upLoad = "Upload_Failed"
        }
        #S3有bak檔案
        else{
            $upLoad = "Upload_Success"
            $bakCon = $bakCon + $awsBak
            $BakTotel.Add($bakCon)
            #$upTrn = (aws s3 ls s3://v1-db-backup/$s/$i/ |findstr "$yesterday" |findstr ".trn").Count
            $Succ = Write-Output "$($i): Full_Backup = $awsBak"
            #計算bak數量並暫存到陣列
            $Bak.Add($Succ)
            <#
            #Trn數量不等於0，計算log數量
            if ($upTrn -ne 0 ){
                $trnCon = $trnCon + $upTrn
                $trnSucc = Write-Output "$($i): Trn_Log = $upTrn"
                #計算trn數量並暫存到陣列
                $Trn.Add($trnSucc)
                $TrnTotel.Add($trnCon)
            }
            #>
        }
    }
}
elseif ($args[0] -match 'v2'){
    $username = 'RCG-2nd_Uploaded File'
    $channelname = 'rcg真人二點零-監控群'
    $weburl = 'https://hooks.slack.com/services/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'
    # 撈取二代DB清單寫查詢S3檔案及數量
    foreach ($i in (Get-Content D:\UploadFile\DBList\$s.txt)){
        $awsBak = (aws s3 ls s3://v2-db-backup/$s/$i/ |findstr "$yesterday" |findstr ".bak").Count
        $localBak = (Get-ChildItem -Path D:\FTP_Root\$i |findstr "$yesterday" |findstr ".bak").Count
        #計算數量
        $Count = 0
        #$TrnCount = 0
        #S3如果無昨日bak檔案
        if ($awsBak -ne $localBak){
            #$upTrn = (aws s3 ls s3://v2-db-backup/$s/$i/ |findstr "$yesterday" |findstr ".trn").Count
            $upBak = (aws s3 ls s3://v2-db-backup/$s/$i/ |findstr "$yesterday" |findstr ".bak").Count
            #Count
            $fai = Write-Output "$($i): Full_Backup = $upBak"
            $Bak.Add($fai)
            #$trnfai = Write-Output "$($i): Trn_Log = $upTrn"
            #$Trn.Add($trnfai)
            $upLoad = "Upload_Failed"
        }
        #S3有bak檔案
        else{
            $upLoad = "Upload_Success"
            $bakCon = $bakCon + $awsBak
            $BakTotel.Add($bakCon)
            #$upTrn = (aws s3 ls s3://v2-db-backup/$s/$i/ |findstr "$yesterday" |findstr ".trn").Count
            $Succ = Write-Output "$($i): Full_Backup = $awsBak"
            #計算bak數量並暫存到陣列
            $Bak.Add($Succ)
            <#
            #Trn數量不等於0，計算log數量
            if ($upTrn -ne 0 ){
                $trnCon = $trnCon + $upTrn
                $trnSucc = Write-Output "$($i): Trn_Log = $upTrn"
                #計算trn數量並暫存到陣列
                $Trn.Add($trnSucc)
                $TrnTotel.Add($trnCon)
            }
            #>
        }
    }
}
elseif ($args[0] -match 'maesot'){
    $username = 'Maesot_Uploaded File'
    $channelname = 'maesot-監控群'
    $weburl = 'https://hooks.slack.com/services/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'
    # 撈取二代DB清單寫查詢S3檔案及數量
    foreach ($i in (Get-Content D:\UploadFile\DBList\$s.txt)){
        $awsBak = (aws s3 ls s3://maesot-db-backup/$i/ |findstr "$yesterday" |findstr ".bak").Count
        $localBak = (Get-ChildItem -Path D:\FTP_Root\$i |findstr "$yesterday" |findstr ".bak").Count
        #計算數量
        $Count = 0
        #$TrnCount = 0
        #S3如果無昨日bak檔案
        if ($awsBak -eq 0){
            #$upTrn = (aws s3 ls s3://maesot-db-backup/$i/ |findstr "$yesterday" |findstr ".trn").Count
            $upBak = (aws s3 ls s3://maesot-db-backup/$i/ |findstr "$yesterday" |findstr ".bak").Count
            #Count
            $fai = Write-Output "$($i): Full_Backup = $upBak"
            $Bak.Add($fai)
            #$trnfai = Write-Output "$($i): Trn_Log = $upTrn"
            #$Trn.Add($trnfai)
            $upLoad = "Upload_Failed"
        }
        #S3有bak檔案
        else{
            $upLoad = "Upload_Success"
            $bakCon = $bakCon + $awsBak
            $BakTotel.Add($bakCon)
            #$upTrn = (aws s3 ls s3://maesot-db-backup/$i/ |findstr "$yesterday" |findstr ".trn").Count
            $Succ = Write-Output "$($i): Full_Backup = $awsBak"
            #計算bak數量並暫存到陣列
            $Bak.Add($Succ)
            <#
            #Trn數量不等於0，計算log數量
            if ($upTrn -ne 0 ){
                $trnCon = $trnCon + $upTrn
                $trnSucc = Write-Output "$($i): Trn_Log = $upTrn"
                #計算trn數量並暫存到陣列
                $Trn.Add($trnSucc)
                $TrnTotel.Add($trnCon)
            }
            #>
        }
    }
}
else {
    echo "Enter Error"
    break
    Write-Output $today "Enter Error" >> D:\UploadFile\UploadLog.txt
}
#執行Log
Write-Output "-----------------------------< $today  >----------------------------------" >> D:\UploadFile\FullBakLog.txt
$Bak >> D:\UploadFile\FullBakLog.txt
#$Trn >> D:\UploadFile\FullBakLog.txt
#發送Slack
$sBak = $Bak -join "`n"
#$sTrn = $Trn -join "`n"
#Slack
$Webhook = "$($weburl)"
$ContentType= 'application/json; charset=utf-8'
$template = @"
    {
        "channel": "$($channelname)",
        "username": "$($username)",
        "text": "Status: $($upLoad) \nTime: $($yesterday) \nHostName: $($s) \n------------------------------ \n$($sBak)",
        "icon_emoji":":aws_icon:"

    }
"@
$sbody = $template.Replace("UPLOAD","Full_Backup Upload Success").Replace("DATE",$yesterday).Replace("TARGET",$s)
Invoke-RestMethod -uri $Webhook -Method Post -body $sbody -ContentType $ContentType