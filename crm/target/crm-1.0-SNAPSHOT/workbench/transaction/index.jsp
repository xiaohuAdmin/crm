<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
/*
* 在页面第一次刷新的时候去调用分页
* 在点击查询按钮的时候,将文本框的内容去添加到隐藏域当中去,调用分页方法
* 调用分页方法的时候,从隐藏域当中取出刚才填写在文本框里的内容,发出ajax请求,局部刷新交易列表
* 难点：
* 	在点击条件查询按钮的时候,传递的是所有者名字,客户名称,联系人名称
*   但是在数据库表当中存的是customerId,ContactsId,owner,
*   需要三表联查
*
* */
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
		pageList(1,2);
		//为条件查询的按钮绑定事件
		$("#searchBtn").click(function () {
			//将文本框内容添加到有隐藏域当中去,执行分页方法
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-CustomerName").val($.trim($("#search-CustomerName").val()));
			$("#hidden-stage").val($.trim($("#search-stage").val()));
			$("#hidden-type").val($.trim($("#search-type").val()));
			$("#hidden-source").val($.trim($("#search-source").val()));
			$("#hidden-fullname").val($.trim($("#search-fullname").val()));
			pageList(1,2);
		})
		
	});

	function pageList(pageNo, pageSize) {

		//刷新界面之前，删除掉标题行的复选框的选中状态
		//$("#qx").prop("checked",false);

		//查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-CustomerName").val($.trim($("#hidden-CustomerName").val()));
		$("#search-stage").val($.trim($("#hidden-stage").val()));
		$("#search-type").val($.trim($("#hidden-type").val()));
		$("#search-source").val($.trim($("#hidden-source").val()));
		$("#search-fullname").val($.trim($("#hidden-fullname").val()));

		$.ajax({
			url:"workbench/transaction/pageList.do",
			type:"get",
			data:{
				//分页查询
				"pageNo":pageNo,
				"pageSize":pageSize,
				//加入查询事件的条件 (条件查询)
				"name" : $.trim($("#search-name").val()),
				"owner" : $.trim($("#search-owner").val()),
				"CustomerName" : $.trim($("#search-CustomerName").val()),
				"stage" : $.trim($("#search-stage").val()),
				"type" : $.trim($("#search-type").val()),
				"source" : $.trim($("#search-source").val()),
				"fullname" : $.trim($("#search-fullname").val())
			},
			dataType:"json",
			success:function (data) {

				var html="";
				$.each(data.dataList,function (index,emlemnt) {
					html+= '<tr>';
					html+= '<td><input type="checkbox" name="xz" value="'+emlemnt.id+'"/></td>';
					html+= '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id='+emlemnt.id+'\';">'+emlemnt.name+'</a></td>';
					html+= '<td>'+emlemnt.customerId+'</td>';
					html+= '<td>'+emlemnt.stage+'</td>';
					html+= '<td>'+emlemnt.type+'</td>';
					html+= '<td>'+emlemnt.owner+'</td>';
					html+= '<td>'+emlemnt.source+'</td>';
					html+= '<td>'+emlemnt.contactsId+'</td>';
					html+= '</tr>';
				})
				$("#transactionBody").html(html);

				//数据处理完毕后结合分页插件对前端展现分页
				//计算总页数
				var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
				$("#transactionPage").bs_pagination({
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
<input type="hidden" id="hidden-CustomerName"/>
<input type="hidden" id="hidden-stage"/>
<input type="hidden" id="hidden-type"/>
<input type="hidden" id="hidden-source"/>
<input type="hidden" id="hidden-fullname"/>

	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="search-CustomerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="search-stage">
						  <option></option>
						  <c:forEach items="${stageList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="search-type">
						  <option></option>
						  <c:forEach items="${transactionTypeList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						  <c:forEach items="${sourceList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="search-fullname">
				    </div>
				  </div>

					<button type="button" id="searchBtn" class="btn btn-default">查询</button>

				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				 <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/add.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" onclick="window.location.href='edit.html';"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="transactionBody">

					</tbody>
				</table>
			</div>

			<div style="height: 50px; position: relative;top: 30px;">
				<div id="transactionPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>