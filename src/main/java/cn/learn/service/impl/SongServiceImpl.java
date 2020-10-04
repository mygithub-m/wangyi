package cn.learn.service.impl;

import cn.learn.dao.*;
import cn.learn.pojo.Album;
import cn.learn.pojo.Singer;
import cn.learn.pojo.Song;
import cn.learn.pojo.User;
import cn.learn.service.SongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class SongServiceImpl implements SongService {

    @Autowired
    private SongMapper songMapper;

    @Autowired
    private SingerMapper singerMapper;

    @Autowired
    private AlbumMapper albumMapper;

    @Autowired
    private LikeSongsMapper likeSongsMapper; //歌曲是否为我喜欢

    @Autowired
    private DownLoadMapper downLoadMapper;  //歌曲是否下载

    @Transactional
    //关键字搜索歌曲
    public List<Song> searchSongs(String keyword, User user) {

        //先查找出满足条件的歌曲
        List<Song> songs = songMapper.searchSongs(keyword);

        for (Song song : songs) {
            //查询歌手信息
            Singer singer = singerMapper.findById(song.getSinger_id());
            //查询专辑信息
            Album album = albumMapper.findById(song.getAlbum_id());
            song.setSinger(singer);
            if (user != null){
                //判断歌曲是否为我喜欢
                Integer res = likeSongsMapper.findByUIdAndSId(user.getU_id(), song.getS_id());
                if(res != null){
                    song.setIsLike(true);
                } else {
                    song.setIsLike(false);
                }
                //判断歌曲是否下载
                Integer res2 = downLoadMapper.isDownload(user.getU_id(), song.getS_id());
                if (res2 != null){
                    song.setIsDownload(true);
                } else {
                    song.setIsDownload(false);
                }
            }
            song.setAlbum(album);
        }

        return songs;
    }

    @Transactional
    //根据歌曲id查询歌曲
    public Song findById(int id) {
        return songMapper.findById(id);
    }
}
