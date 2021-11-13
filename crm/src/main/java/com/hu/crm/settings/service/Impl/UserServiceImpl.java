package com.hu.crm.settings.service.Impl;

import com.hu.crm.exception.LoginException;
import com.hu.crm.settings.dao.UserDao;
import com.hu.crm.settings.domain.User;
import com.hu.crm.settings.service.UserService;
import com.hu.crm.utils.DateTimeUtil;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {
    @Resource
    private UserDao userDao;
    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        Map<String,String> map=new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user=userDao.login(map);
        if (user==null){
            throw new LoginException("账号或密码错误");
        }
        String UserIp= user.getAllowIps();
        if (!UserIp.contains(ip)){
            throw new LoginException("账号ip受限");
        }
        String expireTime =user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if (expireTime.compareTo(currentTime)<0){
            throw new LoginException("账号失效了！");
        }
        String lookState =user.getLockState();
        if ("0".equals(lookState)){
            throw new LoginException("账号已锁定！");
        }
        return user;
    }

    @Override
    public boolean updatePassWordBtn(Map<String, Object> map) {
        boolean flag=true;
        int count=userDao.updatePassWordBtn(map);
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public List<User> getUserList() {
        List<User> userList= userDao.getUserList();
        return userList;
    }

}
