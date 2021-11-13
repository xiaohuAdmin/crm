package com.hu.crm.workbench.web.controller;

import com.hu.crm.settings.domain.User;
import com.hu.crm.settings.service.UserService;
import com.hu.crm.utils.DateTimeUtil;
import com.hu.crm.utils.UUIDUtil;
import com.hu.crm.vo.PaginationVO;
import com.hu.crm.workbench.domain.Activity;
import com.hu.crm.workbench.domain.ActivityRemark;
import com.hu.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {
    @Resource
    private ActivityService  actService;
    @Resource
    private UserService userService;

    @ResponseBody
    @RequestMapping("/getUserList.do")
    public List<User> getUserList(){
        System.out.println("进入市场活动模块-获取用户列表");
        List<User> userList=userService.getUserList();
        return userList;
    }
    @ResponseBody
    @RequestMapping("/save.do")
    public boolean save(Activity at, HttpServletRequest request){
        System.out.println("进入市场活动模块-执行市场活动添加操作");
        String id= UUIDUtil.getUUID();
        //创建时间,当前系统时间
        String createTime= DateTimeUtil.getSysTime();
        //创建人
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        at.setId(id);
        at.setCreateTime(createTime);
        at.setCreateBy(createBy);
        boolean flag= actService.save(at);
        return flag;
    }
    @ResponseBody
    @RequestMapping("/pageList.do")
    public PaginationVO<Activity> pageList(String name, String owner, String startDate,
                                           String endDate, Integer pageNo,Integer pageSize){
        System.out.println("进入市场活动模块-进入到分页查询操作");
        //        计算出略过的数量
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        PaginationVO<Activity> vo=actService.pageList(map);
        return vo;
    }
    @ResponseBody
    @RequestMapping("/delete.do")
    //@RequestParam前端传递的变量和后端接收的变量名字不一致时,用注解@RequestParam来实现数据的传递
    public boolean delete(@RequestParam("id") String[] ids){
        System.out.println("进入市场活动模块-执行市场活动删除操作");
        boolean flag= actService.delete(ids);
        return flag;
    }

    @ResponseBody
    @RequestMapping("/getUserListAndActivity.do")
    public Map<String,Object> getUserListAndActivity(String id){
        System.out.println("进入市场活动模块-通过用户勾选id查找该id对应的市场活动以及用户信息");
        Map<String,Object> map= actService.getUserListAndActivity(id);
        return map;
    }
    @ResponseBody
    @RequestMapping("/update.do")
    public boolean update(Activity activity,HttpServletRequest request){
        System.out.println("进入市场活动模块-执行市场活动信息修改操作");
        //修改时间：当前系统时间
        String editTime = DateTimeUtil.getSysTime();
        //修改人：当前登录用户
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        activity.setEditTime(editTime);
        activity.setEditBy(editBy);
        boolean flag= actService.update(activity);
        return flag;
    }
    @ResponseBody
    @RequestMapping("/detail.do")
    public ModelAndView detail(String id){
        System.out.println("进入市场活动模块-进入到查看详细页面操作");
        ModelAndView mv=new ModelAndView();
        Activity activity=actService.detail(id);
        mv.addObject("activity",activity);
        mv.setViewName("/activity/detail");
        return mv;
    }

    @ResponseBody
    @RequestMapping("/getRemarkListByAid.do")
    public List<ActivityRemark> getRemarkListByAid(String activityId){
        System.out.println("进入市场活动模块-根据市场活动id，取得备注信息列表");
        List<ActivityRemark> list=actService.getRemarkListByAid(activityId);
        return list;
    }
    @ResponseBody
    @RequestMapping("/deleteRemark.do")

    public boolean deleteRemark(String id){
        System.out.println("进入市场活动模块-删除备注操作");
        boolean flag=actService.deleteRemark(id);
        return flag;
    }
    @ResponseBody
    @RequestMapping("/SaveRemark.do")
    public Map<String ,Object> saveRemark(ActivityRemark ar,HttpServletRequest request){
        System.out.println("进入市场活动模块-执行备注添加操作");
        String id =UUIDUtil.getUUID();
        String createTime= DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        String editFlag="0";
        ar.setId(id);
        ar.setCreateBy(createBy);
        ar.setCreateTime(createTime);
        ar.setEditFlag(editFlag);
        boolean flag=actService.saveRemark(ar);
        Map<String ,Object> map=new HashMap<>();
        map.put("success",flag);
        map.put("ar",ar);
        return map;
    }
    @ResponseBody
    @RequestMapping("/updateRemark.do")
    public Map<String ,Object> updateRemark(ActivityRemark ar,HttpServletRequest request){
        System.out.println("进入市场活动模块-执行修改备注的操作");
        String editTime= DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("user")).getName();
        String editFlag="1";
        ar.setEditFlag(editFlag);
        ar.setEditTime(editTime);
        ar.setEditBy(editBy);
        boolean flag=actService.updateRemark(ar);
        Map<String ,Object> map=new HashMap<>();
        map.put("success",flag);
        map.put("ar",ar);
        return map;
    }
    @ResponseBody
    @RequestMapping("/cost.do")
    public Map<String ,Object> cost(){
        Map<String,Object> map= actService.getCharts();

        return map;
    }

}
