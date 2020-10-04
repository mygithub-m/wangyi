package cn.learn.service;

import cn.learn.pojo.Song;

/**
 * 本地音乐service
 */
public interface LocalSongService {

    /**
     * 通过本地音乐查询远程音乐的信息
     * @param song
     * @return
     */
    public Song selectByLocal(Song song);
}
