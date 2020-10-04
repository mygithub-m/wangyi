$(function () {
    var trs = $(".myDownload .content .bottom table");  //本地给歌曲列表

    //双击播放歌曲
    trs.on("dblclick", "tr", function () {

        clearInterval(window.timer);
        clearInterval(window.timer2);
        first = 1;

        var lastSpan = $(".myDownload .content .bottom table tr td:first-child span:last-child");  //正在播放标志
        var firstSpan = $(".myDownload .content .bottom table tr td:first-child span:first-child");  //歌曲序号

        //将所有的span还原
        lastSpan.each(function (index, element) {
            $(element).css("display", "none");
        });
        firstSpan.each(function (index, element) {
            $(element).css("display", "block");
        });
        //改变当前播放歌曲的样式
        $(this.querySelector("td:first-child span:last-child")).css("display", "block");
        $(this.querySelector("td:first-child span:first-child")).css("display", "none");
        var s_id = $(this.querySelector("td:last-child")).html();

        //获取用户登录情况
        $.get("/wangyi/login/auto.do", function (data) {
            //获取用户登录信息
            let uid = data.u_id;
            $.post("/wangyi/playList/addOne.do", {sid: s_id, uid: uid}, function (data) {
                if (data != null && data.length != 0) {
                    console.log(data);
                    $("#footer").load("pages/utils/footer.jsp");  //重新加载页面
                }
            });
        });

    });


    //本地音乐搜索
    var search = $(".myDownload .content .main .search input");
    var search_btn = $(".myDownload .content .main .search img");

    search.on("keyup", function (e) {
        if (e.key == "Enter") {  //当enter键被按下
            var text = search.val();
            searchByKeyword(text);
        }
    });

    search.on("input", function () {
        if (search.val().length == 0) {  //如果搜索框中的内容为空，则不显示关闭按钮
            $(".myDownload .content .main .search span").css("display", "none");  //关闭隐藏
            $(".myDownload .content .main .search img").css("display", "block");
        } else {
            $(".myDownload .content .main .search span").css("display", "block");  //关闭显示
            $(".myDownload .content .main .search img").css("display", "none");
        }
    });

    search_btn.on("click", function () {
        var text = search.val();
        searchByKeyword(text);
    });


    //取消搜索
    $(".myDownload .content .main .search span").on("click", function () {
        search.val(""); //搜索框内容清空
        $.get("/wangyi/song/local.do", {}, function (data) {
            if (data != null) {  //获取数据成功
                $(".myDownload .content .main .search span").css("display", "none");  //关闭隐藏
                $(".myDownload .content .main .search img").css("display", "block");

                $(".myDownload .content .bottom table").html("");  //先清空，再显示数据
                $(".myDownload .content .bottom table").append($("<tr><td></td><td>音乐标题</td><td>歌手</td><td>专辑</td><td>时长</td><td>大小</td><td>id</td></tr>"));

                $(".myDownload .content .top span span").html(data.length); //歌曲数量
                for (let i = 0; i < data.length; i++) {
                    let id = i + 1;
                    id = id < 10 ? "0" + id : id;
                    //生成dom元素，并添加信息
                    let tr = " <tr><td><span>" + id + "</span><span class='glyphicon glyphicon-volume-up'></span></td><td>" + data[i].s_name + "</td><td>" + data[i].singer.singer_name + "</td><td>" + data[i].album.a_name + "</td><td>" + data[i].s_length + "</td><td>" + data[i].s_size + "MB</td><td>" + data[i].s_id + "</td></tr>"
                    $(".myDownload .content .bottom table").append($(tr));
                }
            }
        });
    });


    //用于搜索的函数
    function searchByKeyword(keyword) {
        keyword = keyword.trim();  //删除头尾空格
        if (keyword.length != 0) {
            $.get("/wangyi/song/search/" + keyword + ".do", {}, function (data) {
                //清空内容区
                $(".myDownload .content .bottom table").html("");
                //标题栏
                let tr = " <tr><td><span></span><span class='glyphicon glyphicon-volume-up'></span></td><td>音乐标题</td><td>歌手</td><td>专辑</td><td>时长</td><td>大小</td><td>id</td></tr>"
                $(".myDownload .content .bottom table").append($(tr));

                if (data != null && data.length != 0) {
                    //内容栏
                    for (let i = 0; i < data.length; i++) {
                        let id = i + 1;
                        id = id < 10 ? "0" + id : id;
                        //生成dom元素，并添加信息
                        let tr = " <tr><td><span>" + id + "</span><span class='glyphicon glyphicon-volume-up'></span></td><td>" + data[i].s_name + "</td><td>" + data[i].singer.singer_name + "</td><td>" + data[i].album.a_name + "</td><td>" + data[i].s_length + "</td><td>" + data[i].s_size + "MB</td><td>" + data[i].s_id + "</td></tr>"
                        $(".myDownload .content .bottom table").append($(tr));
                    }
                } else {
                    //未查询到匹配的歌曲
                    let str = "<tr><td colspan='7' style='font-size: 12px;text-align: center'>未能找到与<a style='color: #44aaf8'>\"" + keyword + "\"</a>相关的任何音乐</td><td></td></tr>"
                    $(".myDownload .content .bottom table").append($(str));
                }

            });
        } else {
            alert("请输入关键字！");
        }
    }

    //播放全部
    $(".myDownload .content .main .all p span:last-child").on("click", function () {

        $("#playAll").show(500);  //提示页面显示

        $("#continue").one("click", function () {   //确定播放全部
            $("#playAll").hide(500);  //关闭页面

            var tds = $(".myDownload table tr td:last-child");
            var ids = new Array();

            tds.each(function (index, element) {
                if (index > 0) {
                    ids.push($(element).html());
                }
            });
            //获取用户登录情况
            $.get("/wangyi/login/auto.do", function (data) {
                //获取用户登录信息
                let uid = data.u_id;
                //发送异步请求，添加歌曲到播放列表
                $.ajax({
                    url: "/wangyi/playList/add.do",
                    type: "post",
                    data: {ids: ids,uid:uid},
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
});