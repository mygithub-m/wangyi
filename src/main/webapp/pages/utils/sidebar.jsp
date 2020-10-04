<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/8/29
  Time: 10:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>侧边栏</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
</head>

<body>
<div class="sidebar" id="sidebar_s">
    <div class="content">
        <div class="box1 my">
            <!-- 我的音乐板块 -->
            <p>我的音乐</p>
            <ul id="mySong">
                <li>
                    <a  class="local sidebar_select">
                        <span class="glyphicon glyphicon-music"></span>本地音乐</a>
                </li>
                <li>
                    <a class="downloadManager">
                        <span class="glyphicon glyphicon-download-alt"></span>下载管理</a>
                </li>
                <li>
                    <a  class="mycollect">
                        <span class="glyphicon glyphicon-user"></span>我的收藏</a>
                </li>
            </ul>
        </div>

        <div class="box1 box2">
            <!-- 创建的歌单模块 -->
            <p>
                <span>创建的歌单</span>
                <span>
                        <span class="glyphicon glyphicon-plus-sign"></span>
                        <span class="glyphicon glyphicon-menu-down"></span>
                    </span>
            </p>
            <ul id="MySongList">
                <li><a id="like">
                    <span></span><span class="glyphicon glyphicon-heart-empty"></span>喜欢的音乐</a></li>
            </ul>
        </div>
    </div>

    <div class="details" id="details">
        <!-- 歌曲信息 -->
        <div class="box">
            <div class="img">
                <img src="${pageContext.request.contextPath}/img/11.png" alt="" id="details_img">
                <div class="open">
                    <div>
                        <span class="glyphicon glyphicon-resize-full"></span>
                    </div>
                </div>
            </div>
            <div>
                <p><span id="detail_songName">世界第一等</span><span class="glyphicon glyphicon-heart-empty"></span></p>
                <p><span id="detail_songerName">刘德华</span><span class="glyphicon glyphicon-share"></span></p>
            </div>
        </div>
    </div>
</div>
<!-- 新建歌单页面 -->
<div id="add"></div>
<script>
    $("#add").load("pages/utils/addList.jsp");
</script>

<script>
    $(function () {
        //发送异步请求，请求当前已经登录的用户信息,用于获取用户创建的歌单
        $.get("${pageContext.request.contextPath}/login/auto.do", function (data) {
            if (data != null && data.length != 0) {
                let uid = data.u_id;
                //发送请求，获取用户的所有歌单
                $.get("${pageContext.request.contextPath}/songList/all/" + uid + ".do", function (data) {
                    if (data != null && data.length != 0) {
                        $(".sidebar .content .box2 ul").html();  //清空
                        for (let i = 0; i < data.length; i++) {
                            let str = "<li><a><span>" + data[i].sl_id + "</span><span class='glyphicon glyphicon-tasks'></span>" + data[i].sl_name + "</a></li>";

                            $(".sidebar .content .box2 ul").append($(str));  //写入
                        }
                    }
                });
                //发送异步请求获取当前播放歌单信息，并渲染到页面
                $.get("${pageContext.request.contextPath}/playList/current.do", {uid: uid}, function (data) {
                    if (data != null && data.length != 0){
                        //改变样式
                        $("#details_img").prop("src", data.album.a_image);  //专辑图片
                        $("#detail_songName").html(data.s_name);  //歌曲名
                        $("#detail_songerName").html(data.singer.singer_name); //歌手名

                        if (data.isLike) {  //为我喜欢
                            $("#detail_songName").siblings("span").removeClass("glyphicon-heart-empty");
                            $("#detail_songName").siblings("span").addClass("glyphicon-heart").css("color", "#cd2929");
                        } else {  //为我不喜欢
                            $("#detail_songName").siblings("span").removeClass("glyphicon-heart");
                            $("#detail_songName").siblings("span").addClass("glyphicon-heart-empty").css("color", "#444");
                        }
                    }
                });
            }
        });
    });
</script>

<script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
</body>

</html>
