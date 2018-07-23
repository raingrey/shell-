#!/bin/bash
#检测是否联网，要是断网就发送登录curl
#@dark_jadeite
#2018.7.20

echo "检测是否联网，如果断网就发送登录curl"
if [ $# -ge 2 ]
then
user=$1
passwd=$2
else
echo "用户名和密码是必须的"
exit 1
fi

if [ $# -eq 3 ]
then
echo "检测间隔：$3"
interval_time=$3
else
interval_time=10
echo "检测间隔：10"
fi

log_name="log1"
echo "启动时间 "`date "+%Y-%m-%d %H:%M:%S"`>>$log_name
echo "\n\n">>$log_name

counter=0
while true 
do
	for url in "8.8.8.8" "61.139.2.69" "114.114.114.114" "168.95.1.1" "223.5.5.5" "180.76.76.76"
	do
		echo "PING ${url}">>$log_name

		ping=`ping -c 3 ${url}|awk 'NR==7 {print $4}'`

		if [ ${ping} -eq 0 ]
		then
			ping_ok=0
			echo "ping:${url} fault!">>$log_name
		else
			ping_ok=1
			echo "ping:${url} ok!">>$log_name
			break
		fi
	done
#检测结果处理
	if [ ${ping_ok} -ne 1 ]
	then
		curl -d "opr=pwdLogin&pwd=$passwd&rememberPwd=1&userName=$user" http://1.1.1.3/ac_portal/log_namein.php
		echo "发生重新登录">>$log_name
	fi

	echo "检测时间 "`date "+%Y-%m-%d %H:%M:%S"`>>$log_name
	echo "---------第$counter 次检测--------">>$log_name
	sleep $interval_time
	counter=`expr $counter + 1`

	if [ $(($counter/$interval_time%8640)) -eq 0 ]
	then
		log_name="log2"
	elif [ $(($counter/$interval_time%17280)) -eq 0 ]
	then

		log_name="log1"
		rm -f $log_name
	fi
	echo "$(($counter/$interval_time%8640))"
done
