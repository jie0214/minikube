#Invoke-RestMethod : 要求已經中止: 無法建立 SSL/TLS 的安全通道
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#日期格式
$today = Get-Date -Format "yyyy-MM-dd-HH-mm"
$dd = -1
$yesterday = (Get-Date).AddDays($dd).ToString('yyyy-MM-dd')

#Slack
#一代
#$Webhook = "https://hooks.slack.com/services/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"
#二代
$Webhook = "https://hooks.slack.com/services/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"
$ContentType= 'application/json; charset=utf-8'
$template = @"
    {
        "channel": "#rcg真人二點零-監控群",
        "username": "AWS Bot",
        "text": "Status: UPLOAD \nTime: DATE \nHostName: TARGET \n------------------------------ \nFull_Bak: FBAK \nLog: TRN",
        "icon_emoji":":aws_icon:"

    }
"@
#Full Backup Log 儲存
$Bak = [System.Collections.Generic.List[string]]::new()
#Trn Backup Log 儲存
$Trn = [System.Collections.Generic.List[string]]::new()
#Full Backup 數量計算儲存
$BakTotel = [System.Collections.Generic.List[string]]::new()
#Trn Log 數量計算儲存
$TrnTotel = [System.Collections.Generic.List[string]]::new()
#執行參數2變數
$s = $args[1]
#計算FullBackup
$bakCon = 0
# 撈取一代DB清單寫查詢S3檔案及數量
if ($args[0] -match "v1"){
    foreach ($i in (Get-Content D:\UploadFile\DBList\$s.txt)){
        $aws = (aws s3 ls s3://v1-db-backup/$s/$i/ |findstr "$yesterday" |findstr .bak).Count
        #計算數量
        $Count = 0
        $TrnCount = 0
        #S3如果無昨日bak檔案
        if ($aws -eq 0){
            foreach ($a in (Get-Content D:\UploadFile\DBList\$s.txt)){
                $upTrn = (aws s3 ls s3://v1-db-backup/$s/$a/ |findstr "$yesterday" |findstr .trn).Count
                $upBak = (aws s3 ls s3://v1-db-backup/$s/$a/ |findstr "$yesterday" |findstr .bak).Count
                #計算數量
                $Count = $Count + $upBak
                $TrnCount = $TrnCount + $upTrn
                #發送Slack
                $body = $template.Replace("UPLOAD","$i Full_Backup Upload Failed").Replace("DATE",$yesterday).Replace("TARGET",$s).Replace("FBAK", $Count).Replace("TRN", $TrnCount)
                Invoke-RestMethod -uri $Webhook -Method Post -body $body -ContentType $ContentType
            } 
        }
        #S3有bak檔案
        else{
            $bakCon = $bakCon + $aws
            $BakTotel.Add($bakCon)
            $upTrn = (aws s3 ls s3://v1-db-backup/$s/$i/ |findstr "$yesterday" |findstr .trn).Count
            $Succ = Write-Output "$s / $i / :Full Backup Upload Success_Totel= $aws"
            #計算bak數量並暫存到陣列
            $Bak.Add($Succ)
            #Trn數量不等於0，計算log數量
            if ($upTrn -ne 0 ){
                $trnCon = $trnCon + $upTrn
                $trnSucc = Write-Output "$s / $i / :Trn_Log Backup Upload Success_Totel= $upTrn"
                #計算trn數量並暫存到陣列
                $Trn.Add($trnSucc)
                $TrnTotel.Add($trnCon)
            }
        }
    }
}
elseif ($args[0] -match 'v2'){
    # 撈取二代DB清單寫查詢S3檔案及數量
    foreach ($i in (Get-Content D:\UploadFile\DBList\$s.txt)){
        $aws = (aws s3 ls s3://v2-db-backup/$s/$i/ |findstr "$yesterday" |findstr .bak).Count
        #計算數量
        $Count = 0
        $TrnCount = 0
        #S3如果無昨日bak檔案
        if ($aws -eq 0){
            foreach ($a in (Get-Content D:\UploadFile\DBList\$s.txt)){
                $upTrn = (aws s3 ls s3://v2-db-backup/$s/$a/ |findstr "$yesterday" |findstr .trn).Count
                $upBak = (aws s3 ls s3://v2-db-backup/$s/$a/ |findstr "$yesterday" |findstr .bak).Count
                #計算數量
                $Count = $Count + $upBak
                $TrnCount = $TrnCount + $upTrn
                #發送Slack
                $body = $template.Replace("UPLOAD","$i Full_Backup Upload Failed").Replace("DATE",$yesterday).Replace("TARGET",$s).Replace("FBAK", $Count).Replace("TRN", $TrnCount)
                Invoke-RestMethod -uri $Webhook -Method Post -body $body -ContentType $ContentType
            } 
        }
        #S3有bak檔案
        else{
            $bakCon = $bakCon + $aws
            $BakTotel.Add($bakCon)
            $upTrn = (aws s3 ls s3://v2-db-backup/$s/$i/ |findstr "$yesterday" |findstr .trn).Count
            $Succ = Write-Output "$s / $i / :Full Backup Upload Success_Totel= $aws"
            #計算bak數量並暫存到陣列
            $Bak.Add($Succ)
            #Trn數量不等於0，計算log數量
            if ($upTrn -ne 0 ){
                $trnCon = $trnCon + $upTrn
                $trnSucc = Write-Output "$s / $i / :Trn_Log Backup Upload Success_Totel= $upTrn"
                #計算trn數量並暫存到陣列
                $Trn.Add($trnSucc)
                $TrnTotel.Add($trnCon)
            }
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
$Trn >> D:\UploadFile\FullBakLog.txt
#發送Slack
$sbody = $template.Replace("UPLOAD","Full_Backup Upload Success").Replace("DATE",$yesterday).Replace("TARGET",$s).Replace("FBAK", $BakTotel[-1]).Replace("TRN", $TrnTotel[-1])
Invoke-RestMethod -uri $Webhook -Method Post -body $sbody -ContentType $ContentType
