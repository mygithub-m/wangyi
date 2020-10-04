$(function () {
    //返回登录
    var returnLogin = $(".login .returnLogin");
    var login = $("#login");
    var register = $("#register");

    //返回登录
    returnLogin.on("click", function () {
        register.hide();
        login.show();
    });

    var close = $(".register_close");
    //关闭按钮
    close.on("click",function () {
       register.hide();
    });

    //注册成功后登录
    var regAfter = $(".register_msg span");

    regAfter.on("click","a",function () {   //事件委派
        returnLogin.click();
    });

});