<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/9/18
  Time: 21:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/songList.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/album.css">
</head>

<body>
<div class="songList">
    <div class="content">
        <div class="top">
            <div class="box1">
                <div class="little_box">
                    <div class="img">
                        <img src="${pageContext.request.contextPath}/img/head.png" alt="">
                        <span></span>
                    </div>
                    <div class="caozuo">
                        <div class="a">
                            <span class="aa">专辑</span>
                            <h4>披着羊皮的狼</h4>
                        </div>
                        <div class="c">
                            <!-- 播放全部 -->
                            <div class="all">
                                <p>
                                    <span class="glyphicon glyphicon-play-circle"></span>
                                    <span>播放全部</span>
                                </p>
                                <span>+</span>
                            </div>
                            <!-- 收藏 -->
                            <div class="cc">
                                <span class="glyphicon glyphicon-plus"></span>
                                <span>收藏</span>
                            </div>
                            <!-- 下载全部 -->
                            <div class="cc">
                                <span class="glyphicon glyphicon-download-alt"></span>
                                <span>下载全部</span>
                            </div>
                        </div>
                        <div class="d">
                            <span>歌手：</span><span>刀郎</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="box2">
                <div class="one">
                    <span>歌曲列表</span>
                    <div></div>
                </div>
                <div class="two">
                    <span>评论(0)</span>
                    <div></div>
                </div>
                <div class="three">
                    <span>专辑详情</span>
                    <div></div>
                </div>

            </div>
        </div>
        <div class="bottom">
            <table>
                <tr>
                    <td><span></span></td>
                    <td>操作</td>
                    <td>音乐标题</td>
                    <td>歌手</td>
                    <td>专辑</td>
                    <td>时长</td>
                </tr>
                <%--<tr>
                    <td>01</td>
                    <td>
                        <div>
                            <span class="glyphicon glyphicon-heart-empty"></span>
                            <span class="glyphicon glyphicon-download-alt"></span>
                        </div>
                    </td>
                    <td>世界第一等</td>
                    <td>刘德华</td>
                    <td>爱你一万年</td>
                    <td>04:21</td>
                </tr>--%>

            </table>
        </div>
    </div>
</div>

<script>
    $(function () {

        //获取专辑id
        let a_id = window.aid;  //从全局作用域中获取
        if (a_id != null && a_id.length != 0) {  //说明全局作用域中存在
            getAlbum(a_id);
            window.aid = null;  //使用完后清除记录

        } else {
            //获取用户的登录情况，根据用户获得用户的播放列表
            $.get("${pageContext.request.contextPath}/login/auto.do", function (data) {
                let uid = data.u_id;
                //发送异步请求获取当前正在播放的歌曲，获得歌曲的专辑id
                $.get("${pageContext.request.contextPath}/playList/current.do", {uid: uid}, function (data) {
                    if (data != null && data.length != 0) {
                        a_id = data.album.a_id;  //获得专辑id
                        getAlbum(a_id);  //加载
                    }
                });
            });
        }

        //获取专辑的详细信息
        function getAlbum(a_id) {
            $(".songList .content .top .box1 .little_box .img span").html(a_id); //将专辑id存起来，用于收藏
            //发送请求获取专辑的详细信息
            $.get("${pageContext.request.contextPath}/album/details/" + a_id + ".do", function (data) {
                if (data != null && data.length != 0) {
                    //页面渲染
                    $(".songList .content .top .box1 .little_box .img img").prop("src", data.a_image);  //专辑封面
                    $(".songList .content .top .box1 .little_box .caozuo .a h4").html(data.a_name);  //专辑名
                    $(".songList .content .top .box1 .little_box .caozuo .d span:last-child").html(data.singer.singer_name);  //歌手名

                    //判断专辑是否为用户收藏
                    if (data.isCollect) {  //为我收藏
                        $(".songList .content .top .box1 .little_box .caozuo .c .cc:nth-child(2) span:first-child").addClass("glyphicon-ok");
                        $(".songList .content .top .box1 .little_box .caozuo .c .cc:nth-child(2) span:last-child").html("已收藏");
                    } else {
                        $(".songList .content .top .box1 .little_box .caozuo .c .cc:nth-child(2) span:first-child").addClass("glyphicon-plus");
                        $(".songList .content .top .box1 .little_box .caozuo .c .cc:nth-child(2) span:last-child").html("收藏");
                    }

                    //歌曲列表
                    for (let i = 0; i < data.songs.length; i++) {
                        let id = i + 1;
                        id = id < 10 ? "0" + id : id;
                        //判断一首歌曲是不是我喜欢
                        let like = null; //我喜欢
                        if (data.songs[i].isLike) {  //我喜欢
                            like = "glyphicon-heart";
                        } else {
                            like = "glyphicon-heart-empty";
                        }
                        //判断歌曲是否下载
                        let download = null; //是否下载
                        if (data.songs[i].isDownload) { //已下载
                            download = "glyphicon-ok-sign";
                        } else {
                            download = "glyphicon-download-alt";
                        }
                        let str = "<tr><td>" + id + "<span>" + data.songs[i].s_id + "</span></td><td><div><span class='glyphicon "+like+"'></span><span class='glyphicon "+download+"'></span></div></td><td>" + data.songs[i].s_name + "</td><td>" + data.singer.singer_name + "</td><td>" + data.a_name + "</td><td>" + data.songs[i].s_length + "</td></tr>";
                        $(".songList .content .bottom table").append($(str));
                    }
                }
            });
        }
    });
</script>

<script src="${pageContext.request.contextPath}/js/album.js"></script>
<script src="${pageContext.request.contextPath}/js/likeList.js"></script>
</body>

</html>
