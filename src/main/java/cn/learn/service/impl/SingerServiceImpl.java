package cn.learn.service.impl;

import cn.learn.dao.*;
import cn.learn.pojo.*;
import cn.learn.service.SingerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class SingerServiceImpl implements SingerService {

    @Autowired
    private SingerMapper singerMapper;  //歌手

    @Autowired
    private AlbumMapper albumMapper;  //专辑

    @Autowired
    private SongMapper songMapper;  //歌曲

    @Autowired
    private LikeSongsMapper likeSongsMapper;  //歌曲是否为我喜欢

    @Autowired
    private DownLoadMapper downLoadMapper;  //是否下载


    @Transactional
    //通过歌手id获得歌手的详细信息
    public Singer findById(int id, User user) {
        //根据歌手id获得歌手的基本信息
        Singer singer = singerMapper.findById(id);
        //判断歌手是不是我的收藏
        if (user != null) {
            Integer res = singerMapper.checkSinger(user.getU_id(), id);
            if (res != null) {
                singer.setIsCollect(true);
            } else {
                singer.setIsCollect(false);
            }
        }
        //根据歌手id获得歌手拥有的专辑
        List<Album> albums = albumMapper.findBySingerId(id);
        //查询每一个专辑中的歌曲信息
        for (Album album : albums) {
            //获得歌曲
            List<Song> songs = songMapper.findByAlbumId(album.getA_id());
            //用户是否登录
            if (user != null) {
                for (Song song : songs) {
                    //判断一首歌曲是不是我喜欢
                    Integer res = likeSongsMapper.findByUIdAndSId(user.getU_id(), song.getS_id());
                    if (res != null) {  //歌曲为我喜欢
                        song.setIsLike(true);
                    } else {
                        song.setIsLike(false);
                    }
                    //歌曲是否被下载
                    Integer res2 = downLoadMapper.isDownload(user.getU_id(), song.getS_id());
                    if(res2!=null){
                        song.setIsDownload(true);
                    } else {
                        song.setIsDownload(false);
                    }
                }
            }
            //写入对象
            album.setSongs(songs);
        }
        //将歌手的专辑信息写进对象
        singer.setAlbums(albums);

        return singer;
    }

    @Transactional
    //取消收藏歌手
    public void deCollectSinger(int uid, int sid) {
        singerMapper.deCollectSinger(uid, sid);
    }

    @Transactional
    //收藏歌手
    public void collectSinger(int uid, int sid) {
        singerMapper.collectSinger(uid, sid);
    }

    @Transactional
    //获取用户收藏的所有歌手信息
    public List<Singer> findCollectSinger(int uid) {
        //获取用户收藏的所有歌手id
        List<Integer> sids = singerMapper.findCollectSinger(uid);
        List<Singer> singers = new ArrayList<Singer>();  //用来存储收藏的歌手集合
        //通过歌手id查询歌手的详细信息
        for (Integer sid : sids) {
            //获取歌手的基本信息
            Singer singer = singerMapper.findById(sid);
            //获取歌手的专辑信息
            List<Album> albums = albumMapper.findBySingerId(singer.getSinger_id());
            singer.setAlbums(albums);
            //存入
            singers.add(singer);
        }
        return singers;
    }

    @Transactional
    //通过关键字搜索歌手
    public List<Singer> searchSinger(String keyword) {
        //获得满足条件的歌手基本信息
        List<Singer> singers = singerMapper.searchSinger(keyword);
        //获得歌手的专辑信息
        for (Singer singer : singers) {
            List<Album> albums = albumMapper.findBySingerId(singer.getSinger_id());
            singer.setAlbums(albums);
        }
        return singers;
    }
}
