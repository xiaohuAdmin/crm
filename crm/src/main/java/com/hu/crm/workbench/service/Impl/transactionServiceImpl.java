package com.hu.crm.workbench.service.Impl;

import com.hu.crm.utils.DateTimeUtil;
import com.hu.crm.utils.UUIDUtil;
import com.hu.crm.vo.PaginationVO;
import com.hu.crm.workbench.dao.ContactsDao;
import com.hu.crm.workbench.dao.CustomerDao;
import com.hu.crm.workbench.dao.TranDao;
import com.hu.crm.workbench.dao.TranHistoryDao;
import com.hu.crm.workbench.domain.Activity;
import com.hu.crm.workbench.domain.Customer;
import com.hu.crm.workbench.domain.Tran;
import com.hu.crm.workbench.domain.TranHistory;
import com.hu.crm.workbench.service.transactionService;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class transactionServiceImpl implements transactionService {
    @Resource
    private CustomerDao customerDao;//客户表
    @Resource
    private TranDao tranDao;//交易表
    @Resource
    private TranHistoryDao tranHistoryDao;//交易历史表
    @Resource
    private ContactsDao contactsDao;//联系人表
    @Override
    public boolean save(Tran t, String customerName) {

        /*

            交易添加业务：

                在做添加之前，参数t里面就少了一项信息，就是客户的主键，customerId

                先处理客户相关的需求

                （1）判断customerName，根据客户名称在客户表进行精确查询
                       如果有这个客户，则取出这个客户的id，封装到t对象中
                       如果没有这个客户，则再客户表新建一条客户信息，然后将新建的客户的id取出，封装到t对象中

                （2）经过以上操作后，t对象中的信息就全了，需要执行添加交易的操作

                （3）添加交易完毕后，需要创建一条交易历史



         */

        boolean flag = true;

        Customer cus = customerDao.getCustomerByName(customerName);

        //如果cus为null，需要创建客户
        if(cus==null){

            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setName(customerName);
            cus.setCreateBy(t.getCreateBy());
            cus.setCreateTime(DateTimeUtil.getSysTime());
            cus.setContactSummary(t.getContactSummary());
            cus.setNextContactTime(t.getNextContactTime());
            cus.setOwner(t.getOwner());
            //添加客户
            int count1 = customerDao.save(cus);
            if(count1!=1){
                flag = false;
            }

        }

        //通过以上对于客户的处理，不论是查询出来已有的客户，还是以前没有我们新增的客户，总之客户已经有了，客户的id就有了
        //将客户id封装到t对象中
        t.setCustomerId(cus.getId());

        //添加交易
        int count2 = tranDao.save(t);
        if(count2!=1){
            flag = false;
        }

        //添加交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(t.getId());
        th.setStage(t.getStage());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setCreateBy(t.getCreateBy());
        int count3 = tranHistoryDao.save(th);
        if(count3!=1){
            flag = false;
        }
        //把客户跟联系人的信息关联起来
        t.getCustomerId();//顾客id
        t.getContactsId();//联系人id
        //执行关联
        //contactsDao.

        return flag;
    }

    @Override
    public PaginationVO<Tran> pageList(Map<String, Object> map) {
        //获取到查询出来的总记录数total
        int total=tranDao.getTotalByCondition(map);
        //获取到市场活动信息列表 dataList
        List<Tran> dataList=tranDao.getActivityListByCondition(map);
        //封装到vo对象
        PaginationVO<Tran> vo=new PaginationVO<Tran>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        //返回vo
        return vo;
    }

    @Override
    public Tran detail(String id) {
        Tran t = tranDao.detail(id);

        return t;
    }

    @Override
    public List<Tran> getTranListByCustomerId(String customerId) {
        //取request
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        List<Tran> aList= tranDao.getTranListByCustomerId(customerId);
        for (Tran t:aList) {
            //取出一个交易对象 就取出他的阶段
            String stage =t.getStage();
           //在从全局作用域对象当中取出阶段和可能性之间的关系 pMap
            ServletContext application=request.getServletContext();
            Map<String,String> pMap = (Map<String, String>) application.getAttribute("pMap");
            //取出可能性
            String possibility = pMap.get(stage);
            //将可能性存放到交易对象当中去
            t.setPossibility(possibility);
        }
        return aList;
    }

    @Override
    public List<TranHistory> getHistoryListByTranId(String tranId) {
        List<TranHistory> thList = tranHistoryDao.getHistoryListByTranId(tranId);
        return thList;
    }

    @Override
    public boolean changeStage(Tran t) {
        boolean flag = true;

        //改变交易阶段
        int count1 = tranDao.changeStage(t);
        if(count1!=1){

            flag = false;

        }

        //交易阶段改变后，生成一条交易历史
        TranHistory th = new TranHistory();
        String  possibility=t.getPossibility();
        String stage=t.getStage();
        th.setPossibility(possibility);
        th.setStage(stage);
        th.setId(UUIDUtil.getUUID());
        th.setCreateBy(t.getEditBy());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setExpectedDate(t.getExpectedDate());
        th.setMoney(t.getMoney());
        th.setTranId(t.getId());
        System.out.println("我添加的交易历史信息为 "+ th);
        //添加交易历史
        int count2 = tranHistoryDao.save(th);
        if(count2!=1){

            flag = false;

        }

        return flag;
    }

    public Map<String, Object> getCharts() {

        //取得total
        int total = tranDao.getTotal();


        //取得dataList
        List<Map<String,Object>> dataList = tranDao.getCharts();

        //将total和dataList保存到map中
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("total", total);
        map.put("dataList", dataList);

        //返回map
        return map;
    }
}
