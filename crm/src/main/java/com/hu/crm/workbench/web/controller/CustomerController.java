package com.hu.crm.workbench.web.controller;

import com.hu.crm.settings.domain.User;
import com.hu.crm.settings.service.UserService;
import com.hu.crm.utils.DateTimeUtil;
import com.hu.crm.utils.UUIDUtil;
import com.hu.crm.vo.PaginationVO;
import com.hu.crm.workbench.dao.TranDao;
import com.hu.crm.workbench.domain.*;
import com.hu.crm.workbench.service.ContactsService;
import com.hu.crm.workbench.service.CustomerService;
import com.hu.crm.workbench.service.transactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/customer")
public class CustomerController {
    @Autowired
    private CustomerService customerService;
    @Autowired
    private UserService userService;
    @Resource
    private ContactsService contactsService;//联系人
    @Resource
    private transactionService transactionService;//交易

    @ResponseBody
    @RequestMapping("/getUserList.do")
    public List<User> getUserList(){
        System.out.println("进入客户模块-获取用户列表");
        List<User> userList=userService.getUserList();
        return userList;
    }
    @ResponseBody
    @RequestMapping("/save.do")
    public boolean save(Customer ct, HttpServletRequest request){
        System.out.println("进入客户模块-执行创建客户操作");
        String id= UUIDUtil.getUUID();
        //创建时间,当前系统时间
        String createTime= DateTimeUtil.getSysTime();
        //创建人
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        ct.setId(id);
        ct.setCreateTime(createTime);
        ct.setCreateBy(createBy);
        boolean flag=customerService.save(ct);
        return flag;
    }

    @ResponseBody
    @RequestMapping("/pageList.do")
    public PaginationVO<Customer> pageList(String name, String owner, String phone,
                                           String website, Integer pageNo, Integer pageSize){
        System.out.println("进入客户模块-进入到分页查询操作");
        //        计算出略过的数量
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("phone",phone);
        map.put("website",website);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        PaginationVO<Customer> vo=customerService.pageList(map);
        return vo;
    }

    @ResponseBody
    @RequestMapping("/delete.do")
    //@RequestParam前端传递的变量和后端接收的变量名字不一致时,用注解@RequestParam来实现数据的传递
    public boolean delete(@RequestParam("id") String[] ids){
        System.out.println("进入客户模块-执行客户的删除操作");
        boolean flag= customerService.delete(ids);
        return flag;
    }


    @ResponseBody
    @RequestMapping("/getUserListAndCustomer.do")
    public Map<String,Object> getUserListAndActivity(String id){
        System.out.println("进入客户模块-通过用户勾选id查找该id对应的客户信息以及用户信息");
        Map<String,Object> map= customerService.getUserListAndCustomer(id);
        return map;
    }

    @ResponseBody
    @RequestMapping("/update.do")
    public boolean update(Customer customer,HttpServletRequest request){
        System.out.println("进入进入客户模块-执行客户信息修改操作");
        //修改时间：当前系统时间
        String editTime = DateTimeUtil.getSysTime();
        //修改人：当前登录用户
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        customer.setEditTime(editTime);
        customer.setEditBy(editBy);
        boolean flag= customerService.update(customer);
        return flag;
    }
    @ResponseBody
    @RequestMapping("/detail.do")
    public ModelAndView detail(String id){
        System.out.println("进入进入客户模块-进入到查看详细页面操作");
        ModelAndView mv=new ModelAndView();
        Customer customer=customerService.detail(id);
        mv.addObject("customer",customer);
        mv.setViewName("/customer/detail");
        return mv;
    }
    @ResponseBody
    @RequestMapping("/getRemarkListByAid.do")
    public List<CustomerRemark> getRemarkListByAid(String customerId){
        System.out.println("进入进入客户模块-根据客户活动id，取得备注信息列表");
        List<CustomerRemark> list=customerService.getRemarkListByAid(customerId);
        return list;
    }

    @ResponseBody
    @RequestMapping("/SaveRemark.do")
    public Map<String ,Object> saveRemark(CustomerRemark cr,HttpServletRequest request){
        System.out.println("进入进入客户模块-执行备注添加操作");
        String id =UUIDUtil.getUUID();
        String createTime= DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        String editFlag="0";
        cr.setId(id);
        cr.setCreateBy(createBy);
        cr.setCreateTime(createTime);
        cr.setEditFlag(editFlag);
        boolean flag=customerService.saveRemark(cr);
        Map<String ,Object> map=new HashMap<>();
        map.put("success",flag);
        map.put("ar",cr);
        return map;
    }

    @ResponseBody
    @RequestMapping("/deleteRemark.do")

    public boolean deleteRemark(String id){
        System.out.println("进入进入客户模块-删除备注操作");
        boolean flag=customerService.deleteRemark(id);
        return flag;
    }

    @ResponseBody
    @RequestMapping("/updateRemark.do")
    public Map<String ,Object> updateRemark(CustomerRemark cr,HttpServletRequest request){
        System.out.println("进入进入客户模块-执行修改备注的操作");
        String editTime= DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("user")).getName();
        String editFlag="1";
        cr.setEditFlag(editFlag);
        cr.setEditTime(editTime);
        cr.setEditBy(editBy);
        boolean flag=customerService.updateRemark(cr);
        Map<String ,Object> map=new HashMap<>();
        map.put("success",flag);
        map.put("ar",cr);
        return map;
    }
    @ResponseBody
    @RequestMapping("/getContactsListByAid.do")
    public List<Contacts> getContactsListByAid(String customerId){
        System.out.println("详细信息页面加载完毕自动展现与之关联的联系人信息");
        List<Contacts> aList= customerService.getContactsListByAid(customerId);
        return aList;
    }
    @ResponseBody
    @RequestMapping("/save2.do")
    public boolean save(Contacts ca,HttpServletRequest request){
        System.out.println("进入联系人模块-执行联系人添加操作");
        String id= UUIDUtil.getUUID();
        //创建时间,当前系统时间
        String createTime= DateTimeUtil.getSysTime();
        //创建人
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        ca.setId(id);
        ca.setCreateTime(createTime);
        ca.setCreateBy(createBy);
        boolean flag= contactsService.save2(ca);
        return flag;
    }
    @ResponseBody
    @RequestMapping("/getTranListByCustomerId.do")
    public List<Tran> getTranListByCustomerId(String customerId){
        System.out.println("详细信息页面加载完毕自动展现与之关联的交易信息");

        List<Tran> aList= transactionService.getTranListByCustomerId(customerId);
        return aList;
    }

}
