<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
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

		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

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
				url:"workbench/customer/getUserList.do",
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
			$("#createCustomerModal").modal("show");
		})

		//为保存按钮绑定操作 执行添加操作
		$("#saveBtn").click(function () {


			$.ajax({
				url:"workbench/customer/save.do",
				type: "post",
				data:{

					owner:$.trim($("#create-owner").val()),
					name:$.trim($("#create-name").val()),
					website:$.trim($("#create-website").val()),
					phone:$.trim($("#create-phone").val()),
					description:$.trim($("#create-description").val()),
					contactSummary:$.trim($("#create-contactSummary").val()),
					nextContactTime:$.trim($("#create-nextContactTime").val()),
					address:$.trim($("#create-address1").val()),

				},
				dataType: "json",
				success:function (data) {
					if (data){
						//添加成功后
						//局部刷新市场活动信息列表
						alert("添加成功")
						pageList(1,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
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
						$("#customerAddForm")[0].reset();

						//关闭添加操作对象的模糊窗口
						$("#createCustomerModal").modal("hide");

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
			$("#hidden-phone").val($.trim($("#search-phone").val()));
			$("#hidden-website").val($.trim($("#search-website").val()));
			pageList(1,2)
		})

		//为全选复选框绑定事件,触发全选操作
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})
		//为数据行的复选框绑定事件 实现全选
		$("#customerBody").on("click",$("input[name=xz]"),function (){
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
		})
		//为删除按钮绑定事件,执行市场活动删除操作
		$("#deleteBtn").click(function () {

			//找到复选框中被选中的复选框的jquery对象
			var $xz = $("input[name=xz]:checked");

			if ($xz.length==0){
				alert("请选择要删除的客户记录")
			}else {

				if(confirm("您确定要删除该客户记录吗？")){
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
						url:"workbench/customer/delete.do",
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
								pageList($("#customerPage").bs_pagination('getOption','currentPage'),
										$("#customerPage").bs_pagination('getOption', 'rowsPerPage'))
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
					url:"workbench/customer/getUserListAndCustomer.do",
					data:{"id":id},
					type:"get",
					dataType:"json",
					success:function (data) {

						$("#edit-owner").empty()
						//处理修改模态窗口所有者的下拉框
						$.each(data.uList,function (index,emlemnt) {
							$("#edit-owner").append("<option value='"+emlemnt.id+"'>"+emlemnt.name+"</option>")
						})
						var id="${user.id}";
						$("#edit-owner").val(id);

						//处理单条客户 activity
						$("#edit-id").val(data.a.id);
						$("#edit-name").val(data.a.name);
						$("#edit-website").val(data.a.website);
						$("#edit-description").val(data.a.description);
						$("#edit-contactSummary").val(data.a.contactSummary);
						$("#edit-nextContactTime").val(data.a.nextContactTime);
						$("#edit-address").val(data.a.address);
						$("#edit-phone").val(data.a.phone);

					}
				})
				//打开模态窗口
				$("#editCustomerModal").modal("show");
			}

		})
		//为更新按钮绑定事件，执行市场活动的修改操作
		$("#updateBtn").click(function () {
			$.ajax({
				url:"workbench/customer/update.do",
				type:"post",
				data:{
					"id":$.trim($("#edit-id").val()),
					"owner":$.trim($("#edit-owner").val()),
					"name":$.trim($("#edit-name").val()),
					"website":$.trim($("#edit-website").val()),
					"phone":$.trim($("#edit-phone").val()),
					"description":$.trim($("#edit-description").val()),
					"contactSummary":$.trim($("#edit-contactSummary").val()),
					"nextContactTime":$.trim($("#edit-nextContactTime").val()),
					"address":$.trim($("#edit-address").val()),

				},
				dataType:"json",
				success:function (data) {
					//{flag:true/flash}
					if (data){
						// pageList(1,2)
						pageList($("#customerPage").bs_pagination('getOption','currentPage')
								,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'))
						//关闭模态窗口
						$("#editCustomerModal").modal("hide");
					}else {
						alert("更新失败")
					}

				}
			})

		})



	});

	function pageList(pageNo, pageSize) {

		//刷新界面之前，删除掉标题行的复选框的选中状态
		$("#qx").prop("checked",false);

		//查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-phone").val($.trim($("#hidden-phone").val()));
		$("#search-website").val($.trim($("#hidden-website").val()));
		$.ajax({
			url:"workbench/customer/pageList.do",
			type:"get",
			data:{
				//分页查询
				"pageNo":pageNo,
				"pageSize":pageSize,
				//加入查询事件的条件 (条件查询)
				"name" : $.trim($("#search-name").val()),
				"owner" : $.trim($("#search-owner").val()),
				"phone" : $.trim($("#search-phone").val()),
				"website" : $.trim($("#search-website").val())
			},
			dataType:"json",
			success:function (data) {

				var html="";
				$.each(data.dataList,function (index,emlemnt) {
					html+= '<tr>';
					html+= '<td><input type="checkbox" name="xz" value="'+emlemnt.id+'"/></td>';
					html+= '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/detail.do?id='+emlemnt.id+'\';">'+emlemnt.name+'</a></td>';
					html+= '<td>'+emlemnt.owner+'</td>';
					html+= '<td>'+emlemnt.phone+'</td>';
					html+= '<td>'+emlemnt.website+'</td>';
					html+= '</tr>';
				})
				$("#customerBody").html(html);

				//数据处理完毕后结合分页插件对前端展现分页
				//计算总页数
				var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
				$("#customerPage").bs_pagination({
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
	<input type="hidden" id="hidden-phone"/>
	<input type="hidden" id="hidden-website"/>
	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="customerAddForm" role="form">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id"/>
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="edit-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
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
				<h3>客户列表</h3>
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
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" type="text" id="search-website">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
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
						<td>公司座机</td>
						<td>公司网站</td>
					</tr>
					</thead>
					<tbody id="customerBody">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="customerPage"></div>
			</div>

		</div>

	</div>
</body>
</html>