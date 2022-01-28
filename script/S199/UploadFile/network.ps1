(Get-NetAdapterStatistics -Name LAN1).SentBytes

#Get-Counter –Counter ‘\Network Interface(intel[r] ethernet 10g 4p x550 rndc _4)\Bytes Sent/sec’ | format-table –auto
Get-Counter '\Network Interface(intel[r] ethernet 10g 4p x550 rndc _4)\Bytes Sent/sec'