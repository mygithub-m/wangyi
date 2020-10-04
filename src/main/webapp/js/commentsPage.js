$(function(){

    //内容栏中字数变化
    var textarea = $(".commentsPage .content .main textarea");
    var num = $(".commentsPage .content .main span");
    textarea.on("input",function () {
        num.html(140-textarea[0].value.length);
    });

    //评论窗口关闭
    $(".commentsPage .content .top button").on("click",function(){
        $("#commentsPage").fadeOut(500);
    });

});