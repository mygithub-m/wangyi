<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/9/5
  Time: 16:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/myDownload.css">
</head>

<body>
<div class="myDownload">
    <div class="content" id="style-5">
        <div class="top">
            <h4>本地音乐<span>共<span></span>首</span></h4>
        </div>
        <div class="main">
            <div class="all">
                <p>
                    <span class="glyphicon glyphicon-play-circle"></span>
                    <span>播放全部</span>
                </p>
                <span>+</span>
            </div>
            <div class="search">
                <input type="text" name="" placeholder="搜索本地音乐">
                <img src="${pageContext.request.contextPath}/img/07.png">
                <span>✖</span>
            </div>
        </div>
        <div class="bottom">
            <table>
                <tr>
                    <td></td>
                    <td>音乐标题</td>
                    <td>歌手</td>
                    <td>专辑</td>
                    <td>时长</td>
                    <td>大小</td>
                    <td>id</td>
                </tr>
                <%--   <tr>
                       <td>01</td>
                       <td>世界第一等</td>
                       <td>刘德华</td>
                       <td>爱你一万年</td>
                       <td>04:21</td>
                       <td>10.2MB</td>
                   </tr>--%>

            </table>
        </div>
    </div>
</div>

<script>

    $(function () {
        //发送异步请求请求本地音乐列表
        $.get("${pageContext.request.contextPath}/song/local.do", {}, function (data) {
            if (data != null) {  //获取数据成功
                $(".myDownload .content .bottom table").html("");  //先清空，再显示数据
                $(".myDownload .content .bottom table").append($("<tr><td></td><td>音乐标题</td><td>歌手</td><td>专辑</td><td>时长</td><td>大小</td><td>id</td></tr>"));

                $(".myDownload .content .top span span").html(data.length); //歌曲数量
                for (let i = 0; i < data.length; i++) {
                    let id = i + 1;
                    id = id < 10 ? "0" + id : id;
                    //生成dom元素，并添加信息
                    let tr = " <tr><td><span>" + id + "</span><span class='glyphicon glyphicon-volume-up'></span></td><td>" + data[i].s_name + "</td><td>" + data[i].singer.singer_name + "</td><td>" + data[i].album.a_name + "</td><td>" + data[i].s_length + "</td><td>" + data[i].s_size + "MB</td><td>" + data[i].s_id + "</td></tr>"
                    $(".myDownload .content .bottom table").append($(tr));
                }
            }

            //获取用户的登录情况，根据用户获得用户的播放列表
            $.get("${pageContext.request.contextPath}/login/auto.do", function (data) {
                let uid = data.u_id;
                $.get("${pageContext.request.contextPath}/playList/current.do", {uid: uid}, function (data) {

                    $(".myDownload .content .bottom table tr").each(function (index, element) {

                        if ($(this.querySelector("td:last-child")).html() == data.s_id) {
                            $(this.querySelector("td:first-child span:last-child")).css("display", "block");
                            $(this.querySelector("td:first-child span:first-child")).css("display", "none");
                        } else {
                            $(this.querySelector("td:first-child span:last-child")).css("display", "none");
                            $(this.querySelector("td:first-child span:first-child")).css("display", "block");
                        }
                    });
                });
            });
        });
    });
</script>
<script src="${pageContext.request.contextPath}/js/myDownload.js"></script>
</body>
</html>
