<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/8/29
  Time: 10:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>头部</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
</head>
<body>
<!-- 头部 -->
<div class="header">
    <div class="content">
        <div class="title">
            <img src="${pageContext.request.contextPath}/img/08.png">
            <h3>网易云音乐</h3>
        </div>
        <div class="box1">
            <div class="search">
                <input type="text" name="" placeholder="搜索歌曲,歌手" id="searchInput">
                <img src="${pageContext.request.contextPath}/img/07.png">
            </div>
            <div class="about_me">
                <img src="${pageContext.request.contextPath}/img/head.png" id="userHead">
                <a href="javaScript:;" id="userName">未登录<span class="caret"></span></a>
            </div>
        </div>
    </div>
</div>
<!-- 头部结束 -->

<script>
    $(function () {
        //查询客户端是否存在自动登录用户
        $.get("${pageContext.request.contextPath}/login/auto.do",
            {},
            function (data) {

                if (data != null && data !=""){//自动登录成功
                    //获取头部元素
                    let userName = $("#userName");  //获取头部用户名元素
                    let userHead = $("#userHead");  //获取头部用户头像元素
                    //获取信息框中元素
                    let myself_userName = $("#myself_userName");  //个人信息框中用户名
                    let myself_userHead = $("#myself_userHead");  //个人信息框中用户头像
                    //写入头部
                    userName.html(data.u_nickname+'<span class="caret"></span>');  //写入用户名
                    userHead.prop("src",data.u_head_image);  //写入用户头像
                    //写入信息框
                    myself_userName.html(data.u_nickname);  //写入用户名
                    myself_userHead.prop("src",data.u_head_image);  //写入用户头像
                }
            });
    });
</script>
<script src="${pageContext.request.contextPath}/js/header.js"></script>
</body>
</html>
