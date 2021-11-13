package com.hu.crm.workbench.service;

import com.hu.crm.vo.PaginationVO;
import com.hu.crm.workbench.domain.Contacts;
import com.hu.crm.workbench.domain.Customer;
import com.hu.crm.workbench.domain.CustomerRemark;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    boolean save(Customer ct);

    PaginationVO<Customer> pageList(Map<String, Object> map);

    boolean delete(String[] ids);

    Map<String, Object> getUserListAndCustomer(String id);

    boolean update(Customer customer);

    Customer detail(String id);

    List<CustomerRemark> getRemarkListByAid(String customerId);

    boolean saveRemark(CustomerRemark cr);

    boolean deleteRemark(String id);

    boolean updateRemark(CustomerRemark cr);

    String selectCustomerByName(String customerName);

    List<String> getCustomerName(String name);

    List<Contacts> getContactsListByAid(String customerId);
}
