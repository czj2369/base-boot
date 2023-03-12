#!/usr/bin/env bash
# 配置jdk路径
export JAVA_HOME=/home/dev/jdk-11.0.17
# 配置jenkins映射本地workspace路径，最终路径为项目bin的启动脚本位置
cd /home/docker/jenkins/workspace/common-monitor/target/classes/shell
# -t 表示指定镜像仓库名称/镜像名称:镜像标签 .表示使用当前目录下的Dockerfile
docker build -t base-boot/base-boot:1.0.0 .
docker run -p 10002:10002 --name base-boot -v /home/logs/baseboot:/home/logs -d base-boot/base-boot:1.0.0