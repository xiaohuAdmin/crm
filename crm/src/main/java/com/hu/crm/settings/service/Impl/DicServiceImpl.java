package com.hu.crm.settings.service.Impl;

import com.hu.crm.settings.dao.DicTypeDao;
import com.hu.crm.settings.dao.DicValueDao;
import com.hu.crm.settings.domain.DicType;
import com.hu.crm.settings.domain.DicValue;
import com.hu.crm.settings.service.DicService;
import com.hu.crm.utils.SqlSessionUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DicServiceImpl implements DicService {
    @Autowired
    private DicTypeDao dicTypeDao;
    @Autowired
    private DicValueDao dicValueDao;

    @Override
    public Map<String, List<DicValue>> getAll() {
        Map<String, List<DicValue>> map=new HashMap<String, List<DicValue>>();
        //将字典类型取出
        List<DicType>  dtList=dicTypeDao.getTypeList();
        //遍历集合 取出每一种类型的字典编码
        for(DicType dt:dtList){
            String code=dt.getCode();
            //有了字典类型 在去调业务层去查找每一种类型对应的字典值
            List<DicValue> dvList =dicValueDao.getListByCode(code);
            map.put(code+"List",dvList);

        }
        return map;
    }
}
