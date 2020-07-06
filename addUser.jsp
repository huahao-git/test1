<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,com.lxem.model.*"%>
<%@ include file="/commons/header.jsp"%>
<%User user = (User) request.getSession().getAttribute("user"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>会计再教育管理系统</title>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
<link href="<%=basePath%>js/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="<%=basePath%>js/laydate/need/laydate.css" rel="stylesheet" />
<link href="<%=basePath%>css/app.css" rel="stylesheet" />
<link href="<%=basePath%>css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=basePath%>css/style.css" rel="stylesheet" type="text/css" />
<link href="<%=basePath%>css/popover.css" rel="stylesheet" type="text/css" />
<style>
.account ul li > .select-city, .account ul li input[type="text"], .account ul li input[type="password"], .account ul li select{
    width:600px;
}
</style>
<script type="text/javascript" src="<%=basePath%>js/layer/layer.js"></script>
 <script type="text/javascript">
  $(function(){
   getCity();
  })
  function getCity(){ 
	   var province = $('#province').val();
	   $("#city").empty();
	   $.ajax({
	 	    type: "POST",
	 	    url: "../user/getCity",
			data : {"province" : province},
			dataType : "json",
			success : function(data) {
			   addInput(data);
		   }  
		});
   }	  

// 动态生成城市checkbox
  function  addInput(list){
    //$("#city").append("<br/>");
	for(var i=0;i<list.length;i++){
		$("#city").append("<label><input id='chk"+list[i].ID+"' name='chkItem' onclick='checkAll("+list[i].ID+")' type='checkbox' value='"+list[i].ID+"'/>"+list[i].NAME+"</label> ");
		/*if(i%4==0){
			$("#city").append("<br/>");
		}*/
	}
}
// 动态生成区县checkbox
  function  addqxInput(list,id){
	for(var i=0;i<list.length;i++){
		$("#area").append("<label class='qx"+id+"'><input name='qxItem' onclick='checkAll2()' type='radio' value='"+list[i].ID+"'/>"+list[i].NAME+"</label> ");

	}
}
function checkAll(id){
if($('#chk'+id).is(':checked')){
//选中checkbox触发事件
 $.ajax({
	 	    type: "POST",
	 	    url: "../user/getArea",
			data :  {"city" : id},
			dataType : "json",
			success : function(data) {
			   addqxInput(data,id);
		   }
		});
		}
	else{
		$(".qx"+id).remove(); //取消选中
	}

}
function checkAll2(){

	var chsub = $("[name = qxItem]:checkbox").length; //获取subcheck的个数
	var checkedsub = $("[name = qxItem]:checkbox:checked").length; //获取选中的subcheck的个数
	if (checkedsub == chsub) {
		$("#qxAll").prop("checked", true);
	}else{
		$("#qxAll").prop("checked", false);
	}
}
/* 新增账号 */
		function addUserSave(){
 		var username = $("#username").val().trim();
 		var password = $("#password").val();
 		var name = $("#name").val().trim();
 		var role = $("#role").children('option:selected').val();
 		var province = $("#province").children('option:selected').val();
 		var checkBox = document.getElementsByName("chkItem");
		var selectId = '';
		for (var i = 0; i < checkBox.length; i++) {
			if (checkBox[i].checked) {
				selectId = selectId + checkBox[i].value + ',';
			}
		}
		//选择区
		var areaId = '';
		var radio = document.getElementsByName("qxItem");
		for (var i = 0; i < radio.length; i++) {
			if (radio[i].checked) {
				if(areaId == ''){
					areaId = radio[i].value;
				}
				else{
				areaId = areaId +','+ radio[i].value ;
				}
			}
		}
 		if(username == null || username == ''){
 			layer.msg("账号不能为空！");
 			return false;
 		}
 		/* if(password == null ){
 			layer.msg("请填写登录密码！");
 			return false;
 		} */
		if(role == ""){
			layer.msg("请选择相应的角色！");
			return false;
		}
		if(province == ""){
			layer.msg("请选择省！");
			return false;
		}
		if(selectId == null || selectId == ''){
			layer.msg("请选择城市！");
			return false;
		}
		var city=selectId.substring(0,selectId.length-1);
		$.ajax({
	  		 	    type: "POST",
	  		 	    url: "../user/checkUserName",
	  				data : {"username" : username},
	  				dataType : "json",
	  				success : function(data) {
	  					if(data.success){
	  						layer.msg(data.message);
	  					}else{
	  						$.ajax({
	  			 		 	    type: "POST",
	  			 		 	    url: "../user/userSave",
	  			 		 		data:"name="+name+"&city="+city+"&province="+province +"&role="+role+"&username="+username+"&password=" +password+"&area=" +areaId,
	  			 				dataType : "json",
	  			 				success : function(data) {
	  			 					if(data.success){
	  			 						window.parent.location.reload();
	  			 						parent.layer.close(index);
	  			 						layer.msg(data.message);
	  			 					}else{
	  			 						layer.msg(data.message);
	  			 					}
	  			 			   }
	  			 			});
	  					}
	  			   }  
	  	});
		
			 
		}

	// 取消操作
	function back(){
		var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
       parent.layer.close(index);
	}


  </script>
  </head>
  <body>

	<div class="container">
	<div class="pop city account">
		<ul>
			<li>
				<span>登录账号：</span>
				<input type="text" id="username" name="username" />
			</li>
			<li>
				<span>登录密码：</span>
				<input type="password" id="password" name="password" />
			</li>
		
			<li>
				<span>真实姓名：</span>
				<input type="text" id="name" name="name" />
			</li>
			<li>
				<span>账号角色：</span>
				<select id="role" name="role">
					<option value="">==请选择==</option>
					<c:forEach items="${roleList}" var="item" varStatus="status">
						<c:if test="${item!=null}">
							<option value="${item.CODE}">${item.NAME}</option>
						</c:if>
					</c:forEach>
				</select>
			</li>
			<li>
				<span>所属地区：</span>
				<select id="province" name="province" onchange="getCity()">
					<c:forEach items="${provinceList}" var="item" varStatus="status">
						<c:if test="${item!=null}">
							<option value="${item.ID}">${item.NAME}</option>
						</c:if>
					</c:forEach>
				</select>
				<li style="height:auto;">
				<span>公告城市：</span>
				<label><input id="chkAll" type="checkbox"/>全选 </label> 
				<div class="select-city" id="city" >
				</div>
			</li>

				<li style="height:auto;">
				<span>公告区县：</span>
				<div class="select-city" id="area" >
				</div>
			</li>
			</li>
		</ul>
		<div class="cb"></div>
		<div class="pop-btnbox">
			<input type="button" class="btn determine margin-15" value="确定"  onclick="addUserSave()"/>
			<input type="button" class="btn cancel" value="取消"  onclick="back()"/>
		</div>
	</div>
</div>
  </body>
  </html>