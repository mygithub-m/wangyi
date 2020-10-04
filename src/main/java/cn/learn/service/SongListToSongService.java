package cn.learn.service;

import java.util.List;

/**
 * 用于操作歌单存放歌曲的表
 */
public interface SongListToSongService {

    /**
     * 通过歌单id查询歌单歌曲id
     * @param id
     * @return
     */
    public List<Integer> findBySLId(int id);

    /**
     * 添加歌曲到自定义歌单
     * @return
     */
    public Integer addSong(int sl_id,int s_id);

    /**
     * 判断歌曲是否是用户的收藏
     * @param sl_id
     * @param s_id
     * @return
     */
    public Integer findBySlidAndSid(int sl_id,int s_id);

}
