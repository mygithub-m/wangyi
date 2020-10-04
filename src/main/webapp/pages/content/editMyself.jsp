<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/9/1
  Time: 17:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/editMyself.css">
</head>

<body>
<div class="editMyself">
    <div class="content">
        <div class="big_box">
            <div class="top">
                <h4>编辑个人信息</h4>
            </div>
            <div class="buttom">
                <div class="small_box">
                    <div class="left">
                        <form>
                            <label>昵称：</label>
                            <input class="nickname" type="text" value="" name="u_nickname">
                            <br>
                            <div class="introduce">
                                <label>介绍：</label>
                                <div class="text">
                                    <textarea name="u_introduce" id="" cols="30" rows="10" maxlength="300"></textarea>
                                    <span>300</span>
                                </div>
                            </div>

                            <br>
                            <div class="sex">
                                <label>性别：</label>
                                <input style="margin-left: 0px;" type="radio" name="u_sex" value="保密" selected>&ensp;保密
                                <input type="radio" name="u_sex" value="男">&ensp;男
                                <input type="radio" name="u_sex" value="女">&ensp;女
                            </div>
                            <br>
                            <label>生日:</label>
                            <select name="year" class="year">
                                <!--年-->
                                <c:forEach begin="1920" var="i" step="1" end="2020">
                                    <option value="${i}">${i}年</option>
                                </c:forEach>
                            </select>
                            <select name="mouth" class="mouth">
                                <!--月-->
                                <c:forEach begin="1" var="i" step="1" end="12">
                                    <option value="${i}">${i}月</option>
                                </c:forEach>
                            </select>
                            <select name="day" class="day">
                                <!--日-->
                                <c:forEach begin="1" var="i" step="1" end="31">
                                    <option value="${i}">${i}日</option>
                                </c:forEach>
                            </select>
                            <br>
                            <div class="address">
                                <label>地区：</label>
                                <input type="text" value="选择省份" class="x">
                                <select name="sheng" class="sheng" size="10">

                                </select>
                                <input type="text" value="选择城市" class="y" >
                                <select name="shi" class="shi" size="10">

                                </select>
                                <input type="text" value="选择县区" class="z">
                                <select name="qu" class="qu" size="10">

                                </select>
                            </div>

                            <br> <br> <br>
                            <input type="button" value="保存" class="save">
                            <input type="button" value="取消" class="cancel">


                        </form>
                    </div>
                    <div class="right">
                        <div class="img">
                            <img src="${pageContext.request.contextPath}/img/head.png" alt="" id="headImg">
                            <br><br>
                            <button>修改头像</button>
                            <input type="file" name="file" class="headFile" id="uploadFile"/>
                        </div>
                    </div>

                    <div class="msg">
                        <p>
                            <span class="glyphicon glyphicon-remove-circle"></span>
                            <span>修改个人资料成功</span>
                        </p>
                    </div>

                    <div id="upload"></div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    $(function () {
        //获取元素
        let name = $(".nickname");
        let introduce = $(".text textarea");
        let sex = $(".sex input");
        let image = $(".editMyself .img img");
        let year = $(".year option");
        let mouth = $(".mouth option");
        let day = $(".day option");
        let address = $(".address option");

        let sub = $(".editMyself .save");
        let img = $(".editMyself .right img");
        sub.on("click", function () {
            let u_nickname = name.val();
            let u_introduce = introduce.val();
            let u_sex = null;
            sex.each(function (index, element) {
                if ($(element).prop("checked")) {
                    u_sex = $(element).val()
                }
            });
            let u_year = null;
            year.each(function (index, element) {
                if ($(element).prop("selected")) {
                    u_year = $(element).val();
                }
            });

            let u_mouth = null;
            mouth.each(function (index, element) {
                if ($(element).prop("selected")) {
                    u_mouth = $(element).val();
                }
            });

            let u_day = null;
            day.each(function (index, element) {
                if ($(element).prop("selected")) {
                    u_day = $(element).val();
                }
            });

            let u_address = $(".sheng").val()+" "+$(".shi").val()+" "+$(".qu").val();
            //发送异步请求修改用户信息（除头像外）
            $.post("${pageContext.request.contextPath}/register/update.do",
                {
                    "u_nickname": u_nickname,
                    "u_introduce": u_introduce,
                    "u_sex": u_sex,
                    "year": u_year,
                    "mouth": u_mouth,
                    "day": u_day,
                    "u_address": u_address
                },
                function (data) {
                    $(".editMyself .content .small_box .msg p span:last-child").html(data);
                    $(".editMyself .content .small_box .msg").show();
                    setTimeout(function () {  //2s后自动消失
                        $(".editMyself .content .small_box .msg").fadeOut(1000);
                    },1000);
                });
        });

        //发送异步请求，获取已登录用户信息
        $.get("${pageContext.request.contextPath}/register/logined.do", {}, function (data) {

            //将获得的生日转化成日期对象（默认是时间戳）
            let birth = new Date(data.u_birthday);
            let u_year = birth.getFullYear();  //获取生日年份
            let u_mouth = birth.getMonth() + 1;  //月份
            let u_day = birth.getDate();  //号数

            //回显数据
            name.val(data.u_nickname);  //昵称
            introduce.val(data.u_introduce);  //介绍
            image.prop("src",data.u_head_image);  //头像

            //地址
            let u_address = data.u_address;
            let arr = u_address.split(" ");

            $(".x").val(arr[0]);  //省
            $(".y").val(arr[1]);  //市
            $(".z").val(arr[2]); //区
           /* address.each(function (index, element) {
                if ($(element).val() == data.u_address) {
                    $(this).prop("selected", "selected");
                }
            });*/

            sex.each(function (index, element) {   //性别
                if ($(element).val() == data.u_sex) {
                    $(element).prop("checked", "checked");
                }
            });
            year.each(function (index, element) {  //生日之年份
                if ($(this).val() == u_year) {
                    $(this).prop("selected", "selected");
                }
            });
            mouth.each(function (index, element) {  //生日之月份
                if ($(this).val() == u_mouth) {
                    $(this).prop("selected", "selected");
                }
            });
            day.each(function (index, element) {  //生日之号数
                if ($(this).val() == u_day) {
                    $(this).prop("selected", "selected");
                }
            })

        });
    });
</script>
<script src="${pageContext.request.contextPath}/js/cities.js"></script>
<script src="${pageContext.request.contextPath}/js/editMyself.js"></script>
</body>

</html>
