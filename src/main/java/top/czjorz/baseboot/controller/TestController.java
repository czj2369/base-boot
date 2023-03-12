package top.czjorz.baseboot.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author czj
 * @date 2023/3/12
 * @describe testController
 */
@RestController
public class TestController {
    @RequestMapping("/hello")
    public String helloWorld(){
        return "Hello, World!";
    }
}
