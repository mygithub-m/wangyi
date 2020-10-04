<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/9/14
  Time: 16:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/playAll.css">
</head>
<body>
<div class="playAll">
    <div class="content">
        <div class="top">
            <h5>替换播放列表</h5>
            <button type="button" class="close" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        </div>
        <div class="main">
            <div>
                "播放全部"将会替换当前的播放列表，是否继续？
            </div>
            <p>
                <input type="checkbox" name="" id="">
                不再提醒
            </p>
        </div>
        <div class="bottom">
            <button id="continue">继续</button>
            <button id="cancel">取消</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/playAll.js"></script>
</body>
</html>
