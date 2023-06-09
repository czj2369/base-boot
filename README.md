# Base-boot

该项目为springboot基本脚手架，包括启动脚本，docker部署脚本，搭配jenkins使用最佳

## 使用方法

### 1.拉取本项目到本地

```
git clone https://github.com/czj2369/base-boot.git
```

### 2.配置项目

在release-note中配置对应的

name：项目名称，需要与pom.xml的artifactId保持一致

version：项目版本，需要与pom.xml的version保持一致

port：docker宿主机映射端口，可以与application.yml的server.port保持一致，只会影响docker启动方式的宿主机映射端口

具体使用位置为shell/jenkins-deploy-docker.sh

```
docker run -p $API_PORT:$API_PORT --name $API_NAME -v /home/logs/$API_NAME:/home/logs -d $API_NAME/$API_NAME:$API_VERSION
```

可以修改日志的打印目录，默认为/home/logs/{projectName}，修改log4j2.xml对应配置即可

### 3.拉取依赖

使用idea拉取项目的依赖

### 4.运行项目

项目成功启动后，浏览器http://localhost:10004/hello，是否正常响应，若出现Hello, World！则表示成功。

### 5.手动部署项目

先放开pom.xml注释的plugin代码，并修改main方法入口的class，接着使用maven打包，先clean再package，会在项目根目录产生target目录，该打包方式将依赖与项目本体分开，需将/target/lib下面的所有jar包放到base-boot-1.0.0-releases.zip/base-boot-1.0.0-releases.tar的/base-boot-1.0.0/lib下面，再将整个.zip/.tar上传到服务器，解压之后进入目录/bin，执行以下命令

```shell
sh service-normal.sh start 项目名-版本号
# 如 sh service-normal.sh start base-boot-1.0.0
```

### 6.jenkins部署项目

如果进行了第五步的，请还原

1.正常部署

在jenkins项目配置的Post Steps的选择Send files or execute commands over SSH ，且在Exec command输入以下指令

```shell
#!/usr/bin/env bash
cd /home/docker/jenkins/workspace/base-boot/target/classes/shell
sh jenkins-deploy-docker.sh 
```

2.docker部署

Exec command的指令为

```shell
#!/usr/bin/env bash
cd /home/docker/jenkins/workspace/base-boot/target/classes/shell
sh jenkins-deploy-docker.sh
```

注：请将路径中base-boot缓存maven打包之后的项目名