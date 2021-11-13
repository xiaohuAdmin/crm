
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

	Map<String,String> pMap = (Map<String,String>)application.getAttribute("pMap");

	Set<String> set = pMap.keySet();
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

	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

	<script type="text/javascript">

		var json = {

			<%

				for(String key:set){

					String value = pMap.get(key);
			%>

			"<%=key%>" : <%=value%>,

			<%
				}

			%>

		};


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
		$(function(){
			//客户名称不存在就自动补全
			$("#create-customerName").typeahead({
				source: function (query, process) {
					$.get(
							"workbench/transaction/getCustomerName.do",
							{ "name" : query },
							function (data) {
								process(data);
							},
							"json"
					);
				},
				delay: 1500
			});
			//日期拾取器
			$(".time1").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});
			$(".time2").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});
		//为创建交易的市场活动源打开模态窗口
			$("#openActivityModalBtn").click(function () {
				$("#findMarketActivity").modal("show");
			})
		//为创建交易的联系人名称打开模态窗口
			$("#openCustomerModalBtn").click(function () {
				$("#findContacts").modal("show")
			})
			//为市场活动搜索操作的模态窗口的搜索框绑定事件
			$("#aname").keydown(function (event) {
				if (event.keyCode==13){
					$.ajax({
						url:"workbench/clue/getActivityListByName.do",
						data:{
							"aname":$.trim($("#aname").val()),
						},
						type:"get",
						dataType:"json",
						success:function (data) {
							var html="";
							$.each(data,function (i,n) {
								html+= '<tr>';
								html+= '<td><input type="radio" name="xz" value="'+n.id+'"/></td>';
								html += '<td id="'+n.id+'">'+n.name+'</td>';
								html+= '<td>'+n.startDate +'</td>';
								html+= '<td>'+ n.endDate+'</td>';
								html+= '<td>'+n.owner +'</td>';
								html+= '</tr>';
							})
							$("#activitySearchBody").html(html);
						}
					})
					return false;
				}
			})

			//为联系人搜索操作的模态窗口搜索框绑定事件
			$("#uname").keydown(function (event) {
				if (event.keyCode==13){
					$.ajax({
						url:"workbench/contacts/getContactsListByName.do",
						data:{
							"uname":$.trim($("#uname").val()),
						},
						type:"get",
						dataType:"json",
						success:function (data) {
							var html="";
							$.each(data,function (i,n) {
								html+= '<tr>';
								html+= '<td><input type="radio" name="xx" value="'+n.id+'"/></td>';
								html += '<td id="'+n.id+'">'+n.fullname+'</td>';
								html+= '<td>'+n.email +'</td>';
								html+= '<td>'+ n.mphone+'</td>';
								html+= '</tr>';
							})
							$("#contactsSearchBod").html(html);

						}
					})
					return false;
				}
			})
			//为绑定市场活动的按钮“提交”按钮绑定事件
			$("#submitActivityBtn").click(function () {
				var $xz=$("input[name=xz]:checked")
				if ($xz.length==0){
					alert("请选择要关联的市场活动")
				}else{
					//填写市场活动源 两项信息(名字+id，id放入隐藏域)
					//取id
					var id=$xz.val();
					//取名字
					var name = $("#"+id).html();
					$("#activityId").val(id);
					$("#activityName").val(name);
					$("#findMarketActivity").modal("hide")
				}
			})
			//为绑定联系人的按钮“提交”按钮绑定事件
			$("#submitContactsBtn").click(function () {
				var $xz=$("input[name=xx]:checked")
				if ($xz.length==0){
					alert("请选择要关联的联系人")
				}else{
					//填写市场活动源 两项信息(名字+id，id放入隐藏域)
					//取id
					var id=$xz.val();
					//取名字
					var name = $("#"+id).html();
					$("#contactsId").val(id);
					$("#contactsName").val(name);
					$("#findContacts").modal("hide")
				}
			})

			//为阶段的下拉框，绑定选中下拉框的事件,根据选中的阶段填写可能性
			$("#create-stage").change(function () {
				//取得选中的阶段
				var stage=$("#create-stage").val();
				//取可能性
				var possibility=json[stage];
				$("#create-possibility").val(possibility+"%")

			})
			//为保存按钮绑定事件,执行交易添加
			$("#saveTranBtn").click(function () {
				if(confirm("您正在创建一笔交易")){
					//发出传统请求 提交表单
					$("#tranForm").submit();
				}

			})



		});
	</script>
