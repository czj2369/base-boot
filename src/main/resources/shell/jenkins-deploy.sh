#!/usr/bin/env bash
API_NAME=''
API_VERSION=''
API_PORT=''

while read line
do
  config=(${line//=/ })
  if [[ ${config[0]} == "name" ]]
  then
          echo ${config[1]}
    API_NAME=${config[1]}
  elif [[ ${config[0]} == "version" ]]
  then
          echo ${config[1]}
    API_VERSION=${config[1]}
  else
    echo ${config[1]}
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
cd /home/docker/jenkins/workspace/$API_NAME/target/classes/bin
# 使用脚本启动项目
sh service.sh restart $API_NAME-API_VERSION