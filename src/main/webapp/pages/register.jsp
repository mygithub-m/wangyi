<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/9/1
  Time: 8:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>

<body>

<div class="login">
    <div class="content">
        <div class="form">
            <form>
                <div class="box1">
                    <div class="name register_name">
                        <span class="glyphicon glyphicon-user"></span>
                        <input type="text" name="nickname" placeholder="用户名">
                    </div>
                    <div class="pwd register_pwd">
                        <span class="glyphicon glyphicon-lock"></span>
                        <input type="password" name="password" placeholder="设置登录密码 不少于6位">
                    </div>
                </div>
                <div class="auto">

                </div>
                <div class="btn reg_btn">
                    <input type="submit" value="注册">
                </div>

                <div class="register_msg msg">
                    <span></span>
                </div>

            </form>
        </div>

        <div class="close register_close">
            <button type="button" class="close" aria-label="Close"><span aria-hidden="true">&times;</span>
            </button>
        </div>

        <div class="returnLogin">
            <span><返回登录</span>
        </div>
    </div>
</div>

<script>
    $(function () {
        //注册表单异步提交
        let sub_btn = $(".reg_btn input");
        let register_msg = $(".register_msg span");
        let msg_div = $(".register_msg");

        sub_btn.on("click", function () {
            //获取注册表单元素内容，进行正则校验
            let name = $(".register_name input").val();
            let pwd = $(".register_pwd input").val();

            //定义正则表达式
            let nameReg = /^[0-9a-zA-Z\u2E80-\u9FFF]{3,15}$/;
            let pwdReg = /^[0-9a-zA-Z]{6,10}$/;

            //正则校验
            let name_res = nameReg.test(name);
            let pwd_res = pwdReg.test(pwd);

            if (name_res && pwd_res) {  //如果格式都正确，则发送异步请求进行用户注册

                $.post("${pageContext.request.contextPath}/register/user.do",
                    {nickname: name, password: pwd},
                    function (data) {
                         console.log(data);
                        register_msg.html(data)
                        msg_div.fadeIn(100);
                    });

            } else {  //否则提示错误消息
                register_msg.html("密码或用户名格式不正确！")
                 msg_div.fadeIn(100);
            }
            return false;
        });
    });
</script>
<script src="${pageContext.request.contextPath}/js/login.js"></script>
<script src="${pageContext.request.contextPath}/js/register.js"></script>
</body>

</html>
