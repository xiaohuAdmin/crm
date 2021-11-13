<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

    <script type="text/javascript">

        ;(function($){
            $.fn.datetimepicker.dates['zh-CN'] = {
                days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"],
                daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六", "周日"],
                daysMin:  ["日", "一", "二", "三", "四", "五", "六", "日"],
                months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
                monthsShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
                today: "今天",
                suffix: [],
                meridiem: ["上午", "下午"]
            };
        }(jQuery));

        var rsc_bs_pag = {
            go_to_page_title: 'Go to page',
            rows_per_page_title: 'Rows per page',
            current_page_label: 'Page',
            current_page_abbr_label: 'p.',
            total_pages_label: 'of',
            total_pages_abbr_label: '/',
            total_rows_label: 'of',
            rows_info_records: 'records',
            go_top_text: '首页',
            go_prev_text: '上一页',
            go_next_text: '下一页',
            go_last_text: '末页'
        };

        $(function(){

            //日期拾取器
            $(".time").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            /*
            操作模态窗口的方式:
            需要躁作的模态窗口的jquRy对象，调用modal方法，为该方法传递参数 show:打开模态窗口hide:关闭模态窗口
            */
            $("#addBtn").click(function () {

                $.ajax({
                    url:"workbench/activity/getUserList.do",
                    type:"get",
                    dataType:"json",
                    success:function (data) {
                        /*
                        * data是什么？
                        * 	模态窗口的(所有者)用户名
                            * 	[{"id":"?","name":"?"},{"id":"?","name":"?"}]
                        * */
                        //先清空复选框当中的内容
                        $("#create-owner").empty()
                        $.each(data,function (index,emlemnt) {
                            //循环遍历json数组 添加option标签

                            $("#create-owner").append(" <option value='"+emlemnt.id +"'>"+ emlemnt.name+"</option>")

                            //将当前登录的用户，设置为下拉默认框的选项
                            var id="${user.id}";
                            $("#create-owner").val(id);

                        })
                    }
                })
                //打开模态窗口
                $("#createActivityModal").modal("show");
            })

            //为保存按钮绑定操作 执行添加操作
            $("#saveBtn").click(function () {


                $.ajax({
                    url:"workbench/activity/save.do",
                    type: "post",
                    data:{

                        owner:$.trim($("#create-owner").val()),
                        name:$.trim($("#create-name").val()),
                        startDate:$.trim($("#create-startDate").val()),
                        endDate:$.trim($("#create-endDate").val()),
                        cost:$.trim($("#create-cost").val()),
                        description:$.trim($("#create-description").val())
                    },
                    dataType: "json",
                    success:function (data) {
                        if (data){
                            //添加成功后
                            //局部刷新市场活动信息列表

                            pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            //清空模态窗口当中的数据
                            /*

                            注意:
                            我们拿到了form表单的jquery对象
                            对于表单的jquery对象，提供了submit()方法让我们提交表单
                            但是表单的jquery对象，没有为我们提供reset()方法让我们重置表单（坑: idea为我们提示了有reset()方法)
                            虽然jquery对象没有为我们提供reset方法，但是原生js为我们提供了reset方法
                            所以我们要将jquery对象转换为原生dom对象
                                 jquery对象转换为dom对象:
                                      jquery对象[下标]
                                 dom对象转换为jquery对象:
                                      $(dom对象)
                             */
                            //清空模态窗口当中的数据
                            $("#activityAddForm")[0].reset();
                            //关闭添加操作对象的模糊窗口
                            $("#createActivityModal").modal("hide");
                            //pageList(1,2);
                        }else {
                            alert("添加市场活动失败")
                        }
                    }

                })
            })

            //页面加载完毕之后,触发一个分页的方法
            pageList(1,2);

            //为查询事件绑定按钮,触发分页方法
            $("#searchBtn").click(function () {

                /*
              点击查询按钮的时候，我们应该将搜索框中的信息保存起来,保存到隐藏域中
             */
                $("#hidden-name").val($.trim($("#search-name").val()));
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-startDate").val($.trim($("#search-startDate").val()));
                $("#hidden-endDate").val($.trim($("#search-endDate").val()));
                pageList(1,2)
            })

            //为全选复选框绑定事件,触发全选操作
            $("#qx").click(function () {
                $("input[name=xz]").prop("checked",this.checked);
            })
            //为数据行的复选框绑定事件 实现全选
            $("#activityBody").on("click",$("input[name=xz]"),function (){
                $("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
            })

            //为删除按钮绑定事件,执行市场活动删除操作
            $("#deleteBtn").click(function () {

                //找到复选框中被选中的复选框的jquery对象
                var $xz = $("input[name=xz]:checked");

                if ($xz.length==0){
                    alert("请选择要删除的记录")
                }else {

                    if(confirm("您确定要删除该记录吗？")){
                        //拼接参数
                        var param = "";

                        //将$xz中的每一个dom对象遍历出来，取其value值相当于取得了需要删除记录的id
                        for (var i=0;i<$xz.length;i++){
                            param += "id="+ $($xz[i]).val();
                            if (i<$xz.length-1){
                                param += "&";
                            }
                        }

                        $.ajax({
                            url:"workbench/activity/delete.do",
                            type:"post",
                            data:param,
                            dataType:"json",
                            success:function (data) {
                                /*
                                * data:
                                *   {success:true/false}
                                * */
                                if (data){
                                    //局部刷新列表
                                    //pageList(1,2);
                                    pageList($("#activityPage").bs_pagination('getOption','currentPage'),
                                        $("#activityPage").bs_pagination('getOption', 'rowsPerPage'))
                                }else {
                                    alert("删除市场活动失败")
                                }
                            }
                        })
                    }

                }
            })

            //为修改按钮绑定事件 打开模态窗口
            $("#editBtn").click(function () {
                //找到名字为xz 被选中状态的input标签
                var $xz=$("input[name=xz]:checked")
                if ($xz.length==0){
                    alert("请选择要修改的记录")
                }else if ($xz.length>1){
                    alert("只能更改一条数据")
                }else {
                    //执行到这里 保证只有一条数据
                    var id= $xz.val();
                    $.ajax({
                        url:"workbench/activity/getUserListAndActivity.do",
                        data:{"id":id},
                        type:"get",
                        dataType:"json",
                        success:function (data) {
                            /*
                            * data:
                            *
                            *   {"uList:[{用户1},{2},{3}]","a":{市场活动}}
                            *
                            * */
                            $("#edit-owner").empty()
                            //处理修改模态窗口所有者的下拉框
                            $.each(data.uList,function (index,emlemnt) {
                                $("#edit-owner").append("<option value='"+emlemnt.id+"'>"+emlemnt.name+"</option>")
                            })
                            var id="${user.id}";
                            $("#edit-owner").val(id);

                            //处理单条市场活动 activity
                            $("#edit-id").val(data.a.id);
                            $("#edit-name").val(data.a.name);
                            $("#edit-startDate").val(data.a.startDate);
                            $("#edit-endDate").val(data.a.endDate);
                            $("#edit-cost").val(data.a.cost);
                            $("#edit-description").val(data.a.description);

                        }
                    })
                    //打开模态窗口
                    $("#editActivityModal").modal("show");
                }

            })
            //为更新按钮绑定事件，执行市场活动的修改操作
            $("#updateBtn").click(function () {
                $.ajax({
                    url:"workbench/activity/update.do",
                    type:"post",
                    data:{
                        "id":$.trim($("#edit-id").val()),
                        "owner":$.trim($("#edit-owner").val()),
                        "name":$.trim($("#edit-name").val()),
                        "startDate":$.trim($("#edit-startDate").val()),
                        "endDate":$.trim($("#edit-endDate").val()),
                        "cost":$.trim($("#edit-cost").val()),
                        "description":$.trim($("#edit-description").val())
                    },
                    dataType:"json",
                    success:function (data) {
                        //{flag:true/flash}
                        if (data){
                            // pageList(1,2)
                            pageList($("#activityPage").bs_pagination('getOption','currentPage')
                                ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'))
                            //关闭模态窗口
                            $("#editActivityModal").modal("hide");
                        }else {
                            alert("更新失败")
                        }

                    }
                })

            })


        });

        /*
	对于所有的关系型数据库，做前端的分页相关操作的基础组件就是pageNo和pageSize
		pageNo:页码
		pagesize:每页展现的记录数

		pageList方法:就是发出ajax请求到后台，从后台取得最新的市场活动信息列表数据
			通过响应回来的数据,局部刷新市场活动信息列表
		我们都在哪些情况下，需要调用pageList方法（什么情况下需要刷新一下市场活动列表)
		(1）点击左侧菜单中的"市场活动"超链接，需要刷新市场活动列表，调用pageList方法
		(2）添加，修改，删除后，需要刷新市场活动列表，调用pageList方法
		(3）点击查询按钮的时候，需要刷新市场活动列表，调用pageList方法
		(4）点击分页组件的时候,调用pageList方法
	以上为pogeList方法制定了六个入口，也就是说，在以上6个操作执行完毕后，
	我们必须要调用pageList方法，刷新市场活动信息列表
	 */
        function pageList(pageNo, pageSize) {

            //刷新界面之前，删除掉标题行的复选框的选中状态
            $("#qx").prop("checked",false);

            //查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
            $("#search-name").val($.trim($("#hidden-name").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-startDate").val($.trim($("#hidden-startDate").val()));
            $("#search-endDate").val($.trim($("#hidden-endDate").val()));
            $.ajax({
                url:"workbench/activity/pageList.do",
                type:"get",
                data:{
                    //分页查询
                    "pageNo":pageNo,
                    "pageSize":pageSize,
                    //加入查询事件的条件 (条件查询)
                    "name" : $.trim($("#search-name").val()),
                    "owner" : $.trim($("#search-owner").val()),
                    "startDate" : $.trim($("#search-startDate").val()),
                    "endDate" : $.trim($("#search-endDate").val())
                },
                dataType:"json",
                success:function (data) {

                    /*  data
                         我们需要的:市场活动信息列表
                         [{市场活动1},{2},{3}]  List<Activity> aList
                          分页插件需要的:查询出来的总记录数
                         {"total":100} int total
                         {"total":100, "datalist":[{市场活动1},{2},{3]]}*/


                    var html="";
                    $.each(data.dataList,function (index,emlemnt) {
                        html+= '<tr class="active">';
                        html+= '<td><input type="checkbox" name="xz" value="'+emlemnt.id+'"/></td>';
                        html+= '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+emlemnt.id+'\';">'+emlemnt.name+'</a></td>';
                        html+= '<td>'+emlemnt.owner+'</td>';
                        html+= '<td>'+emlemnt.startDate+'</td>';
                        html+= '<td>'+emlemnt.endDate+'</td>';
                        html+= '</tr>';
                    })
                    $("#activityBody").html(html);

                    //数据处理完毕后结合分页插件对前端展现分页
                    //计算总页数
                    var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
                    $("#activityPage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数

                        visiblePageLinks: 3, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        //该回调函数，点击分页组件的时时候触发
                        onChangePage : function(event, data){
                            pageList(data.currentPage , data.rowsPerPage);
                        }
                    });

                }
            })
        }
    </script>
</head>
<body>

<input type="hidden" id="hidden-name"/>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-startDate"/>
<input type="hidden" id="hidden-endDate"/>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form id="activityAddForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">

                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startDate">
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endDate">
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <!--
                    data-dismiss="modal"
                        表示关闭动态窗口


                -->
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <input type="hidden" id="edit-id"/>

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">

                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startDate">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endDate">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <!--
                                关于文本域textarea:
                            (1）一定是要以标签对的形式来呈现,正常状态下标签对要紧紧的挨着
                            (2) textarea虽然是以标签对的形式来呈现的，但是它也是属于表单元素范畴
                            我们所有的对于textarea的取值和赋值操作，应该统一使用val()方法（而不是html()方法)


                            -->
                            <textarea class="form-control" rows="3" id="edit-description">123</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>




<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon ">开始日期</div>
                        <input class="form-control time" type="text" id="search-startDate" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" type="text" id="search-endDate">
                    </div>
                </div>

                <button type="button" id="searchBtn" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <!--
                    data-toggle="modal":
                    表示触发该按钮，将要打开一个模态窗口
                    data-target="#createActivityModaL":
                    表示要打开哪个模态窗口，通过#id的形式找到该窗口
                    现在我们是以属性和属性值的方式写在了button元素中，用来打开模态窗口但是这样做是有问题的:
                        问题在于没有办法对按钮的功能进行扩充
                    所以未来的实际项目开发，对于触发模态窗口的操作，一定不要写死在元素当中应该由我们自己写js代码来操作


                -->
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="activityBody">

                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div id="activityPage"></div>
        </div>

    </div>

</div>
</body>
</html>