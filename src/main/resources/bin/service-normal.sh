# export：用于设置或显示环境变量
# export [-fnp][变量名称]=[变量设置值]
export JAVA_HOME=$JAVA_HOME
export JRE_HOME=$JAVA_HOME

# 变量赋值，反斜杠为转义
# API_NAME+JAR_NAME 包名 第二个参数传jar名称
API_NAME=$2
JAR_NAME=../lib/$API_NAME\.jar
# 启动日志名
LOG_NAME=../../$API_NAME\.log
#PID  代表是PID文件
PID=../../$API_NAME\.pid


# 方法：使用说明，用来提示输入参数
formatDescription() {
	# echo：输出字符串
	# -e：开启转义
	echo -e "===============Please use the following format==================\n"
 	echo -e ">>>      sh service.sh [start|debug|stop|restart|status]      <<<"
    echo -e "\n==============================================================="
	# exit  0：正常运行程序并退出程序；
	# exit  1：非正常运行导致退出程序；
	exit 1
}

# 方法：检查程序是否在运行
checkStatus(){
	# ps -ef|grep $JAR_NAME 匹配进程中包名
	# grep -v 参数 : 过滤 匹配参数
	# awk '{print $2}' 匹配第二个参数
	# $0 就是你写的shell脚本本身的名字
	# $1 是你给你写的shell脚本传的第一个参数
	# $2 是你给你写的shell脚本传的第二个参数
	pid=`ps -ef|grep $JAR_NAME|grep -v grep|awk '{print $2}' `
	# if then、elif then、else、fi
	# [ -z STRING ]  “STRING” 的长度为零则为真
	# 如果不存在返回1，存在返回0
	if [ -z "${pid}" ]; then
		return 1
	else
		return 0
	fi
}

# 方法：启动方法
startService(){
	# 调用shell内的方法
	checkStatus
	# $?:获取函数返回值或者上一个命令的退出状态
	# -eq : 等于
	if [ $? -eq "0" ]; then
		echo ">>> ${JAR_NAME} is already running, PID=${pid} <<<"
	else
		# nohup + & ：后台运行
		# >$LOG_NAME ： 将日志信息输出到log日志中
		# 0 表示stdin标准输入
		# 1 表示stdout标准输出
		# 2 表示stderr标准错误
		# & 相当于等效于标准输出
		# 2>&1 是将标准错误信息转变成标准输出，这样就可以将错误信息输出到out.log 日志里面来
		# -noverify：关闭字节码验证
		# java -jar XXX.jar ：执行jar
		nohup $JRE_HOME/bin/java -server -Xms68m -Xmx68m -Xmn48m -Xss256K -Dspring.config.location=../config/application.yml -Dloader.path=../lib,resources,lib -jar $JAR_NAME >$LOG_NAME 2>&1 &
		# $! Shell最后运行的后台Process的PID
		# '>'  为创建： echo “hello shell”  > out.txt
		# '>>' 为追加：echo “hello shell”  >> out.txt
		# 将进程的pid输出到.pid文件中（PID=$API_NAME\.pid）
		echo $! > $PID
		echo ">>>  ${JAR_NAME} start successfully, PID=$! <<<"
	fi
}

# 方法：debug方法
debugService(){
  checkStatus
  if [ $? -eq "0" ]; then
    echo ">>> ${JAR_NAME} is already running, PID=${pid} <<<"
  else
    nohup $JRE_HOME/bin/java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005 -Xms128m -Xmx256m -Dspring.config.location=../config/application.yml -Dloader.path=../lib,resources,lib -jar $JAR_NAME >$LOG_NAME 2>&1 &
    echo $! > $PID
    echo ">>>  ${JAR_NAME} start in debug mode successfully, PID=$! <<<"
   fi
}

# 方法：停止方法
stopService(){
  # cat读取PID文件
  pidf=$(cat $PID)
  #echo "$pidf"
  echo ">>> ${JAR_NAME} begin kill, $pidf <<<"
  # kill 杀进程
  kill $pidf
  # rm -rf ： 删除文件
  rm -rf $PID
  # 休眠3s
  sleep 3
  checkStatus
  if [ $? -eq "0" ]; then
    echo ">>> kill failed, kill it forcefully <<<"
	echo ">>>  ${JAR_NAME} begin kill -9 $pid <<<"
	# kill -9 强制杀进程
    kill -9  $pid
    sleep 3
	# 无需确认，进程biss
    echo ">>> ${JAR_NAME} has been killed	<<<"
  else
    echo ">>> ${JAR_NAME} has stopped <<<"
  fi
}

# 方法：重启
restartService(){
  stopService
  startService
}

# 方法：输出运行状态
statusService(){
  checkStatus
  if [ $? -eq "0" ]; then
    echo ">>> ${JAR_NAME} is running, PID=${pid} <<<"
  else
    echo ">>> ${JAR_NAME} is not running <<<"
  fi
}

# 根据输入参数，选择执行对应方法，不输入则执行使用说明
# case expression in
# 	pattern 1)
# 		statement1
# 		;;
# 	pattern 2)
# 		statement2
# 		;;
# ……
# 	*)
# 		statementn
# esac
case "$1" in
  "start")
    startService
    ;;
  "stop")
    stopService
    ;;
  "status")
    statusService
    ;;
  "restart")
    restartService
    ;;
  "debug")
    debugService
    ;;
  *)
    formatDescription
    ;;
esac
exit 0