</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
	<div class="modal-dialog" role="document" style="width: 80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">查找市场活动</h4>
			</div>
			<div class="modal-body">
				<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
					<form class="form-inline" role="form">
						<div class="form-group has-feedback">
							<input type="text" id="aname" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
							<span class="glyphicon glyphicon-search form-control-feedback"></span>
						</div>
					</form>
				</div>
				<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
					<thead>
					<tr style="color: #B3B3B3;">
						<td></td>
						<td>名称</td>
						<td>开始日期</td>
						<td>结束日期</td>
						<td>所有者</td>
					</tr>
					</thead>
					<tbody id="activitySearchBody">

					</tbody>
				</table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
				<button type="button" class="btn btn-primary" id="submitActivityBtn">提交</button>
			</div>
		</div>
	</div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
	<div class="modal-dialog" role="document" style="width: 80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">查找联系人</h4>
			</div>
			<div class="modal-body">
				<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
					<form class="form-inline" role="form">
						<div class="form-group has-feedback">
							<input type="text" class="form-control" id="uname" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
							<span class="glyphicon glyphicon-search form-control-feedback"></span>
						</div>
					</form>
				</div>
				<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
					<thead>
					<tr style="color: #B3B3B3;">
						<td></td>
						<td>名称</td>
						<td>邮箱</td>
						<td>手机</td>
					</tr>
					</thead>
					<tbody id="contactsSearchBod">

					</tbody>
				</table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
				<button type="button" class="btn btn-primary" id="submitContactsBtn">提交</button>
			</div>
		</div>
	</div>
</div>


<div style="position:  relative; left: 30px;">
	<h3>创建交易</h3>
	<div style="position: relative; top: -40px; left: 70%;">
		<button type="button" class="btn btn-primary" id="saveTranBtn">保存</button>
		<button type="button" class="btn btn-default">取消</button>
	</div>
	<hr style="position: relative; top: -40px;">
</div>
<form action="workbench/transaction/save.do" id="tranForm" method="post" class="form-horizontal" role="form" style="position: relative; top: -30px;">
	<div class="form-group">
		<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<select class="form-control" id="create-owner" name="owner">
				<option></option>
				<option></option>
				<c:forEach items="${uList}" var="u">
					<option value="${u.id}" ${user.id eq u.id ? "selected" : ""}>${u.name}</option>
				</c:forEach>
			</select>
		</div>
		<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="create-amountOfMoney" name="money">
		</div>
	</div>

	<div class="form-group">
		<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="create-transactionName" name="name">
		</div>
		<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control time1" id="create-expectedClosingDate" name="expectedDate">
		</div>
	</div>

	<div class="form-group">
		<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="create-customerName" name="customerName" placeholder="支持自动补全，输入客户不存在则新建">
		</div>
		<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<select class="form-control" id="create-stage" name="stage">
				<option></option>
				<c:forEach items="${stageList}" var="s">
					<option value="${s.value}">${s.text}</option>
				</c:forEach>
			</select>
		</div>
	</div>

	<div class="form-group">
		<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
		<div class="col-sm-10" style="width: 300px;">
			<select class="form-control" id="create-transactionType" name="type">
				<option></option>
				<c:forEach items="${transactionTypeList}" var="s">
					<option value="${s.value}">${s.text}</option>
				</c:forEach>
			</select>
		</div>
		<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="create-possibility" readonly>
		</div>
	</div>

	<div class="form-group">
		<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
		<div class="col-sm-10" style="width: 300px;">
			<select class="form-control" id="create-clueSource" name="source">
				<option></option>
				<c:forEach items="${sourceList}" var="s">
					<option value="${s.value}">${s.text}</option>
				</c:forEach>
			</select>
		</div>
<%--
		<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
--%>
		<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openActivityModalBtn"><span class="glyphicon glyphicon-search"></span></a></label>

		<div class="col-sm-10" style="width: 300px;">

			<input type="text" class="form-control" id="activityName" placeholder="点击左侧搜索" readonly>
			<input type="hidden" id="activityId" name="activityId">
		</div>
	</div>

	<div class="form-group">

		<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="openCustomerModalBtn"><span class="glyphicon glyphicon-search"></span></a></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="contactsName" placeholder="点击左侧搜索" readonly>
			<input type="hidden" id="contactsId" name="contactsId">
		</div>
	</div>

	<div class="form-group">
		<label for="create-describe" class="col-sm-2 control-label">描述</label>
		<div class="col-sm-10" style="width: 70%;">
			<textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
		</div>
	</div>

	<div class="form-group">
		<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
		<div class="col-sm-10" style="width: 70%;">
			<textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
		</div>
	</div>

	<div class="form-group">
		<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control time2" id="create-nextContactTime" name="nextContactTime">
		</div>
	</div>

</form>
</body>
</html>