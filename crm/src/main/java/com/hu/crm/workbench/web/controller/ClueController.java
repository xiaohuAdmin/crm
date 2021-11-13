package com.hu.crm.workbench.web.controller;

import com.hu.crm.settings.domain.User;
import com.hu.crm.settings.service.UserService;
import com.hu.crm.utils.DateTimeUtil;
import com.hu.crm.utils.UUIDUtil;
import com.hu.crm.vo.PaginationVO;
import com.hu.crm.workbench.domain.Activity;
import com.hu.crm.workbench.domain.Clue;
import com.hu.crm.workbench.domain.ClueRemark;
import com.hu.crm.workbench.domain.Tran;
import com.hu.crm.workbench.service.ActivityService;
import com.hu.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/workbench/clue")
public class ClueController {
    @Autowired
    private ActivityService actService;
    @Autowired
    private UserService userService;
    @Autowired
    private ClueService clueService;
    @ResponseBody
    @RequestMapping("/getUserList.do")
    public List<User> getUserList(){
        System.out.println("进入线索模块-获取用户列表");
        List<User> userList=userService.getUserList();
        return userList;
    }
    @ResponseBody
    @RequestMapping("/save.do")
    public boolean save(Clue clue, HttpServletRequest request){
        System.out.println("进入线索模块-执行保存线索操作");
        String id = UUIDUtil.getUUID();
        String createBy =((User)request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        clue.setId(id);
        clue.setCreateTime(createTime);
        clue.setCreateBy(createBy);
        boolean flag= clueService.save(clue);
        return flag;
    }
    @ResponseBody
    @RequestMapping("/pageList.do")
    public PaginationVO<Clue> pageList(String fullname, String owner,String company,
            String phone,String mphone,String state, String source,
            Integer pageNo, Integer pageSize){
        System.out.println("进入线索模块-进入到分页查询操作");
        // 计算出略过的数量
        int skipCount=(pageNo-1)*pageSize;

        Map<String,Object> map=new HashMap<String, Object>();
        map.put("fullname",fullname);
        map.put("owner",owner);
        map.put("company",company);
        map.put("phone",phone);
        map.put("mphone",mphone);
        map.put("state",state);
        map.put("source",source);
        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);

        PaginationVO<Clue> vo=clueService.pageList(map);
        return vo;
    }
    @ResponseBody
    @RequestMapping("/delete.do")
    public boolean delete(@RequestParam("id") String[] ids){
        System.out.println("进入线索模块-执行线索删除操作");
        boolean flag=clueService.delete(ids);
        return flag;
    }
    @ResponseBody
    @RequestMapping("/detail.do")
    public ModelAndView detail(String id){
        System.out.println("进入线索模块-执行跳转到线索详细信息页操作");
        ModelAndView mv=new ModelAndView();
        Clue c= clueService.detail(id);
        mv.addObject("c",c);
        mv.setViewName("/clue/detail");
        return mv;
    }

    @ResponseBody
    @RequestMapping("/getActivityListByClueId.do")
    public List<Activity> getActivityListByClueId(String clueId){
        System.out.println("详细信息页面加载完毕自动展现与之关联的市场活动列表");
        List<Activity> aList= actService.getActivityListByClueId(clueId);
        return aList;
    }

    @ResponseBody
    @RequestMapping("/getRemarkListByAid.do")
    public List<ClueRemark> getRemarkListByAid(String clueId){
        System.out.println("详细信息页面加载完毕自动展现与之关联的备注列表");
        List<ClueRemark> c= clueService.getRemarkListByAid(clueId);
        return c;
    }

    @ResponseBody
    @RequestMapping("/unbund.do")

    public boolean unbund(String id){
        System.out.println("执行解除线索与市场活动的关联的操作");
        System.out.println("要删除的市场活动id为："+id);
        boolean flag=clueService.unbund(id);
        return flag;
    }

    @ResponseBody
    @RequestMapping("/getActivityListByNameAndNotByClueId.do")
    public List<Activity> getActivityListByNameAndNotByClueId(String aname,String clueId){
        System.out.println("进入到线索模块-关联查询操作");
        Map<String,String> map=new HashMap<String, String>();
        map.put("aname",aname);
        map.put("clueId",clueId);
        List<Activity> aList=actService.getActivityListByNameAndNotByClueId(map);
        return aList;
    }

    @ResponseBody
    @RequestMapping("/bund.do")
    public boolean bund(String cid,@RequestParam("aid") String[] aids ){
        System.out.println("执行为线索绑定市场活动的操作");
        boolean flag = clueService.bund(cid,aids);
        return flag;
    }
    @ResponseBody
    @RequestMapping("/getUserListAndClue.do")
    public Map<String,Object> getUserListAndClue(String id){
        System.out.println("通过用户勾选id查找该id对应的线索以及用户信息");
        Map<String,Object> map= clueService.getUserListcAndClue(id);
        return map;
    }
    @ResponseBody
    @RequestMapping("/update.do")
    public boolean update(Clue clue,HttpServletRequest request){
        System.out.println("执行线索更新操作");
        //修改时间：当前系统时间
        String editTime = DateTimeUtil.getSysTime();
        //修改人：当前登录用户
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        clue.setEditTime(editTime);
        clue.setEditBy(editBy);
        //执行更新
        boolean flag=clueService.update(clue);
        return flag;
    }
    @ResponseBody
    @RequestMapping("/getActivityListByName.do")
    public List<Activity> getActivityListByName(String aname){
        System.out.println("执行线索转换-市场活动关联的查询操作");
        List<Activity> aList= clueService.getActivityListByName(aname);
        return aList;
    }

    @ResponseBody
    @RequestMapping("/convert.do")
    public ModelAndView convert(String clueId,String flag,HttpServletRequest request){
        System.out.println("执行线索转换操作");
        Tran t=null;
        ModelAndView mv=new ModelAndView();
        //通过request对象获得创建人,这样在业务层做添加操作的时候就可以取到创建人了,把这创建人作为参数传递传递给业务层
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        //如需要创建交易
        if ("a".equals(flag)){
            t=new Tran();
            String money=request.getParameter("money");
            String name=request.getParameter("name");
            String expectedDate=request.getParameter("expectedDate");
            String stage=request.getParameter("stage");
            String activityId=request.getParameter("activityId");
            String id=UUIDUtil.getUUID();
            String createTime= DateTimeUtil.getSysTime();
            t.setId(id);
            t.setCreateTime(createTime);
            t.setCreateBy(createBy);
            t.setMoney(money);
            t.setName(name);
            t.setExpectedDate(expectedDate);
            t.setStage(stage);
            t.setActivityId(activityId);
        }
        boolean flag1 = clueService.convert(clueId,t,createBy);
        if(flag1)
        {
            mv.setViewName("redirect:/workbench/clue/index.jsp");
        }
        mv.addObject(flag1);
        return mv;
    }
}
