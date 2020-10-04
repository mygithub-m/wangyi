package cn.learn.service.impl;

import cn.learn.dao.LocalSongMapper;
import cn.learn.pojo.Song;
import cn.learn.service.LocalSongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LocalSongServiceImpl implements LocalSongService {

    @Autowired
    private LocalSongMapper localSongMapper;

    @Transactional
    //判断歌曲是不是本地音乐
    public Song selectByLocal(Song song) {
        return localSongMapper.selectBySong(song);
    }
}
