$(function () {  
    var close = $(".login_close");
    var login = $("#login");
    var reg_btn = $(".reg a");  //注册按钮
    var register = $("#register");  //注册框

    //关闭登录框
    close.on("click",function () {
        login.hide();
    });

    //切换注册框
    reg_btn.on("click",function () {
        login.hide();
        register.show();
    });

    //当表单获取焦点时，提示消息消失
    var msg = $(".login .msg");
    var name = $(".login .content .form .name input");
    var pwd = $(".login .content .form .pwd input");

    name.on("focus",function () {
         msg.fadeOut(1000);
    });

    pwd.on("focus",function () {
        msg.fadeOut(1000);
    });
});