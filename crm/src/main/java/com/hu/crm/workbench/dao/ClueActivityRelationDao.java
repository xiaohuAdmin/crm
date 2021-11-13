package com.hu.crm.workbench.dao;

import com.hu.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {
    int unbund(String id);


    int bund(ClueActivityRelation car);

    int getCountByAids(String[] ids);

    int deleteByAids(String[] ids);

    List<ClueActivityRelation> getListByClueId(String clueId);


}
