<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/8/29
  Time: 10:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
</head>
<body>
<div class="footer">
    <div class="content">
        <!-- 播放按钮开始 -->
        <div class="play">
            <div class="toggle previous">
                <span class="glyphicon glyphicon-step-backward"></span>
            </div>
            <div class="start" id="start">
                <span class="glyphicon glyphicon-play"></span>
                <!-- glyphicon glyphicon-pause -->
            </div>
            <div class="toggle next">
                <span class="glyphicon glyphicon-step-forward"></span>
            </div>
        </div>
        <!-- 播放按钮结束 -->

        <!-- 进度条开始 -->
        <div class="time">
            <span class="current">00:00</span>
            <div class="progress_bar">
                <div class="bar"></div>
                <div class="but">
                    <span></span>
                </div>
            </div>
            <span class="count">00:00</span>
        </div>
        <!-- 进度条结束 -->

        <audio src="" id="audio"></audio>

        <!-- 音量调节开始 -->
        <div class="volume">
            <span class="glyphicon glyphicon-volume-up"></span>
            <!-- glyphicon glyphicon-volume-off -->
            <div class="bar">
                <div class="box"></div>
                <div class="but">
                    <span></span>
                </div>
            </div>
        </div>
        <!-- 音量调节结束 -->

        <!-- 设置循环模式开始 -->
        <div class="cycle">
            <img src="${pageContext.request.contextPath}/img/09.png" alt="" title="列表循环">
            <span class="glyphicon glyphicon-th-list"></span>
        </div>
        <!-- 设置循环模式结束 -->
    </div>
</div>
<%--播放列表--%>
<div id="playList">

</div>
<script>
    $("#playList").load("/wangyi/pages/utils/playList.jsp");  //加载播放列表
    $("#playPage").load("pages/content/playPage.jsp");  //加载播放页面
</script>

