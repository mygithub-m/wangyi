<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/9/9
  Time: 20:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mycollect.css">
</head>

<body>
<div class="mycollect">
    <div class="content" id="style-5">
        <div class="top">
            <div class="box">
                <div class="box1 select">专辑</div>
                <div class="box1">歌手</div>
            </div>
        </div>

        <div class="ed now">
            <div class="main">
                <div class="box">
                    <div class="all">
                        <h4>收藏的专辑</h4>
                    </div>
                </div>
                <div class="search">
                    <input type="text" name="" placeholder="搜索我收藏的专辑">
                    <img src="${pageContext.request.contextPath}/img/07.png">
                    <span>✖</span>
                </div>
            </div>
            <div class="bottom">
                <table>
                    <%-- <tr>
                         <td><img src="${pageContext.request.contextPath}/img/head.png" alt=""></td>
                         <td>世界上不存在的歌</td>
                         <td>陈奕迅</td>
                         <td>1首</td>
                         <td>id</td>
                     </tr>--%>
                </table>
            </div>
        </div>


        <div class="ing">
            <div class="main">
                <div class="box">
                    <div class="all">
                        <h4>收藏的歌手</h4>
                    </div>
                </div>
                <div class="search">
                    <input type="text" name="" placeholder="搜索我收藏的歌手">
                    <img src="${pageContext.request.contextPath}/img/07.png">
                    <span>✖</span>
                </div>
            </div>
            <div class="bottom">
                <table>
                   <%-- <tr>
                        <td><img src="http://localhost:8080/music_player_singer_image/head.png" alt=""></td>
                        <td>世界上不存在的歌</td>
                        <td>陈奕迅</td>
                        <td>专辑:107</td>
                        <td>歌曲:1000</td>
                    </tr>--%>

                </table>
            </div>
        </div>
    </div>
</div>

<script>
    $(function () {
        //发送异步请求获取用户的登录情况
        $.get("${pageContext.request.contextPath}/login/auto.do", function (data) {
            if (data != null && data.length != 0) {
                //获取用户id
                let uid = data.u_id;
                //发送异步请求，获取用户收藏的专辑信息
                $.get("${pageContext.request.contextPath}/album/getAll.do", {uid: uid}, function (data) {
                    if (data != null && data.length != 0) {
                        //收藏列表
                        for (let i = 0; i < data.length; i++) {
                            let str = "<tr><td><img src='" + data[i].a_image + "'></td><td>" + data[i].a_name + "</td><td>" + data[i].singer.singer_name + "</td><td>" + data[i].songs.length + "首</td><td>" + data[i].a_id + "</td></tr>"
                            //写入
                            $(".mycollect .content .ed .bottom table").append($(str));
                        }
                    }
                });
            }
        });
    });
</script>

<script src="${pageContext.request.contextPath}/js/mycollect.js"></script>
</body>

</html>
