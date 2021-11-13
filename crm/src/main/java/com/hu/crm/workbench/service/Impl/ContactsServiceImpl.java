package com.hu.crm.workbench.service.Impl;

import com.hu.crm.settings.dao.UserDao;
import com.hu.crm.utils.DateTimeUtil;
import com.hu.crm.utils.UUIDUtil;
import com.hu.crm.vo.PaginationVO;
import com.hu.crm.workbench.dao.*;
import com.hu.crm.workbench.domain.Activity;
import com.hu.crm.workbench.domain.Contacts;
import com.hu.crm.workbench.domain.ContactsRemark;
import com.hu.crm.workbench.domain.Customer;
import com.hu.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class ContactsServiceImpl implements ContactsService {
    @Resource
    private UserDao userDao; //用户表
    @Resource
    private ContactsDao contactsDao; //联系人表
    @Resource
     private CustomerDao customerDao; //顾客表

    @Override
    public PaginationVO<Contacts> pageList(Map<String, Object> map) {
        //根据客户名字查询客户的id

        //获取到查询出来的总记录数total
        int total=contactsDao.getTotalByCondition(map);
        //获取到市场活动信息列表 dataList
        List<Contacts> dataList=contactsDao.getContactsListByCondition(map);
        //封装到vo对象
        PaginationVO<Contacts> vo=new PaginationVO<Contacts>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        //返回vo
        return vo;
    }

    @Override
    public List<Contacts> getContactsListByName(String uname) {
        List<Contacts> cList= contactsDao.getContactsListByName(uname);
        return cList;
    }

    @Override
    public boolean save(Contacts ca, String customerName) {
        //
        boolean flag = true;

        Customer cus = customerDao.getCustomerByName(customerName);

        //如果cus为null，需要创建客户
        if(cus==null){

            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setName(customerName);
            cus.setCreateBy(ca.getCreateBy());
            cus.setCreateTime(DateTimeUtil.getSysTime());
            cus.setContactSummary(ca.getContactSummary());
            cus.setNextContactTime(ca.getNextContactTime());
            cus.setOwner(ca.getOwner());
            //添加客户
            int count1 = customerDao.save(cus);
            if(count1!=1){
                flag = false;
            }

        }
        //执行到这里,客户必有,从当中取出客户的id 封装进cus当中 执行保存联系人操作
        ca.setCustomerId(cus.getId());

        //保存联系人
         int count =contactsDao.save(ca);
         if (count!=1){
             flag=false;
         }

        return flag;
    }

    @Override
    public boolean save2(Contacts ca) {
        boolean flag = true;
        int count =contactsDao.save(ca);
        if (count!=1){
            flag=false;
        }

        return flag;
    }
}
