$(function () {
    //切换功能
    $(".mycollect .content .top .box1").on("click",function(){
        $(this).addClass("select").siblings("div").removeClass("select");
    });

    //收藏的专辑显示
    $(".mycollect .content .top .box div:first-child").on("click",function () {
        $(".mycollect .content .ed").show();
        $(".mycollect .content .ing").hide();
        //发送异步请求获取用户的登录情况
        $.get("/wangyi/login/auto.do", function (data) {
            if (data != null && data.length != 0 ){
                //获取用户id
                let uid = data.u_id;
                //发送异步请求获取用户收藏的专辑信息
                $.get("/wangyi/album/getAll.do",{uid:uid},function (data) {
                    $(".mycollect .content .ed .bottom table").html("");  //清空
                    if (data != null && data.length != 0 ) {
                        //收藏列表
                        for (let i = 0; i < data.length; i++) {
                            let str = "<tr><td><img src='" + data[i].a_image + "'></td><td>" + data[i].a_name + "</td><td>" + data[i].singer.singer_name + "</td><td>" + data[i].songs.length + "首</td><td>" + data[i].a_id + "</td></tr>"
                            //写入
                            $(".mycollect .content .ed .bottom table").append($(str));
                        }
                    } else {
                        let str = "<tr><td colspan='5' style='text-align: center'>你还没有收藏哦！</td><td></td></tr>";
                        $(".mycollect .content .ed .bottom table").append($(str));
                    }
                });
            }
        });
    });

   //收藏的歌手显示
    $(".mycollect .content .top .box div:last-child").on("click",function () {
        $(".mycollect .content .ed").hide();
        $(".mycollect .content .ing").show();
        //发送异步请求获取用户的登录情况
        $.get("/wangyi/login/auto.do", function (data) {
            if (data != null && data.length != 0 ){
                //获取用户id
                let uid = data.u_id;
                //发送异步请求获取用户收藏的歌手信息
                $.get("/wangyi/singer/getAll.do",{uid:uid},function (data) {
                    $(".mycollect .content .ing .bottom table").html("");  //清空
                     if (data != null && data.length != 0 ) {
                         for (let i = 0; i < data.length; i++) {
                             let str = "<tr><td><img src='" + data[i].singer_image + "' ></td><td>" + data[i].singer_name + "</td><td></td><td style='width: 200px'>专辑:" + data[i].albums.length + "</td><td>" + data[i].singer_id + "</td></tr>";
                             $(".mycollect .content .ing .bottom table").append($(str));
                         }
                     } else {
                         let str = "<tr><td colspan='5' style='text-align: center'>你还没有收藏哦！</td><td></td></tr>";
                         $(".mycollect .content .ing .bottom table").append($(str));
                     }
                });
            }
        });

    });


    //收藏的专辑详情
    $(".mycollect .content .ed .bottom table").on("click","tr",function () {
         //获取当前专辑的id
         let aid = $(this.querySelector("td:last-child")).html();
         window.aid = aid;  //将其存进全局作用域
         //加载专辑页面
        $("#album").load("pages/content/album.jsp");
        $("#album").show().siblings("div").hide();
        $("#sidebar").show();

        //侧边栏样式需要改变
        var sidebar = $("#sidebar_s .box1 li a");
        sidebar.each(function (index, ele) {
            $(ele).removeClass("sidebar_select");
        });
    });

    //收藏的歌手详情
    $(".mycollect .content .ing .bottom table").on("click","tr",function () {
        //获取当前专辑的id
        let sid = $(this.querySelector("td:last-child")).html();
        window.singerId = sid;
        $("#singer").load("pages/content/singer.jsp");  //加载专辑页面
        $("#singer").show().siblings("div").hide();
        $("#sidebar").show();

        //侧边栏样式需要改变
        var sidebar = $("#sidebar_s .box1 li a");
        sidebar.each(function (index, ele) {
            $(ele).removeClass("sidebar_select");
        });
    });

    //歌手搜索
    let searchImg = $(".mycollect .content .ing .main .search img ");
    let searchInput = $(".mycollect .content .ing .main .search input");
    let searchSpan = $(".mycollect .content .ing .main .search span");
    //1.点击搜索图片开始搜索
    searchImg.on("click",function () {
        //获取歌手关键字
        let keyword = searchInput.val();
        searchSinger(keyword);
    })
    //2.按下enter键开始搜索
    searchInput.on("keyup",function (e) {
        if (e.key == "Enter"){
            searchImg.click();
        }
    })

    //搜索函数
    function searchSinger(keyword){
        keyword = keyword.trim();  //去除关键字两端的空格
        if (keyword.length != 0){
            //发送异步请求搜索歌手
            $.get("/wangyi/singer/search/"+keyword+".do",function (data) {
                console.log(data);
                $(".mycollect .content .ing .bottom table").html("");  //清空
                if (data != null && data.length !=0 ){
                    for (let i = 0; i < data.length; i++) {
                        let str = "<tr><td><img src='" + data[i].singer_image + "' ></td><td>" + data[i].singer_name + "</td><td></td><td style='width: 200px'>专辑:" + data[i].albums.length + "</td><td>" + data[i].singer_id + "</td></tr>";
                        $(".mycollect .content .ing .bottom table").append($(str));
                    }
                } else {
                    let str = "<tr><td colspan='5' style='text-align: center'>未能找到与<a style='color: #44aaf8'>\"" + keyword + "\"</a>相关的任何歌手信息</td><td></td></tr>";
                    $(".mycollect .content .ing .bottom table").append($(str));
                }
            })
        }
    }

    //当搜索框存在文本的时候隐藏搜索图片，显示小叉号
    searchInput.on("input",function () {
         if (searchInput.val().length == 0 ){ //搜索框没有内容
             searchImg.show();
             searchSpan.hide();
         } else {
             searchSpan.show();
             searchImg.hide();
         }
    });
    //3.当小叉号被点击了，则取消搜索
    searchSpan.on("click",function () {
        $(".mycollect .content .top .box div:last-child").click();
        searchImg.show();
        searchSpan.hide();
        searchInput.val("");
    });

    //专辑搜索
    let aSearchImg = $(".mycollect .content .ed .main .search img ");
    let aSearchInput = $(".mycollect .content .ed .main .search input");
    let aSearchSpan = $(".mycollect .content .ed .main .search span");
    //1.点击搜索图片开始搜索
    aSearchImg.on("click",function () {
        //获取歌手关键字
        let keyword = aSearchInput.val();
        searchAlbum(keyword);
    })
    //2.按下enter键开始搜索
    aSearchInput.on("keyup",function (e) {
        if (e.key == "Enter"){
            aSearchImg.click();
        }
    })

    //搜索函数
    function searchAlbum(keyword){
        keyword = keyword.trim();  //去除关键字两端的空格
        if (keyword.length != 0){
            //发送异步请求搜索歌手
            $.get("/wangyi/album/search/"+keyword+".do",function (data) {
                console.log(data);
                $(".mycollect .content .ed .bottom table").html("");  //清空
                if (data != null && data.length != 0 ) {
                    //收藏列表
                    for (let i = 0; i < data.length; i++) {
                        let str = "<tr><td><img src='" + data[i].a_image + "'></td><td>" + data[i].a_name + "</td><td>" + data[i].singer.singer_name + "</td><td>" + data[i].songs.length + "首</td><td>" + data[i].a_id + "</td></tr>"
                        //写入
                        $(".mycollect .content .ed .bottom table").append($(str));
                    }
                } else {
                    let str = "<tr><td colspan='5' style='text-align: center'>未能找到与<a style='color: #44aaf8'>\"" + keyword + "\"</a>相关的任何专辑信息！</td><td></td></tr>";
                    $(".mycollect .content .ed .bottom table").append($(str));
                }
            })
        }
    }

    //当搜索框存在文本的时候隐藏搜索图片，显示小叉号
    aSearchInput.on("input",function () {
        if (aSearchInput.val().length == 0 ){ //搜索框没有内容
            aSearchImg.show();
            aSearchSpan.hide();
        } else {
            aSearchSpan.show();
            aSearchImg.hide();
        }
    });
    //3.当小叉号被点击了，则取消搜索
    aSearchSpan.on("click",function () {
        $(".mycollect .content .top .box div:first-child").click();
        aSearchImg.show();
        aSearchSpan.hide();
        aSearchInput.val("");
    });


});