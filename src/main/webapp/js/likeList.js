$(function () {

    //列表切换
    $(".songList .content .top .box2 >div").on("click", function () {
        $(this).css("color", " #44aaf8").siblings("div").css("color", " #000");

        $(".songList .content .top .box2 >div div").each(function (index, element) {
            $(element).css("display", "none");
        });

        $(this.querySelector("div")).css("display", "block");
    });

    //歌曲双击播放
    var trs = $(".songList .content .bottom table");

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

    //播放全部
    $(".songList .content .top .box1 .little_box .caozuo .c .all").on("click", function () {

        let that = this;
        $("#playAll").show(500);  //提示页面显示

        $("#continue").one("click", function () {   //确定播放全部
            $("#playAll").hide(500);  //关闭页面
            //歌单播放次数
            let sl_id = $(".songList .content .bottom table tr:first-child td:first-child span").html();  //获取歌单id
            if (sl_id != null && sl_id.length != 0) {  //自定义歌单，播放次数加一
                $.post("/wangyi/songList/update/" + sl_id + ".do", function (data) {
                });
            }

            /*var tds = $(".songList .content .bottom table tr td:first-child span");*/
            var tds = $(that).parent(".c").parent(".caozuo").parent(".little_box")
                .parent(".box1").parent(".top").parent(".content").find(".bottom table tr td:first-child span");
            console.log(tds);
            var ids = new Array();

            tds.each(function (index, element) {
                if (index > 0) {
                    ids.push($(element).html());
                }
            });
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
                       /* //需要将存放歌曲的数组置为空
                        ids = [];*/
                    },
                    error:function () {
                        alert("播放全部出错了");
                    }
                });
            });
        });

        $("#cancel").on("click", function () {  //取消播放全部
            $("#playAll").hide(500);  //关闭页面
        });
    });

    //歌曲搜索
    var search = $(".songList .content .top  .search input");
    var search_btn = $(".songList .content .top  .search img");

    search.on("keyup", function (e) {
        if (e.key == "Enter") {  //当enter键被按下
            let sl_id = $(".songList .content .bottom table tr:first-child td:first-child span").html();
            var text = search.val();
            if (sl_id != null && sl_id.length != 0) {  //该歌单为自定义歌单
                mySearch(text, sl_id);
            } else {
                likeSearch(text);
            }
        }
    });

    search.on("input", function () {
        if (search.val().length == 0) {  //如果搜索框中的内容为空，则不显示关闭按钮
            $(".songList .content .top  .search span").css("display", "none");  //关闭隐藏
            $(".songList .content .top  .search img").css("display", "block");
        } else {
            $(".songList .content .top  .search span").css("display", "block");  //关闭显示
            $(".songList .content .top  .search img").css("display", "none");
        }
    });

    search_btn.on("click", function () {
        let sl_id = $(".songList .content .bottom table tr:first-child td:first-child span").html();
        var text = search.val();
        if (sl_id != null && sl_id.length != 0) {  //该歌单为自定义歌单
            mySearch(text, sl_id);
        } else {
            likeSearch(text);
        }
    });

    //取消搜索
    $(".songList .content .top  .search span").on("click", function () {
        search.val(""); //搜索框内容清空
        //获取歌单信息
        let sl_id = $(".songList .content .bottom table tr:first-child td:first-child span").html();
        if (sl_id != null && sl_id.length != 0) {  //该歌单为自定义歌单
            //发送异步请求请求当前歌单的信息
            $.get("/wangyi/songList/get/" + sl_id + ".do", function (data) {
                if (data != null && data.length != 0) {
                    $(".songList .content .top  .search span").css("display", "none");  //关闭隐藏
                    $(".songList .content .top  .search img").css("display", "block");
                    $(".songList .content .bottom table").html("");  //清空
                    //标题栏
                    let tr = "<tr><td><span>" + sl_id + "</span></td><td>操作</td><td>音乐标题</td><td>歌手</td><td>专辑</td><td>时长</td></tr>";
                    $(".songList .content .bottom table").append($(tr));
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

                        let str = "<tr><td>" + id + "<span>" + data.songList[i].s_id + "</span></td><td><div><span class='glyphicon " + like + "'></span><span class='glyphicon " + download + "'></span></div></td><td>" + data.songList[i].s_name + "</td><td>" + data.songList[i].singer.singer_name + "</td><td>" + data.songList[i].album.a_name + "</td><td>" + data.songList[i].s_length + "</td></tr>";

                        $(".songList .content .bottom table").append($(str));
                    }
                }
            });
        } else {
            //发送异步请求请求用户登录信息
            $.get("/wangyi/login/auto.do", function (data) {
                if (data != null && data.length != 0) {
                    let u_id = data.u_id;  // 用户id
                    //发送异步请求请求用户喜欢的歌曲信息
                    $.get("/wangyi/likeList/like/" + u_id + ".do", function (data) {
                        if (data != null && data.length != 0) {
                            $(".songList .content .top  .search span").css("display", "none");  //关闭隐藏
                            $(".songList .content .top  .search img").css("display", "block");
                            //清空内容区
                            $(".songList .content .bottom table").html("");
                            //标题栏
                            let tr = "<tr><td><span></span></td><td>操作</td><td>音乐标题</td><td>歌手</td><td>专辑</td><td>时长</td></tr>";
                            $(".songList .content .bottom table").append($(tr));
                            for (let i = 0; i < data.length; i++) {
                                let id = i + 1;
                                id = id < 10 ? "0" + id : id;
                                //判断歌曲是否被下载
                                let load = null;
                                if (data[i].isDownload) {  //被下载
                                    load = "glyphicon-ok-sign";
                                } else {
                                    load = "glyphicon-download-alt";
                                }
                                let str = "<tr><td>" + id + "<span>" + data[i].s_id + "</span></td><td><div><span class='glyphicon glyphicon-heart'></span><span class='glyphicon " + load + "'></span></div></td><td>" + data[i].s_name + "</td><td>" + data[i].singer.singer_name + "</td><td>" + data[i].album.a_name + "</td><td>" + data[i].s_length + "</td></tr>"
                                $(".songList .content .bottom table").append($(str));
                            }
                        }
                    });
                }
            });
        }
    });

    //用于搜索我喜欢歌单的函数
    function likeSearch(keyword) {
        keyword = keyword.trim();  //删除头尾空格
        if (keyword.length != 0) {
            $.get("/wangyi/likeList/search/" + keyword + ".do", {}, function (data) {
                //清空内容区
                $(".songList .content .bottom table").html("");
                //标题栏
                let tr = "<tr><td><span></span></td><td>操作</td><td>音乐标题</td><td>歌手</td><td>专辑</td><td>时长</td></tr>";
                $(".songList .content .bottom table").append($(tr));

                if (data != null && data.length != 0) {
                    //内容栏
                    for (let i = 0; i < data.length; i++) {
                        let id = i + 1;
                        id = id < 10 ? "0" + id : id;
                        //判断歌曲是否被下载
                        let load = null;
                        if (data[i].isDownload) {  //被下载
                            load = "glyphicon-ok-sign";
                        } else {
                            load = "glyphicon-download-alt";
                        }
                        let str = "<tr><td>" + id + "<span>" + data[i].s_id + "</span></td><td><div><span class='glyphicon glyphicon-heart'></span><span class='glyphicon " + load + "'></span></div></td><td>" + data[i].s_name + "</td><td>" + data[i].singer.singer_name + "</td><td>" + data[i].album.a_name + "</td><td>" + data[i].s_length + "</td></tr>"
                        $(".songList .content .bottom table").append($(str));
                    }
                } else {
                    //没有找到匹配的歌曲
                    let str = "<tr><td colspan='6' style='font-size: 12px;text-align: center'>未能找到与<a style='color: #44aaf8'>\"" + keyword + "\"</a>相关的任何音乐</td></tr>"
                    $(".songList .content .bottom table").append($(str));
                }

            });
        } else {
            alert("请输入关键字！");
        }
    }

    //用于搜索自定义歌单的歌曲信息的函数
    function mySearch(keyword, slid) {
        keyword = keyword.trim();  //删除头尾空格
        if (keyword.length != 0) {
            $.get("/wangyi/songList/search.do", {keyword: keyword, sl_id: slid}, function (data) {
                //清空内容区
                $(".songList .content .bottom table").html("");
                //标题栏
                let tr = "<tr><td><span>" + slid + "</sapn></td><td>操作</td><td>音乐标题</td><td>歌手</td><td>专辑</td><td>时长</td></tr>";
                $(".songList .content .bottom table").append($(tr));

                if (data != null && data.length != 0) {
                    console.log(data);
                    //内容栏
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

                        let str = "<tr><td>" + id + "<span>" + data[i].s_id + "</span></td><td><div><span class='glyphicon " + like + "'></span><span class='glyphicon " + download + "'></span></div></td><td>" + data[i].s_name + "</td><td>" + data[i].singer.singer_name + "</td><td>" + data[i].album.a_name + "</td><td>" + data[i].s_length + "</td></tr>";

                        $(".songList .content .bottom table").append($(str));
                    }
                } else {
                    //没有找到匹配的歌曲
                    let str = "<tr><td colspan='6' style='font-size: 12px;text-align: center'>未能找到与<a style='color: #44aaf8'>\"" + keyword + "\"</a>相关的任何音乐</td></tr>"
                    $(".songList .content .bottom table").append($(str));
                }

            });
        } else {
            alert("请输入关键字！");
        }
    }


    //我喜欢
    $(".songList .content .bottom table").on("click", "tr td:nth-child(2) span:first-child", function () {
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

    //下载全部
    $(".songList .content .top .box1 .little_box .caozuo .c .cc:last").on("click", function () {
        if (confirm("你确定要下载全部音乐吗?")) {
            //获取歌单歌曲id
            var tds = $(".songList .content .bottom table tr td:first-child span");
            var sids = new Array();

            tds.each(function (index, element) {
                if (index > 0) {
                    sids.push($(element).html());
                }
            });
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
                    }, 200);

                } else {
                    alert("你还没有登录！");
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
            /*ajax不能实现文件的下载,在这里只能模仿表单提交*/
            let form = $("<form action='/wangyi/download/song.do' method='post' style='display: none'></form>");
            for (let i = 0; i < sids.length; i++) {
                form.append($("<input name='sid' value='"+sids[i]+"'/>"));
            }
            form.append($("<input name='uid' value='"+uid+"'/>"));
            form.appendTo('body').submit().remove();
        })
    }

    //下载一首歌曲
    $(".songList .content .bottom table").on("click", "tr td:nth-child(2) .glyphicon-download-alt", function () {
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

    //将歌曲从自定义歌单中移除
    let s_id = null;
    let sl_id = null;
    $(".songList .content .bottom table").on("mouseup", "tr", function (e) {
        //获取当前歌曲id
        s_id = $(this.querySelector("td:first-child span:last-child")).html();
        //获取当前歌单id
        sl_id = $(".songList .content .bottom table tr:first-child td:first-child span").html();
        //判断当前歌单是不是自定歌单，只有自定义歌单才提供删除歌曲功能
        if (sl_id != null && sl_id.length != 0) {  //说明是自定义歌单，提供删除功能
            if (e.button == 2) {  //鼠标右键被点击

                $("#mouseRight").show();
                $("#mouseRight ul li span:last-child").html("删除歌曲(delete)");
                $("#mouseRight").css("top", e.clientY + "px");
                $("#mouseRight").css("left", e.clientX + "px");
            }
        }
    });

    $("#mouseRight ul li:first-child").on("click", function () {
        if (sl_id != null && sl_id.length != 0 && s_id != null && s_id.length !=0) {
            if (confirm("你确定删除这个歌曲吗？")) {
                //发送异步请求，删除歌曲
                $.post("/wangyi/songList/deleteSong.do",{slId:sl_id,sid:s_id},function () {
                    //重新刷新页面
                    window.sl_id = sl_id;
                    $("#songList").load("pages/content/mySongList.jsp");  //加载自定义歌单列表
                    $("#songList").show().siblings("div").hide();
                    $("#sidebar").show();
                });
                //将这两个参数变量置为空
                s_id = null;
                sl_id = null;
            }
        }
    });
});