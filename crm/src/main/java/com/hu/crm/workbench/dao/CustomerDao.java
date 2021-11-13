package com.hu.crm.workbench.dao;

import com.hu.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerDao {

    Customer getCustomerByName(String company);

    int save(Customer customer);

    int getTotalByCondition(Map<String, Object> map);


    List<Customer> getCustomerListByCondition(Map<String, Object> map);


    Customer getCustomer(String id);

    int update(Customer customer);

    int delete(String[] ids);

    Customer detail(String id);

    //
    int insertCustomer(Customer customer);

    List<String> getCustomerName(String name);
}
