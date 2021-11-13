package com.hu.crm.settings.dao;

import com.hu.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {
    User login(Map<String, String> map);

    List<User> getUserList();

    int updatePassWordBtn(Map<String, Object> map);
}
