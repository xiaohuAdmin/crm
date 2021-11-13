package com.hu.crm.workbench.service;

import com.hu.crm.vo.PaginationVO;
import com.hu.crm.workbench.domain.Tran;
import com.hu.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface transactionService {
    boolean save(Tran tran, String customerName);

    PaginationVO<Tran> pageList(Map<String, Object> map);

    Tran detail(String id);

    List<Tran> getTranListByCustomerId(String customerId);

    List<TranHistory> getHistoryListByTranId(String tranId);

    boolean changeStage(Tran t);

    Map<String, Object> getCharts();
}
