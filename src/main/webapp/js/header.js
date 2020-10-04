$(function () {
    var login = $("#login");    //登录框展示
    var about_me = $(".header .content .about_me");
    var myself = $("#myself");   //个人信息框

    //登录功能
    about_me.on("click", function () {

        $.get("/wangyi/login/isLogin.do", {}, function (data) {

            if (data == "false") { //用户还没有登录，转跳登录框
                login.toggle();
                flag = false;
            } else {  //用户已经登录，转跳个人信息框
                myself.toggle();
                flag = true;
            }
        });

    });

    let input = $(".header .content .search input");  //文本框

    //搜索功能
    $(".header .content .search img").on("click", function () {  //搜索按钮点击
        let keyword = input.val().trim();  //去除头尾空格

        if (keyword != null && keyword.length != 0) {
            //发送异步请求查询歌曲信息
            $("#searchPage").load("pages/content/searchPage.jsp");  //加载search结果页面
            $("#searchPage").show().siblings("div").hide();
            $("#sidebar").show();

            //侧边栏样式需要改变
            var sidebar = $("#sidebar_s .box1 li a");
            sidebar.each(function (index,ele) {
                $(ele).removeClass("sidebar_select");
            });
        } else {
            //什么也不做
        }
    });

    input.on("keyup", function (e) {
        if (e.key == "Enter") {
            $(".header .content .search img").click();
        }
    });

    input.on("focus", function () {
        $("#playPage_close").click();  //关闭播放页面
        $("#playList_close").click();  //关闭播放列表页面
    });

});

//对于id属性好像可以全局查找，也可能是因为我用了load引入公共页面，详细还有待查证