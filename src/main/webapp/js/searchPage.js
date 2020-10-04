$(function () {

    //列表切换
    $(".searchPage .content .top .box2 >div").on("click", function () {
        //切换键样式改变
        $(this).css("color", " #44aaf8").siblings("div").css("color", " #000");
        $(".searchPage .content .top .box2 >div div").each(function (index, element) {
            $(element).css("display", "none");
        });
        $(this.querySelector("div")).css("display", "block");
    });
    /*****************搜索模块***************************/
    //歌曲搜索
    $(".searchPage .content .top .box2 .one").on("click", function () {
        $(".song").show();
        $(".singer").hide();
        $(".album").hide();
        //发送异步请求，请求搜索结果
        let input = $("#searchInput");  //搜索文本框
        let keyword = input.val().trim();
        //发送异步请求，搜索歌曲
        $.get("/wangyi/remoteSong/search/" + keyword + ".do", function (data) {
            $(".searchPage .content .top .box1>span span:first-child").html("\"" + keyword + "\"");  //显示关键字
            $(".searchPage .content .top .box1>span span:last-child").html("首歌曲");  //搜索类型
            $(".song table").html("");  //清空
            //表头
            $(".song table").append($("<tr><td></td><td>操作</td><td>音乐标题</td><td>歌手</td><td>专辑</td><td>时长</td></tr>"));
            if (data != null && data.length != 0) {
                $(".searchPage .content .top .box1>span span:nth-child(2)").html(data.length);  //结果数量
                for (let i = 0; i < data.length; i++) {
                    let id = i + 1;
                    id = id < 10 ? "0" + id : id;
                    //判断一首歌曲是不是我喜欢
                    let like = null; //我喜欢
                    if (data[i].isLike) {  //我喜欢
                        like = "glyphicon-heart";
                    } else {
                        like = "glyphicon-heart-empty";
                    }
                    //判断歌曲是否下载
                    let download = null; //是否下载
                    if (data[i].isDownload) { //已下载
                        download = "glyphicon-ok-sign";
                    } else {
                        download = "glyphicon-download-alt";
                    }
                    let str = "<tr><td><span>" + id + "</span><span>" + data[i].s_id + "</span></td><td><div><span class='glyphicon " + like + "'></span><span class='glyphicon " + download + "'></span></div></td><td>" + data[i].s_name + "</td><td>" + data[i].singer.singer_name + "</td><td>" + data[i].album.a_name + "</td><td>" + data[i].s_length + "</td></tr>";

                    $(".searchPage .content .song table").append($(str));
                }
            } else {
                $(".searchPage .content .top .box1>span span:nth-child(2)").html(0);  //结果数量
            }
        });
    });

    $(".searchPage .content .top .box2 .one").click();

    //歌手搜索
    $(".searchPage .content .top .box2 .two").on("click", function () {
        $(".song").hide();
        $(".singer").show();
        $(".album").hide();
        //获取关键字
        let input = $("#searchInput");  //搜索文本框
        let keyword = input.val().trim();
        //发送异步请求，通过关键字搜索歌手
        $.get("/wangyi/singer/hSearch/" + keyword + ".do", function (data) {

            $(".searchPage .content .top .box1>span span:first-child").html("\"" + keyword + "\"");  //显示关键字
            $(".searchPage .content .top .box1>span span:last-child").html("个歌手");  //搜索类型
            $(".singer table").html("");  //清空页面
            if (data != null && data.length != 0) {
                $(".searchPage .content .top .box1>span span:nth-child(2)").html(data.length);  //结果数量
                //渲染页面
                for (let i = 0; i < data.length; i++) {
                    let str = "<tr><td><img src='" + data[i].singer_image + "'></td><td>" + data[i].singer_name + "</td><td>" + data[i].singer_id + "</td></tr>";
                    $(".singer table").append($(str));
                }
            } else {
                $(".searchPage .content .top .box1>span span:nth-child(2)").html(0);  //结果数量
            }
        });
    });

    //专辑搜索
    $(".searchPage .content .top .box2 .three").on("click", function () {
        $(".song").hide();
        $(".singer").hide();
        $(".album").show();
        //获取关键字
        let input = $("#searchInput");  //搜索文本框
        let keyword = input.val().trim();
        //发送请求，搜索专辑
        $.get("/wangyi/album/hSearch/" + keyword + ".do", function (data) {
            $(".searchPage .content .top .box1>span span:first-child").html("\"" + keyword + "\"");  //显示关键字
            $(".searchPage .content .top .box1>span span:last-child").html("个专辑");  //搜索类型
            $(".album table").html("");  //清空页面
            if (data != null && data.length != 0) {
                $(".searchPage .content .top .box1>span span:nth-child(2)").html(data.length);  //结果数量
                for (let i = 0; i < data.length; i++) {
                    let str = "<tr><td><img src='" + data[i].a_image + "'></td><td>" + data[i].a_name + "</td><td>" + data[i].singer.singer_name + "</td><td>" + data[i].a_id + "</td></tr>";
                    $(".album table").append($(str));
                }
            } else {
                $(".searchPage .content .top .box1>span span:nth-child(2)").html(0);  //结果数量
            }
        });
    });

    /*************播放模块**************/
        //双击歌曲开始播放
    var trs = $(".searchPage .content .song table");  //本地给歌曲列表

    trs.on("dblclick", "tr", function () {

        clearInterval(window.timer);
        clearInterval(window.timer2);
        first = 1;

        var s_id = $(this.querySelector("td:first-child span:last-child")).html();
        //获取用户登录情况
        $.get("/wangyi/login/auto.do", function (data) {
            let uid = data.u_id;
            $.post("/wangyi/playList/addOne.do", {sid: s_id, uid: uid}, function (data) {
                if (data != null && data.length != 0) {
                    $("#footer").load("pages/utils/footer.jsp");  //重新加载页面
                }
            });
        });
    });

    //我喜欢操作
    $(".searchPage .content .song table").on("click", "tr td:nth-child(2) span:first-child", function () {
        let sid = $(this).parent("div").parent("td").parent("tr")
            .children("td:first-child").children("span:last-child").html();  //获取歌曲id
        toggleLike($(this), sid);
    });


    //函数用来进行添加和移除我喜欢的操作，参数为我喜欢哪个爱心标志
    function toggleLike(btn, sid) {
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
                    //通过歌曲id判断当前播放的歌曲是不是这首歌曲，如果是，那么需要改变播放页面的样式
                    $.get("/wangyi/playList/current.do", {uid: uid}, function (data) {

                        if (data != null && data.length != 0) {

                            //比较两首歌曲的id判断是不是同一首歌曲
                            if (data.s_id == sid) {  //说明是同一首歌曲，样式改变，否则什么也不做
                                //改变侧边栏样式
                                $("#detail_songName").siblings("span").addClass("glyphicon-heart");  //改变样式
                                $("#detail_songName").siblings("span").css("color", "#cd2929");
                                $("#detail_songName").siblings("span").removeClass("glyphicon-heart-empty");
                                $("#playPage").load("pages/content/playPage.jsp");  //加载播放页面
                            }
                        }
                    });

                } else {  //说明歌曲已经被添加为我喜欢
                    btn.removeClass("glyphicon-heart");  //改变样式
                    btn.css("color", "#444");
                    btn.addClass("glyphicon-heart-empty");

                    //发送异步请求进行移除操作
                    $.post("/wangyi/likeList/remove.do", {uid: uid, sid: sid}, function (data) {

                    });

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
                }
            } else {
                alert("对不起，你还没有的登录！");
            }
        });
    }

    //搜索页面歌手信息详情
    $(".searchPage .content .singer table").on("click", "tr", function () {
        //获取当前专辑的id
        let sid = $(this.querySelector("td:last-child")).html();
        window.singerId = sid;
        $("#singer").load("pages/content/singer.jsp");  //加载专辑页面
        $("#singer").show().siblings("div").hide();
        $("#sidebar").show();

        //侧边栏样式需要改变
        var sidebar = $("#sidebar_s .box1 li a");
        sidebar.each(function (index, ele) {
            $(ele).removeClass("sidebar_select");
        });
    });

    //搜索页面专辑信息详情
    $(".searchPage .content .album table").on("click", "tr", function () {
        //获取当前专辑的id
        let aid = $(this.querySelector("td:last-child")).html();
        window.aid = aid;  //将其存进全局作用域
        //加载专辑页面
        $("#album").load("pages/content/album.jsp");
        $("#album").show().siblings("div").hide();
        $("#sidebar").show();

        //侧边栏样式需要改变
        var sidebar = $("#sidebar_s .box1 li a");
        sidebar.each(function (index, ele) {
            $(ele).removeClass("sidebar_select");
        });
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
    $(".searchPage .content .song table").on("click", "tr td:nth-child(2) .glyphicon-download-alt", function () {
        if (confirm("你确定要下载这首歌曲吗？")) {
            //获取当前歌曲id
            let sid = $(this).parent("div").parent("td").parent("tr")
                .children("td:first-child").children("span:last-child").html();  //获取歌曲id
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

});