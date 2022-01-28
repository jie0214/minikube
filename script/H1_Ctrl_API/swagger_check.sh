#!/bin/bash


check=$(curl -X GET http://192.168.168.64:$1/swagger/index.html | grep swagger-ui | wc -l)

d=`date +%y%m%d-%H:%M:%S`
time=`date +%y%m%d_%H-%M`

echo [$d] Catch Line:$check >> /var/log/swagger_check.log

if [ $check = 0 ]
then
        echo [$d] swagger_$1 is Down >> /var/log/swagger_check.log

        docker inspect jsp_adminwebsite_v2_db_api_$1 > /var/log/jsp_adminwebsite_v2_db_api_$1.log-$time

        docker restart jsp_adminwebsite_v2_db_api_$1
        echo [$d] swagger_$1 is Up >> /var/log/swagger_check.log
else
        echo [$d] swagger_$1 is running >> /var/log/swagger_check.log
fi
