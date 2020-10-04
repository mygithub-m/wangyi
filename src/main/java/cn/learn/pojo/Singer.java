package cn.learn.pojo;

import lombok.Data;

import java.util.List;

/**
 * 歌手实体类
 */
@Data
public class Singer {
    private Integer singer_id;  //歌手id
    private String singer_name;  //歌手名
    private String singer_image;  //歌手图片

    private List<Album> albums;  //歌手拥有的专辑
    private List<Song> songs;  //歌手拥有的歌曲

    private Boolean isCollect;  //歌手是否为用户收藏
}
