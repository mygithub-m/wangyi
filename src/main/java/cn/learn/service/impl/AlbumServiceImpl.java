package cn.learn.service.impl;

import cn.learn.dao.*;
import cn.learn.pojo.Album;
import cn.learn.pojo.Singer;
import cn.learn.pojo.Song;
import cn.learn.pojo.User;
import cn.learn.service.AlbumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class AlbumServiceImpl implements AlbumService {

    @Autowired
    private AlbumMapper albumMapper;  //专辑

    @Autowired
    private SongMapper songMapper;  //歌曲

    @Autowired
    private SingerMapper singerMapper;  //歌手

    @Autowired
    private LikeSongsMapper likeSongsMapper;  //歌曲是否为我喜欢

    @Autowired
    private DownLoadMapper downLoadMapper;  //歌曲是否下载


    @Transactional
    //通过专辑信息获取专辑的详细信息
    public Album getAlbumDetails(int aid, User user) {
        Album album = albumMapper.findById(aid);  //专辑

        List<Song> songs = songMapper.findByAlbumId(aid);  //专辑歌曲

        if (user != null) {
            //判断专辑是否为我收藏
            Integer a_id = albumMapper.checkAlbum(user.getU_id(), aid);
            if (a_id != null){  //用户已经收藏
                album.setIsCollect(true);
            } else {
                album.setIsCollect(false);
            }

            for (Song song : songs) {
                //判断歌曲是否为我喜欢
                Integer res = likeSongsMapper.findByUIdAndSId(user.getU_id(), song.getS_id());
                if (res != null) {
                    song.setIsLike(true);
                } else {
                    song.setIsLike(false);
                }
                //判断歌曲是否为我下载
                Integer res2 = downLoadMapper.isDownload(user.getU_id(), song.getS_id());
                if (res2!=null){
                    song.setIsDownload(true);
                } else {
                    song.setIsDownload(false);
                }
            }
        }
        //添加歌曲到专辑对象中
        album.setSongs(songs);
        //获取歌手信息
        Singer singer = singerMapper.findById(album.getS_id());  //歌手
        album.setSinger(singer);

        return album;
    }

    @Transactional
    //用户收藏专辑
    public void collectAlbum(int uid, int aid) {
        albumMapper.collectAlbum(uid, aid);
    }

    @Transactional
    //移除收藏的专辑
    public void deCollectAlbum(int uid, int aid) {
      albumMapper.deCollectAlbum(uid,aid);
    }

    @Transactional
    //获取用户收藏的全部专辑信息
    public List<Album> findCollectAlbum(int uid) {
        //获取用户收藏的专辑id
        List<Integer> aids = albumMapper.findCollectAlbum(uid);
        List<Album> albums = new ArrayList<Album>();  //存放专辑集合
        //通过专辑id获取专辑的详细信息
        for (Integer aid : aids) {
            //获取专辑信息
            Album album = albumMapper.findById(aid);
            //获取专辑歌手信息
            Singer singer = singerMapper.findById(album.getS_id());
            album.setSinger(singer);
            //获取专辑歌曲信息
            List<Song> songs = songMapper.findByAlbumId(album.getA_id());
            album.setSongs(songs);
            albums.add(album);
        }
        return albums;
    }

    @Transactional
    //通过关键字搜索专辑
    public List<Album> searchAlbum(String keyword) {
        //获取专辑基本信息
        List<Album> albums = albumMapper.searchAlbum(keyword);
        for (Album album : albums) {
            //根据歌手id获取专辑
            Singer singer = singerMapper.findById(album.getS_id());
            album.setSinger(singer);
        }
        return albums;
    }
}
