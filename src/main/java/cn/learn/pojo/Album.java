package cn.learn.pojo;

import lombok.Data;

import java.util.List;

/**
 * 专辑
 */
@Data
public class Album {
    private Integer a_id;  //专辑id
    private String a_name;  //专辑名
    private String a_image;  //专辑封面
    private Integer s_id;  //歌手id

    private List<Song> songs;  //专辑包含的歌曲
    private Singer singer; //专辑歌手
    private Boolean isCollect; //是否为我收藏

}
