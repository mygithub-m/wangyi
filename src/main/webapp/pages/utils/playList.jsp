<%--
  Created by IntelliJ IDEA.
  User: 滑翔的人儿
  Date: 2020/9/7
  Time: 21:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/playList.css">
</head>

<body>
<div class="playList" id="playList_son">
    <div class="content">
        <div class="top">
            <div class="toggle">
                <div class="box">
                    <div class="list list_select">
                        播放列表
                    </div>
                    <div class="history">
                        历史记录
                    </div>
                </div>
            </div>
            <div class="close">
                <button type="button" aria-label="Close" id="playList_close"><span aria-hidden="true">&times;</span></button>
            </div>
        </div>
        <div class="main">
            <span>共<span></span>首</span>
            <div class="box2">
                <div class="add">
                    <span class="glyphicon glyphicon-plus"></span>
                    收藏全部&ensp;&ensp;
                </div>
                <div class="remove">
                    <span class="glyphicon glyphicon-trash"></span>
                    <span>清空</span>
                </div>
            </div>
        </div>
        <div class="bottom" id="style-5">
            <table>
                <%-- <tr>
                     <td>
                         <span></span>
                         <span class="glyphicon glyphicon-pause"></span>
                                      glyphicon glyphicon-play
                     </td>
                     <td>世界第一等</td>
                     <td>刘德华</td>
                     <td><span class="glyphicon glyphicon-link
                             glyphicon "></span></td>
                     <td>04:21</td>
                 </tr>--%>
            </table>
        </div>
    </div>
</div>
<script>
    //请求播放列表信息
    var playListTable = $("#playList_son table");
    var playListNum = $("#playList_son .content .main > span span");

    //发送异步请求获取用户的登录情况
    $.get("${pageContext.request.contextPath}/login/auto.do", function (data) {
        //用户id
        let uid = data.u_id;
        $.get("${pageContext.request.contextPath}/playList/findAll.do",{uid:uid},function (data) {
            playListTable.html("");  //清空页面
            if (data != null && data.length != 0) {
                //渲染页面
                playListNum.html(data.length);
                for (let i = 0; i < data.length; i++) {
                    let str = "<tr><td><span>" + data[i].s_id + "</span><span class='glyphicon glyphicon-pause'></span></td> <td>" + data[i].s_name + "</td><td>" + data[i].singer.singer_name + "</td> <td><span class='glyphicon glyphicon-link'></span></td><td>" + data[i].s_length + "</td></tr>"
                    playListTable.append($(str));
                }
            } else {
                playListNum.html(0);
                let str = "<tr><td colspan='5' align='center'>你的歌单还没有歌曲哦！</td></tr>";
                playListTable.append($(str));
            }

            //获取当前播放歌曲
            $.get("${pageContext.request.contextPath}/playList/current.do",{uid:uid},function (data) {
                if (data != null && data.length !=0){
                    $("#playList_son table tr td:first-child span:first-child").each(function (index, element) {
                        if ($(this).html() == data.s_id) {
                            $(this).siblings("span").css("display","block");
                        } else {
                            $(this).siblings("span").css("display","none");
                        }
                    });
                }
            });
        });
    });
</script>
<script src="${pageContext.request.contextPath}/js/playList.js"></script>
</body>
</html>
