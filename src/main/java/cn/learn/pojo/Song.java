package cn.learn.pojo;

import lombok.Data;

import java.util.List;

/**
 * 歌曲实体
 */
@Data
public class Song {
    private Integer s_id;  //歌曲id
    private String s_name;  //歌曲名
    private String s_length;  //歌曲时长
    private String s_size;  //歌曲大小
    private String s_path;  //歌曲路径
    private Integer album_id;  //专辑id
    private Integer singer_id;  //歌手id
    private List<Comments>  comments;  //歌曲评论

    private Singer singer;  //歌手
    private Album album;  //专辑

    private Integer s_type;  //歌曲类型，0代表本地歌曲，1代表远程歌曲
    private Boolean isLike;  //是否为我喜欢
    private Boolean isCollect;  //是否为我收藏
    private Boolean isDownload;  //是否被下载

}
