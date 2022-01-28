$time = Get-Date -Format 'yyyy-MM-dd'
$path = "D:\jie\Lab"
$dd = -1
$yesterday = (Get-Date).AddDays($dd).ToString('yyyy-MM-dd')
$Bak = [System.Collections.Generic.List[string]]::new()
$Del = [System.Collections.Generic.List[string]]::new()
$Dir = [System.Collections.Generic.List[string]]::new()
$Non=[System.Collections.Generic.List[string]]::new()
$json = "$($path)\movefile.json"
#Find File
foreach ($i in (Get-Content $path\DBList\upload.txt)){
    $abc=(Get-ChildItem $path\$i -Filter "*.bak").Name |findstr "$time"
    Write-Output $abc >> $path\Move.txt
}

#Find Expired File
foreach ($i in (Get-Content $path\DBList\upload.txt)){
    $abc=(Get-ChildItem $path\DBList\$i -Filter "*.bak").Name |findstr "$yesterday"
    $c=((Get-ChildItem $path\DBList\$i -Filter "*.bak").Name |findstr "$yesterday" |Measure-Object).Count
    $Non.Add($c)
    Write-Output $abc >> $path\Delete.txt
}

#Save to array
foreach ($line in (Get-Content $path\Move.txt)){
    $Bak.Add($line)
    Write-Output "" > $path\Move.txt
}
foreach ($line in (Get-Content $path\Delete.txt)){
    $Del.Add($line)
    Write-Output "" > $path\Delete.txt
}
#Get Folder
foreach ($n in (Get-Content $path\DBList\upload.txt)){
    $Dir.Add($n)
}

#Copy
foreach ($n in (Get-Content $path\DBList\upload.txt)){
    if(!(Test-Path $path\DBList\$n)){
        New-Item $path\DBList\$n -ItemType "directory"
    }
    $a=(Get-ChildItem $path\$n\ -Filter "*.bak" -Recurse).Name |findstr "$time"
    Write-Output $a >> $default\movefile.txt
    #Copy-Item $path\$n\$a $path\DBList\$n\ -Recurse
}


$a=1
foreach ($n in (Get-Content $path\DBList\DBList.txt)){
    Copy-Item $path\$n\$Bak[$a] $path\DBList\$n\ -Recurse
    $Bak[$a]
    $a=$a+1
}
foreach ($n in (Get-Content $path\movefile.txt)){
    $Bak.Add($n)
    Write-Output "" > $path\movefile.txt
}
<#
$cun=1
if($non -ne "0"){
    foreach ($n in (Get-Content $path\DBList\upload.txt)){
        $file=(Get-ChildItem $path\DBList\$n\ -Filter "*bak" -Recurse).Name |findstr "$yesterday"
        $c=((Get-ChildItem $path\DBList\$n\ -Filter "*.bak" -Recurse).Name |findstr "$yesterday" |Measure-Object).Count
        Write-Output $file
        if($c -ne "0"){
            Get-ChildItem "$path\DBList\$($n)\$($file)" |Remove-Item
            $c=((Get-ChildItem $path\DBList\$n\ -Filter "*.bak" -Recurse).Name |findstr "$yesterday" |Measure-Object).Count
            $non.Add($c)
        }
    $cun=$cun+1
    }
}
#>