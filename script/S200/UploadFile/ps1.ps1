$today = Get-Date -Format "yyyy-MM-dd-HH-mm"
$s = $args[1]
if ($s -eq "v1"){
    foreach ($i in (Get-Content D:\UploadFile\DBList\$s.txt)){
        Copy-Item -Path D:\FTP_Root\$i\
    }
}