<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <base href="<%=basePath%>">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <style type="text/css">
        *{margin: 0;padding: 0;}
        .main{width: 100%;height: 100%; position: absolute;}
        .quarter-div{width: 50%;height: 50%;float: left; }
    </style>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
    <script type="text/javascript">

        $(function(){
            $.ajax({
                url:"workbench/activity/cost.do",
                dataType:"json",
                method:"post",
                success:function(resp){
                    var myChart = echarts.init(document.getElementById('first'));

                    // 指定图表的配置项和数据
                    option = {
                        title: {
                            text: '市场活动花费漏斗图',
                            left: 'center'
                        },
                        legend: {
                            data: resp.dataList,
                            orient: 'vertical',
                            left: 'left',
                        },
                        calculable: true,
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c}"
                        },
                        series: [
                            {
                                name:'市场活动花销',
                                type:'funnel',
                                left: '10%',
                                top: 60,
                                //x2: 80,
                                bottom: 60,
                                width: '80%',
                                // height: {totalHeight} - y - y2,
                                min: 0,
                                max: resp.total,
                                minSize: '0%',
                                maxSize: '100%',
                                sort: 'descending',
                                gap: 2,
                                label: {
                                    normal: {
                                        show: true,
                                        position: 'inside'
                                    },
                                    emphasis: {
                                        textStyle: {
                                            fontSize: 20
                                        }
                                    }
                                },
                                labelLine: {
                                    normal: {
                                        length: 10,
                                        lineStyle: {
                                            width: 1,
                                            type: 'solid'
                                        }
                                    }
                                },
                                itemStyle: {
                                    normal: {
                                        borderColor: '#fff',
                                        borderWidth: 1
                                    }
                                },
                                data: resp.dataList
                            }
                        ]
                    };

                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
            })

            $.ajax({
                url:"workbench/activity/cost.do",
                dataType:"json",
                method:"post",
                success:function(resp){
                    var myChart = echarts.init(document.getElementById('second'));
                    option = {
                        title: {
                            text: '市场活动花销饼图',
                            left: 'center'
                        },
                        tooltip: {
                            trigger: 'item'
                        },
                        legend: {
                            data: resp.dataList,
                            orient: 'vertical',
                            left: 'left',
                        },
                        series: [
                            {
                                name: '市场活动花销',
                                type: 'pie',
                                radius: '50%',
                                data:resp.dataList,
                                emphasis: {
                                    itemStyle: {
                                        shadowBlur: 10,
                                        shadowOffsetX: 0,
                                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                                    }
                                }
                            }
                        ]
                    };
                    myChart.setOption(option);
                }
            })
        })

    </script>
</head>
<body>
<div class="main">
    <div id="first" class="quarter-div"></div>
    <div id="second" class="quarter-div"></div>
</div>
</body>
</html>
