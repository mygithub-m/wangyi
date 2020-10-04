<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/9/13
  Time: 9:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/commentsPage.css">
</head>
<body>
<div class="commentsPage">
    <div class="content">
        <div class="top">
            <h5>歌曲:&ensp;<span>世界第一等</span></h5>
            <button type="button" class="close" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        </div>
        <div class="main">
            <div>
                <textarea name="c_content" maxlength="140" cols="30" rows="10" placeholder="发表评论"></textarea>
                <br>
                <span>140</span>
            </div>
        </div>
        <div class="bottom">
            <button>评论</button>

        </div>
    </div>
</div>

<script>

    $(function () {
        var song_id = null;  //歌曲id
        var user_id = null;  //用户id
        //获取用户登录情况
        $.get("${pageContext.request.contextPath}/login/auto.do", function (data) {
            let uid = data.u_id;
            //发送异步请求，请求当前播放歌曲信息
            $.get("${pageContext.request.contextPath}/playList/current.do",{uid:uid},function (data) {

                if (data != null && data.length != 0) {
                    song_id = data.s_id;
                    $(".commentsPage .content .top h5 span").html(data.s_name);  //歌曲名
                }
            });
        });



        //发布评论
        $(".commentsPage .content .bottom button").on("click", function () {

            //获取评论内容
            var c_content = $(".commentsPage .content .main textarea").val().trim();
            if (c_content.length != 0) {  //说明有内容
                //获取用户信息
                $.get("${pageContext.request.contextPath}/login/auto.do", function (data) {
                    if (data != null && data.length != 0) {
                        user_id = data.u_id;  //用户id
                        $.post("/wangyi/comments/add.do", {
                            song_id: song_id,
                            user_id: user_id,
                            c_content: c_content
                        }, function (data) {
                            if (data != null && data.length != 0) {  //说明添加成功
                                $(".commentsPage .content .top button").click();  //关闭评论页面
                                //请求歌曲最新的评论消息
                                $.get("${pageContext.request.contextPath}/comments/find/" + song_id + ".do", function (data) {
                                    if (data != null && data.length != 0) {
                                        //刷新评论区
                                        $(".playPage .content .bottom .box .comments ul").html("");  //加载前先清空一下
                                        $(".playPage .content .bottom .box h4 span span").html(data.length);  //歌曲评论数

                                        for (let i = 0; i < data.length; i++) {
                                            let date = parseTime(data[i].c_date);   //评论时间

                                            let str = "<li data-index=" + data[i].user.u_id + "><span>" + data[i].c_id + "</span><div><img src=" + data[i].user.u_head_image + "><div><div><p><span>" + data[i].user.u_nickname + "</span>：" + data[i].c_content + "</p></div><p><span>" + date + "</span><span class='glyphicon glyphicon-thumbs-up'>(" + data[i].c_support + ")</span> </p></div></div></li>";
                                            $(".playPage .content .bottom .box .comments ul").append($(str));
                                        }
                                    }
                                });
                            }
                        });
                    } else {
                        alert("请先登录！");
                    }
                });
            } else {
                alert("请输入内容！");
            }

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

<script src="${pageContext.request.contextPath}/js/commentsPage.js"></script>
</body>
</html>
