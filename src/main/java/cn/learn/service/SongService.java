package cn.learn.service;

import cn.learn.pojo.Song;
import cn.learn.pojo.User;

import java.util.List;

/**
 * 歌曲service
 */
public interface SongService {

    /**
     * 关键字搜索歌曲
     * @param keyword
     * @param user
     * @return
     */
    public List<Song> searchSongs(String keyword, User user);


    /**
     * 通过歌曲id查询歌曲信息
     * @param id
     * @return
     */
    public Song findById(int id);
}
