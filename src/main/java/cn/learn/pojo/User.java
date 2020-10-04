package cn.learn.pojo;

import lombok.Data;

import java.util.Date;

/**
 * 用户实体类
 */
@Data
public class User {
    private Integer u_id;
    private String u_nickname;
    private String u_password;
    private String u_sex;
    private Date u_birthday;
    private String u_address;
    private String u_head_image = "http://localhost:8080/music_player_user_headImage/head.png";  //默认头像
    private String u_introduce;
    private Date u_register_date;
}
