package com.hu.crm.workbench.dao;

import com.hu.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {
    int save(Tran t);

    int getCountByAids(String[] ids);

    int deleteByAids(String[] ids);

    int getTotalByCondition(Map<String, Object> map);

    List<Tran> getActivityListByCondition(Map<String, Object> map);

    List<Tran> getTranListByCustomerId(String customerId);

    Tran detail(String id);

    int getTotal();

    List<Map<String, Object>> getCharts();

    int changeStage(Tran t);
}
