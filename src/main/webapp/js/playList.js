$(function () {

    //关闭播放列表
    $(".playList .content .top .close button").on("click",function () {
          $("#playList").hide();
    });

    //清空播放列表
    $(".playList .content .main .box2 .remove").on("click",function () {
       //获取用户登录页面
        $.get("/wangyi/login/auto.do", function (data) {
            let uid = data.u_id;  //用户id
            $.get("/wangyi/playList/clear.do",{uid:uid},function () {
                $("#playList").load("/wangyi/pages/utils/playList.jsp");  //重新加载播放列表
            });
        });
    });

    //双击播放音乐
    $(".playList .content .bottom table").on("dblclick","tr",function () {
        clearInterval(window.timer);
        clearInterval(window.timer2);
        first = 1;

        var s_id = $(this.querySelector("td:first-child span:first-child")).html();

        //获取用户登录情况
        $.get("/wangyi/login/auto.do", function (data) {
            let uid = data.u_id;
            $.post("/wangyi/playList/addOne.do", {sid: s_id,uid:uid}, function (data) {
                if (data != null && data.length != 0) {
                    $("#footer").load("pages/utils/footer.jsp");  //重新加载页面
                }
            });
        });
    });

    //收藏当前播放列表中所有歌曲到歌单
    $(".playList .content .main .box2 .add").on("click",function () {
          //获取播放列表中的所有歌曲的id
        let sids = new Array();
        $(".playList .content .bottom table tr td:first-child span:first-child").each(function (index,ele) {
             let sid = $(ele).html();
             sids.push(sid);
        });
        playList_sids = sids;
        //加载收藏页面
        //获取用户登录情况
        $.get("/wangyi/login/auto.do", function (data) {
            if (data != null && data.length != 0){
                $("#collectPage").load("pages/utils/collectPage.jsp");
            } else {
                alert("对不起，你还没有登录！")
            }
        });
    });
});