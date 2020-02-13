#!/bin/bash
# 构建ss_web_go的脚本
DOCKER_IMAGE="myruirui:v0.1"
DOCKER_CONTAINER="myruirui"
REPO="https://github.com/sunhongyue4500/ss_web_go.git"
APP="ss_web_go"
ORI_WEB_GO_DIR="/root/ss_web_go"

echo "script start"
# kill myruirui 容器
str=`docker ps | grep $DOCKER_CONTAINER | wc -l`
# echo $str
if [ $str -eq 1 ]; then
        docker kill $DOCKER_CONTAINER
fi

# rm myruirui:v0.1 镜像, grep 通过$DOCKER_CONTAINER
str=`docker image ls | grep $DOCKER_CONTAINER | wc -l`
# echo $str
if [ $str -eq 1 ]; then
        docker image rm $DOCKER_IMAGE
fi

# 从github上拉最新代码，
# 目录是否存在, 不存在则创建
if [ ! -d $ORI_WEB_GO_DIR ]
then
  mkdir -p $ORI_WEB_GO_DIR
  cd $ORI_WEB_GO_DIR
  git clone $REPO
fi

cd $ORI_WEB_GO_DIR
# 拉取最新代码
git pull $REPO
# build 镜像
docker build -t $DOCKER_IMAGE .
echo "start container"
# run 容器
docker run --name $DOCKER_CONTAINER  -p 7777:7777 --rm $DOCKER_IMAGE




