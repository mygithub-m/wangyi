$("#big_img")[0].onload = function () {
    var width = this.clientWidth;
    var height = this.clientHeight;

    var cut = $(".upload .content .main .big .left .big_img .cut"); //获取到剪切框
    var big_img = $(".upload .content .main .big .left .big_img"); //图片容器
    var two = $(".upload .content .main .big .left .big_img .two"); //第二部分阴影
    var one = $(".upload .content .main .big .left .big_img .one"); //第一部分阴影
    var box2 = $(".upload .content .main .big .left .big_img .box2"); //剪切框容器
    var m_img = $(".upload .content .main .big .right .m_img img"); //中等图片
    var s_img = $(".upload .content .main .big .right .s_img img"); //小图片
    var cut_width = null; //截取图片的宽度
    var x = null; //截取图片相对于原图片的位置
    var width_bili = null; //图片缩放宽比例
    var height_bili = null; //图片缩放高比例
    var b_m_bili = null;  //大图片于中等图片比例
    var b_s_bili = null;  //大图片与小图片比例
    var flag = null;  //标记是横向 还是纵向  true横向  false纵向

    if (width > height) { //根据图片宽高的不同，做出不同的缩放  //横放
        /* 初始化 */
        flag = true;
        big_img.css("width", "270px");
        $(this).css("width", "100%");
        box2.css("width", "270px"); //动态生成剪切框容器大小
        box2.css("height", this.clientHeight);
        box2.css("flexDirection","row")
        cut.css("width", this.clientHeight); //动态生成剪切框大小
        cut.css("height", this.clientHeight);
        two.css("width", 268 - this.clientHeight); //初始化阴影部分大小
        two.css("height", this.clientHeight);
        two.css("left", cut[0].clientWidth + 2 + "px");
        one.css("height", this.clientHeight);


        $("#cavas")[0].width = height;   //画板大小
        $("#cavas")[0].height = height;

        m_img.css("height", "100%");
        s_img.css("height", "100%");

        height_bili = height / cut[0].clientWidth;
        width_bili = width / big_img[0].clientWidth;
        b_m_bili = m_img[0].clientWidth / big_img[0].clientWidth;
        b_s_bili = s_img[0].clientWidth / big_img[0].clientWidth;

        /* 操作 */
        cut.on("mousedown", function (e) {

            b_width = big_img[0].clientWidth; //被剪切图片的宽度
            cut_width = this.clientWidth; //剪切框宽度
            var start = e.pageX; //鼠标开始位置
            let box2_left = parseInt(box2.css("left")); //剪切框容器开始位置

            $(document).on("mousemove", function (e) {
                let distance = e.pageX - start; //移动距离
                let cutLeft = parseInt(box2.css("left")); //剪切框移动距离，相对左边
                if (cutLeft >= 0 && cutLeft <= (b_width - cut_width)) {

                    box2.css("left", box2_left + distance + "px");
                    one.css("width", cutLeft + "px");


                    m_img.css("left", -cutLeft * b_m_bili + "px");  //中等图片移动
                    s_img.css("left", -cutLeft * b_s_bili + "px");  //小图片移动

                    if (parseInt(box2.css("left")) <= 0) {
                        box2.css("left", "0px");
                    }

                    if (parseInt(box2.css("left")) >= (b_width - cut_width)) {
                        box2.css("left", (b_width - cut_width) + "px");
                    }

                }
            });
        });

        $(document).on("mouseup", function () {
            $(this).off("mousemove");
            x = parseInt(box2.css("left")); //剪切位置
        });


    } else {   //纵向
        flag = false;
        /* 初始化 */
        big_img.css("height", "250px");
        $(this).css("height", "100%");
        box2.css("height", "250px"); //动态生成剪切框容器大小
        box2.css("width", this.clientWidth);
        box2.css("flexDirection","column");
        cut.css("width", this.clientWidth); //动态生成剪切框大小
        cut.css("height", this.clientWidth);
        two.css("width", this.clientWidth); //初始化阴影部分大小
        two.css("height",258 - this.clientWidth);
        two.css("top", cut[0].clientWidth + 2 + "px");
        one.css("width", this.clientWidth);

        $("#cavas")[0].width = width;   //画板大小
        $("#cavas")[0].height = width;

        m_img.css("width", "100%");
        s_img.css("width", "100%");

        height_bili = height / big_img[0].clientHeight;
        width_bili = width / cut[0].clientWidth;
        b_m_bili = m_img[0].clientHeight / big_img[0].clientHeight;
        b_s_bili = s_img[0].clientHeight / big_img[0].clientHeight;


        /* 操作 */
        cut.on("mousedown", function (e) {

            b_width = big_img[0].clientHeight; //被剪切图片的高度
            cut_width = this.clientWidth; //剪切框高度
            var start = e.pageY; //鼠标开始位置
            let box2_left = parseInt(box2.css("top")); //剪切框容器开始位置

            $(document).on("mousemove", function (e) {
                let distance = e.pageY - start; //移动距离
                let cutLeft = parseInt(box2.css("top")); //剪切框移动距离，相对左边
                if (cutLeft >= 0 && cutLeft <= (b_width - cut_width)) {

                    box2.css("top", box2_left + distance + "px");
                    one.css("height", cutLeft + "px");


                    m_img.css("top", -cutLeft * b_m_bili + "px");  //中等图片移动
                    s_img.css("top", -cutLeft * b_s_bili + "px");  //小图片移动

                    if (parseInt(box2.css("top")) <= 0) {
                        box2.css("top", "0px");
                    }

                    if (parseInt(box2.css("top")) >= (b_width - cut_width)) {
                        box2.css("top", (b_width - cut_width) + "px");
                    }

                }
            });
        });

        $(document).on("mouseup", function () {
            $(this).off("mousemove");
            if (flag){  //横向
                x = parseInt(box2.css("left")); //剪切位置
            } else {
                x = parseInt(box2.css("top")); //剪切位置
            }
        });


    }

    //提交头像
    $(".upload .content .buttom button:last-child").on("click", function () {
        if (cut_width == null) {
            cut_width = cut[0].clientWidth;
        }
        if (x == null) {
            x = 0;
        }
        //进行截图操作
        var canvas = $("#cavas");   //获取画板元素
        var con = canvas[0].getContext("2d");
        var img = $("#big_img");

        // 画图（截图）
       if (flag){  //横向
           con.drawImage(img[0], x * width_bili, 0, cut_width * height_bili, cut_width * height_bili, 0, 0, cut_width * height_bili, cut_width * height_bili);
       } else {  //纵向
           con.drawImage(img[0], 0, x * height_bili, cut_width * width_bili, cut_width * width_bili, 0, 0, cut_width * width_bili, cut_width * width_bili);
       }


        //将画板上的图片转化为二进制好进行提交
        var img = canvas[0].toDataURL();

        img = img.split(",")[1];

        img = window.atob(img);


        var ia = new Uint8Array(img.length);

        for (let i = 0; i < img.length; i++) {
            ia[i] = img.charCodeAt(i);
        }

        var blob = new Blob([ia],{type:"image/png"});

        var formData = new FormData();  //使用formdata进行图片上传
        formData.append("file",blob);
        //上传图片
        $.ajax({
            url: '/wangyi/register/uploadImage.do',
            type: 'POST',
            cache: false,
            data: formData,
            processData: false,
            contentType: false,
            success:function (res) {
                //处理上传结果
                if(res != null && res.length != 0){   //上传成功
                    $("#close").click();
                }else {
                    alert("上传失败！");
                }
            }
        });

    });

    //关闭剪切栏
    $("#close").on("click", function () {
        $("#upload").hide();
    });

    //重新选择
    $(".upload .content .buttom button:first-child").on("click", function () {
        $("#uploadFile").click();
        $("#upload").hide();
    });
}