$(function () {
    //取消点击关闭
    $(".addList .content .bottom button:last-child").on("click", function () {
        $("#add").hide(100);
    });

    //歌单当文本框中有内容，创建按钮样式改变
    $(".addList .content .main input").on("input", function () {
        $(".addList .content .bottom button:first-child").css("opacity", 1);
    });

    //新建歌单操作
    $(".addList .content .bottom button:first-child").on("click", function () {
        //获取表单中新建歌单的歌单名称
        let listName = $(".addList .content .main input").val().trim();
        if (listName.length != 0) {  //歌单名有效
            //获取用户登录信息，如果用户没有登录，则不允许创建
            $.get("/wangyi/register/logined.do", function (data) {

                if (data != null && data.length != 0) {
                    let uid = data.u_id;  //用户id
                    //发送异步请求，创建歌单
                    $.post("/wangyi/songList/create.do", {uid: uid, listName: listName}, function (data) {
                        if (data == 1) { //说明创建成功

                        } else {  //创建失败

                        }
                        //重新刷新侧边栏
                        $("#sidebar").load("pages/utils/sidebar.jsp");
                    });
                } else {
                    alert("请你先登录!");
                }
            });
        } else {
            alert("请输入歌单名称!");
        }

    })
});