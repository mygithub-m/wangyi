<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/8/29
  Time: 9:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>网易云</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico">
    <script src="${pageContext.request.contextPath}/js/jQuery.js"></script>
    <style>
        #content{
            display: flex;
        }

        #content > div{
            position: relative;
        }

        #downloadManager {
            display: none;
        }

        #mycollect{
            display: none;
        }

        #editMyself{
            display: none;
        }

        #playPage{
            position: absolute!important;
            display: none;
            z-index: 10;
            top: 60px;
            left: 0px;
        }

        #footer{
            position: relative;
            z-index: 100;
        }

        #mouseRight {
            width: 200px;
            background-color: #fafafa;
            box-shadow: 0px 0px 5px 5px #ddd;
            position: absolute;
            top: 0px;
            left: 0px;
            display: none;
        }

        #mouseRight ul {
            padding: 3px;
            margin: 0px;
        }

        #mouseRight ul li {
            width: 194px;
            height: 30px;
            list-style: none;
            display: flex;
            align-items: center;
            font-size: 12px;
            cursor: pointer;
            z-index: 5;
        }

        #mouseRight ul li:hover {
            background-color: #e3e3e5;
        }

        #mouseRight ul li span:first-child {
            margin: 0px 10px 0px 15px;
            color: #999;
        }

        #mouseRight ul li span:last-child {
            font-weight: bold;
        }

    </style>
    <script>
        /*一些用于控制的全局变量*/
        window.first = 0;  //标志是不是第一次加载
        window.playList_sids = null;  //播放列表歌曲id集合
        window.singerId = null; //全局专辑id
        window.aid = null; //全局专辑id
        window.loadTimer = null;  //控制音乐下载的定时器
        window.mouseRightSlId = null;  //鼠标右击获取歌单id
    </script>
</head>
<body>
<!-- 头部 -->
<div id="header"></div>
<!-- 内容区 -->
<div id="content">
    <!-- 侧边栏 -->
    <div id="sidebar"></div>
    <!-- 我的下载 -->
    <div id="display"></div>
    <!-- 下载管理 -->
    <div id="downloadManager"></div>
    <!-- 我的收藏 -->
    <div id="mycollect"></div>
    <!-- 个人信息修改-->
    <div id="editMyself"></div>
    <!-- 搜索歌曲页面-->
    <div id="searchPage"></div>
    <!-- 我的歌单 -->
    <div id="songList"></div>
    <!-- 专辑详情 -->
    <div id="album"></div>
    <!-- 歌手详情 -->
    <div id="singer"></div>
</div>
<!-- 底部 -->
<div id="footer"></div>
<!-- 播放页面展示 -->
<div id="playPage"></div>
<!-- 登录框 -->
<div id="login"></div>
<!-- 个人信息框 -->
<div id="myself"></div>
<!-- 注册框 -->
<div id="register"></div>
<!-- 播放全部提示框 -->
<div id="playAll"></div>
<!--评论-->
<div id="commentsPage"></div>
<!--收藏歌曲-->
<div id="collectPage"></div>
<!-- 鼠标右键 -->
<div id="mouseRight">
    <ul>
        <li>
            <span class="glyphicon glyphicon-trash"></span>
            <span>删除</span>
        </li>
    </ul>
</div>
<script>
    $(function () {
        $(document).on("click", function (e) {
            $("#mouseRight").hide();
        });

        //鼠标右键
        //阻止默认右键事件
        $(document).on("contextmenu", function (e) {
            e.preventDefault();
        });
    });
</script>
<script src="${pageContext.request.contextPath}/js/test.js"></script>
</body>
</html>
