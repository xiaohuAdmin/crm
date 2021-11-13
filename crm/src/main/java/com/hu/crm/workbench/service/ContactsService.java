package com.hu.crm.workbench.service;

import com.hu.crm.vo.PaginationVO;
import com.hu.crm.workbench.domain.Activity;
import com.hu.crm.workbench.domain.Contacts;
import com.hu.crm.workbench.domain.ContactsRemark;
import com.hu.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ContactsService {

    PaginationVO<Contacts> pageList(Map<String, Object> map);


    List<Contacts> getContactsListByName(String uname);

    boolean save(Contacts ca, String customerName);

    boolean save2(Contacts ca);
}
