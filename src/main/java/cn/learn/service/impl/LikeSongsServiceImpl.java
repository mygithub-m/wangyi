package cn.learn.service.impl;

import cn.learn.dao.*;
import cn.learn.pojo.Album;
import cn.learn.pojo.Singer;
import cn.learn.pojo.Song;
import cn.learn.service.LikeSongsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class LikeSongsServiceImpl implements LikeSongsService {

    @Autowired
    private LikeSongsMapper likeSongsMapper;

    @Autowired
    private SongMapper songMapper;

    @Autowired
    private AlbumMapper albumMapper;

    @Autowired
    private SingerMapper singerMapper;

    @Autowired
    private DownLoadMapper downLoadMapper;


    @Transactional
    //查询用户喜欢的歌曲
    public List<Song> findLike(int id) {
        //获取歌曲id列表
        List<Integer> ids = likeSongsMapper.findLike(id);
        List<Song> songs = new ArrayList<Song>();  //用来存放歌曲列表

        for (Integer sid : ids) {
            //通过歌曲id查询歌曲信息
            Song song = songMapper.findById(sid);
            //通过专辑id查询专辑信息
            Album album = albumMapper.findById(song.getAlbum_id());
            song.setAlbum(album);
            //通过歌手id查询歌手信息
            Singer singer = singerMapper.findById(song.getSinger_id());
            song.setSinger(singer);
            //判断歌曲是否被下载
            Integer res = downLoadMapper.isDownload(id, sid);
            if (res != null){  //已经下载
                song.setIsDownload(true);
            } else {
                song.setIsDownload(false);
            }
            songs.add(song);
        }

        return songs;
    }

    @Transactional
    //判断一首歌曲是不是用户喜欢的歌曲
    public Integer findByUIdAndSId(int uid, int sid) {
        return  likeSongsMapper.findByUIdAndSId(uid, sid);
    }

    @Transactional
    //添加歌曲到我喜欢
    public void addSong(int uid, int sid) {
        likeSongsMapper.addLikeSong(uid,sid);
    }

    @Transactional
    //将歌曲从我喜欢中移除
    public void removeSong(int uid, int sid) {
        likeSongsMapper.deleteSong(uid, sid);
    }
}
