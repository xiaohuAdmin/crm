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
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

	<script type="text/javascript">
		$(function () {

			if(window.top!=window){
				window.top.location=window.location;
			}

			//自动获取焦点
			$("#loginAct").focus();
			//刷新界面自动清空账号和密码框的val
			$("#loginAct").val("");
			$("#loginPwd").val("");
			//给点击登录按钮绑定事件
			$("#submitBtn").click(function () {
				login();
			})
			//给敲击键盘也绑定事件
			$(window).keydown(function (event) {
				if (event.keyCode==13){
					//执行登录
					login();
				}
			})

		})

		function login() {
			//清空输入框的""
			var loginAct= $.trim($("#loginAct").val());
			var loginPwd= $.trim($("#loginPwd").val());
			//判断输入是否为空
			if (loginAct=="" || loginPwd==""){
				$("#msg").html("账号密码不能为空")
				return false;
			}
			//发送ajax请求开始登录
			$.ajax({
				url:"user/login.do",
				data:{"loginAct":loginAct,"loginPwd":loginPwd},
				type:"post",
				dataType:"json",
				success:function (data) {
					//data包含什么数据？
					//要有一个登录成功与否
					// {"success": true/falsse}
					//如果登录失败要显示哪里错误了
					//{"msg":,msg}
					if (data.success){
						//登录成功 跳转
						window.location.href="workbench/index.jsp";
					}else {
						//登录失败
						$("#msg").html(data.msg);
					}
				}
			})
		}
	</script>

</head>
<body>

<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
	<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
	<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2021&nbsp;小胡同学</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
	<div style="position: absolute; top: 0px; right: 60px;">
		<div class="page-header">
			<h1>登录</h1>
		</div>
		<form action="workbench/index.jsp" class="form-horizontal" role="form">
			<%--<form method="get" action="settings/user/login.do" class="form-horizontal" role="form">--%>
			<div class="form-group form-group-lg">
				<div style="width: 350px;">
					<input class="form-control" type="text" name="loginAct" placeholder="用户名"id="loginAct" >
				</div>
				<div style="width: 350px; position: relative;top: 20px;">
					<input class="form-control" type="password" name="loginPwd" placeholder="密码" id="loginPwd">
				</div>
				<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">

					<span id="msg" style="color: red"></span>

				</div>
				<button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
			</div>
		</form>
	</div>
</div>
</body>
</html>