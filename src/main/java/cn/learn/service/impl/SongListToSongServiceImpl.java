package cn.learn.service.impl;

import cn.learn.dao.SongListToSongMapper;
import cn.learn.service.SongListToSongService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class SongListToSongServiceImpl implements SongListToSongService {

    @Autowired
    private SongListToSongMapper songListToSongMapper;

    @Transactional
    //通过歌单id查询歌单中歌曲id
    public List<Integer> findBySLId(int id) {
        return songListToSongMapper.findBySLId(id);
    }

    @Transactional
    //添加歌曲到自定义歌单
    public Integer addSong(int sl_id, int s_id) {
        return songListToSongMapper.saveSong(sl_id, s_id);
    }

    @Transactional
    //判断一首歌曲是否为我收藏
    public Integer findBySlidAndSid(int sl_id,int s_id){
       return songListToSongMapper.findBySlidAndSid(sl_id, s_id);
    }
}
