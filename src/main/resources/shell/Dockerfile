# 该镜像需要依赖的基础镜像
FROM openjdk:11-jdk
# 指定维护者的名字
MAINTAINER czj
ARG APP_NAME
ENV NAME=$APP_NAME
# 将当前目录下的jar包复制到docker容器的/目录下
ADD ${APP_NAME}.jar /home/${APP_NAME}.jar
# 将lib目录复制到容器里面
RUN mkdir -p /lib
COPY lib /lib
# 设置日志路径
VOLUME /logs
# 指定docker容器启动时运行jar包
ENTRYPOINT java -server -Xms68m -Xmx68m -Xmn48m -Xss256K -Dspring.config.location=/config/application.yml -Dfile.encoding=UTF-8 -Dloader.path=/lib,resources,lib -jar /home/$NAME.jar