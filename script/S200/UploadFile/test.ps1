$default="D:\FTP_Root"
$cpfile="D:\UploadFile"
$today=Get-Date -Format "yyyy-MM-dd"
$yesterday = get-date -format "%Y-%m-%d" ((get-date).adddays(-1))
$Bak=[System.Collections.Generic.List[string]]::new()
$Del=[System.Collections.Generic.List[string]]::new()
$non=[System.Collections.Generic.List[string]]::new()
echo $cpfile
#Delete Expired File
foreach ($n in (Get-Content $cpfile\DBList\upload.txt)){
    $a=(Get-ChildItem $cpfile\DBList\$n\ -Filter "*.bak" -Recurse).Name |findstr "$yesterday"
    Write-Output $a >> $cpfile\Delete.txt
}

foreach ($n in (Get-Content $cpfile\Delete.txt)){
    $Del.Add($n)
}
$Del
foreach ($n in (Get-Content $cpfile\DBList\upload.txt)){
    for($i=1;$i -le 5;$i++){
    }
    Get-ChildItem $cpfile\DBList\$n\$($Del[$i]) |Remove-Item
}
Write-Output "" >  $cpfile\Delete.txt

foreach ($n in (Get-Content $cpfile\DBList\upload.txt)){
    if(!(Test-Path $cpfile\DBList\$n)){
        New-Item $cpfile\DBList\$n -ItemType "directory"
    }
    $B=(Get-ChildItem $default\$n\ -Filter "*.bak" -Recurse).Name |findstr "$today"
    Write-Output $B >> $cpfile\movefile.txt
    #Copy-Item $default\$n\$B $default\DBList\$n\ -Recurse
}

foreach ($n in (Get-Content $cpfile\movefile.txt)){
    $Bak.Add($n)
}
write-output $Bak
Write-Output "" > $cpfile\movefile.txt

foreach ($n in (Get-Content $cpfile\DBList\upload.txt)){
    for($i=1;$i -le 5;$i++){
        Copy-Item $default\$n\$($Bak[$i]) $cpfile\DBList\$n\ -Recurse
    }
}
