$default="D:\jie\Lab"
$cpfile="D:\jie\Lab"
$today=Get-Date -Format "yyyy-MM-dd"
$yesterday = get-date -uformat "%Y-%m-%d" ((get-date).adddays(-1))
$Bak=[System.Collections.Generic.List[string]]::new()
$Del=[System.Collections.Generic.List[string]]::new()
$non=[System.Collections.Generic.List[string]]::new()

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
    for($i=1;$i -le 4;$i++){
    }
    Get-ChildItem $cpfile\DBList\$n\$($Del[$i]) |Remove-Item
}

#Copy Today Full.Bak File
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
    Write-Output "" > $cpfile\movefile.txt
}

foreach ($n in (Get-Content $cpfile\DBList\upload.txt)){
    for($i=1;$i -le 4;$i++){
        Copy-Item $default\$n\$($Bak[$i]) $cpfile\DBList\$n\ -Recurse
    }
}