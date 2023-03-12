#!/usr/bin/env bash
# 配置jdk路径
export JAVA_HOME=/home/dev/jdk-11.0.17
# 配置jenkins映射本地workspace路径，最终路径为项目bin的启动脚本位置
cd /home/docker/jenkins/workspace/common-monitor/target/classes/bin
# 使用脚本启动项目
sh service.sh restart common-monitor-1.0