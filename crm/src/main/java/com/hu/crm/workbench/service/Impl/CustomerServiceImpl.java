package com.hu.crm.workbench.service.Impl;

import com.hu.crm.settings.dao.UserDao;
import com.hu.crm.settings.domain.User;
import com.hu.crm.vo.PaginationVO;
import com.hu.crm.workbench.dao.*;
import com.hu.crm.workbench.domain.*;
import com.hu.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {
    @Resource
    private CustomerDao customerDao;//客户表
    @Resource
    private CustomerRemarkDao customerRemarkDao; //客户备注表
    @Resource
    private TranDao tranDao;//交易表
    @Resource
    private UserDao userDao;//用户表
    @Resource
    private ContactsDao contactsDao;//联系人表


    @Override
    //保存客户
    public boolean save(Customer ct) {
        boolean flag=true;
        int  count=customerDao.save(ct);
        if (count!=1) {
            flag=false;
        }
        return flag;
    }

    @Override
    //分页
    public PaginationVO<Customer> pageList(Map<String, Object> map) {
        //获取到查询出来的总记录数total
        int total=customerDao.getTotalByCondition(map);
        //获取到市场活动信息列表 dataList
        List<Customer> dataList=customerDao.getCustomerListByCondition(map);

        //封装到vo对象
        PaginationVO<Customer> vo=new PaginationVO<Customer>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        //返回vo
        return vo;
    }

    @Override
    public boolean delete(String[] ids) {
        //客户关联的有客户活动备注表，交易表，市场活动表
        //要先删除客户就必须先删除客户活动备注表
        boolean flag=true;
        //查询出应该删除的备注的数量
        int count1=customerRemarkDao.getCountByAids(ids);
        //返回实际影响数据库条数的数量
        int count2=customerRemarkDao.deleteByAids(ids);
        //如果应该删除的备注条数 和 实际删除的备注条数 不一样的话 删除失败
        if (count1!=count2){
            flag=false;
        }
        //要先删除客户就必须先删除客户交易表

        //查询出应该删除的交易表的数量
        int count3=tranDao.getCountByAids(ids);
        //返回实际影响数据库条数的数量
        int count4=tranDao.deleteByAids(ids);
        //如果应该删除的交易表条数 和 实际删除的交易表条数 不一样的话 删除失败
        if (count3!=count4){
            flag=false;
        }
        int count5= customerDao.delete(ids);
        //如果删除的市场活动跟传递的市场活动id的长度不一致 删除失败
        if (count5!= ids.length){
            flag=false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndCustomer(String id) {
        //取得uList
        List<User> uList = userDao.getUserList();
        //取activity
        Customer customer= customerDao.getCustomer(id);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("uList",uList);
        map.put("a",customer);
        return map;
    }

    @Override
    public boolean update(Customer customer) {
        boolean flag=true;
        int count= customerDao.update(customer);

        if (count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public Customer detail(String id) {
        Customer customer= customerDao.detail(id);
        return customer;
    }

    @Override
    public List<CustomerRemark> getRemarkListByAid(String customerId) {
        List<CustomerRemark> arList=customerRemarkDao.getRemarkListByAid(customerId);
        return arList;
    }

    @Override
    public boolean saveRemark(CustomerRemark cr) {
        Boolean flag=true;
        int Count=customerRemarkDao.saveRemark(cr);
        if(Count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag=true;
        int Count=customerRemarkDao.deleteRemark(id);
        if(Count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(CustomerRemark cr) {
        Boolean flag=true;
        int Count=customerRemarkDao.updateRemark(cr);
        if(Count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public String selectCustomerByName(String customerName) {
        //Customer customer= customerDao.selectCustomerByName(customerName);
        Customer customer= null;
        if (customer!=null){
           String id= customer.getId();
            return id;
        }
        return "false";
    }

    @Override
    public List<String> getCustomerName(String name) {
        List<String> sList=  customerDao.getCustomerName(name);
        return sList;
    }

    @Override
    public List<Contacts> getContactsListByAid(String customerId) {
        List<Contacts> cList=contactsDao.getContactsListByAid(customerId);
        return cList;
    }
}


