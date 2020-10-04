<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/9/9
  Time: 19:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/downloadManager.css">
</head>

<body>
<div class="downloadManager">
    <div class="content" id="style-5">
        <div class="top">
            <div class="box">
                <div class="box1 select">已下载单曲</div>
                <div class="box1" id="loading">正在下载</div>
            </div>
        </div>

        <!-- 已经下载的音乐列表 -->
        <div class="ed now">
            <div class="main">
                <div class="box">
                    <div class="all">
                        <p>
                            <span class="glyphicon glyphicon-play-circle"></span>
                            <span>播放全部</span>
                        </p>
                        <span>+</span>
                    </div>
                    <div class="path">
                        <span>存储目录：</span>
                    </div>
                </div>
                <div class="search">
                    <input type="text" name="" placeholder="搜索我下载的音乐">
                    <img src="${pageContext.request.contextPath}/img/07.png">
                    <span>✖</span>
                </div>
            </div>
            <div class="bottom">
                <table>
                   <%-- <tr>
                        <td></td>
                        <td></td>
                        <td>音乐标题</td>
                        <td>歌手</td>
                        <td>专辑</td>
                        <td>大小</td>
                        <td>下载时间</td>
                    </tr>
                    <tr>
                        <td>01</td>
                        <td><span class="glyphicon glyphicon-heart"></span></td>
                        <td>世界第一等</td>
                        <td>刘德华</td>
                        <td>爱你一万年</td>
                        <td>10.2MB</td>
                        <td>2020-09-09</td>
                        <td>id</td>
                    </tr>--%>
                </table>
            </div>
        </div>

        <!-- 正在下载列表 -->
        <div class="ing" id="ing">
            <div class="main">
                <div class="box">
                    <div class="caozuo">
                        <div>
                            <span class="glyphicon glyphicon-arrow-down"></span>
                            <span>全部开始</span>
                        </div>
                        <div>
                            <span class="glyphicon glyphicon-pause"></span>
                            <span>全部暂停</span>
                        </div>
                        <div>
                            <span class="glyphicon glyphicon-trash"></span>
                            <span>清空全部</span>
                        </div>
                    </div>
                    <div class="path">
                        <span>存储目录:</span>
                    </div>
                </div>
            </div>
            <div class="bottom">
                <table>
                  <%--  <tr><td></td><td>音乐标题</td><td>进度</td></tr>
                    <tr>
                        <td>01</td>
                        <td>世界第一等</td>
                        <td>刘德华</td>
                        <td></td>
                    </tr>--%>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/downloadManager.js"></script>
</body>

</html>
