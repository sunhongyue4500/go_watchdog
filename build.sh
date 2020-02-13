#!/bin/bash
# 构建go程序的脚本
APP="go_watchdog"
APPFILE=$APP".go"
GOBIN="/root/go/bin"
SHELLNAME="watchdog.sh"
PROCESS=`ps -aux | grep ./$APP | grep -v grep | awk '{print $2}'`

for i in $PROCESS
do
  echo "Kill the $1 process [ $i ]"
  kill -9 $i
done

if [ -f $APPFILE ]; then
  echo "install"
  go install $APPFILE
  cp $SHELLNAME $GOBIN
  cd $GOBIN
  echo "excecute"
  nohup ./$APP &
fi


