$i = @('MonDB')
$today = "2023-02-21"
$uploadfile_path = "C:\UploadFile\DBList\$i"
$array = @()
#$today = Get-Date -Format "yyyy-MM-dd"
        Get-ChildItem -Path $uploadfile_path | ForEach-Object {
          $File = $_.Name
          $Size = $_.Length
          $GSize = [math]::Round(($Size/1GB),2)
          $start = Get-Date -Format "yyyy-MM-dd-HH:mm"
          #aws s3 sync $Path s3://h1-backup/$DIR/
          $finish = Get-Date -Format "yyyy-MM-dd-HH:mm"
        }

aws s3 ls s3://h1-backup/$($i)/ |Select-String -Pattern "$today" > S3File.txt
$Count = (Get-Content .\S3File.txt |Select-String "$today").Count

if ($Count -ne 0){
    echo "成功 $($Count)"
    foreach ($i in Get-Content .\S3File.txt){
        $array.Add($i)
    }
}else{
    echo "失敗"
}
$array