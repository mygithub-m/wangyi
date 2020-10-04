$(function () {

    //关闭页面
    $(".collectPage .content .top button").on("click", function () {
        $("#collectPage").html("");
    });

    //歌曲收藏到歌单
    $(".collectPage .content .bottom ul").on("click", "li", function () {
        //获取歌单id
        let sl_id = $(this.querySelector("span")).html();
        //判断歌单类型
        if (sl_id != null && sl_id.length != 0) {  //说明是自定义歌单
            //判断要添加多首歌曲，还是单首歌曲
            if (window.playList_sids != null) {  //说明要添加多首歌曲
                collectMulToSongList(sl_id)
            } else {  //说明只添加一首歌曲
                //获取用户登录情况
                $.get("/wangyi/login/auto.do", function (data) {
                    let uid = data.u_id;
                    collectOneToSongList(sl_id, uid);
                });
            }
        } else {  //说明是我喜欢歌单
            //获取用户登录情况
            $.get("/wangyi/login/auto.do", function (data) {
                if (data != null && data.length != 0) {
                    let uid = data.u_id;
                    //判断要添加多首歌曲，还是单首歌曲
                    if (window.playList_sids != null) {  //说明要添加多首歌曲
                        collectMulToLike(uid);
                    } else {  //说明只添加一首歌曲
                        //判断歌曲是不是已经是我喜欢了
                        let like = $("#gongneng div:first-child span:first-child");
                        if (like.hasClass("glyphicon-heart")) {//说明歌曲已经是我喜欢了
                            alert("歌曲已经加入到你喜欢了");
                        } else {
                            collectOneToLike(uid);
                        }
                    }
                } else {
                    alert("对不起，你还没有登录！");
                }
            });
        }
    });

//收藏一首歌曲到我喜欢歌单中
    function collectOneToLike(u_id) {
        //获取正在播放歌曲
        $.get("/wangyi/playList/current.do", {uid: u_id}, function (data) {
            if (data != null && data.length != 0) {
                let s_id = data.s_id;
                //发送异步请求，添加歌曲到自定义歌单
                $.post("/wangyi/likeList/add.do", {uid: u_id, sid: s_id}, function (data) {
                    $("#collectPage").html("");

                    if ($("#like").hasClass("sidebar_select")) {  //如果侧边栏现在选中了我喜欢模块就刷新页面
                        $("#songList").load("pages/content/likeList.jsp");  //刷新我喜欢页面
                    }
                    //播放页面样式改变
                    like.addClass("glyphicon-heart").removeClass("glyphicon-heart-empty").css("color", "#cd2929");
                    //改变侧边栏样式
                    $("#detail_songName").siblings("span").addClass("glyphicon-heart").removeClass("glyphicon-heart-empty").css("color", "#cd2929");
                });
            }
        });
    }

//收藏多首歌曲到我喜欢歌单中
    function collectMulToLike(uid) {
        //获取歌曲列表集合
        let sids = window.playList_sids;
        //发送异步请求进行歌曲的添加
        $.post("/wangyi/likeList/addMul.do", {sid: sids, uid: uid}, function () {
            window.playList_sids = null;
            $("#collectPage").html("");
        });
    }

//收藏当前播放的歌曲到自定义歌单中
    function collectOneToSongList(sl_id, uid) {
        //获取正在播放歌曲
        $.get("/wangyi/playList/current.do", {uid: uid}, function (data) {
            if (data != null && data.length != 0) {
                let s_id = data.s_id;
                //发送异步请求，添加歌曲到自定义歌单
                $.post("/wangyi/songList/add.do", {sl_id: sl_id, s_id: s_id}, function (data) {
                    if (data == 0) {
                        alert("歌曲已经收藏了！")
                    }
                    $("#collectPage").html("");
                });
            }
        });
    }

    //收藏多首歌曲到自定义歌单中
    function collectMulToSongList(sl_id) {
        //获取歌曲列表集合
        let sids = window.playList_sids;
        //发送异步请求，进行多首歌曲的收藏
        $.post("/wangyi/songList/addMul.do", {sid: sids, sl_id: sl_id}, function (data) {
            window.playList_sids = null;
            $("#collectPage").html("");
        });
    }

    /****新建歌单模块****/
//新建歌单并添加当前歌曲
    $(".collectPage .content .main div").on("click", function () {
        $(".collectPage").hide();
        $(".createList").show();
    });

//新建歌单页面关闭
    $(".createList .content .top button").on("click", function () {
        $("#collectPage").html("");
    });

    $(".createList .content .bottom button:last-child").on("click", function () {
        $(".createList .content .top button").click();
    });

    //歌单当文本框中有内容，创建按钮样式改变
    $(".createList .content .main input").on("input", function () {
        $(".createList .content .bottom button:first-child").css("opacity", 1);
    });

    //创建歌单并添加歌曲
    $(".createList .content .bottom button:first-child").on("click", function () {
        //获取表单中新建歌单的歌单名称
        let listName = $(".createList .content .main input").val().trim();
        //判断歌单名是否有效
        if (listName.length != 0) {
            //获取用户登录情况
            $.get("/wangyi/login/auto.do", function (data) {
                if (data != null && data.length != 0) {
                    //获取用户id
                    let uid = data.u_id;
                    let sids = null;  //歌曲列表
                    if (window.playList_sids != null) {  //添加多首歌曲
                        //获取用户想收藏的歌曲id数组
                        sids = window.playList_sids;
                        //将参数封装为一个对象
                        let param = {
                            sid: sids,
                            uid: uid,
                            listName: listName
                        }
                        //调用方法进行添加
                        $.post("/wangyi/songList/createAndAdd.do", param, function () {
                            window.playList_sids = null;
                            $(".createList .content .top button").click();  //关闭页面
                            $("#sidebar").load("pages/utils/sidebar.jsp");  //刷新侧边栏
                        });
                    } else {  //添加当前播放的歌曲
                        //获取当前正在播放的歌曲
                        $.get("/wangyi/playList/current.do", {uid: uid}, function (data) {
                            if (data != null && data.length != 0) {
                                let sid = data.s_id;
                                //将当前歌曲装进数组中提交
                                sids = new Array();
                                sids.push(sid);
                                //将参数封装为一个对象
                                let param = {
                                    sid: sids,
                                    uid: uid,
                                    listName: listName
                                }
                                //调用方法进行添加
                                $.post("/wangyi/songList/createAndAdd.do", param, function () {
                                    window.playList_sids = null;
                                    $(".createList .content .top button").click();  //关闭页面
                                    $("#sidebar").load("pages/utils/sidebar.jsp");  //刷新侧边栏
                                });
                            }
                        });
                    }
                } else {
                    alert("对不起，你还没有登录!");
                }
            });
        } else {
            alert("你输入的歌单名无效！");
        }
    });
})
;