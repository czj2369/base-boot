#!/usr/bin/env bash
APP_NAME=''
APP_VERSION=''
APP_PORT=''

while read line
do
  config=(${line//=/ })
  if [[ ${config[0]} == "APP_NAME" ]]
  then
    APP_NAME=${config[1]}
  elif [[ ${config[0]} == "APP_VERSION" ]]
  then
    APP_VERSION=${config[1]}
  else
    APP_PORT=${config[1]}
  fi

  if [[ -n ${APP_NAME} ]] && [[ -n ${APP_VERSION} ]] && [[ -n ${APP_PORT} ]]
  then
    break
  fi
done <<< "$(cat ./.env)"

cp ./../$APP_NAME-$APP_VERSION.jar ./$APP_NAME.jar
mkdir lib
cp ./../lib/* ./lib/

docker stop $APP_NAME
docker rm $APP_NAME
docker rmi $APP_NAME/$APP_NAME:$APP_VERSION
# -t 表示指定镜像仓库名称/镜像名称:镜像标签 .表示使用当前目录下的Dockerfile
docker build --build-arg APP_NAME=$APP_NAME -t $APP_NAME/$APP_NAME:$APP_VERSION .
docker compose up -d
