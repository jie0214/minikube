# 今日日期格式
$today = Get-Date -format "yyyy-MM-dd"
$dd = -1
$yesterday = (Get-Date).AddDays($dd).ToString('yyyy-MM-dd')

#Slack通知
function slack {
    [System.Net.ServicePointManager]::SecurityProtocol=[System.Net.SecurityProtocolType]::Tls12
    param(
    $username = 'H1-System_Uploaded File',
    #$channelname = 'db每日備份通知',
    #$Webhook = 'https://hooks.slack.com/services/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',
    $channelname = 'test-slack',
    $Webhook = 'https://hooks.slack.com/services/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',
    $ContentType= 'application/json; charset=utf-8',
    $HostName = '100.47_H1-Jump-oper'
    )
    
    $template = @"
    {
        "channel": "$($channelname)",
        "username": "$($username)",
        "text": "HostName: $($HostName) \nDirectory: $($ftp_root_dir) \nFileName: $($File) \nSize: $($GSize) GB \nTime: $($Today)",
        "icon_emoji":":aws_icon:"
    }
"@

#$body = $template.Replace("UPLOAD","Full_Backup Upload Success").Replace("DATE",$yesterday)
Invoke-RestMethod -uri $Webhook -Method Post -body $template -ContentType $ContentType

}

# 來源子目錄名稱
if ($args[0] -match 'day')
{
    $ftp_root_dir = @('DayDB','KSDB_Linux')
}
elseif ($args[0] -match 'mon')
{
    $ftp_root_dir = @('MonDB')
}
elseif ($args[0] -match 'all')
{
    $ftp_root_dir = @('MonDB','DayDB','KSDB_Linux')
}
else
{
    echo 'Script stop is not specified day or mon or all'
    break
}

foreach ($i in $ftp_root_dir)
{
    # 今日日期格式
    # $today = Get-Date -format "yyyy-MM-dd"
    # $dd = -1
    # $yesterday = (Get-Date).AddDays($dd).ToString('yyyy-MM-dd')
    # 來源目錄
    $ftp_root_path = "Y:\$i"
    # 目的目錄
    $uploadfile_path = "C:\UploadFile\DBList\$i"
    # Log目錄
    $log_path = "C:\UploadFile"
    Write-Output "----------------------------------------------------------------" >> $log_file\movefile.txt
    

    # 查詢來源目錄檔案
    $ftp_root_path_file = Get-ChildItem -Path "$ftp_root_path" -Filter Mon*Full.bak -Name  | Select-String "$today"  | % { $_.Line }

    # 計算來源檔案數量
    $ftp_root_path_count = ($ftp_root_path_file).count

    # 來源沒有檔案則略過
    if ($ftp_root_path_count -eq 0)
    {
        echo "$i directory is empty" 
        continue
    }
    else
    {
        
        # 清空目標資料夾
        $clear_directory = Get-ChildItem -Path "$uploadfile_path" | Remove-Item -Recurse
        $clear_directory
        echo "The target $i directory has been emptied"

        # 搬移檔案
        foreach ($j in $ftp_root_path_file)
        {
            #開始搬移時間
            $start = Get-Date -Format "yyyy-MM-dd-HH:mm"
            Write-Output "$($i) upload start on $($start)" >> $log_file\movefile.txt
            Copy-Item "$ftp_root_path\$j" "$uploadfile_path\$j"
            #搬移完成時間
            $finish = Get-Date -Format "yyyy-MM-dd-HH:mm"
            Write-Output "$($i) upload finish on $($finish)" >> $log_file\movefile.txt
        }
        echo "$i [$ftp_root_path_count] files have been moved" 
        sleep 1
        #上傳檔案
        Get-ChildItem -Path $uploadfile_path | ForEach-Object {
          $File = $_.Name
          $Size = $_.Length
          $GSize = [math]::Round(($Size/1GB),2)
          $start = Get-Date -Format "yyyy-MM-dd-HH:mm"
          #aws s3 sync $Path s3://h1-backup/$DIR/
          $finish = Get-Date -Format "yyyy-MM-dd-HH:mm"
          echo "$($File) $($GSize)" >> S3Upload.txt
        }

    }
    sleep 1
}
#檢查上傳檔案
aws s3 ls s3://h1-backup/$($ftp_root_dir)/ |Select-String -Pattern "$today" > S3File.txt
$Count = (Get-Content .\S3File.txt |ForEach-Object {$_.Split()[3]} |Select-String "$today").Count
echo $Count