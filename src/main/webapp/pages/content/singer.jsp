<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/9/20
  Time: 11:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/singer.css">

</head>

<body>
<div class="singer">
    <div class="content" id="singer-style">
        <div class="top">
            <div class="box1">
                <div class="little_box">
                    <div class="img">
                        <img src="${pageContext.request.contextPath}/img/head.png" alt="">
                        <span></span>
                    </div>
                    <div class="caozuo">
                        <div class="a">
                            <span>歌手</span>
                            <h4>刘德华</h4>
                        </div>
                        <div class="d">
                            <span class="glyphicon glyphicon-music"></span>
                            <span>单曲数：</span><span>1750</span>
                        </div>
                        <div class="e">
                            <span class="glyphicon glyphicon-cd"></span>
                            <span>专辑数：</span><span>113</span>
                        </div>
                    </div>
                    <div class="collect">
                        <span class="glyphicon glyphicon-plus"></span>
                        <span>收藏</span>
                    </div>
                </div>
            </div>
            <div class="box2">
                <div class="one">
                    <span>专辑</span>
                    <div></div>
                </div>
                <div class="two">
                    <span>歌手详情</span>
                    <div></div>
                </div>
                <div class="three">
                    <span>相似歌手</span>
                    <div></div>
                </div>

            </div>
        </div>
        <div class="bottom">
            <ul>
                <%--       <li><img src="${pageContext.request.contextPath}/img/head.png" alt="">
                           <div>
                               <div><span>恭喜发财</span>
                                   <div><span class="glyphicon glyphicon-plus"></span><span
                                           class="glyphicon glyphicon-play-circle"></span></div>
                               </div>
                               <table>
                                   <tr>
                                       <td><span>sid</span><span>id</span></td>
                                       <td>
                                           <div><span class="glyphicon glyphicon-heart-empty"></span><span
                                                   class="glyphicon glyphicon-download-alt"></span>
                                           </div>
                                       </td>
                                       <td>恭喜发财2020</td>
                                       <td>02:30</td>
                                   </tr>
                               </table>
                           </div>
                       </li>--%>
            </ul>
        </div>
    </div>
</div>
</body>

<script>
    $(function () {

        let singer_id = window.singerId;
        if (singer_id != null && singer_id.length != 0){  //singerId存在
            getSinger(singer_id);  //加载
            window.singerId = null; //清空
        } else {
            //获取用户的登录情况，根据用户获得用户的播放列表
            $.get("${pageContext.request.contextPath}/login/auto.do", function (data) {
                let uid = data.u_id;
                //发送异步请求获取当前正在播放的歌曲的id
                $.get("${pageContext.request.contextPath}/playList/current.do",{uid:uid},function (data) {
                    if (data != null && data.length != 0) {
                        //获取歌曲的歌手id
                        let singer_id = data.singer_id;
                        getSinger(singer_id);  //加载
                    }
                });
            });
        }


        //根据歌手id获取歌手的详细信息
        function getSinger(singer_id) {
            $(".singer .content .top .box1 .little_box .img span").html(singer_id);  //保存歌手id，用于歌手的收藏
            //发送异步请求获取当前歌手的详细信息
            $.get("${pageContext.request.contextPath}/singer/details/" + singer_id + ".do", function (data) {

                if (data != null && data.length != 0) {
                    //页面渲染
                    $(".singer .content .top .box1 .little_box .img img").prop("src", data.singer_image);  //歌手头像
                    $(".singer .content .top .box1 .little_box .caozuo .a h4").html(data.singer_name);  //歌手名
                    $(".singer .content .top .box1 .little_box .caozuo .e span:last-child").html(data.albums.length); //专辑数

                    //判断专辑是否为用户收藏
                    if (data.isCollect) {  //为我收藏
                        $(".singer .content .top .box1 .little_box .collect span:first-child").addClass("glyphicon-ok");
                        $(".singer .content .top .box1 .little_box .collect span:last-child").html("已收藏");
                    } else {
                        $(".singer .content .top .box1 .little_box .collect span:first-child").addClass("glyphicon-plus");
                        $(".singer .content .top .box1 .little_box .collect span:last-child").html("收藏");
                    }

                    let songNum = 0;  //歌曲数
                    //专辑列表
                    for (let i = 0; i < data.albums.length; i++) {
                        songNum = songNum + data.albums[i].songs.length;
                        //专辑基本信息
                        let str = "<li><img src='" + data.albums[i].a_image + "'><div><div><span>" + data.albums[i].a_name + "</span><div><span class='glyphicon glyphicon-plus'></span><span class='glyphicon glyphicon-play-circle'></span><span>"+data.albums[i].a_id+"</span></div></div><table></table></div></li>";
                        $(".singer .content .bottom ul").append($(str));
                        //专辑歌曲信息
                        let id = 0;
                        for (let j = 0; j < data.albums[i].songs.length; j++) {
                            id = j + 1;
                            id = id < 10 ? "0" + id : id;
                            //判断一首歌曲是不是我喜欢
                            let like = null; //我喜欢
                            if (data.albums[i].songs[j].isLike) {  //我喜欢
                                like = "glyphicon-heart";
                            } else {
                                like = "glyphicon-heart-empty";
                            }
                            //判断歌曲是否下载
                            let download = null; //是否下载
                            if (data.albums[i].songs[j].isDownload) { //已下载
                                download = "glyphicon-ok-sign";
                            } else {
                                download = "glyphicon-download-alt";
                            }
                            let songStr = "<tr><td><span>" + data.albums[i].songs[j].s_id + "</span><span>" + id + "</span></td><td><div><span class='glyphicon "+like+"'></span><span class='glyphicon "+download+"'></span></div></td><td>" + data.albums[i].songs[j].s_name + "</td><td>" + data.albums[i].songs[j].s_length + "</td></tr>";
                            //写入
                            $(".singer .content .bottom ul li:last-child").find("table").append($(songStr));
                        }

                    }

                    $(".singer .content .top .box1 .little_box .caozuo .d span:last-child").html(songNum);  //单曲数量
                }
            });
        }
    });
</script>

<script src="${pageContext.request.contextPath}/js/singer.js"></script>
</html>