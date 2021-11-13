package com.hu.crm.workbench.web.controller;

import com.hu.crm.settings.domain.User;
import com.hu.crm.settings.service.UserService;
import com.hu.crm.utils.DateTimeUtil;
import com.hu.crm.utils.UUIDUtil;
import com.hu.crm.vo.PaginationVO;
import com.hu.crm.workbench.domain.Activity;
import com.hu.crm.workbench.domain.Customer;
import com.hu.crm.workbench.domain.Tran;
import com.hu.crm.workbench.domain.TranHistory;
import com.hu.crm.workbench.service.CustomerService;
import com.hu.crm.workbench.service.transactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/transaction")
public class transactionController {
    @Autowired
    private UserService userService;//用户
    @Autowired
    private transactionService transactionService;//交易
    @Autowired
    private CustomerService customerService;//客户
    @ResponseBody
    @RequestMapping("/add.do")
    public ModelAndView getUserList(){
        System.out.println("进入交易模块-获取用户列表");
        List<User> userList=userService.getUserList();
        ModelAndView mv=new ModelAndView();
        mv.addObject("uList",userList);
        mv.setViewName("/transaction/save");
        return mv;
    }
    @ResponseBody
    @RequestMapping("/getCustomerName.do")
    public List<String> getCustomerName(String name){
        System.out.println("进入添加交易模块-获取客户列表");
        List<String> sList= customerService.getCustomerName(name);
        return sList;
    }

    @RequestMapping(value = "/save.do",produces="text/plain;charset=utf-8")
    public String save(Tran tran, String customerName, HttpServletRequest request){
        String id = UUIDUtil.getUUID();
        String createTime= DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        tran.setId(id);
        tran.setCreateTime(createTime);
        tran.setCreateBy(createBy);
        System.out.println("执行添加操作");
        boolean flag= transactionService.save(tran,customerName);

            //如果成功跳到添加页面
            return "redirect:/workbench/transaction/index.jsp";

    }
    @ResponseBody
    @RequestMapping("/pageList.do")
    public PaginationVO<Tran> pageList(String name, String owner, String CustomerName,
                                       String stage, String type, String source, String fullname,
                                       Integer pageNo, Integer pageSize){
        System.out.println("进入交易模块-进入到分页查询操作");
        //计算出略过的数量
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("CustomerName",CustomerName);
        map.put("stage",stage);
        map.put("type",type);
        map.put("source",source);
        map.put("fullname",fullname);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        PaginationVO<Tran> vo=transactionService.pageList(map);
        return vo;
    }
    @ResponseBody
    @RequestMapping("/detail.do")
    public ModelAndView detail(String id,HttpServletRequest request){
        System.out.println("进入进入交易模块-进入到交易详细页面操作");
        ModelAndView mv=new ModelAndView();
        Tran t=transactionService.detail(id);
        //处理前端需要的“可能性”
        /*

            阶段 t
            阶段和可能性之间的对应关系 pMap

         */
        //取阶段t
        String stage = t.getStage();
        //先获取全局作用域对象，在从全局作用域对象当中获取 阶段和可能性之间的对应关系 pMap
        ServletContext application= request.getServletContext();
        Map<String,String> pMap = (Map<String, String>) application.getAttribute("pMap");
        //取出可能性
        String possibility = pMap.get(stage);
        t.setPossibility(possibility);
        mv.addObject("t",t);
        mv.setViewName("/transaction/detail");
        return mv;
    }
    @ResponseBody
    @RequestMapping("/getHistoryListByTranId.do")
    public List<TranHistory> getHistoryListByTranId(String tranId,HttpServletRequest request){
        List<TranHistory> thList= transactionService.getHistoryListByTranId(tranId);
        //阶段和可能性之间的对应关系
        Map<String,String> pMap = (Map<String,String>)request.getServletContext().getAttribute("pMap");
        //将交易历史列表遍历
        for(TranHistory th : thList){

            //根据每条交易历史，取出每一个阶段
            String stage = th.getStage();
            String possibility = pMap.get(stage);
            th.setPossibility(possibility);
        }
        return thList;
    }
    @ResponseBody
    @RequestMapping("/changeStage.do")
    public Map<String,Object> changeStage(Tran t,HttpServletRequest request){
        System.out.println("执行改变阶段的操作");
        System.out.println("在控制器获取到的交易对象"+t);
        //取出阶段
        String stage=t.getStage();
        //修改时间
        String editTime=DateTimeUtil.getSysTime();
        //修改人
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        t.setEditBy(editBy);
        t.setEditTime(editTime);
        Map<String,String> pMap = (Map<String,String>)request.getServletContext().getAttribute("pMap");
        t.setPossibility(pMap.get(stage));
        boolean flag = transactionService.changeStage(t);
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("success", flag);
        map.put("t", t);
        return map;
    }
    @ResponseBody
    @RequestMapping("/getCharts.do")
    public  Map<String,Object> getCharts(){
        Map<String,Object> map= transactionService.getCharts();

        return map;
    }


}
