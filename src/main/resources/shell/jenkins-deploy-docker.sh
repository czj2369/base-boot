#!/usr/bin/env bash
API_NAME=''
API_VERSION=''
API_PORT=''

while read line
do
  config=(${line//=/ })
  if [[ ${config[0]} == "API_NAME" ]]
  then
    API_NAME=${config[1]}
  elif [[ ${config[0]} == "API_VERSION" ]]
  then
    API_VERSION=${config[1]}
  else
    API_PORT=${config[1]}
  fi

  if [[ -n ${API_NAME} ]] && [[ -n ${API_VERSION} ]] && [[ -n ${API_PORT} ]]
  then
    break
  fi
done <<< "$(cat ./.env)"

cp ./../$API_NAME-$API_VERSION.jar ./$API_NAME.jar
mkdir lib
cp ./../lib/* ./lib/

docker stop $API_NAME
docker rm $API_NAME
docker rmi $API_NAME/$API_NAME:$API_VERSION
# -t 表示指定镜像仓库名称/镜像名称:镜像标签 .表示使用当前目录下的Dockerfile
docker build -t $API_NAME/$API_NAME:$API_VERSION .
docker compose up -d
