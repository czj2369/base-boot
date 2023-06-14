package top.czjorz.baseboot.aop;

import com.alibaba.fastjson.JSON;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;

/**
 * @author czj
 * @date 2023/6/14
 * @describe 日志打印切面
 */
@Aspect
@Component
@Slf4j
public class LogAop {
    @Pointcut("execution(public * top.czjorz.baseboot.controller..*.*(..))")
    public void logCut() {
    }

    @Before("logCut()")
    public void deBefore(JoinPoint joinPoint) {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes.getRequest();
        StringBuffer sb = new StringBuffer();
        sb.append("\n=============================START=======================\n")
                .append("URL            :" + request.getRequestURL().toString() + "\n")
                .append("TOKEN          :" + JSON.toJSONString(request.getHeaderNames()) + "\n")
                .append("HTTP METHOD    :" + request.getMethod() + "\n")
                .append("CLASS METHOD   :" + joinPoint.getSignature().getDeclaringTypeName() + "." + joinPoint.getSignature().getName() + "\n")
                .append("IP             :" + request.getRemoteAddr() + "\n")
                .append("REQUEST ARGS   :" + JSON.toJSONString(joinPoint.getArgs()) + "\n")
                .append("=============================END=======================\n");
        log.info(sb.toString());
    }
}
