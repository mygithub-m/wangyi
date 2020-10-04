package cn.learn.dao;

import cn.learn.pojo.Song;
import cn.learn.pojo.User;

import java.util.List;

/**
 * 歌曲dao
 */
public interface SongMapper {

    /**
     * 添加歌曲
     * @param song
     * @return
     */
    public Integer insertSong(Song song);


    /**
     * 通过id查询歌曲
     * @param id
     * @return
     */
    public Song findById(int id);

    /**
     * 通过关键字搜索歌曲
     * @param keyword
     * @return
     */
    public List<Song> searchSongs(String keyword);

    /**
     * 通过专辑id获取专辑的所有歌曲
     * @param aid
     * @return
     */
    public List<Song> findByAlbumId(int aid);
}
