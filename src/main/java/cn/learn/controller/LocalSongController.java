package cn.learn.controller;

import cn.learn.pojo.Song;
import cn.learn.service.LocalSongService;
import cn.learn.service.impl.LocalSongServiceImpl;
import cn.learn.utils.FileUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * 歌曲控制
 */
@Controller
@RequestMapping("/song")
public class LocalSongController {

    @Autowired
    private LocalSongService localSongService;


    /**
     * 通过关键字搜索本地音乐
     *
     * @return
     */
    @GetMapping("/search/{keyword}")
    @ResponseBody
    public List<Song> searchLocalSongs(@PathVariable(name = "keyword") String keyword) {
        List<Song> localSongs = getLocalSongs();
        List<Song> songs = new ArrayList<Song>();  //用来存储满足条件的歌曲列表

        for (Song song : localSongs) {
            if (song.getS_name().indexOf(keyword) != -1 || song.getSinger().getSinger_name().indexOf(keyword) != -1) {  //判断歌曲名和歌手名是否包含关键字，如果包含则加入集合
                songs.add(song);
            }
        }
        return songs;
    }


    /**
     * 通过id查询本地音乐文件数据
     *
     * @param id
     * @return
     */
    @GetMapping("/find/{id}")
    @ResponseBody
    public Song getLocalSongById(@PathVariable(name = "id") Integer id) {
        List<Song> localSongs = getLocalSongs();
        for (Song song : localSongs) {
            if (id == song.getS_id()) {  //找到了这首歌曲
                return song;
            }
        }
        return null;
    }

    /**
     * 获取本地音乐列表
     * 同时用作播放全部的音乐列表查询
     *
     * @return
     */
    @GetMapping("/local")
    @ResponseBody
    public List<Song> getLocalSongs() {
        //调用工具类获取本地音乐文件
        List<Song> songs = FileUtil.getLocalSongs();

        for (Song song : songs) {   //获取远程音乐id,并将其赋值给对应歌曲
            Song newSong = localSongService.selectByLocal(song);
            if (newSong != null) {
                song.setS_id(newSong.getS_id());
            }
        }
        System.out.println("我从文件中来");
        return songs;
    }
}
