package cn.learn.pojo;

import lombok.Data;

/**
 * 播放列表实体类
 */
@Data
public class PlayList {
    private Integer p_id;  //播放id
    private Integer s_id;  //歌曲id
    private Integer s_type;  //歌曲类型
    private Integer u_id;  //用户id
}
