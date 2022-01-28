$time = Get-Date -Format 'yyyy-MM-dd'
$path = "D:\jie\Lab\"
$dd = -1
$yesterday = (Get-Date).AddDays($dd).ToString('yyyy-MM-dd')
#$Bak = [System.Collections.Generic.List[string]]::new()
#$Del = [System.Collections.Generic.List[string]]::new()
$Dir = [System.Collections.Generic.List[string]]::new()
#$Non=[System.Collections.Generic.List[string]]::new()

foreach ($n in (Get-Content $path\DBList.txt)){
    $Dir.Add($n)
}
