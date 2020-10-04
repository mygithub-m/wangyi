package cn.learn.service.impl;

import cn.learn.dao.*;
import cn.learn.pojo.*;
import cn.learn.service.LoginService;
import cn.learn.service.SongListService;
import cn.learn.service.SongListToSongService;
import cn.learn.service.SongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class SongListServiceImpl implements SongListService {

    @Autowired
    private SongListMapper songListMapper;

    @Autowired
    private LoginMapper loginMapper;

    @Autowired
    private SongListToSongMapper songListToSongMapper;

    @Autowired
    private LikeSongsMapper likeSongsMapper;  //判断一首歌曲是不是我喜欢

    @Autowired
    private SongService songService;  //歌曲

    @Autowired
    private AlbumMapper albumMapper;  //专辑

    @Autowired
    private SingerMapper singerMapper;  //歌手

    @Autowired
    private DownLoadMapper downLoadMapper;  //是否下载

    @Transactional
    //通过用户id查询用户歌单
    public List<SongList> findByUId(int id) {
        return songListMapper.findByUId(id);
    }

    @Transactional
    //通过歌单id查询歌单信息
    public SongList findById(int id) {
        //获取歌单基本信息
        SongList songList = songListMapper.findById(id);

        //获取歌单拥有者的信息
        User user = loginMapper.selectById(songList.getU_id());
        songList.setUser(user);

        //获取歌曲信息
        List<Song> songs = new ArrayList<Song>();  //用于存放歌单歌曲
        List<Integer> songsId = songListToSongMapper.findBySLId(songList.getSl_id());

        for (Integer s_id : songsId) {
            Song song = songService.findById(s_id);
            //通过歌曲id查询专辑信息
            Album album = albumMapper.findById(song.getAlbum_id());
            song.setAlbum(album);
            //通过歌曲id查询歌手信息
            Singer singer = singerMapper.findById(song.getSinger_id());
            song.setSinger(singer);
            //判断歌曲是不是我喜欢
            Integer res = likeSongsMapper.findByUIdAndSId(user.getU_id(), s_id);
            if (res != null){  //说明是我喜欢
                song.setIsLike(true);
            } else {
                song.setIsLike(false);
            }
            //判断歌曲是否被下载
            Integer res2 = downLoadMapper.isDownload(user.getU_id(), s_id);
            if (res2 != null ){
                song.setIsDownload(true);
            } else {
                song.setIsDownload(false);
            }
            //将歌曲放进集合
            songs.add(song);
        }

        songList.setSongList(songs);

        return songList;
    }

    @Transactional
    //新建歌单
    public Integer createList(SongList songList) {
        return songListMapper.saveList(songList);
    }

    @Transactional
    //修改歌单的播放次数
    public void updatePlayNum(SongList songList) {
        songListMapper.updatePlayNum(songList);
    }

    @Transactional
    //通过除id之外的所有字段查询歌单信息
    public SongList findByOthers(SongList songList) {
        return songListMapper.findByOthers(songList);
    }

    @Transactional
    //删除歌单
    public void deleteBySlId(int slId) {
        //删除歌单中的歌曲
        songListToSongMapper.deleteBySlId(slId);
        //删除歌单
        songListMapper.deleteById(slId);
    }

    @Transactional
    //删除歌单中的某一首歌曲
    public void deleteSong(int slId, int sid) {
        songListToSongMapper.deleteSong(slId, sid);
    }
}
