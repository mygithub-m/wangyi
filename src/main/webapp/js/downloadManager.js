$(function () {
    //切换功能
    $(".downloadManager .content .top .box1").on("click", function () {
        $(this).addClass("select").siblings("div").removeClass("select");
    });

    //已经下载
    $(".downloadManager .content .top .box div:first-child").on("click", function () {
        $(".downloadManager .content .ed").show();
        $(".downloadManager .content .ing").hide();
        //发送异步请求，获取用户已经下载的歌曲列表
        //获取用户登录信息
        $.get("/wangyi/login/auto.do", function (data) {
            let uid = data.u_id;
            //获取用户已经下载得歌曲列表
            $.get("/wangyi/download/loaded.do", {uid: uid}, function (data) {
                //先清空表格
                $(".downloadManager .content .ed .bottom table").html("");
                $(".downloadManager .content .ed .bottom table").append($("<tr><td></td><td></td><td>音乐标题</td><td>歌手</td><td>专辑</td><td>大小</td><td>下载时间</td><td></td></tr>"));  //表头
                if (data != null && data.length != 0) {
                    for (let i = 0; i < data.length; i++) {
                        //序号
                        let id = i + 1;
                        id = id < 10 ? "0" + id : id;
                        //下载时间转换
                        let date = parseTime(data[i].m_date);
                        //判断一首歌曲是否为我喜欢
                        let str = null;
                        if (data[i].song.isLike) { //我喜欢
                            str = " <tr><td>" + id + "</td><td><span class='glyphicon glyphicon-heart'></span></td><td>" + data[i].song.s_name + "</td><td>" + data[i].song.singer.singer_name + "</td><td>" + data[i].song.album.a_name + "</td><td>" + data[i].song.s_size + "MB</td><td>" + date + "</td><td>" + data[i].song.s_id + "</td></tr>";
                        } else {
                            str = " <tr><td>" + id + "</td><td><span class='glyphicon glyphicon-heart-empty'></span></td><td>" + data[i].song.s_name + "</td><td>" + data[i].song.singer.singer_name + "</td><td>" + data[i].song.album.a_name + "</td><td>" + data[i].song.s_size + "MB</td><td>" + date + "</td><td>" + data[i].song.s_id + "</td></tr>";
                        }
                        $(".downloadManager .content .ed .bottom table").append($(str));
                    }
                } else {
                    let str = "<tr><td colspan='7' style='text-align: center'>你还没有任何下载哦！</td><td></td></tr>";
                    $(".downloadManager .content .ed .bottom table").append($(str));
                }
            })
        });
    });

    //默认显示已经下载
    $(".downloadManager .content .top .box div:first-child").click();

    //正在下载
    $(".downloadManager .content .top .box div:last-child").on("click", function () {
        $(".downloadManager .content .ed").hide();
        $(".downloadManager .content .ing").show();
        //发送异步请求，获取用户已经下载的歌曲列表
        //获取用户登录信息
        $.get("/wangyi/login/auto.do", function (data) {
            let uid = data.u_id;
            //获取用户已经下载得歌曲列表
            $.get("/wangyi/download/loading.do", {uid: uid}, function (data) {
                //先清空表格
                $(".downloadManager .content .ing .bottom table").html("");
                $(".downloadManager .content .ing .bottom table").append($(" <tr><td></td><td>音乐标题</td><td>进度</td><td></td></tr>"));  //表头
                if (data != null && data.length != 0) {
                    for (let i = 0; i < data.length; i++) {
                        //序号
                        let id = i + 1;
                        id = id < 10 ? "0" + id : id;

                        let str = " <tr><td>" + id + "</td><td>" + data[i].song.s_name + "</td><td><div><div></div></div></td><td>" + data[i].song.s_id + "</td></tr>";
                        $(".downloadManager .content .ing .bottom table").append($(str));
                        //获取为下载完的音乐的进度
                        $(".downloadManager .content .ing .bottom table tr td:nth-child(3)>div>div").css("width", data[i].status + "%");
                    }
                } else {
                    let str = "<tr><td colspan='3' style='text-align: center'>你还没有歌曲正在下载哦！</td><td></td></tr>";
                    $(".downloadManager .content .ing .bottom table").append($(str));
                }
            })
        });
    });


    //日期转换函数
    function parseTime(x) {
        let date = new Date(x);
        let year = date.getFullYear();
        let mouth = date.getMonth() + 1;
        mouth = mouth < 10 ? "0" + mouth : mouth;
        let day = date.getDate();
        day = day < 10 ? "0" + day : day;

        return year + "-" + mouth + "-" + day;
    }

    //暂停全部
    $(".downloadManager .content .ing .main .box .caozuo div:nth-child(2)").on("click", function () {
        if (confirm("你确定要暂停下载吗？")) {
            $.post("/wangyi/download/pause.do", function () {
                //关闭掉流对象之后需要将定时器也关闭掉
                clearInterval(window.loadTimer);
            });
        }
    });

    //清空全部
    $(".downloadManager .content .ing .main .box .caozuo div:nth-child(3)").on("click", function () {
        if (confirm("你确定要清空全部吗？")) {
            //获取当前用户信息
            $.get("/wangyi/login/auto.do", function (data) {
                if (data != null && data.length != 0) {
                    let uid = data.u_id;
                    //先暂停下载
                    $.post("/wangyi/download/pause.do", function () {
                        //发送请求清空正在下载列表
                        $.post("/wangyi/download/clear.do", {uid: uid}, function () {
                            //刷新正在下载页面
                            $(".downloadManager .content .top .box div:last-child").click();
                        });
                        //关闭掉流对象之后需要将定时器也关闭掉
                        clearInterval(window.loadTimer);
                    });
                } else {
                    alert("对不起，不能获取您的账户信息!");
                }
            });

        }
    });

    //全部开始
    //
    //

    //音乐双击播放
    $(".downloadManager .content .ed .bottom table").on("dblclick", "tr", function () {
        clearInterval(window.timer);
        clearInterval(window.timer2);
        first = 1;

        var s_id = $(this.querySelector("td:last-child")).html();  //获取当前歌曲id
        console.log(s_id);

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

    //播放全部
    $(".downloadManager .content .ed .main .all p").on("click", function () {
        $("#playAll").show(500);  //提示页面显示

        $("#continue").one("click", function () {   //确定播放全部
            $("#playAll").hide(500);  //关闭页面
            //歌单播放次数


            var tds = $(".downloadManager .content .ed .bottom table tr td:last-child");
            var ids = new Array();

            tds.each(function (index, element) {
                if (index > 0) {
                    ids.push($(element).html());
                }
            });
            console.log(ids);
            //获取用户登录情况
            $.get("/wangyi/login/auto.do", function (data) {
                let uid = data.u_id;
                //发送异步请求，添加歌曲到播放列表
                $.ajax({
                    url: "/wangyi/playList/add.do",
                    type: "post",
                    data: {ids: ids, uid: uid},
                    traditional: true,  /*!//这句话很重要，没有这句话会报错*/
                    success: function (data) {
                        clearInterval(window.timer);
                        clearInterval(window.timer2);
                        first = 1; //开启自动播放
                        $("#footer").load("pages/utils/footer.jsp");  //重新加载页面
                    }
                });
            });
        });

        $("#cancel").on("click", function () {  //取消播放全部
            $("#playAll").hide(500);  //关闭页面
        });
    });

    //我喜欢操作
    $(".downloadManager .content .ed .bottom table").on("click", "td:nth-child(2) span", function () {
        //获取歌曲id
        let sid = $(this).parent("td").parent("tr").find("td:last-child").html();
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

    //歌曲搜索
    var search = $(".downloadManager .content .ed .main .search input");
    var search_btn = $(".downloadManager .content .ed .main .search img");
    var search_span = $(".downloadManager .content .ed .main .search span");

    search.on("keyup", function (e) {
        if (e.key == "Enter") {  //当enter键被按下
            search_btn.click();
        }
    });

    search.on("input", function () {
        if (search.val().length == 0) {  //如果搜索框中的内容为空，则不显示关闭按钮
            search_span.css("display", "none");  //关闭隐藏
            search_btn.css("display", "block");
        } else {
            search_span.css("display", "block");  //关闭显示
            search_btn.css("display", "none");
        }
    });

    search_btn.on("click", function () {
        var text = search.val();
        searchLoad(text);
    });

    //取消搜索
    search_span.on("click",function () {
        search.val(""); //搜索框内容清空
        search_span.css("display", "none");  //关闭隐藏
        search_btn.css("display", "block");
        $(".downloadManager .content .top .box div:first-child").click();
    });

    function searchLoad(keyword) {
        keyword = keyword.trim();  //删除头尾空格
        if (keyword.length != 0) {
            //获取用户登录情况
            $.get("/wangyi/login/auto.do", function (data) {
                if (data != null && data.length != 0) {
                    let uid = data.u_id;
                    $.get("/wangyi/download/search/" + keyword + ".do", {uid:uid}, function (data) {
                        //先清空表格
                        $(".downloadManager .content .ed .bottom table").html("");
                        $(".downloadManager .content .ed .bottom table").append($("<tr><td></td><td></td><td>音乐标题</td><td>歌手</td><td>专辑</td><td>大小</td><td>下载时间</td><td></td></tr>"));  //表头
                        if (data != null && data.length != 0) {
                            for (let i = 0; i < data.length; i++) {
                                //序号
                                let id = i + 1;
                                id = id < 10 ? "0" + id : id;
                                //下载时间转换
                                let date = parseTime(data[i].m_date);
                                //判断一首歌曲是否为我喜欢
                                let str = null;
                                if (data[i].song.isLike) { //我喜欢
                                    str = " <tr><td>" + id + "</td><td><span class='glyphicon glyphicon-heart'></span></td><td>" + data[i].song.s_name + "</td><td>" + data[i].song.singer.singer_name + "</td><td>" + data[i].song.album.a_name + "</td><td>" + data[i].song.s_size + "MB</td><td>" + date + "</td><td>" + data[i].song.s_id + "</td></tr>";
                                } else {
                                    str = " <tr><td>" + id + "</td><td><span class='glyphicon glyphicon-heart-empty'></span></td><td>" + data[i].song.s_name + "</td><td>" + data[i].song.singer.singer_name + "</td><td>" + data[i].song.album.a_name + "</td><td>" + data[i].song.s_size + "MB</td><td>" + date + "</td><td>" + data[i].song.s_id + "</td></tr>";
                                }
                                $(".downloadManager .content .ed .bottom table").append($(str));
                            }
                        } else {
                            let str = "<tr><td colspan='7' style='text-align: center'>未能找到与<a style='color: #44aaf8'>\"" + keyword + "\"</a>相关的任何音乐</td><td></td></tr>";
                            $(".downloadManager .content .ed .bottom table").append($(str));
                        }

                    });
                }
            });
        } else {
            alert("请输入关键字！");
        }
    }
});