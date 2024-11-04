# Base-boot

该项目为springboot基本脚手架，包括启动脚本，docker部署脚本，搭配jenkins使用最佳

# 环境要求

- docker
- docker compose

- maven
- git

# 使用方法

## 1.拉取本项目到本地

```
git clone https://github.com/czj2369/base-boot.git
```

## 2.打包

执行maven命令打包

```bash
mvn clean package
```

进入target目录

解压***-release.zip**

## 3.部署

进入解压目录的/bin目录

执行命令

```bash
sh jenkins-deploy-docker.sh
```

后续想停止可以执行

```bash
docker compose down
```

启动

```bash
docker compose up -d
```

## 4.验证

项目成功启动后，浏览器http://localhost:10004/hello，是否正常响应，若出现Hello, World！则表示成功。



# 配置项目

在bin/.env中配置对应的

API_NAME：项目名称，需要与pom.xml的artifactId保持一致

API_VERSION：项目版本，需要与pom.xml的version保持一致

API_PORT：项目对外端口，需要与application.yml中server.port一致

MAPPING_PORT：docker宿主机映射端口，可以与application.yml的server.port保持一致，只会影响docker启动方式的宿主机映射端口

CONFIG_PATH：配置文件目录，application.yml所在的目录

LOG_PATH：映射日志文件目录

可以修改日志的打印目录，默认为/home/logs/{projectName}，修改log4j2.xml对应配置即可

# jenkins部署项目

docker部署

Exec command的指令为

```shell
#!/usr/bin/env bash
cd /home/docker/jenkins/workspace/base-boot/target/classes/shell
sh jenkins-deploy-docker.sh
```

注：请将路径中base-boot缓存maven打包之后的项目名