该项目为springboot基本脚手架
作用：
1.集成普通服务器部署方案以及Docker部署方案，只需要少数的配置即可实现部署
2.专注于逻辑代码的编写，减少无相关内容的干扰

配置：
1.日志路径：本项目使用log4j2日志框架，只需要对log4j2.xml修改<property name="logdir">/home/logs/${prjname}</property>即可配置日志打印位置
2.启动脚本：修改service.sh的JAR_NAME接口，如果启动失败，查看对应目录的log文件即可
3.部署方案：
本机：修改shell/jenkins-deploy.sh即可
docker：