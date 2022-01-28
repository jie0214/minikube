function copyFile {
    #function 參數
    param(
        [string]$path,
        [string]$includeFile
    )

    #資料夾/Port
    for ($i = 8001; $i -lt 9000; $i ++) {
        $testPath=Test-Path $path\$i\$includeFile
        
        #搜尋上月份檔案名稱 YYYY_MM_DD
        if ($testPath -eq "True" ) {
            $CURRENTDATE=GET-DATE
            #扣除一個月
            #$MonthAgo = $CURRENTDATE.AddMonths(-1)

            #1到30日
            for ($dd = 1; $dd -le 31; $dd ++ ) {
                #$FIRSTDAYOFMONTH=GET-DATE $MonthAgo -Day $dd
                $FIRSTDAYOFMONTH=GET-DATE -Day $dd
                $dday=$FIRSTDAYOFMONTH.ToString("yyyy_MM_dd")
                $testPath=Test-Path $path\$i\$includeFile\$dday
                
                #有檔案才複製
                if ($testPath -eq "True") {
                    Copy-Item -Path $path\$i\$includeFile\$dday -Recurse .\copyVideo\$i\$includeFile\$dday
                    Write-Output .\copyVideo\$i\$includeFile\$dday "copy completed"
                   
                }
                    
            }
 
        }else{
            continue
        }

    }
    
}
#path 資料夾路徑 includeFile 檔案路徑
copyFile -path .\RoyalBattle -includeFile video