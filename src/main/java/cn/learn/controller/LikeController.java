package cn.learn.controller;

import cn.learn.pojo.Song;
import cn.learn.pojo.User;
import cn.learn.service.LikeSongsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 * 用户喜欢的歌曲controller
 */

@Controller
@RequestMapping("/likeList")
public class LikeController {

    @Autowired
    private LikeSongsService likeSongsService;

    /**
     * 我喜欢歌曲的歌曲搜索
     *
     * @param keyword
     * @return
     */
    @GetMapping("/search/{keyword}")
    @ResponseBody
    public List<Song> searchSongs(@PathVariable(name = "keyword") String keyword, HttpSession session) {
        //获取用户id
        User user = (User) session.getAttribute("loginUser");
        List<Song> songs = new ArrayList<Song>();  //用户喜欢的歌曲列表
        List<Song> filterSongs = new ArrayList<Song>();  //搜索后的歌曲列表
        if (user != null) {
            //查询用户喜欢的歌曲列表
            songs = findLike(user.getU_id());
        }

        //在歌曲列表中查询可以与关键字匹配的音乐
        for (Song song : songs) {
            if (song.getS_name().indexOf(keyword) != -1 || song.getSinger().getSinger_name().indexOf(keyword) != -1) { //查询歌名和用户名
                filterSongs.add(song);
            }
        }
        return filterSongs;
    }

    /**
     * 将歌曲从我喜欢中移除
     *
     * @param uid
     * @param sid
     */
    @PostMapping("/remove")
    @ResponseBody
    public void removeLike(int uid, int sid) {
        likeSongsService.removeSong(uid, sid);
    }


    /**
     * 向我喜欢中添加多首歌曲
     *
     * @param sids
     * @param uid
     */
    @PostMapping("/addMul")
    @ResponseBody
    public void AddMultiple(@RequestParam("sid[]") int[] sids, int uid) {
        for (int sid : sids) {
            System.out.println(sid);
            //判断歌曲是否已经是我喜欢
            Integer res = likeSongsService.findByUIdAndSId(uid, sid);
            if (res == null) { //没有添加
                likeSongsService.addSong(uid, sid);
            }
        }
    }

    /**
     * 添加歌曲到我喜欢
     *
     * @param uid
     * @param sid
     */
    @PostMapping("/add")
    @ResponseBody
    public Integer addLike(int uid, int sid) {
        //判断歌曲是否已经是我喜欢了
        Integer res = likeSongsService.findByUIdAndSId(uid, sid);
        if (res != null) {  //已经添加过了
            return 0;
        }
        likeSongsService.addSong(uid, sid);
        return 1;
    }

    /**
     * 通过用户id和歌曲id判断歌曲是否为用户喜欢的音乐
     *
     * @param uid
     * @param sid
     * @return
     */
    @GetMapping("/getOne")
    @ResponseBody
    public Integer findByUIdAndSId(int uid, int sid) {
        return likeSongsService.findByUIdAndSId(uid, sid);
    }


    /**
     * 通过用户id查询用户喜欢的歌曲
     *
     * @param id
     * @return
     */
    @GetMapping("/like/{id}")
    @ResponseBody
    public List<Song> findLike(@PathVariable(name = "id") int id) {
        return likeSongsService.findLike(id);
    }
}
