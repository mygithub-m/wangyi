<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/9/14
  Time: 20:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/searchPage.css">
</head>
<body>
<div class="searchPage">
    <div class="content">
        <div class="top">
            <div class="box1">
                <span>搜索<span></span>,找到<span></span><span></span></span>
            </div>
            <div class="box2">
                <div class="one">
                    <span>单曲</span>
                    <div></div>
                </div>
                <div class="two">
                    <span>歌手</span>
                    <div></div>
                </div>
                <div class="three">
                    <span>专辑</span>
                    <div></div>
                </div>
            </div>
        </div>
        <div class="song">
            <table>
               <%-- <tr><td></td><td>操作</td><td>音乐标题</td><td>歌手</td><td>专辑</td><td>时长</td></tr>--%>
                <%--  <tr>
                      <td><span></span><span></span></td>
                      <td><span class="glyphicon glyphicon-heart-empty"></span><span
                              class="glyphicon glyphicon-download-alt"></span></td>
                      <td>世界第一等</td>
                      <td>刘德华</td>
                      <td>爱你一万年</td>
                      <td>04:21</td>
                  </tr>--%>
            </table>
        </div>
        <div class="singer">
            <table>
                <%--<tr>td><img src="../img/head.png" alt=""></td><td>庞龙</td><td>id</td></tr>--%>
            </table>
        </div>
        <div class="album">
            <table>
                <%--<tr><td><img src="../img/head.png" alt=""></td><td>辑名 </td><td>歌手名</td><td>id</td></tr>--%>
            </table>
        </div>
    </div>
</div>
<script>
    $(function () {
        //改变侧边栏样式
        var sidebar = $("#sidebar_s .box1 li a");
        sidebar.each(function (index, ele) {
            $(ele).removeClass("sidebar_select");
        });
    });
</script>
<script src="${pageContext.request.contextPath}/js/searchPage.js"></script>
</body>
</html>
