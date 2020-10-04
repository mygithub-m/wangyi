$(function () {

    //收藏专辑
    $(".songList .content .top .box1 .little_box .caozuo .c .cc:nth-child(2)").on("click",function () {
        let that = this;
        //发送异步请求请求用户登录信息
        $.get("/wangyi/login/auto.do", function (data) {
            if (data != null && data.length !=0 ){
                //获取专辑id
                let aid = $(".songList .content .top .box1 .little_box .img span").html();
                //获得用户id
                let uid = data.u_id;

                //判断专辑是否已经收藏了
                if ($(that.querySelector("span:first-child")).hasClass("glyphicon-ok")){  //已经收藏了
                    //取消收藏
                    $.post("/wangyi/album/deCollect.do",{uid:uid,aid:aid},function (data) {
                        $(that.querySelector("span:last-child")).html("收藏");
                    });
                } else {
                    //发送异步请求进行收藏操作
                    $.post("/wangyi/album/collect.do",{uid:uid,aid:aid},function (data) {
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
});