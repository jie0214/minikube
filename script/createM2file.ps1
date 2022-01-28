foreach($i in (Get-Content "D:\jie\K8S Git\M2-GS-List\M2-GS-List.txt")){
    new-item "D:\jie\K8S Git\M2-GS-List\svc\$($i)" -type file
}