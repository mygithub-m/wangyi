package cn.learn.pojo;

import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * 歌单类
 */
@Data
public class SongList {
    private Integer sl_id;  //歌单id
    private String sl_name; //歌单名称
    private Integer u_id;  //拥有者id
    private Date sl_date;  //创建时间
    private String sl_introduce;  //歌单简介
    private String sl_tag;  //歌单标签
    private Integer sl_playnum;  //歌单播放次数
    private List<Song> songList;  //歌单中的歌曲信息
    private User user;  //歌单拥有者信息
}
