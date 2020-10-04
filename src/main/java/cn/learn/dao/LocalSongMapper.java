package cn.learn.dao;

import cn.learn.pojo.Song;

/**
 * 本地歌曲dao
 */
public interface LocalSongMapper {


    /**
     * 通过本地歌曲查询远程本首歌曲信息
     * @return
     */
    public Song selectBySong(Song song);
}
