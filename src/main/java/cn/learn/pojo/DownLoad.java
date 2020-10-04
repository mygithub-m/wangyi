package cn.learn.pojo;

import lombok.Data;

import java.util.Date;

/**
 * 下载实体
 */

@Data
public class DownLoad {
    private Integer m_id;   //下载id
    private Integer s_id;   //歌曲id
    private Integer u_id ;  //用户id
    private Date m_date;  //歌曲下载时间
    private Long status;  //歌曲状态，0~100代表下载进度（百分比）

    private Song song;  //歌曲信息
}
