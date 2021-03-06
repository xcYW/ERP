<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>退货商品入库</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<link rel="stylesheet" type="text/css" href="<%=path %>/easyui/themes/default/easyui.css">   
	<link rel="stylesheet" type="text/css" href="<%=path %>/easyui/themes/icon.css">   
	<script type="text/javascript" src="<%=path %>/easyui/jquery-1.8.3.min.js"></script>   
	<script type="text/javascript" src="<%=path %>/easyui/jquery.easyui.min.js"></script>  
	<script type="text/javascript" src="<%=path %>/easyui/easyui-lang-zh_CN.js"></script>  
  </head>
  <script type="text/javascript">
  $(function(){
	  $('#dg').datagrid({    
		    url:'proBackInFood/datagrid',
		    fitColumns:true,
		    toolbar: '#addTool',
		    rownumbers:true,
		    pagination:true,
		    pageSize:5,
		    pageList:[5,10,20,30,40,50],
		    columns:[[
		    	{field:'check',checkbox:true,width:100},
		        {field:'rorderno',title:'订单编号',width:100},
		        {field:'psize',title:'产品规格',width:100},
		        {field:'rpname',title:'产品名称',width:100},
		        {field:'rpnum',title:'退货量(吨)',width:100},
		        {field:'reason',title:'审核意见',width:100},
		        {field:'states',title:'审核状态',width:100},
		        {field:'action',title:'操作',width:100,
		        	formatter: function(value,row,index){
		        		if(row.rstate==2){
		        			return "<input type='button' value='点击入库' onclick='inFood("+row.id+")'/>";
		        		}else{
		        			return "<a>已成功入库</a>";
		        		}
		        		
					}
		        }
		    ]], 
		});
		$('#ss').searchbox({ 
			searcher:function(value,name){ 
				$('#dg').datagrid('load',{
					name: name,
					value: value
				});
			}, 
			menu:'#mm', 
			prompt:'请输入关键字' 
		});  
		
  });
  		function inFood(id){
		//新增窗口
		$("#updateId").dialog({
			title:'新增',
			width: 600,
			height: 400,
			closed: false,
			cache: false,
			href: 'proBackInFood/inFood?id='+id,
			modal: true
		});
	}
  
  
	function clearFun(){
		//searchbox设置为空
		$("#ss").searchbox('setValue', '');
		//刷新列表
		$("#dg").datagrid('reload',{
			name:null,
			value:null
		});
	}
	/* 已入库 */
	function passOutWarehouse(){
		//searchbox设置为空
		$("#ss").searchbox('setValue', '');
		//刷新列表
		$("#dg").datagrid('reload',{
			name:'rstate',
			value:7
		});
	}
	/* 未入库 */
	function notPass(){
		//searchbox设置为空
		$("#ss").searchbox('setValue', '');
		//刷新列表
		$("#dg").datagrid('reload',{
			name:'rstate',
			value:8
		});
	}
	/* 退回成品批量入库 */
	function xuanzhong(){
			var checkList=$("#dg").datagrid("getChecked");
			console.info(checkList);
			//ar idStr="";  复选通过第二种方法
			var idStr=[];
			for(var i=0;i<checkList.length;i++){
				if(checkList[i].rstate==2){
					idStr[i]=checkList[i].id;
				}
				else{
					$.messager.confirm("警告","已筛重复数据,确定继续提交?",function(t){
						if(t){
							continue;
						}else{
							break;
						}
					});
				}
			}
			console.info(idStr);
			if(idStr.length!=0){
				$.messager.confirm("确认","你确定要入库这么多吗?",function(t){
					if(t){
						$.post("proBackInFood/passapprovalAll",{idStr:idStr},function(data){
				 			if(data>0){
				 				$.messager.show({
				 					title:"消息",
				 					msg:"批量入库成功!",
				 					timeout:1000,
				 					showType:'show'
				 				});
				 				$("#dg").datagrid("reload");
				 			}else{
				 				$.messger.show({
				 					title:"消息",
				 					msg:"批量入库失败!",
				 					timeout:2000,
				 					showType:'show'
				 				});
				 			}	
				 		},"json");
					}
				});
			}else{
				$.messager.confirm("请选择","您没有选择!");
			}
		}
  </script>
  <body>
  	<input id="ss"></input> 
	<div id="mm" style="width:120px"> 
	<div data-options="name:'rorderno'">订单编号</div> 
	</div>
	<a id="btn" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="clearFun()">清空</a>
	<div>
		<a id="btn" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="passOutWarehouse()">已入库</a>
		<a id="btn" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="notPass()">未入库</a> 
		<a id="btn" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="xuanzhong()">一键入库</a> 
	</div>
  	<table id="dg"></table>  
     <div id="updateId"></div>
  </body>
</html>

