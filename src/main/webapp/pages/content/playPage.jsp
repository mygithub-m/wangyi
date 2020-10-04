<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/9/12
  Time: 18:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/playPage.css">
</head>

<body>
<div class="playPage">
    <div class="content" id="style-6">
        <!-- 歌词部分 -->
        <div class="top">
            <div class="box">
                <div class="changdie">
                    <div class="x">
                        <img src="${pageContext.request.contextPath}/img/x.png" alt="" id="zhen">
                    </div>
                    <div class="w" id="album_image">
                        <img src="${pageContext.request.contextPath}/img/w.png" alt="">
                        <div>
                            <img src="${pageContext.request.contextPath}/img/11.png" alt="">
                        </div>
                    </div>
                    <div class="gongneng" id="gongneng">
                        <div>
                            <span class="glyphicon glyphicon-heart-empty"></span>
                            <span>喜欢</span>
                        </div>
                        <div>
                            <span class="glyphicon glyphicon-plus"></span>
                            <span>收藏</span>
                        </div>
                        <div>
                            <span class="glyphicon glyphicon-download-alt"></span>
                            <span>下载</span>
                        </div>
                    </div>
                </div>
                <div class="geci">
                    <h4>世界第一等</h4>
                    <p>
                        <span>专辑:<span>世界第一等</span></span>
                        <span>歌手:<span>刘德华</span></span>
                    </p>
                    <div class="geci_box">
                        <span>该模块还未开发</span>
                    </div>
                </div>
                <div class="page_close" id="playPage_close">
                    <span class="glyphicon glyphicon-resize-small"></span>
                </div>
            </div>
        </div>
        <!-- 评论部分 -->
        <div class="bottom">
            <div class="box">
                <h4>听友评论<span>(已有<span></span>条评论)</span></h4>
                <div class="input">
                    <p>
                        <span class="glyphicon glyphicon-pencil"></span>
                        <input type="text" placeholder="发表评论" disabled=false>
                        😊
                    </p>
                </div>
                <h6>精彩评论</h6>
                <div class="comments">
                    <ul>
                        <%-- <li>
                             <div><img src="${pageContext.request.contextPath}/img/head.png" alt="">
                                 <div>
                                     <div><p><span>滑翔的人儿:</span>真TM好听</p></div>
                                     <p>
                                     <span class="glyphicon glyphicon-thumbs-up">(999)</span>
                                     </p></div>
                             </div>
                         </li>--%>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $("#commentsPage").load("pages/commentsPage.jsp");
</script>


<script>
    $(function () {

        //获取用户的登录情况，根据用户获得用户的播放列表
        $.get("${pageContext.request.contextPath}/login/auto.do", function (data) {
            let uid = data.u_id;
            //发送异步请求请求当前播放歌曲信息
            $.get("${pageContext.request.contextPath}/playList/current.do", {uid: uid}, function (data) {
                if (data != null && data.length != 0) {
                    $(".playPage .content .top .box .geci h4").html(data.s_name);  //歌曲名
                    $(".playPage .content .top .box .geci p>span:first-child span").html(data.album.a_name);  //专辑
                    $(".playPage .content .top .box .geci p>span:last-child span").html(data.singer.singer_name);  //歌手
                    $(".playPage .content .top .box .changdie .w div img").prop("src", data.album.a_image);  //专辑图片
                    let sid = data.s_id;  //歌曲id

                    //判断当前歌曲是否为我喜欢
                    if (data.isLike){   //我喜欢
                        let btn = $(".playPage .content .top .box .changdie .gongneng div:first-child span:first-child");
                        btn.addClass("glyphicon-heart");  //改变样式
                        btn.css("color", "#cd2929");
                        btn.removeClass("glyphicon-heart-empty");
                    }
                    //判断歌曲是否下载
                    if (data.isDownload){  //已经下载
                        let btn = $(".playPage .content .top .box .changdie .gongneng div:last-child span:first-child");
                        $(".playPage .content .top .box .changdie .gongneng div:last-child span:last-child").html("已下载");
                        btn.addClass("glyphicon-ok-sign");
                        $(".playPage .content .top .box .changdie .gongneng div:last-child").css("background-color","#e1e1e1");
                        btn.removeClass("glyphicon-download-alt")
                    }

                    //获取当前歌曲的评论信息
                    $.get("${pageContext.request.contextPath}/comments/find/" + sid + ".do", function (data) {
                        if (data != null && data.length != 0) {
                            $(".playPage .content .bottom .box .comments ul").html("");  //加载前先清空一下
                            $(".playPage .content .bottom .box h4 span span").html(data.length);  //歌曲评论数

                            for (let i = 0; i < data.length; i++) {
                                let date = parseTime(data[i].c_date);   //评论时间

                                let str = "<li data-index=" + data[i].user.u_id + "><span>" + data[i].c_id + "</span><div><img src=" + data[i].user.u_head_image + "><div><div><p><span>" + data[i].user.u_nickname + "</span>：" + data[i].c_content + "</p></div><p><span>" + date + "</span><span class='glyphicon glyphicon-thumbs-up'>(" + data[i].c_support + ")</span> </p></div></div></li>";
                                $(".playPage .content .bottom .box .comments ul").append($(str));
                            }
                        } else {
                            $(".playPage .content .bottom .box h4 span span").html(0);  //歌曲评论数
                            $(".playPage .content .bottom .box .comments ul").html("<strong>歌曲还没有评论，开来抢沙发</strong>");
                        }
                    });
                }
            });
        });


        //将评论日期转换为指定格式
        function parseTime(x) {
            let date = new Date(x);
            let year = date.getFullYear();
            let mouth = date.getMonth() + 1;
            let day = date.getDate();

            let h = date.getHours();
            h = h < 10 ? "0" + h : h;
            let m = date.getMinutes();
            m = m < 10 ? "0" + m : m;

            return year + "年" + mouth + "月" + day + "日" + "  " + h + ":" + m;
        }


    });
</script>
<script src="${pageContext.request.contextPath}/js/playPage.js"></script>
</body>

</html>
