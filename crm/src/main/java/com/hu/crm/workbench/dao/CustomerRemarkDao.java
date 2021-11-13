package com.hu.crm.workbench.dao;

import com.hu.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {
    int save(CustomerRemark customerRemark);

    int getCountByAids(String[] ids);

    int deleteByAids(String[] ids);

    List<CustomerRemark> getRemarkListByAid(String customerId);

    int saveRemark(CustomerRemark cr);

    int deleteRemark(String id);

    int updateRemark(CustomerRemark cr);
}
