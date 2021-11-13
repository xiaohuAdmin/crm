package com.hu.crm.workbench.dao;

import com.hu.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {
    int save(Clue clue);

    int getTotalByCondition(Map<String, Object> map);


    List<Clue> getClueListByCondition(Map<String, Object> map);

    int delete(String[] ids);


    Clue datail(String id);

    Clue getClue(String id);

    int update(Clue clue);

    Clue getById(String clueId);


    int delete2(String clueId);
}
