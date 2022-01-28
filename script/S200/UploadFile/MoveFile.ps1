# �ӷ��l�ؿ��W��
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
    # �������榡
    $today = Get-Date -format "yyyy-MM-dd"
    # �ӷ��ؿ�
    $ftp_root_path = "..\FTP_Upload\$i"
    # �ت��ؿ�
    $uploadfile_path = ".\DBList\$i"

    # �d�ߨӷ��ؿ��ɮ�
    $ftp_root_path_file = Get-ChildItem -Path "$ftp_root_path" -Filter *Full.bak -Name  | Select-String "$today"  | % { $_.Line }

    # �p��ӷ��ɮ׼ƶq
    $ftp_root_path_count = ($ftp_root_path_file).count

    # �ӷ��S���ɮ׫h���L
    if ($ftp_root_path_count -eq 0)
    {
        echo "$i directory is empty" 
        continue
    }
    else
    {
        # �M�ťؼи�Ƨ�
        $clear_directory = Get-ChildItem -Path "$uploadfile_path" | Remove-Item -Recurse
        $clear_directory
        echo "The target $i directory has been emptied"

        # �h���ɮ�
        foreach ($j in $ftp_root_path_file)
        {
            Copy-Item "$ftp_root_path\$j" "$uploadfile_path\$j"
        }
        echo "$i [$ftp_root_path_count] files have been moved" 
        sleep 1
    }
    sleep 1
}