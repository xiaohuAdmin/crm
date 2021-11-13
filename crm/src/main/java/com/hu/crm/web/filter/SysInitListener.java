package com.hu.crm.web.filter;


import com.hu.crm.settings.domain.DicValue;
import com.hu.crm.settings.service.DicService;
import com.hu.crm.settings.service.Impl.DicServiceImpl;
import com.hu.crm.utils.ServiceFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

//监听器
public class SysInitListener implements ServletContextListener {

    /**
     *
     * 在全局作用域对象被Http服务器初始化被调用
     *      去数据库取出数据字典存放到全局作用域对象当中去
     * @sce ：全局作用域对象
     */

    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("监听器+服务器缓存 处理数据字典");
        //拿到全局作用域对象
       ServletContext application=sce.getServletContext();

        DicService dicService= WebApplicationContextUtils.getWebApplicationContext(sce.getServletContext()).getBean(DicServiceImpl.class);


        Map<String,List<DicValue>> map =dicService.getAll();
        Set<String> set= map.keySet();
        for (String key:set) {
            application.setAttribute(key,map.get(key));
        }
        System.out.println("已经将数据字典添加到 ServletContext 当中");
        //数据字典处理完毕后，处理Stage2Possibility.properties文件
        /*

            处理Stage2Possibility.properties文件步骤：
                解析该文件，将该属性文件中的键值对关系处理成为java中键值对关系（map）

                Map<String(阶段stage),String(可能性possibility)> pMap = ....
                pMap.put("01资质审查",10);
                pMap.put("02需求分析",25);
                pMap.put("07...",...);

                pMap保存值之后，放在服务器缓存中
                application.setAttribute("pMap",pMap);

         */

        //解析properties文件

        Map<String,String> pMap = new HashMap<String,String>();

        ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");

        Enumeration<String> e = rb.getKeys();
        //迭代器
        while (e.hasMoreElements()){

            //阶段
            String key = e.nextElement();
            //可能性
            String value = rb.getString(key);

            pMap.put(key, value);


        }

        //将pMap保存到服务器缓存中
        application.setAttribute("pMap", pMap);



    }


    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }


}


