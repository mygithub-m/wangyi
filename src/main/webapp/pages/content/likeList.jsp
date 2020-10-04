<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/9/15
  Time: 17:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/songList.css">
</head>

<body>
<div class="songList">
    <div class="content">
        <div class="top">
            <div class="box1">
                <div class="little_box">
                    <div class="img">
                        <img src="${pageContext.request.contextPath}/img/head.png" alt="">
                        <div>
                            <span class="glyphicon glyphicon-heart-empty" id="likeStar"></span>
                        </div>
                    </div>
                    <div class="caozuo">
                        <div class="a">
                            <span>歌单</span>
                            <h4>我喜欢的音乐</h4>
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
                <%--  <tr>
                      <td>01<span></span></td>
                      <td>
                          <div><span class="glyphicon glyphicon-heart"></span><span
                                  class="glyphicon glyphicon-download-alt"></span></div>
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
        //发送异步请求请求用户登录信息
        $.get("${pageContext.request.contextPath}/login/auto.do", function (data) {
            if (data != null && data.length != 0) {
                $(".songList .content .top .box1 .little_box .caozuo .b img").prop("src", data.u_head_image)//用户头像
                $(".songList .content .top .box1 .little_box .caozuo .b .name").html(data.u_nickname);  //用户名称
                $("#date").html(parseTime(data.u_register_date) + "创建");  //歌单创建时间

                let u_id = data.u_id;  // 用户id
                //发送异步请求请求用户喜欢的歌曲信息
                $.get("${pageContext.request.contextPath}/likeList/like/" + u_id + ".do", function (data) {
                    if (data != null && data.length != 0) {
                        $(".songList .content .bottom table").html("<tr><td><span></span></td><td>操作</td><td>音乐标题</td><td>歌手</td><td>专辑</td><td>时长</td></tr>");  //清空，只保留表头

                        $(".songList .content .top .box1 .little_box .jilu div:first-child span").html(data.length);  //歌曲总数
                        $(".songList .content .top .box1 .little_box .jilu div:last-child span").html(0);  //播放次数
                        $(".songList .content .top .box1 .little_box .img img").prop("src", data[0].album.a_image);  //歌单封面，默认为第一首歌曲封面

                        for (let i = 0; i < data.length; i++) {
                            let id = i + 1;
                            id = id < 10 ? "0" + id : id;
                            //判断歌曲是否被下载
                            let load = null;
                            if(data[i].isDownload){  //被下载
                                load = "glyphicon-ok-sign";
                            } else {
                                load = "glyphicon-download-alt";
                            }
                            let str = "<tr><td>" + id + "<span>" + data[i].s_id + "</span></td><td><div><span class='glyphicon glyphicon-heart'></span><span class='glyphicon "+load+"'></span></div></td><td>" + data[i].s_name + "</td><td>" + data[i].singer.singer_name + "</td><td>" + data[i].album.a_name + "</td><td>" + data[i].s_length + "</td></tr>"
                            $(".songList .content .bottom table").append($(str));
                        }
                    }
                });
            }
        });

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
