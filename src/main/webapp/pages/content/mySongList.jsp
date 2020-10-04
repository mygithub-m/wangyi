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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mySongList.css">
</head>

<body>
<div class="songList">
    <div class="content">
        <div class="top">
            <div class="box1">
                <div class="little_box">
                    <div class="img">
                        <img src="${pageContext.request.contextPath}/img/head.png" alt="">
                    </div>
                    <div class="caozuo">
                        <div class="a">
                            <span>歌单</span>
                            <h4>自定义歌单</h4>
                            <span class="glyphicon glyphicon-edit"></span>
                        </div>
                        <div class="b">
                            <img src="${pageContext.request.contextPath}/img/head.png" alt="">
                            <span class="name">滑翔的人儿</span>
                            <span id="date">2020-09-26创建</span>
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
                            <span>标签：</span><span>华语</span>
                        </div>
                        <div class="e">
                            <span>简介：</span><span>我的私人珍藏</span>
                        </div>
                    </div>
                    <div class="jilu">
                        <div>
                            <p>歌曲数</p>
                            <span>10</span>
                        </div>
                        <div>
                            <p>播放数</p>
                            <span>60</span>
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
                    <span>收藏者</span>
                    <div></div>
                </div>

            </div>
            <div class="search">
                <input type="text" name="" placeholder="搜索歌单音乐">
                <img src="${pageContext.request.contextPath}/img/07.png">
                <span>✖</span>
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
        //获取自定义歌单id
        let slid = window.sl_id;
        if (slid != null && slid.length != 0) {
            //发送异步请求请求当前歌单的信息
            $.get("${pageContext.request.contextPath}/songList/get/" + slid + ".do", function (data) {

                if (data != null && data.length != 0) {
                    $(".songList .content .bottom table tr:first-child td:first-child span").html(data.sl_id);  //歌单id
                    $(".songList .content .top .box1 .little_box .caozuo .b img").prop("src", data.user.u_head_image)//用户头像
                    $(".songList .content .top .box1 .little_box .caozuo .b .name").html(data.user.u_nickname);  //用户名称
                    $(".songList .content .top .box1 .little_box .caozuo .a h4").html(data.sl_name);  //专辑名称
                    $("#date").html(parseTime(data.sl_date) + "创建");  //歌单创建时间

                    $(".songList .content .top .box1 .little_box .jilu div:first-child span").html(data.songList.length);  //歌曲总数
                    $(".songList .content .top .box1 .little_box .jilu div:last-child span").html(data.sl_playnum);  //播放次数
                    $(".songList .content .top .box1 .little_box .caozuo .d span:last-child").html(data.sl_tag);  //歌单标签
                    $(".songList .content .top .box1 .little_box .caozuo .e span:last-child").html(data.sl_introduce);  //歌单标签

                    //判断歌单中是否存在歌曲
                    if (data.songList.length == 0) {  //如果歌单中没有歌曲
                        let str = "<tr><td colspan='6' style='font-size: 12px;text-align: center'>你还没有收藏任何歌曲</td></tr>"
                        $(".songList .content .bottom table").append($(str));
                    } else {  //将第一首歌曲封面作为歌单封面
                        $(".songList .content .top .box1 .little_box .img img").prop("src", data.songList[0].album.a_image);  //歌单封面，默认为第一首歌曲封面

                        //歌曲列表
                        for (let i = 0; i < data.songList.length; i++) {
                            let id = i + 1;
                            id = id < 10 ? "0" + id : id;

                            //判断一首歌曲是不是我喜欢
                            let like = null; //我喜欢
                            if (data.songList[i].isLike) {  //我喜欢
                                like = "glyphicon-heart";
                            } else {
                                like = "glyphicon-heart-empty";
                            }
                            //判断歌曲是否下载
                            let download = null; //是否下载
                            if (data.songList[i].isDownload) { //已下载
                                download = "glyphicon-ok-sign";
                            } else {
                                download = "glyphicon-download-alt";
                            }

                            let str = "<tr><td>" + id + "<span>" + data.songList[i].s_id + "</span></td><td><div><span class='glyphicon "+like+"'></span><span class='glyphicon "+download+"'></span></div></td><td>" + data.songList[i].s_name + "</td><td>" + data.songList[i].singer.singer_name + "</td><td>" + data.songList[i].album.a_name + "</td><td>" + data.songList[i].s_length + "</td></tr>";

                            $(".songList .content .bottom table").append($(str));
                        }
                    }
                }
            });
        }

        //将评论日期转换为指定格式
        function parseTime(x) {
            let date = new Date(x);
            let year = date.getFullYear();
            let mouth = date.getMonth() + 1;
            mouth = mouth < 10 ? "0" + mouth : mouth;
            let day = date.getDate();
            day = day < 10 ? "0" + day : day;

            return year + "-" + mouth + "-" + day;
        }

    });
</script>

<script src="${pageContext.request.contextPath}/js/likeList.js"></script>
</body>

</html>
