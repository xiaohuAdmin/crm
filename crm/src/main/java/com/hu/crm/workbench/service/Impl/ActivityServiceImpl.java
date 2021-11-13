package com.hu.crm.workbench.service.Impl;

import com.hu.crm.settings.dao.UserDao;
import com.hu.crm.settings.domain.User;
import com.hu.crm.settings.service.UserService;
import com.hu.crm.vo.PaginationVO;
import com.hu.crm.workbench.dao.ActivityDao;
import com.hu.crm.workbench.dao.ActivityRemarkDao;
import com.hu.crm.workbench.domain.Activity;
import com.hu.crm.workbench.domain.ActivityRemark;
import com.hu.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Resource
    private UserDao userDao;
    @Resource
    private ActivityDao activityDao;
    @Resource
    private ActivityRemarkDao activityRemarkDao;
    @Override
    public boolean save(Activity at) {
        boolean flag=true;
        int count= activityDao.save(at);
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public PaginationVO<Activity> pageList(Map<String, Object> map) {
        //获取到查询出来的总记录数total
        int total=activityDao.getTotalByCondition(map);
        //获取到市场活动信息列表 dataList
        List<Activity> dataList=activityDao.getActivityListByCondition(map);
        //封装到vo对象
        PaginationVO<Activity> vo=new PaginationVO<Activity>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        //返回vo
        return vo;
    }

    @Override
    public boolean delete(String[] ids) {
        //市场活动关联的有市场活动备注表
        //要先删除市场活动就必须先删除市场活动备注
        boolean flag=true;
        //查询出应该删除的备注的数量
        int count1=activityRemarkDao.getCountByAids(ids);
        //返回实际影响数据库条数的数量
        int count2=activityRemarkDao.deleteByAids(ids);

        //如果应该删除的备注条数 和 实际删除的备注条数 不一样的话 删除失败
        if (count1!=count2){
            flag=false;
        }

        //删除市场活动
        int count3= activityDao.delete(ids);

        //如果删除的市场活动跟传递的市场活动id的长度不一致 删除失败
        if (count3!= ids.length){
            flag=false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndActivity(String id) {
        //取得uList
        List<User> uList = userDao.getUserList();
        //取activity
        Activity activity= activityDao.getActivity(id);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("uList",uList);
        map.put("a",activity);
        return map;
    }

    @Override
    public boolean update(Activity activity) {
        boolean flag=true;
        int count= activityDao.update(activity);

        if (count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public Activity detail(String id) {
        Activity a= activityDao.detail(id);
        return a;
    }

    @Override
    public List<ActivityRemark> getRemarkListByAid(String activityId) {
        List<ActivityRemark> arList=activityRemarkDao.getRemarkListByAid(activityId);
        return arList;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag=true;
        int Count=activityRemarkDao.deleteRemark(id);
        if(Count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(ActivityRemark ar) {
        Boolean flag=true;
        int Count=activityRemarkDao.saveRemark(ar);
        if(Count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(ActivityRemark ar) {
        Boolean flag=true;
        int Count=activityRemarkDao.updateRemark(ar);
        if(Count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public List<Activity> getActivityListByClueId(String clueId) {
        List<Activity> aList= activityDao.getActivityListByClueId(clueId);
        return aList;
    }

    @Override
    public List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map) {
        List<Activity> aList= activityDao.getActivityListByNameAndNotByClueId(map);
        return aList;
    }

    @Override
    public Map<String, Object> getCharts() {
        //取得total
        int total = activityDao.getTotal();


        //取得dataList
        List<Map<String,Object>> dataList = activityDao.getCharts();

        //将total和dataList保存到map中
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("total", total);
        map.put("dataList", dataList);

        //返回map
        return map;
    }


}
