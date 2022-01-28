# 來源子目錄名稱
if ($args[0] -match 'S199')
{
    $ftp_root_dir = @('H1Day','H1DayCur')
}
elseif ($args[0] -match 'S200')
{
    $ftp_root_dir = @('H1LogDB','H1MobileDB','H1Mon')
}
elseif ($args[0] -match 'all')
{
    $ftp_root_dir = @('H1Day','H1DayCur','H1KSDB','H1LogDB','H1MobileDB','H1Mon','S199')
}
else
{
    echo 'Script stop is not specified S199 or S200 or all'
    break
}

foreach ($i in $ftp_root_dir)
{
    # 今日日期格式
    $today = Get-Date -format "yyyy-MM-dd"
    # 來源目錄
    $ftp_root_path = "..\FTP_Upload\$i"
    # 目的目錄
    $uploadfile_path = ".\DBList\$i"

    # 查詢來源目錄檔案
    $ftp_root_path_file = Get-ChildItem -Path "$ftp_root_path" -Filter *Full.bak -Name  | Select-String "$today"  | % { $_.Line }

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
            Copy-Item "$ftp_root_path\$j" "$uploadfile_path\$j"
        }
        echo "$i [$ftp_root_path_count] files have been moved" 
        sleep 1
    }
    sleep 1
}