package com.hu.crm.workbench.dao;

import com.hu.crm.workbench.domain.Contacts;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ContactsDao {

    int save(Contacts con);

    int getTotalByCondition(Map<String, Object> map);

    List<Contacts> getContactsListByCondition(Map<String, Object> map);

    List<Contacts> getContactsListByName(String uname);

    List<Contacts> getContactsListByAid(String customerId);
}