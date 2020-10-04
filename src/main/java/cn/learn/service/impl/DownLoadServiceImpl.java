package cn.learn.service.impl;

import cn.learn.dao.*;
import cn.learn.pojo.Album;
import cn.learn.pojo.DownLoad;
import cn.learn.pojo.Singer;
import cn.learn.pojo.Song;
import cn.learn.service.DownLoadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class DownLoadServiceImpl implements DownLoadService {
    @Autowired
    private DownLoadMapper downLoadMapper;

    @Autowired
    private SongMapper songMapper;

    @Autowired
    private SingerMapper singerMapper;

    @Autowired
    private AlbumMapper albumMapper;

    @Autowired
    private LikeSongsMapper likeSongsMapper;

    @Transactional
    //添加到下载歌曲
    public void addSong(DownLoad downLoad) {
       downLoadMapper.saveSong(downLoad);
    }

    @Transactional
    //修改歌曲下载进度
    public void updateStatus(DownLoad downLoad) {
       downLoadMapper.updateStatus(downLoad);
    }

    @Transactional
    //获取用户下载的歌曲列表
    public List<DownLoad> findLoaded(int uid) {
        //获取基本信息
        List<DownLoad> downLoads = downLoadMapper.findUserLoaded(uid);
        for (DownLoad downLoad : downLoads) {
            //根据歌曲id获取歌曲信息
            Song song = songMapper.findById(downLoad.getS_id());
            //根据歌曲信息获取专辑信息
            Album album = albumMapper.findById(song.getAlbum_id());
            song.setAlbum(album);
            //根据歌曲信息获取歌手信息
            Singer singer = singerMapper.findById(song.getSinger_id());
            song.setSinger(singer);
            //判断歌曲是否是我喜欢
            Integer res = likeSongsMapper.findByUIdAndSId(uid, song.getS_id());
            if (res != null){
                song.setIsLike(true);
            } else {
                song.setIsLike(false);
            }
            downLoad.setSong(song);
        }
        return downLoads;
    }

    @Transactional
    //查找正在下载音乐列表
    public List<DownLoad> findLoading(int uid) {
        //获取基本信息
        List<DownLoad> downLoads = downLoadMapper.findUserLoading(uid);
        for (DownLoad downLoad : downLoads) {
            //根据歌曲id获取歌曲信息
            Song song = songMapper.findById(downLoad.getS_id());
            downLoad.setSong(song);
        }
        return downLoads;
    }

    @Transactional
    //清空用户的正在下载音乐列表
    public void clearUser(int uid) {
        downLoadMapper.clearUser(uid);
    }

    @Transactional
    //判断一首歌曲是否是已经被下载了
    public Integer isDownload(int uid, int sid) {
        return downLoadMapper.isDownload(uid, sid);
    }
}
