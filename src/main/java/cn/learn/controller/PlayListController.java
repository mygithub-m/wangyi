package cn.learn.controller;

import cn.learn.pojo.PlayList;
import cn.learn.pojo.Song;
import cn.learn.pojo.User;
import cn.learn.service.LikeSongsService;
import cn.learn.service.PlayListService;
import cn.learn.utils.PlayListUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 * 歌曲播放控制
 */
@Controller
@RequestMapping("/playList")
public class PlayListController {

    @Autowired
    private PlayListService playListService;

    @Autowired
    private PlayListUtils playListUtils;  //播放列表工具类

    private int index = 0;  //表示当前播放歌曲

    private List<Song> playList = new ArrayList<Song>();  //用于存放播放列表

    /**
     * 播放上一首歌曲
     */
    @GetMapping("/previous")
    @ResponseBody
    public void previousSong(Integer uid) {
        //判断用户是否登录
        if (uid == null) {  //未登录
            if (playList.size() != 0) {
                index--;
            }
        } else {  //已经登录
            //获取用户播放列表
            List<Song> songs = findSongs(uid);
            if (songs.size() != 0) {
                index--;
            }
        }

    }

    /**
     * 播放下一首歌曲
     */
    @GetMapping("/next")
    @ResponseBody
    public void nextSong(Integer uid) {
        //判断用户是否登录
        if (uid == null) {  //未登录
            if (playList.size() != 0) {
                index++;
            }
        } else {  //已经登录
            //获取用户播放列表
            List<Song> songs = findSongs(uid);
            if (songs.size() != 0) {
                index++;
            }
        }
    }

    /**
     * 查询当前应该播放的歌曲
     *
     * @return
     */
    @GetMapping("/current")
    @ResponseBody
    public Song findCurrentSong(Integer uid) {
        if (uid == null) {  //说明用户没有登录，那么不需要去查询用户的播放列表
            if (playList.size() == 0) {  //说明没有歌曲
                return null;
            } else {
                if (index >= playList.size()) {
                    index = 0;
                }
                if (index < 0) {
                    index = playList.size() - 1;
                }
                return playList.get(index);
            }
        } else {  //用户登录了，去数据库查询用户的播放列表信息
            List<Song> songs = findSongs(uid);
            if (songs.size() == 0) {  //说明没有歌曲
                return null;
            } else {
                if (index >= songs.size()) {
                    index = 0;
                }
                if (index < 0) {
                    index = songs.size() - 1;
                }
                return songs.get(index);
            }
        }
    }

    //用于添加一首歌曲
    @PostMapping("/addOne")
    @ResponseBody
    public String addSong(Integer sid, Integer uid) {
        //更具歌曲id获取歌曲的详细信息
        Song song = playListService.findBySid(sid, uid);

        if (uid == null) {  //如果用户id为空，则不将添加的歌曲保存在数据库
            //判断播放列表中是否存在该歌曲
            Integer res = playListUtils.isPlayList(playList, song);
            if (res != null) {  //说明歌曲存在在播放列表中
                index = res;  //播放这首歌曲
                return "开始播放";
            }
            //如果播放列表不存在该歌曲进行添加操作
            //判断歌曲是否是本地音乐
            song = playListUtils.isLocal(song);
            if (playList != null && playList.size() != 0) {
                index = index + 1;
            }
            playList.add(index, song); //将歌曲插入正在播放的歌曲后面
            System.out.println(playList);
        } else {
            //查询播放列表
            List<Song> songs = findSongs(uid);
            //判断播放列表中是否存在该歌曲
            Integer res = playListUtils.isPlayList(songs, song);
            if (res != null) {  //说明歌曲存在在播放列表中
                index = res;  //播放这首歌曲
                return "开始播放";
            }
            //如果播放列表中不存在，则进行添加工作
            //判断歌曲是不是本地音乐
            song = playListUtils.isLocal(song);
            //将该歌曲插入播放列表并开始播放
            if (songs != null && songs.size() != 0) {
                index = index + 1;
            }
            songs.add(index, song); //将歌曲插入正在播放的歌曲后面
            //将用户播放列表清空
            playListService.clear(uid);
            //将新的播放列表存进数据库
            for (Song song1 : songs) {
                playListService.addSong(song1.getS_id(), song1.getS_type(), uid);
            }
        }
        return "添加成功";
    }

    //用于添加多首歌曲,如果播放列表已经存在了则默认不添加
    @PostMapping("/add")
    @ResponseBody
    public String addSongs(@RequestParam("ids") int[] id,Integer uid) {
        //判断用户是否登录
        if (uid == null ){
            playList.clear();
            index = 0;
            //添加歌曲
            for (int i = 0; i < id.length; i++) {
                //获取歌曲信息
                Song song = playListService.findBySid(id[i], uid);
                //判断歌曲是不是本地音乐
                song = playListUtils.isLocal(song);
                //存进临时集合
                playList.add(song);
            }
        }else{
            //添加多个歌曲到播放列表前需要先清空播放列表，否则会出先添加失败情况
            playListService.clear(uid);
            //将当前播放的歌曲索引恢复为0
            index = 0;
            //添加歌曲
            for (int i = 0; i < id.length; i++) {
                //获取歌曲的详细信息
                Song song = playListService.findBySid(id[i],uid);
                //判断歌曲是不是本地歌曲
                song = playListUtils.isLocal(song);

                //将歌曲信息存进数据库
                playListService.addSong(song.getS_id(),song.getS_type(),uid);
            }
        }
        return "添加成功";
    }

    /**
     * 用于查询播放列表歌曲信息(详细信息)
     *
     * @return
     */
    @GetMapping("/findAll")
    @ResponseBody
    public List<Song> findSongs(Integer uid) {

        if (uid == null) {  //用户没有登录，返回一个空集合
            for (Song song : playList) {
                song = playListUtils.isLocal(song);
            }
            return playList;
        } else {  //去数据库查询用户播放列表信息
            //获取歌单歌曲列表
            List<Song> songs = playListService.findAll(uid);
            //去缓存中查找看该歌曲是不是本地的
            for (Song song : songs) {
                song = playListUtils.isLocal(song);
            }
            return songs;
        }
    }

    //清空播放列表
    @GetMapping("/clear")
    @ResponseBody
    public void clear(Integer uid) {
        if (uid == null) {
            playList.clear();
        } else {
            playListService.clear(uid);
        }
    }

    //用于将播放列表下标置零
    public void initIndex(){
        index = 0;
    }
}
