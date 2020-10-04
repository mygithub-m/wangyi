<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/9/2
  Time: 18:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/uploadHead.css">
</head>

<body>

<div class="upload">
    <div class="content">
        <div class="top">
            <h5>上传头像</h5>
            <button type="button" class="close" aria-label="Close" id="close"><span
                    aria-hidden="true">&times;</span></button>
        </div>
        <div class="main">
            <div class="big">
                <div class="left">
                    <div class="big_img">
                        <img src="${pageContext.request.contextPath}/img/12.jpg" alt="" id="big_img">
                        <div class="box">
                            <div class="one"></div>
                            <div class="box2">
                                <div class="cut"></div>
                                <div class="two"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="right">
                    <div class="m_img">
                        <div>
                            <img src="${pageContext.request.contextPath}/img/12.jpg" alt="" id="m_img">
                        </div>
                        <p>大尺寸封面</p>
                    </div>
                    <div class="s_img">
                        <div>
                            <img src="${pageContext.request.contextPath}/img/12.jpg" alt="" id="s_img">
                        </div>
                        <p>小尺寸封面</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="buttom">
            <button>重新选择</button>
            <button>保存并关闭</button>
        </div>
        <canvas id="cavas" style="border: 1px solid black;"></canvas>
    </div>
</div>
<script>
    $(function () {
        var files = $("#uploadFile")[0].files[0];
        var URL = window.URL;

        var fileUrl = URL.createObjectURL(files); //获取文件路径，但是表示是形式不是据对路径，而是一种加过密的形式

        $("#big_img").prop("src", fileUrl);

        $("#m_img").prop("src", fileUrl);
        $("#s_img").prop("src", fileUrl);
    });
</script>
<script src="${pageContext.request.contextPath}/js/uploadHead.js"></script>
</body>

</html>
