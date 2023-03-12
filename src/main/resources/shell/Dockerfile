# 该镜像需要依赖的基础镜像
FROM openjdk:11-jdk
# 指定维护者的名字
MAINTAINER czj
# 将当前目录下的jar包复制到docker容器的/目录下
ADD base-boot.jar /home/base-boot.jar
# 设置日志路径
VOLUME /home/logs
# 运行过程中创建一个mall-tiny-docker-file.jar文件
RUN bash -c 'touch /home/base-boot.jar'
# 声明服务运行在xx端口
EXPOSE 10004
# 指定docker容器启动时运行jar包
ENTRYPOINT ["java", "-server","-Xms68m","-Xmx68m","-Xmn48m","-Xss256K","-jar","/home/base-boot.jar"]
