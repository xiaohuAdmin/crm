package com.hu.crm.settings.web.controller;

import com.hu.crm.settings.domain.User;
import com.hu.crm.settings.service.UserService;
import com.hu.crm.utils.MD5Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {
    @Resource
    private UserService userService;

    @ResponseBody
    @RequestMapping("/login.do")
    public Map<String,Object> login(String loginAct, String loginPwd, HttpServletRequest request){
        System.out.println("进入到用户登录模块");
        loginPwd= MD5Util.getMD5(loginPwd);
        //获取用户ip
        String ip=request.getRemoteAddr();
        Map<String ,Object> map=new HashMap<>();
        try{
            User user= userService.login(loginAct,loginPwd,ip);
            //将用户信息保存到session作用域当中
            request.getSession().setAttribute("user",user);

            map.put("success",true);
        }catch (Exception e){
            e.printStackTrace();
            String msg= e.getMessage();
            map.put("success",false);
            map.put("msg",msg);
        }
        return map;
    }
    @ResponseBody
    @RequestMapping("/updatePassWordBtn.do")
    public String updatePassWordBtn(String loginAct,String passWord){
        System.out.println("进入到修改密码操作");
        String pw=MD5Util.getMD5(passWord);
        Map<String,Object>map=new HashMap<String, Object>();
        map.put("passWord",pw);
        map.put("loginAct",loginAct);
        boolean flag= userService.updatePassWordBtn(map);
        return "true";
    }

}
