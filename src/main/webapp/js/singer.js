$(function () {
    //列表切换
    $(".singer .content .top .box2 >div").on("click", function () {
        $(this).css("color", " #44aaf8").siblings("div").css("color", " #000");

        $(".singer .content .top .box2 >div div").each(function (index, element) {
            $(element).css("display", "none");
        });

        $(this.querySelector("div")).css("display", "block");
    });


    //歌手的收藏操作
    $(".singer .content .top .box1 .little_box .collect").on("click", function () {
        let that = this;
        //发送异步请求请求用户登录信息
        $.get("/wangyi/login/auto.do", function (data) {
            if (data != null && data.length != 0) {
                //获取歌手id
                let sid = $(".singer .content .top .box1 .little_box .img span").html();
                //获得用户id
                let uid = data.u_id;

                //判断专辑是否已经收藏了
                if ($(that.querySelector("span:first-child")).hasClass("glyphicon-ok")) {  //已经收藏了
                    //取消收藏
                    $.post("/wangyi/singer/deCollect.do", {uid: uid, sid: sid}, function (data) {
                        $(that.querySelector("span:last-child")).html("收藏");
                    });
                } else {
                    //发送异步请求进行收藏操作
                    $.post("/wangyi/singer/collect.do", {uid: uid, sid: sid}, function (data) {
                        $(that.querySelector("span:last-child")).html("已收藏");
                    });
                }
                //改变按钮样式
                $(that.querySelector("span:first-child")).toggleClass("glyphicon-plus");
                $(that.querySelector("span:first-child")).toggleClass("glyphicon-ok");

            } else {
                alert("请先登录!")
            }
        });
    });

    //双击歌曲播放
    $(".singer .content .bottom ul").on("dblclick", " li table tr", function () {

        clearInterval(window.timer);
        clearInterval(window.timer2);
        first = 1;
        //获取歌曲id
        let sid = $(this.querySelector("td:first-child span:first-child")).html();

        //获取用户登录情况
        $.get("/wangyi/login/auto.do", function (data) {
            let uid = data.u_id;
            $.post("/wangyi/playList/addOne.do", {sid: sid,uid:uid}, function (data) {
                if (data != null && data.length != 0) {
                    $("#footer").load("pages/utils/footer.jsp");  //重新加载页面
                }
            });
        });
    });

    //播放某个专辑的全部音乐
   $(".singer .content .bottom ul").on("click","li>div>div>div span:nth-child(2)",function () {
        //获取专辑id
        let aid = $(this.nextElementSibling).html();
        //发送异步请求，获取专辑的信息
       $.get("/wangyi/album/details/"+aid+".do",function (data) {
            if (data != null && data.length != 0){
                //获取歌曲id的数组
                let sids =  new Array();
                for (let i = 0; i < data.songs.length; i++) {
                    sids.push(data.songs[i].s_id);
                }
                //发送异步请求获取用户登录信息
                $.get("/wangyi/login/auto.do", function (data) {
                    let uid = data.u_id;
                    //发送请播放全部
                    $.ajax({
                        url: "/wangyi/playList/add.do",
                        type: "post",
                        data: {ids: sids,uid:uid},
                        traditional: true,  /*!//这句话很重要，没有这句话会报错*/  //也可以不使用这中方法
                        success: function (data) {
                            clearInterval(window.timer);
                            clearInterval(window.timer2);
                            first = 1; //开启自动播放
                            $("#footer").load("pages/utils/footer.jsp");  //重新加载页面
                        }
                    });
                });
            }
       });
   });

   //收藏某个专辑的全部音乐
    $(".singer .content .bottom ul").on("click","li>div>div>div span:first-child",function () {
        //判断用户是否已经登录了
        $.get("/wangyi/login/auto.do", function (data) {
            if (data != null && data.length !=0){
                //获取专辑id
                let aid = $(".singer .content .bottom ul li>div>div>div span:last-child").html();
                //发送异步请求，获取专辑的信息
                $.get("/wangyi/album/details/"+aid+".do",function (data) {
                    if (data != null && data.length != 0){
                        //获取歌曲id的数组
                        let sids =  new Array();
                        for (let i = 0; i < data.songs.length; i++) {
                            sids.push(data.songs[i].s_id);
                        }
                        //将专辑歌曲信息存进全局数组中
                        window.playList_sids = sids;
                        //显示歌单列表页面
                        $("#collectPage").load("pages/utils/collectPage.jsp");
                    }
                });
            } else {
                alert("对不起，你还没有登录!");
            }
        });
    });

    //下载某一首歌曲
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
            //下载歌曲
            let form = $("<form action='/wangyi/download/song.do' method='post' style='display: none'></form>");
            for (let i = 0; i < sids.length; i++) {
                form.append($("<input name='sid' value='"+sids[i]+"'/>"));
            }
            form.append($("<input name='uid' value='"+uid+"'/>"));
            form.appendTo('body').submit().remove();
        })
    }

    //下载一首歌曲
    $(".singer .content .bottom ul").on("click", "table tr td:nth-child(2) div .glyphicon-download-alt", function () {
        if (confirm("你确定要下载这首歌曲吗？")){
            //获取当前歌曲id
            let sid = $(this).parent("div").parent("td").parent("tr")
                .children("td:first-child").children("span:first-child").html();  //获取歌曲id
            let sids = [];
            sids.push(sid);
            //获取用户登录信息
            $.get("/wangyi/login/auto.do", function (data) {
                if (data != null && data.length != 0) {
                    let uid = data.u_id;  //用户id
                    //将歌曲添加到我的下载列表中
                    addSong(sids, uid);

                    //开始进行获取歌曲下载进度
                    window.loadTimer = setInterval(function () {
                        $.get("/wangyi/download/progress.do", {uid: uid}, function (data) {
                            if (data != null && data.length != 0) {
                                changeLoading(data);
                            } else {
                                console.log("下载完毕！");
                                //关闭定时器
                                clearInterval(window.loadTimer);
                            }
                        });
                    }, 50);

                } else {
                    alert("你还没有登录！");
                }
            });
        }
    });


    //我喜欢操作
    $(".singer .content .bottom ul").on("click", "table tr td:nth-child(2) div span:first-child", function () {
        let sid = $(this).parent("div").parent("td").parent("tr")
            .children("td:first-child").children("span:first-child").html();  //获取歌曲id
        toggleLike($(this), sid);
    });

    //函数用来进行添加和移除我喜欢的操作，参数为我喜欢哪个爱心标志
    function toggleLike(btn, sid) {
        //获取当前用户的信息
        $.get("/wangyi/login/auto.do", function (data) {
            if (data != null && data.length != 0) {
                let uid = data.u_id;
                //判断歌曲是否已经是用户喜欢的音乐
                if (btn.hasClass("glyphicon-heart-empty")) {  //未添加(在我喜欢页面无用)
                    btn.addClass("glyphicon-heart");  //改变样式
                    btn.css("color", "#cd2929");
                    btn.removeClass("glyphicon-heart-empty");

                    //发送异步请求进行添加操作
                    $.post("/wangyi/likeList/add.do", {uid: uid, sid: sid}, function (data) {
                        if ($("#like").hasClass("sidebar_select")) {  //如果侧边栏现在选中了我喜欢模块就刷新页面
                            $("#songList").load("pages/content/likeList.jsp");  //刷新我喜欢页面
                        }
                        //对其它页面进行刷新
                        let num = $(".songList .content .top .box1 .little_box .jilu div:first-child span").html();//改变歌单中的歌曲数量
                        $(".songList .content .top .box1 .little_box .jilu div:first-child span").html(parseInt(num) + 1);
                        //通过歌曲id判断当前播放的歌曲是不是这首歌曲，如果是，那么需要改变播放页面的样式
                        $.get("/wangyi/playList/current.do", {uid: uid}, function (data) {

                            if (data != null && data.length != 0) {

                                //比较两首歌曲的id判断是不是同一首歌曲
                                if (data.s_id == sid) {  //说明是同一首歌曲，样式改变，否则什么也不做
                                    //改变侧边栏样式
                                    $("#detail_songName").siblings("span").removeClass("glyphicon-heart-empty");
                                    $("#detail_songName").siblings("span").css("color", "#cd2929");
                                    $("#detail_songName").siblings("span").addClass("glyphicon-heart");
                                    $("#playPage").load("pages/content/playPage.jsp");  //加载播放页面
                                }
                            }
                        });
                    });

                } else {  //说明歌曲已经被添加为我喜欢
                    btn.removeClass("glyphicon-heart");  //改变样式
                    btn.css("color", "#444");
                    btn.addClass("glyphicon-heart-empty");

                    //发送异步请求进行移除操作
                    $.post("/wangyi/likeList/remove.do", {uid: uid, sid: sid}, function (data) {
                        if ($("#like").hasClass("sidebar_select")) {  //如果侧边栏现在选中了我喜欢模块就刷新页面
                            $("#songList").load("pages/content/likeList.jsp");  //刷新我喜欢页面
                        }
                        //对其它页面进行刷新
                        let num = $(".songList .content .top .box1 .little_box .jilu div:first-child span").html();//改变歌单中的歌曲数量
                        $(".songList .content .top .box1 .little_box .jilu div:first-child span").html(parseInt(num) - 1);
                        //通过歌曲id判断当前播放的歌曲是不是这首歌曲，如果是，那么需要改变播放页面的样式
                        $.get("/wangyi/playList/current.do", {uid: uid}, function (data) {

                            if (data != null && data.length != 0) {

                                //比较两首歌曲的id判断是不是同一首歌曲
                                if (data.s_id == sid) {  //说明是同一首歌曲，样式改变，否则什么也不做
                                    //改变侧边栏样式
                                    $("#detail_songName").siblings("span").removeClass("glyphicon-heart");
                                    $("#detail_songName").siblings("span").css("color", "#444");
                                    $("#detail_songName").siblings("span").addClass("glyphicon-heart-empty");
                                    $("#playPage").load("pages/content/playPage.jsp");  //加载播放页面
                                }
                            }
                        });
                    });
                }

            } else {
                alert("对不起，你还没有的登录！");
            }
        });
    }
});