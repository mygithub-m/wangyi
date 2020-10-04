<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/8/29
  Time: 10:33
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
                    <div class="name login_name">
                        <span class="glyphicon glyphicon-user"></span>
                        <input type="text" name="nickname" placeholder="请输入用户名">
                    </div>
                    <div class="pwd login_pwd">
                        <span class="glyphicon glyphicon-lock"></span>
                        <input type="password" name="password" placeholder="请输入密码">
                    </div>
                </div>
                <div class="auto">
                    <input type="checkbox" name="auto">
                    <span>自动登录</span>
                </div>
                <div class="btn login_btn">
                    <input type="submit" value="登录">
                </div>
                <div class="reg">
                    <a href="javaScript:;">注册</a>
                </div>
                <div class="login_msg msg">
                    <span></span>
                </div>
            </form>
        </div>

        <div class="close login_close">
            <button type="button" class="close" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        </div>
    </div>
</div>

<script>
    $(function () {
        let btn = $(".login_btn input");  //登录按钮
        let text = $(".login_name input"); //用户名
        let password = $(".login_pwd input"); //密码
        let auto = $(".auto input"); //是否自动登录

        btn.on("click",function () {
            let nickname = text.val();
            let pwd = password.val();
            let flag = auto[0].checked == true ? "auto" : null;

           $.get("${pageContext.request.contextPath}/login/user.do",
               {"nickname":nickname,"password":pwd,"auto":flag},
               function (data) {

                  if (data != null && data != ""){//登录成功
                      //表名是第一次登录
                      window.first = 0;
                      //关闭控制歌曲播放以及唱碟旋转的计时器
                      clearInterval(timer);
                      clearInterval(timer2);

                      let close = $(".login_close");

                      close.click();  //关闭登录框
                      //获取头部元素
                      let userName = $("#userName");  //获取用户名元素
                      let userHead = $("#userHead");  //获取用户头像元素

                      //获取信息框中元素
                      let myself_userName = $("#myself_userName");  //个人信息框中用户名
                      let myself_userHead = $("#myself_userHead");  //个人信息框中用户头像
                      //写入头部
                      userName.html(data.u_nickname+'<span class="caret"></span>');  //写入用户名
                      console.log(data.u_head_image);
                      userHead.prop("src",data.u_head_image);  //写入用户头像
                      //写入信息框
                      myself_userName.html(data.u_nickname);  //写入用户名
                      myself_userHead.prop("src",data.u_head_image);  //写入用户头像

                      //刷新页面
                      $("#sidebar").load("pages/utils/sidebar.jsp");
                      $("#footer").load("pages/utils/footer.jsp");
                      $("#mySong .local").click();
                  } else { //登录失败
                      let msg = $(".login_msg span");
                      msg.html("密码或用户名错误");
                      let msg_div = $(".login_msg");
                      msg_div.fadeIn(100);
                  }
               })
           return false;
        });
    });
</script>

<script src="${pageContext.request.contextPath}/js/login.js"></script>
</body>

</html>
