package cn.learn.pojo;

import lombok.Data;

import java.util.Date;

/**
 * 评论实体类
 */
@Data
public class Comments {
    private Integer c_id;  //评论id
    private Integer song_id;  //歌曲id
    private Integer user_id;  //用户id
    private Date c_date;  //评论时间
    private String c_content;  //评论内容
    private Integer c_support;  //评论获赞数

    private Song song;  //歌曲信息
    private User user;  //用户信息
}
