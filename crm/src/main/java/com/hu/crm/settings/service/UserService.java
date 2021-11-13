package com.hu.crm.settings.service;

import com.hu.crm.exception.LoginException;
import com.hu.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    boolean updatePassWordBtn(Map<String, Object> map);

    List<User> getUserList();
}
