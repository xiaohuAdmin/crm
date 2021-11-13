package com.hu.crm.workbench.service;

import com.hu.crm.vo.PaginationVO;
import com.hu.crm.workbench.domain.Activity;
import com.hu.crm.workbench.domain.Clue;
import com.hu.crm.workbench.domain.ClueRemark;
import com.hu.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    boolean save(Clue clue);

    PaginationVO<Clue> pageList(Map<String, Object> map);

    boolean delete(String[] ids);

    Clue detail(String id);

    List<ClueRemark> getRemarkListByAid(String clueId);

    boolean unbund(String id);

    boolean bund(String cid, String[] aids);

    Map<String, Object> getUserListcAndClue(String id);

    boolean update(Clue clue);

    List<Activity> getActivityListByName(String aname);

    boolean convert(String clueId, Tran t, String createBy);
}
