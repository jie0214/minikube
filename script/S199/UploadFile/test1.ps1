$time = Get-Date -Format 'yyyy-MM-dd'
$dd = -1
$yesterday = (Get-Date).AddDays($dd).ToString('yyyy-MM-dd')
foreach ($i in (Get-Content D:\UploadFile\DBList\upload.txt)){
Get-ChildItem D:\UploadFile\$i -Include *$yesterday* -Recurse |Remove-Item
Get-ChildItem D:\FTP_Root\$i -Recurse -Filter "*$($time)*.bak" |Copy-Item -Destination D:\UploadFile\$i
}