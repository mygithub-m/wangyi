package cn.learn.service.impl;

import cn.learn.dao.*;
import cn.learn.pojo.*;
import cn.learn.service.PlayListService;
import com.sun.org.apache.xerces.internal.xs.XSIDCDefinition;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

/**
 *   播放列表
 */
@Service
public class PlayListServiceImpl implements PlayListService {

    @Autowired
    private PlayListMapper playListMapper;  //播放列表

    @Autowired
    private SongMapper songMapper;  //歌曲

    @Autowired
    private AlbumMapper albumMapper;  //专辑

    @Autowired
    private SingerMapper singerMapper;  //歌手

    @Autowired
    private LikeSongsMapper likeSongsMapper;  //我喜欢

    @Autowired
    private DownLoadMapper downLoadMapper; //是否下载


    @Transactional
    //添加歌曲
    public Integer addSong(int sid,int s_type,int uid) {
        return playListMapper.save(sid, s_type, uid);
    }

    @Transactional
    //查询所有歌曲信息
    public List<Song> findAll(int uid) {
        //获取用户播放列表
        List<PlayList> playList = playListMapper.findAll(uid);

        List<Song> songs = new ArrayList<Song>();  //用来存放歌曲

        //获取歌曲
        for (PlayList list : playList) {
            //根据歌曲id获取歌曲的信息
            Song song = songMapper.findById(list.getS_id());
            //判断歌曲是不是我喜欢
            Integer res = likeSongsMapper.findByUIdAndSId(uid, song.getS_id());
            if (res != null){  //我喜欢
                song.setIsLike(true);
            } else {
                song.setIsLike(false);
            }
            //判断歌曲是否下载
            Integer res2 = downLoadMapper.isDownload(uid, song.getS_id());
            if (res2 != null){
                song.setIsDownload(true);
            } else {
                song.setIsDownload(false);
            }
            //获取歌曲播放源
            song.setS_type(list.getS_type());

            songs.add(song);
        }

        //获取歌曲的专辑和歌手信息
        for (Song song : songs) {
            //获取专辑信息
            Album album = albumMapper.findById(song.getAlbum_id());
            song.setAlbum(album);

            //获取歌手信息
            Singer singer = singerMapper.findById(song.getSinger_id());
            song.setSinger(singer);
        }

        return songs;
    }

    @Transactional
    //清空播放列表
    public Integer clear(int uid) {
        return playListMapper.clear(uid);
    }

    @Transactional
    //根据歌曲id获取歌曲信息
    public Song findBySid(int sid,Integer uid) {
        //获得歌曲
        Song song = songMapper.findById(sid);
        //获得歌曲专辑信息
        Album album = albumMapper.findById(song.getAlbum_id());
        song.setAlbum(album);
        //获得歌手信息
        Singer singer = singerMapper.findById(song.getSinger_id());
        song.setSinger(singer);

        if (uid != null){
            //判断歌曲是不是我喜欢
            Integer res = likeSongsMapper.findByUIdAndSId(uid, sid);
            if (res != null ){  //喜欢
                song.setIsLike(true);
            } else {
                song.setIsLike(false);
            }
            //歌曲是否下载
            Integer res2 = downLoadMapper.isDownload(uid, sid);
            if (res2!=null){
                song.setIsDownload(true);
            } else {
                song.setIsDownload(false);
            }
        }
        return song;
    }
}
