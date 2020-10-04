$(function () {

    //获取audio标签
    var audio = $("#audio");

    //音量控制
    var volume = $(".volume .glyphicon");
    var v_flag = true; //声音的判断，代表有声音
    volume.on("click", function () {
        //改变图标
        volume.toggleClass("glyphicon-volume-off");
        volume.toggleClass("glyphicon-volume-up");
        if (v_flag) { //音量为零
            //设置音量
            audio.prop("volume", 0);
            //改变音量条样式
            $(".volume .bar .box").css("width", "0px");
            //改变按钮样式
            $(".volume .bar .but").css("left", "0px");
        } else { //音量为最大
            audio.prop("volume", 1);
            //改变音量条样式
            $(".volume .bar .box").css("width", "100px");
            //改变按钮样式
            $(".volume .bar .but").css("left", "94px");
        }
        //重置标志
        v_flag = !v_flag;

    });

    //循环模式控制
    var cycle = $(".cycle img");
    cycle.on("click", function () {
        cycle.prop("src", "../img/10.png")
    });


     //播放列表
    $(".footer .content .cycle span").on("click", function () {
        $("#playList").toggle();
    });

});