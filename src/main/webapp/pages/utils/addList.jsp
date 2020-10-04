<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/9/18
  Time: 19:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/addList.css">
</head>
<body>
<div class="addList">
    <div class="content">
        <div class="triangle"><em></em><span></span></div>
        <div class="top">
            <h5>新建歌单</h5>
        </div>
        <div class="main">
            <input type="text" placeholder="请输入新歌单标题">
            <br>
            <input type="checkbox" name="" id=""><span>设置为隐私歌单</span>
        </div>
        <div class="bottom">
            <button>创建</button>
            <button>取消</button>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/addList.js"></script>
</body>
</html>
