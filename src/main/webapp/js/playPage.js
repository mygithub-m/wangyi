$(function () {

    //页面关闭
    $(".playPage .content .top .box .page_close").on("click", function () {
        $("#playPage").hide(500);
    });

    //评论页面显示
    $(".playPage .content .bottom .box .input p").on("click", function () {

        //发送异步请求，判断用户是否登录，如果没有登录，则请用户先登录
        $.get("/wangyi/login/isLogin.do", function (data) {
            if (data == "true") {  //用户已经登录，可以评论
                $("#commentsPage").fadeIn(500);
            } else {  //如果用户还没有登录，则提示先登录
                $("#login").fadeIn(500);
            }
        });

    });

    //点赞功能
    $(".playPage .content .bottom .box .comments ul").on("click", ".glyphicon", function () {

        let c_id = $(this).parents("li").children("span").html();  //评论id
        let supportNum = $(this).html();
        supportNum = supportNum.slice(1, supportNum.indexOf(")"));


        //先判断评论现在是否已经被点过赞了
        if ($(this).hasClass("support")) {  //已经点过了
            $.post("/wangyi/comments/decrease/" + c_id + ".do", function () {
            });
            //改变点赞的数量
            supportNum = parseInt(supportNum) - 1;
            $(this).html("(" + supportNum + ")");
        } else {  //还没有点赞
            $.post("/wangyi/comments/increase/" + c_id + ".do", function () {
            });
            //改变点赞的数量
            supportNum = parseInt(supportNum) + 1;
            $(this).html("(" + supportNum + ")");
        }
        $(this).toggleClass("support");
    });

    //添加到我喜欢功能
    $(".gongneng div:first-child").on("click", function () {
        let that = this;
        //获取用户登录情况
        $.get("/wangyi/login/auto.do", function (data) {
            let uid = data.u_id;
            if (data != null && data.length != 0) {
                let btn = $(that.querySelector("span:first-child"));  //喜欢功能
                toggleLike(btn, uid);
            } else {
                alert("对不起，你还没有登录！");
            }
        });
    });

    //函数用来进行添加和移除我喜欢的操作，参数为我喜欢哪个爱心标志
    function toggleLike(btn, uid) {
        //发送异步请求请求当前播放歌曲信息
        $.get("/wangyi/playList/current.do", {uid: uid}, function (data) {
            if (data != null && data.length != 0) {
                let sid = data.s_id;
                //获取当前用户的信息
                $.get("/wangyi/login/auto.do", function (data) {

                    if (data != null && data.length != 0) {
                        let uid = data.u_id;
                        //判断歌曲是否已经是用户喜欢的音乐
                        if (btn.hasClass("glyphicon-heart-empty")) {  //未添加
                            btn.addClass("glyphicon-heart");  //改变样式
                            btn.css("color", "#cd2929");
                            btn.removeClass("glyphicon-heart-empty");

                            //发送异步请求进行添加操作
                            $.post("/wangyi/likeList/add.do", {uid: uid, sid: sid}, function (data) {

                            });
                            //刷新页面
                            $("#detail_songName").siblings("span").addClass("glyphicon-heart");  //改变样式
                            $("#detail_songName").siblings("span").css("color", "#cd2929");
                            $("#detail_songName").siblings("span").removeClass("glyphicon-heart-empty");
                            if ($("#like").hasClass("sidebar_select")) {  //如果侧边栏现在选中了我喜欢模块就刷新页面
                                $("#songList").load("pages/content/likeList.jsp");  //刷新我喜欢页面
                            }


                        } else {  //说明歌曲已经被添加为我喜欢
                            btn.removeClass("glyphicon-heart");  //改变样式
                            btn.css("color", "#444");
                            btn.addClass("glyphicon-heart-empty");

                            //发送异步请求进行移除操作
                            $.post("/wangyi/likeList/remove.do", {uid: uid, sid: sid}, function (data) {

                            });

                            //改变侧边栏样式
                            $("#detail_songName").siblings("span").removeClass("glyphicon-heart");
                            $("#detail_songName").siblings("span").css("color", "#444");
                            $("#detail_songName").siblings("span").addClass("glyphicon-heart-empty");
                            if ($("#like").hasClass("sidebar_select")) {  //如果侧边栏现在选中了我喜欢模块就刷新页面
                                $("#songList").load("pages/content/likeList.jsp");  //刷新我喜欢页面
                            }
                        }
                    } else {
                        alert("对不起，你还没有登录！");
                    }
                });
            }
        });
    };

    //收藏歌曲到歌单
    $(".playPage .content .top .box .changdie .gongneng div:nth-child(2)").on("click", function () {
        //获取用户登录情况
        $.get("/wangyi/login/auto.do", function (data) {
            if (data != null && data.length != 0) {
                $("#collectPage").load("pages/utils/collectPage.jsp");
            } else {
                alert("对不起，你还没有登录！")
            }
        });

    });


    //歌曲专辑详情模块
    $(".playPage .content .top .box .geci p>span:first-child").on("click", function () {
        $(".playPage .content .top .box .page_close").click();  //关闭播放页面
        $("#album").load("pages/content/album.jsp");  //加载专辑页面
        $("#album").show().siblings("div").hide();
        $("#sidebar").show();

        //侧边栏样式需要改变
        var sidebar = $("#sidebar_s .box1 li a");
        sidebar.each(function (index, ele) {
            $(ele).removeClass("sidebar_select");
        });
    });

    //歌手详情模块
    $(".playPage .content .top .box .geci p>span:last-child").on("click", function () {
        $(".playPage .content .top .box .page_close").click();  //关闭播放页面
        $("#singer").load("pages/content/singer.jsp");  //加载专辑页面
        $("#singer").show().siblings("div").hide();
        $("#sidebar").show();

        //侧边栏样式需要改变
        var sidebar = $("#sidebar_s .box1 li a");
        sidebar.each(function (index, ele) {
            $(ele).removeClass("sidebar_select");
        });
    });

    //歌曲下载
    $(".playPage .content .top .box .changdie .gongneng div:last-child").on("click", function () {
        //判断歌曲是否已经被下载了
        if ($(this.querySelector("span:first-child")).hasClass("glyphicon-ok-sign")) {
            alert("歌曲已经下载了!");
        } else {
            //获取当前播放歌曲信息
            $.get("/wangyi/login/auto.do", function (data) {
                if (data != null && data.length != 0) {
                    let uid = data.u_id;
                    $.get("/wangyi/playList/current.do", {uid: uid}, function (data) {
                        if (data != null && data.length != 0) {
                            //获取当前播放歌曲id
                            let sid = data.s_id;
                            //将歌曲id装进数组中，进行参数传递
                            let sids = [];
                            sids.push(sid);
                            //将歌曲添加到我的下载列表中
                            addSong(sids, uid);

                            let num = 0;  //记录已经下载好的歌曲数，用于关闭定时器
                            //开始进行获取歌曲下载进度
                            window.loadTimer = setInterval(function () {
                                $.get("/wangyi/download/progress.do", {uid: uid}, function (data) {
                                    if (data != null && data.length != 0) {
                                        changeLoading(data);
                                    } else {
                                        console.log("下载完毕！");
                                        //改变下载按钮样式
                                        let btn = $(".playPage .content .top .box .changdie .gongneng div:last-child span:first-child");
                                        $(".playPage .content .top .box .changdie .gongneng div:last-child span:last-child").html("已下载");
                                        btn.addClass("glyphicon-ok-sign");
                                        $(".playPage .content .top .box .changdie .gongneng div:last-child").css("background-color", "#e1e1e1");
                                        btn.removeClass("glyphicon-download-alt")
                                        //关闭定时器
                                        clearInterval(window.loadTimer);
                                    }
                                });
                            }, 5);
                        }
                    });
                } else {
                    alert("请先登录再下载！");
                }
            });
        }
    });


    //渲染正在下载页面
    function changeLoading(data) {
        //遍历正在下载的歌曲集合
        for (let i = 0; i < data.length; i++) {
            //获取正在下载列表
            $("#ing .bottom table tr").each(function (index, ele) {
                if (data[i].song.s_id == $(ele.querySelector("td:last-child")).html()) {
                    $(ele.querySelector("td:nth-child(3)>div>div")).css("width", data[i].status + "%");
                    if (data[i].status >= 99) {  //如果一首歌曲下载完毕，重新加载正在下载页面
                        $(ele).remove();
                    }
                }
            })
        }
    }


    //将歌曲添加到下载列表中
    function addSong(sids, uid) {
        //发送异步请求，进行添加操作
        $.post("/wangyi/download/add.do", {sid: sids, uid: uid}, function () {
            //刷新正在下载页面
            $("#loading").click();
            //文件下载采用表单提交的方式
            let form = $("<form action='/wangyi/download/song.do' method='post' style='display: none'></form>");
            for (let i = 0; i < sids.length; i++) {
                form.append($("<input name='sid' value='"+sids[i]+"'/>"));
            }
            form.append($("<input name='uid' value='"+uid+"'/>"));
            form.appendTo('body').submit().remove();
        })
    }

});