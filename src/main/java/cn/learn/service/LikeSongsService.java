package cn.learn.service;

import cn.learn.pojo.Song;

import java.util.List;

/**
 * 用户喜欢的歌曲service
 */
public interface LikeSongsService {

    /**
     * 通过用户id查询用户喜欢的歌曲
     * @param id
     * @return
     */
    public List<Song> findLike(int id);

    /**
     * 判断一首歌曲是不是用户喜欢的歌曲
     * @param uid
     * @param sid
     * @return
     */
    public Integer findByUIdAndSId(int uid,int sid);

    /**
     * 添加歌曲到我喜欢
     * @param uid
     * @param sid
     */
    public void addSong(int uid,int sid);

    /**
     * 将歌曲从我喜欢中移除
     * @param uid
     * @param sid
     */
    public void removeSong(int uid,int sid);
}
