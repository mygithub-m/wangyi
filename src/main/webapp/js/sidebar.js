$(function () {
    //我的音乐模块 
    var box1 = $(".sidebar .box1");

    box1.on("mouseover", "li a", function () {
        $(this).css("color", "black");
    });

    box1.on("mouseout", "li a", function () {
        $(this).css("color", "#5c5c5c");
    });

    //列表选中
    box1.on("click", "li a", function () {
        //遍历box1，保证每次点击只有一个功能选中
        $(".sidebar .content .box1 li a").each(function (index, ele) {
            $(ele).removeClass("sidebar_select");
        });
        //改变选中的样式
        $(this).addClass("sidebar_select");
    });

    //歌单隐藏效果
    $(".sidebar .content .box2 p>span:last-child span:last-child").on("click", function () {

        if ($(this).hasClass("glyphicon-menu-down")) {  //说明正在显示，可隐藏
            $("#MySongList").hide(100);
        } else {
            $("#MySongList").show(100);
        }
        $(this).toggleClass("glyphicon-menu-down");  //改变按钮样式
        $(this).toggleClass("glyphicon-menu-right");
    });


    var open = $(".sidebar .details .box .img .open");
    var img = $(".sidebar .details .box img");
    var openbox = $(".sidebar .details .box .img");

    openbox.on("mouseover", function () {
        open.show();
    });

    openbox.on("mouseout", function () {
        open.hide();
    });

    //打开播放页面
    openbox.on("click", function () {
        $("#playPage").show(500);
    });

    /*****侧边栏功能模块******/
        //本地音乐模块
    var local = $("#mySong .local");
    local.on("click", function () {
        $("#display").show().siblings("div").hide();
        $("#sidebar").show();
    });

    //下载管理
    var downloadManager = $("#mySong .downloadManager");
    downloadManager.on("click", function () {
        $("#downloadManager").load("pages/content/downloadManager.jsp");
        $("#downloadManager").show().siblings("div").hide();
        $("#sidebar").show();
    });

    //我的收藏
    var mycollect = $("#mySong .mycollect");
    mycollect.on("click", function () {
        $("#mycollect").load("pages/content/mycollect.jsp");
        $("#mycollect").show().siblings("div").hide();
        $("#sidebar").show();
    });

    /******我的歌单模块*******/

        //我喜欢模块
    var like = $("#like");
    like.on("click", function () {
        //加载歌单页面
        $("#songList").load("pages/content/likeList.jsp");

        $("#songList").show().siblings("div").hide();
        $("#sidebar").show();
    });

    //添加歌曲到我喜欢
    $("#detail_songName").siblings("span").on("click", function () {
        let that = this;
        //获取当前用户的信息
        $.get("/wangyi/login/auto.do", function (data) {
            if (data != null && data.length != 0) {
                let uid = data.u_id;
                toggleLike($(that), uid);
            } else {
                alert("对不起，你还没有登录!");
            }
        });

    });

    //函数用来进行添加和移除我喜欢的操作，参数为我喜欢哪个爱心标志
    function toggleLike(btn, uid) {
        //发送异步请求请求当前播放歌曲信息
        $.get("/wangyi/playList/current.do", {uid: uid}, function (data) {/***********************************/
            if (data != null && data.length != 0) {
                let sid = data.s_id;
                //判断歌曲是否已经是用户喜欢的音乐
                if (btn.hasClass("glyphicon-heart-empty")) {  //未添加
                    btn.addClass("glyphicon-heart");  //改变样式
                    btn.css("color", "#cd2929");
                    btn.removeClass("glyphicon-heart-empty");

                    //发送异步请求进行添加操作
                    $.post("/wangyi/likeList/add.do", {uid: uid, sid: sid}, function (data) {

                    });
                    //刷新页面
                    if ($("#like").hasClass("sidebar_select")) {  //如果侧边栏现在选中了我喜欢模块就刷新页面
                        $("#songList").load("pages/content/likeList.jsp");  //刷新我喜欢页面
                    }
                    $("#playPage").load("pages/content/playPage.jsp");  //加载播放页面
                } else {  //说明歌曲已经被添加为我喜欢
                    btn.removeClass("glyphicon-heart");  //改变样式
                    btn.css("color", "#444");
                    btn.addClass("glyphicon-heart-empty");

                    //发送异步请求进行移除操作
                    $.post("/wangyi/likeList/remove.do", {uid: uid, sid: sid}, function (data) {

                    });
                    if ($("#like").hasClass("sidebar_select")) {  //如果侧边栏现在选中了我喜欢模块就刷新页面
                        $("#songList").load("pages/content/likeList.jsp");  //刷新我喜欢页面
                    }
                    $("#playPage").load("pages/content/playPage.jsp");  //加载播放页面
                }
            }
        });
    }


    //点击添加自定义歌单
    $(".sidebar .content .box2 p>span:last-child span:first-child").on("click", function () {
        $("#add").show(100);
    });

    //加载自定义歌单
    $(".sidebar .content .box2").on("click", "li a", function () {
        //获取歌单id
        let slId = $(this.querySelector("span:first-child")).html();
        if (slId != null && slId.length != 0) {  //说明是自定义歌单
            //定义一个全局变量，用于传递歌单id
            window.sl_id = slId;

            $("#songList").load("pages/content/mySongList.jsp");  //加载自定义歌单列表
            $("#songList").show().siblings("div").hide();
            $("#sidebar").show();
        }
    });

    //鼠标右键删除歌单

    $(".sidebar .content .box2").on("mouseup", "li a", function (e) {
        //获取歌单id
        mouseRightSlId = $(this.querySelector("span:first-child")).html();
        if (mouseRightSlId != null && mouseRightSlId.length != 0) {  //说明是自定义歌单
            if (!e) e = window.event;
            if (e.button == 2) {

                $("#mouseRight").show();
                $("#mouseRight ul li span:last-child").html("删除歌单(delete)");
                $("#mouseRight").css("top", e.clientY + "px");
                $("#mouseRight").css("left", e.clientX + "px");
            } else {
                mouseRightSlId = null;
            }
        }
    });

    $("#mouseRight ul li:first-child").on("click", function () {
          if (mouseRightSlId != null && mouseRightSlId.length != 0){
              if (confirm("你确定删除这个歌单吗？")){
                  //发送异步请求，删除歌单
                  $.post("/wangyi/songList/delete/"+mouseRightSlId+".do",function () {
                      $("#sidebar").load("pages/utils/sidebar.jsp");
                  });
                  mouseRightSlId = null;
              }
          }
    });
});