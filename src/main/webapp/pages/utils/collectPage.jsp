<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/9/19
  Time: 10:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/collectPage.css">
</head>
<body>
<div class="collectPage">
    <div class="content">
        <div class="top">
            <h5>收藏到歌单</h5>
            <button type="button" class="close" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        </div>
        <div class="main">
            <div>
                <span>+</span>
            </div>
            <span>新建歌单</span>
        </div>
        <div class="bottom">
            <ul id="style_ul">
                <%--<li><span></span><img src="${pageContext.request.contextPath}/img/head.png" alt="">
                    <div><p>我喜欢的音乐</p>
                        <p>32首歌曲，2首已下载</p></div>
                </li>--%>
            </ul>
        </div>
    </div>
</div>
<div class="createList">
    <div class="content">
        <div class="top">
            <h5>新建歌单</h5>
            <button type="button" class="close" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        </div>
        <div class="main">
            <input type="text" placeholder="请输入新歌单标题">
            <br>
            <input type="checkbox" name=""><span>设置为隐私歌单</span>
        </div>
        <div class="bottom">
            <button>创建</button>
            <button>取消</button>
        </div>
    </div>
</div>

<script>
    $(function () {
        //当页面加载完毕后，请求用户的歌单信息，并显示
        $.get("${pageContext.request.contextPath}/login/auto.do", function (data) {
            if (data != null && data.length != 0) {
                let u_id = data.u_id;  // 用户id
                //发送异步请求请求用户喜欢的歌曲信息
                $.get("${pageContext.request.contextPath}/likeList/like/" + u_id + ".do", function (data) {

                    if (data != null && data.length != 0) {
                        $(".collectPage .content .bottom ul").html("");  //清空列表
                        //显示我喜欢歌单信息
                        let str = "<li><span></span><img src=" + data[0].album.a_image + "><div><p>我喜欢的音乐</p><p><span>" + data.length + "</span>首歌曲，0首已下载</p></div></li>";
                        $(".collectPage .content .bottom ul").append($(str));

                        //发送请求，获取用户的所有自定义歌单
                        $.get("${pageContext.request.contextPath}/songList/all/" + u_id + ".do", function (data) {

                            if (data != null && data.length != 0) {
                                for (let i = 0; i < data.length; i++) {
                                    //显示自定义歌单信息
                                    //歌单封面
                                    let image = null;
                                    //歌单歌曲数量
                                    let num = 0;
                                    if (data[i].songList !=null && data[i].songList.length !=0){
                                        image = data[i].songList[0].album.a_image;
                                        num = data[i].songList.length;
                                    } else {
                                        image = "http://localhost:8080/music_player_singer_image/head.png";//说明没有歌曲，使用默认封面
                                    }
                                    let str = "<li><span>" + data[i].sl_id + "</span><img src='"+image+"'><div><p>"+data[i].sl_name+"</p><p><span>" + num + "</span>首歌曲，0首已下载</p></div></li>";
                                    $(".collectPage .content .bottom ul").append($(str));
                                }
                            }
                        });

                    }
                });
            }
        });
    });
</script>

<script src="${pageContext.request.contextPath}/js/collectPage.js"></script>
</body>
</html>
