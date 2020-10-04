$(function () {
    //介绍栏中字数变化
    var textarea = $(".editMyself .content .small_box .left .introduce .text textarea");
    var num = $(".editMyself .content .small_box .left .introduce .text span");
    textarea.on("input", function () {
        num.html(300 - textarea[0].value.length);
    });

    //取消按钮点击
    $(".editMyself .content .small_box .left .cancel").on("click", function () {
         window.history.back();
    });

    //当生日的月份确定后，动态生成天数
    var year = $(".year");  //年份dom对象
    var c_year = year.val();   //当前选中年份
    var mouth = $(".mouth"); //月份dom对象
    var c_mouth = mouth.val();  //当前选中月份
    var dateArr = [1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1];  //表示每个月是大月还是小月，1为大，0为小
    var days = null;  //当月总天数

    getDays(c_year, c_mouth);  //页面一加载就计算月天数

    year.on("change", function () {
        c_year = $(this).val();
        getDays(c_year, c_mouth);

    });

    mouth.on("change", function () {
        c_mouth = $(this).val();
        getDays(c_year, c_mouth);
    });


    //通过当前年份和月份动态生成天数
    function getDays(c_year, c_mouth) {
        //先判断当前年份是否为闰年
        if (((c_year % 4 == 0) && (c_year % 100 != 0)) || ((c_year % 400 == 0 && c_year % 3200 != 0))) {  //为闰年

            if (c_mouth == 2) {  //如果为2月，29天
                days = 29;
            } else {
                if (dateArr[c_mouth - 1] == 1) {  //大月，31天
                    days = 31;
                } else {  //小月,30天
                    days = 30;
                }
            }
        } else {  //为平年
            if (c_mouth == 2) {  //如果为2月，29天
                days = 28;
            } else {
                if (dateArr[c_mouth - 1] == 1) {  //大月，31天
                    days = 31;
                } else {  //小月,30天
                    days = 30;
                }
            }
        }

        //通过days的数量，改变天数
        $(".day option").each(function (index, element) {
            if (index >= days) {
                $(element).hide();  //大于天数的隐藏
            } else {
                $(element).show();  //小于天数的显示
            }
        })
    }

   //修改头像按钮点击
    var headFile = $(".right .img button");
    var input = $("#uploadFile");  //上传文件dom
    var upload = $("#upload");

    headFile.on("click", function () {
        input.click();
    });

    input.on("change", function (e) {
        $("#upload").load("/wangyi/pages/utils/uploadHead.jsp");
        $("#upload").show();
    });


    //地址选择
    //省
    $(".x").on("focus",function () {
        $(".sheng").show();
    });

    $(".sheng").on("click","option",function () {
        $(".x").val($(this).val());
        $(".sheng").hide();
        //生成市
        let sheng = $(".x").val();
        $(".shi").html("");
        for (let i = 0; i < allCities.length; i++) {
            if (sheng == allCities[i].name){
                for (let j = 0; j < allCities[i].city.length; j++) {
                    $(".shi").append($("<option value='"+allCities[i].city[j].name+"'>"+allCities[i].city[j].name+"</option>"));
                }
            }
        }
    });

    $(".sheng").on("blur",function () {
        $(this).hide();
    });


    //市
    $(".y").on("focus",function () {
        $(".shi").show();
    });

    $(".shi").on("click","option",function () {
        $(".y").val($(this).val());
        $(".shi").hide();
        //生成区
        let sheng = $(".x").val();
        let shi = $(".y").val();
        $(".qu").html("");
        for (let i = 0; i < allCities.length; i++) {
            if (sheng == allCities[i].name){
                for (let j = 0; j <allCities[i].city.length; j++) {
                    if (shi == allCities[i].city[j].name){
                        for (let k = 0; k < allCities[i].city[j].area.length; k++) {
                            $(".qu").append($("<option value='"+allCities[i].city[j].area[k]+"'>"+allCities[i].city[j].area[k]+"</option>"))
                        }
                    }
                }
            }
        }
    });

    $(".shi").on("blur",function () {
        $(this).hide();
    });

    //区
    $(".z").on("focus",function () {
        $(".qu").show();
    });

    $(".qu").on("click","option",function () {
        $(".z").val($(this).val());
        $(".qu").hide();
    });

    $(".qu").on("blur",function () {
       $(this).hide();
    });


    for (let i = 0; i < allCities.length; i++) {
        $(".sheng").append($("<option value='"+allCities[i].name+"'>"+allCities[i].name+"</option>"));
    }

});