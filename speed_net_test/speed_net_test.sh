#!/bin/bash
#实时测试某interface的网速
#1.第一参数为interface名，如eth0、wlan0、lo等
#2.第二参数为刷新间隔
#@dark_jadeite
#2018.7.23

if [ $# -eq 1 ]
then
interface=$1
interval_time=1
elif [ $# -eq 2 ]
then
interface=$1
interval_time=$2
else
interface="eth0"
interval_time=1
fi

while true
do
#接收数据包bytes
RX0=$(cat /proc/net/dev|grep $interface|sed 's/:/ /g'|awk '{print $2}')
#发送数据包bytes
TX0=$(cat /proc/net/dev|grep $interface|sed 's/:/ /g'|awk '{print $10}')
#隔秒
sleep 1
#再算一次接收数据包bytes
RX1=$(cat /proc/net/dev|grep $interface|sed 's/:/ /g'|awk '{print $2}')
#再算一次发送数据包bytes
TX1=$(cat /proc/net/dev|grep $interface|sed 's/:/ /g'|awk '{print $10}')
#清屏
#clear
echo "--------`date +%k:%M:%S`--------"
RX=$(($RX1 - $RX0))
TX=$(($TX1 - $TX0))

if [ $RX -le 1024 ]
then
RX="$RX B/s"
elif [ $RX -le 1248576 ]
then
RX=$(($RX / 1024))
RX="$RX KB/s"
else
RX=$(($RX / 1024 / 1024))
RX="$RX MB/s"
fi

if [ $TX -le 1024 ]
then
TX="$TX B/s"
elif [ $TX -le 1248576 ]
then
TX=$(($TX / 1024))
TX="$TX KB/s"
else
TX=$(($TX / 1024 / 1024))
TX="$TX MB/s"
fi

echo "当前网卡$interface----接收网速$RX----发送网速$TX"
sleep $interval_time
done
