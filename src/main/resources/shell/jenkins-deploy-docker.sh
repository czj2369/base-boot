#!/usr/bin/env bash
API_NAME=''
API_VERSION=''
API_PORT=''

while read line
do
  config=(${line//=/ })
  if [[ ${config[0]} == "name" ]]
  then
    API_NAME=${config[1]}
  elif [[ ${config[0]} == "version" ]]
  then
    API_VERSION=${config[1]}
  else
    API_PORT=${config[1]}
  fi

  if [[ -n ${API_NAME} ]] && [[ -n ${API_VERSION} ]] && [[ -n ${API_PORT} ]]
  then
    break
  fi
done <<< "$(cat ../release-note)"

# 配置jdk路径
export JAVA_HOME=/home/dev/jdk-11.0.17
# 配置jenkins映射本地workspace路径，最终路径为项目bin的启动脚本位置
cd /home/docker/jenkins/workspace/$API_NAME/target/classes/shell
cp ../../$API_NAME-$API_VERSION.jar $API_NAME.jar
# -t 表示指定镜像仓库名称/镜像名称:镜像标签 .表示使用当前目录下的Dockerfile
docker build -t $API_NAME/$API_NAME:$API_VERSION .
docker stop $API_NAME
docker rm $API_NAME
docker run -p $API_PORT:$API_PORT --name $API_NAME -v /home/logs/$API_NAME:/home/logs -d $API_NAME/$API_NAME:$API_VERSION
