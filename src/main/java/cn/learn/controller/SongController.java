package cn.learn.controller;

import cn.learn.pojo.Song;
import cn.learn.pojo.User;
import cn.learn.service.LikeSongsService;
import cn.learn.service.SongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 歌曲controller
 */
@Controller
@RequestMapping("/remoteSong")
public class SongController {

    @Autowired
    private SongService songService;


    /**
     * 通过头部搜索栏搜索歌曲
     * @param name
     * @return
     */
    @GetMapping("/search/{s_name}")
    @ResponseBody
    public List<Song> search(@PathVariable(name = "s_name") String name, HttpSession session){
        char[] chars = name.toCharArray();
        name = "%";
        for (char aChar : chars) {
            name += (aChar + "%");
        }
        //获取登录的用户信息,进行用户喜欢歌曲的查询
        User user = (User) session.getAttribute("loginUser");
        List<Song> songs = songService.searchSongs(name,user);

        return songs;
    }
}
