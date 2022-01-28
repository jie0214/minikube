##限制頻寬流量
aws configure set default.s3.max_bandwidth 2MB/s
aws configure set default.s3.max_concurrent_requests 1
aws configure set default.s3.max_queue_size 10