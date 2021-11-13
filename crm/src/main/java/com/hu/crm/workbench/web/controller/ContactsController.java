package com.hu.crm.workbench.web.controller;

import com.hu.crm.settings.domain.User;
import com.hu.crm.settings.service.UserService;
import com.hu.crm.utils.DateTimeUtil;
import com.hu.crm.utils.UUIDUtil;
import com.hu.crm.vo.PaginationVO;
import com.hu.crm.workbench.domain.Activity;
import com.hu.crm.workbench.domain.Contacts;
import com.hu.crm.workbench.service.ContactsService;
import com.hu.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/contacts")
public class ContactsController {
    @Resource
    private CustomerService customerService;//客户
    @Resource
    private UserService userService;//用户
    @Resource
    private ContactsService contactsService;//联系人

    @ResponseBody
    @RequestMapping("/getUserList.do")
    public List<User> getUserList(){
        System.out.println("进入联系人模块-获取用户列表");
        List<User> userList=userService.getUserList();
        return userList;
    }
    @ResponseBody
    @RequestMapping("/save.do")
    public boolean save(Contacts ca, String customerName,HttpServletRequest request){
        System.out.println("进入联系人模块-执行联系人添加操作");
        String id= UUIDUtil.getUUID();
        //创建时间,当前系统时间
        String createTime= DateTimeUtil.getSysTime();
        //创建人
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        ca.setId(id);
        ca.setCreateTime(createTime);
        ca.setCreateBy(createBy);
        boolean flag= contactsService.save(ca,customerName);
        return flag;
    }

    @ResponseBody
    @RequestMapping("/getContactsListByName.do")
    public List<Contacts> getActivityListByName(String uname){
        System.out.println("创建交易-联系人模糊查询");
        List<Contacts> cList= contactsService.getContactsListByName(uname);
        return cList;
    }
    @ResponseBody
    @RequestMapping("/pageList.do")
    public PaginationVO<Contacts> pageList(String fullname,String owner,String customerId,String source,String birth,
                                   Integer pageNo,Integer pageSize ){
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<>();
        map.put("fullname",fullname);
        map.put("owner",owner);
        map.put("customerId",customerId);
        map.put("source",source);
        map.put("birth",birth);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        PaginationVO<Contacts> vo=contactsService.pageList(map);
        return vo;

    }

}
