package cn.learn.service;

import cn.learn.pojo.PlayList;
import cn.learn.pojo.Song;

import java.util.List;

/**
 * 播放列表 service
 */
public interface PlayListService {

    /**
     * 添加歌曲到播放列表
     * @return
     */
    public Integer addSong(int sid,int s_type,int uid);


    /**
     * 查询播放列表所有歌曲信息
     * @return
     */
    public List<Song> findAll(int uid);


    /**
     * 清空播放列表
     * @return
     */
    public Integer clear(int uid);

    /**
     * 根据歌曲id获得歌曲详细信息
     * @return
     */
    public Song findBySid(int sid,Integer uid);
}
