package cn.learn.dao;

import cn.learn.pojo.SongList;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用于操作歌单存放歌曲的表
 */
public interface SongListToSongMapper {

    /**
     * 通过歌单id查询歌单中的歌曲信息
     * @param id
     * @return
     */
    public List<Integer> findBySLId(int id);

    /**
     * 添加歌曲到自定歌单
     * @param sl_id
     * @param s_id
     * @return
     */
    public Integer saveSong(@Param("sl_id") int sl_id, @Param("s_id") int s_id);

    /**
     * 判断歌曲是否是用户的收藏
     * @param sl_id
     * @param s_id
     * @return
     */
    public Integer findBySlidAndSid(@Param("sl_id") int sl_id, @Param("s_id") int s_id);

    /**
     * 根据歌单id删除歌曲
     * @param slId
     */
    public void deleteBySlId(int slId);

    /**
     * 删除歌单中的某一首歌曲
     * @param slId
     * @param sid
     */
    public void deleteSong(@Param("slId") int slId,@Param("sid") int sid);
}
