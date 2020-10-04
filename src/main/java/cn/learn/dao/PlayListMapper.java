package cn.learn.dao;

import cn.learn.pojo.PlayList;
import cn.learn.pojo.Song;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 播放列表 dao
 */
public interface PlayListMapper {

    /**
     * 添加歌曲到播放列表
     * @param sid,s_type,uid
     * @return
     */
    public Integer save(@Param("s_id") int sid,@Param("s_type")int s_type,@Param("u_id") int uid);

    /**
     * 查询播放列表中的所有内容
     * @return
     */
    public List<PlayList> findAll(int uid);

    /**
     * 清空表
     * @return
     */
    public Integer clear(int uid);
}