<script>
    $(function () {

        var width = 0; //进度条长度，默认为0
        var currentTime = 0;  //代表当前时间
        var flag = true;  //音乐播放状态
        var step = null; //步长
        var timeCount = null;  //总时间
        var length = null;
        let uid = null;  //用户登录
        window.timer = null;  //定时器,定义一个全局变量，在双击音乐时可以关闭定时器
        window.timer2 = null;  //唱碟定时器
        window.deg = 0;  //旋转度数

        //获取用户的登录情况，根据用户获得用户的播放列表
        $.get("${pageContext.request.contextPath}/login/auto.do", function (data) {
            //获取用户id
            uid = data.u_id;
            $.get("${pageContext.request.contextPath}/playList/current.do", {uid: uid}, function (data) {
                if (data != null && data.length != 0) {
                    clearInterval(timer);

                    length = parseInt($(".time .progress_bar")[0].clientWidth);  //进度条容器长度

                    //获取歌曲时间(单位s)
                    var time = data.s_length;
                    timeCount = parseTime(time);
                    //求出进度条步长
                    step = length / timeCount;

                    $("#audio").prop("src", data.s_path);  //更改路径
                    if (first != 0) {  //如果是第一次加载就不自动播放
                        $("#audio")[0].addEventListener("canplay",function () {
                            $(".start").click();  //播放歌曲
                        });
                    }

                    //改变样式
                    $("#details_img").prop("src", data.album.a_image);  //专辑图片
                    $("#detail_songName").html(data.s_name);  //歌曲名
                    $("#detail_songerName").html(data.singer.singer_name); //歌手名
                    $(".footer .content .time .count").html(data.s_length);  //歌曲总时间

                    if (data.isLike) {  //为我喜欢
                        $("#detail_songName").siblings("span").removeClass("glyphicon-heart-empty");
                        $("#detail_songName").siblings("span").addClass("glyphicon-heart").css("color", "#cd2929");
                    } else {  //为我不喜欢
                        $("#detail_songName").siblings("span").removeClass("glyphicon-heart");
                        $("#detail_songName").siblings("span").addClass("glyphicon-heart-empty").css("color", "#444");
                    }

                }

            });

        });


        //下一首
        $(".footer .content .play .next").on("click", function () {
            clearInterval(timer);
            clearInterval(timer2);
            first = 1;
            $.get("/wangyi/playList/next.do", {uid: uid}, function () {
                $("#footer").load("pages/utils/footer.jsp");  //重新加载页面
                $("#display").load("pages/content/myDownload.jsp");
            });
        });

        //上一首
        $(".footer .content .play .previous").on("click", function () {
            clearInterval(timer);
            clearInterval(timer2);
            first = 1;
            $.get("/wangyi/playList/previous.do", {uid: uid}, function () {
                $("#footer").load("pages/utils/footer.jsp");  //重新加载页面
                $("#display").load("pages/content/myDownload.jsp");
            });
        });

        //音乐暂停
        $("#audio").on("pause", function () {
            flag = true;
            clearInterval(timer);
            clearInterval(timer2);
            //改变图标样式
            $(" .start .glyphicon").addClass("glyphicon-play");
            $(" .start .glyphicon").removeClass("glyphicon-pause");

            //改变唱碟针样式
            $("#zhen").css("transition", "transform 1s");
            $("#zhen").css("transformOrigin", "8px 0");
            $("#zhen").css("transform", "rotate(-30deg)");
        });

        //音乐播放
        $("#audio").on("play", function () {
            flag = false;
            $("#display").load("pages/content/myDownload.jsp");

            //开启定时器，用于进度条的改变
            timer = setInterval(function () {
                change();
                if (currentTime >= timeCount) {  //歌曲播放完毕，自动播放下一首歌曲
                    clearInterval(timer);
                    clearInterval(timer2);
                    $.get("${pageContext.request.contextPath}/playList/next.do", {uid: uid}, function () {
                        $("#footer").load("pages/utils/footer.jsp");  //重新加载页面
                    });
                }
            }, 1000);

            //唱碟开始旋转
            timer2 = setInterval(function () {
                $("#album_image").css("transform", "rotate(" + deg + "deg)");
                deg++;
            }, 50);


            $(" .start .glyphicon").removeClass("glyphicon-play");
            $(" .start .glyphicon").addClass("glyphicon-pause");

            $("#zhen").css("transition", "transform 1s");
            $("#zhen").css("transformOrigin", "8px 0");
            $("#zhen").css("transform", "rotate(0deg)");
        });

        // 音乐播放按钮
        $(".start").on("click", function () {
            if (flag) {  //暂停到播放
                $("#audio")[0].play(); //音乐播放
                first = 1;
            } else {  //播放到暂停
                $("#audio")[0].pause();  //音乐停止
            }

        });

        //格式化时间 MM：SS -->  xxS
        function parseTime(time) {
            var times = time.split(":");
            return parseInt(times[0]) * 60 + parseInt(times[1]);
        };

        //用于格式化时间 xxs --> MM:SS
        function parseTime2(time) {
            //获取分
            var m = time / 60;
            m = Math.floor(m);
            m = m < 10 ? "0" + m : m;
            //获取秒
            var s = time - m * 60;
            s = Math.floor(s);
            s = s < 10 ? "0" + s : s;

            return m + ":" + s;
        };

        //音乐播放,进度条变化
        function change() {
            width += step;
            if (width >= length) {  //如果进度条长度大于了容器长度，则最大为length
                width = length;
            }
            $(".time .progress_bar .bar").css("width", width + "px"); //进度条增加
            $(".time .progress_bar .but").css("left", width - 5 + "px"); //进度条上按钮移动
            currentTime++;
            var time = parseTime2(currentTime);
            $(".time .current").html(time);
        }

    });
</script>
<script src="${pageContext.request.contextPath}/js/footer.js"></script>
</body>
</html>
