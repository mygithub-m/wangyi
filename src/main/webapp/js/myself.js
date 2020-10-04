$(function () {

    /*样式变化*/
    var p = $(".myself .content .box p");  //获取个人功能列表

    //鼠标经过
    p.on("mouseover",function () {
        $(this).css("backgroundColor","#e3e3e3");
    });

    //鼠标离开
    p.on("mouseout",function () {
        $(this).css("backgroundColor","#fafafa");
    });

    /*用户退出登录*/
    var exit = $(".myself .content .box .exit");
    var myself = $("#myself");   //个人信息框

    exit.on("click",function () {  //绑定单击事件

        myself.toggle();  //关闭信息框
        window.first = 0;
        //关闭控制歌曲播放以及唱碟旋转的计时器
        clearInterval(timer);
        clearInterval(timer2);
        //发送异步请求，进行用户退出登录操作
        $.get("/wangyi/login/exit.do",{},function () {  //没有考虑删除失败
            //刷新整个页面
            $("#header").load("pages/utils/header.jsp");
            $("#sidebar").load("pages/utils/sidebar.jsp");
            $("#footer").load("pages/utils/footer.jsp");
            $("#display").load("pages/content/myDownload.jsp");
            $("#display").show().siblings("div").hide();
            $("#sidebar").show();
        });
    });

    /*修改个人信息*/
    var editMyself = $(".edit");
    var myself = $("#myself");   //个人信息框

    editMyself.on("click",function () {
        myself.hide();
        $("#editMyself").load("pages/content/editMyself.jsp");  //加载修改页面
        $("#editMyself").show().siblings("div").hide();
        $("#sidebar").show();

        //侧边栏样式需要改变
       var sidebar = $("#sidebar_s .box1 li a");
        sidebar.each(function (index,ele) {
            $(ele).removeClass("sidebar_select");
        });
    });
});