get-counter '\Network Interface(*)\Bytes Sent/sec'



<#
CounterSetName     : TCPIP Performance Diagnostics
MachineName        : .
CounterSetType     : SingleInstance
Description        : 此計數器集合會測量各種 TCPIP 活動以進行效能診斷。
Paths              : {\TCPIP Performance Diagnostics\URO segment forwarding failures during software segmentation, \TCPIP Performance Diagnostics\URO segments forwarded via software segmentation and checksu
                     m, \TCPIP Performance Diagnostics\URO segments forwarded via software segmentation, \TCPIP Performance Diagnostics\TCP RSC bytes received...}
PathsWithInstances : {}
Counter            : {\TCPIP Performance Diagnostics\URO segment forwarding failures during software segmentation, \TCPIP Performance Diagnostics\URO segments forwarded via software segmentation and checksu
                     m, \TCPIP Performance Diagnostics\URO segments forwarded via software segmentation, \TCPIP Performance Diagnostics\TCP RSC bytes received...}




CounterSetName     : Physical Network Interface Card Activity
MachineName        : .
CounterSetType     : SingleInstance
Description        : Physical Network Interface Card Activity 計數器集合會測量實體網路卡上的事件。
Paths              : {\Physical Network Interface Card Activity(*)\Low Power Transitions (Lifetime), \Physical Network Interface Card Activity(*)\% Time Suspended (Lifetime), \Physical Network Interface Car
                     d Activity(*)\% Time Suspended (Instantaneous), \Physical Network Interface Card Activity(*)\Device Power State}
PathsWithInstances : {\Physical Network Interface Card Activity(Intel(R) Ethernet Connection (2) I219-V)\Low Power Transitions (Lifetime), \Physical Network Interface Card Activity(Intel(R) Ethernet Connect
                     ion (2) I219-V)\% Time Suspended (Lifetime), \Physical Network Interface Card Activity(Intel(R) Ethernet Connection (2) I219-V)\% Time Suspended (Instantaneous), \Physical Network Inter
                     face Card Activity(Intel(R) Ethernet Connection (2) I219-V)\Device Power State}
Counter            : {\Physical Network Interface Card Activity(*)\Low Power Transitions (Lifetime), \Physical Network Interface Card Activity(*)\% Time Suspended (Lifetime), \Physical Network Interface Car
                     d Activity(*)\% Time Suspended (Instantaneous), \Physical Network Interface Card Activity(*)\Device Power State}


# Network Activity
CounterSetName     : Per Processor Network Interface Card Activity
MachineName        : .
CounterSetType     : MultiInstance
Description        : Per Processor Network Interface Card Activity 計數器組可依每個處理器測量網路介面卡上的網路活動。
Paths              : {\Per Processor Network Interface Card Activity(*)\Packets Coalesced/sec, \Per Processor Network Interface Card Activity(*)\DPCs Deferred/sec, \Per Processor Network Interface Card Acti
                     vity(*)\Tcp Offload Send bytes/sec, \Per Processor Network Interface Card Activity(*)\Tcp Offload Receive bytes/sec...}
PathsWithInstances : {\Per Processor Network Interface Card Activity(0, Fortinet Virtual Ethernet Adapter (NDIS 6.30))\Packets Coalesced/sec, \Per Processor Network Interface Card Activity(0, Hyper-V Virtua
                     l Ethernet Adapter)\Packets Coalesced/sec, \Per Processor Network Interface Card Activity(0, Hyper-V Virtual Ethernet Adapter #2)\Packets Coalesced/sec, \Per Processor Network Interface
                      Card Activity(0, Hyper-V Virtual Switch Extension Adapter)\Packets Coalesced/sec...}
Counter            : {\Per Processor Network Interface Card Activity(*)\Packets Coalesced/sec, \Per Processor Network Interface Card Activity(*)\DPCs Deferred/sec, \Per Processor Network Interface Card Acti
                     vity(*)\Tcp Offload Send bytes/sec, \Per Processor Network Interface Card Activity(*)\Tcp Offload Receive bytes/sec...}



#Time Service
CounterSetName     : Windows Time Service
MachineName        : .
CounterSetType     : SingleInstance
Description        : 「Windows 時間服務效能計數器」會顯示來自服務的時間同步執行階段資訊。請注意，該服務必須執行，才能顯示此資訊。
Paths              : {\Windows Time Service\NTP Server Outgoing Responses, \Windows Time Service\NTP Server Incoming Requests, \Windows Time Service\NTP Client Time Source Count, \Windows Time Service\NTP R
                     oundtrip Delay...}
PathsWithInstances : {}
Counter            : {\Windows Time Service\NTP Server Outgoing Responses, \Windows Time Service\NTP Server Incoming Requests, \Windows Time Service\NTP Client Time Source Count, \Windows Time Service\NTP R
                     oundtrip Delay...}


#>