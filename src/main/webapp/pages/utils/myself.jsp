<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/8/31
  Time: 19:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/myself.css">
</head>
<body>

<div class="myself">
    <div class="content">
        <div class="box">
            <div class="triangle"><em></em><span></span></div>
            <div class="me">
                <img src="" alt="" id="myself_userHead">
                <span id="myself_userName"></span>
            </div>
            <p class="edit">
                <span class="glyphicon glyphicon-cog"></span>
                <span>个人信息设置</span>
            </p>
            <p class="exit">
                <span class="glyphicon glyphicon-off"></span>
                <span>退出登录</span>
            </p>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/myself.js"></script>
</body>
</html>
