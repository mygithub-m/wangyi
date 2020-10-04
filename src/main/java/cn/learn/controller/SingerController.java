package cn.learn.controller;

import cn.learn.pojo.Album;
import cn.learn.pojo.Singer;
import cn.learn.pojo.User;
import cn.learn.service.SingerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 * 歌手 controller
 */
@Controller
@RequestMapping("/singer")
public class SingerController {

    @Autowired
    private SingerService singerService;


    /**
     * 用于头部搜索栏进行歌手的搜索
     * @param keyword
     * @return
     */
    @GetMapping("/hSearch/{keyword}")
    @ResponseBody
    public List<Singer> searchRemoteSinger(@PathVariable(name = "keyword") String keyword){
        //将关键字转变成可以进行模糊查询的形式
        char[] chars = keyword.toCharArray();
        keyword = "%";
        for (char aChar : chars) {
            keyword += (aChar + "%");
        }
        //调用方法进行模糊查询
        List<Singer> singers = singerService.searchSinger(keyword);
        return singers;
    }

    /**
     * 用于关键字搜索用户收藏的歌手
     * @param keyword
     * @return
     */
    @GetMapping("/search/{keyword}")
    @ResponseBody
    public List<Singer> searchCollectSinger(@PathVariable(name = "keyword") String keyword,HttpSession session){
        //获取用户登录信息
        User user = (User) session.getAttribute("loginUser");
        //调用service方法，获取用户收藏的全部歌手信息
        List<Singer> singers = new ArrayList<Singer>();
        if (user != null ){
            List<Singer> singers1 = singerService.findCollectSinger(user.getU_id());
            //查找满足条件的歌手信息
            for (Singer singer : singers1) {
                if (singer.getSinger_name().indexOf(keyword) != -1){  //说明满足条件
                    singers.add(singer);
                }
            }
        }
        return singers;
    }

    /**
     * 获取用户收藏的全部歌手信息
     * @param uid
     * @return
     */
    @GetMapping("/getAll")
    @ResponseBody
    public List<Singer> getCollectAlbum(int uid){
        List<Singer> singer = singerService.findCollectSinger(uid);
        return singer;
    }

    /**
     * 取消收藏歌手
     * @param uid
     * @param sid
     */
    @PostMapping("/deCollect")
    @ResponseBody
    public void deCollectAlbum(int uid,int sid){
        singerService.deCollectSinger(uid, sid);
    }


    /**
     * 收藏歌手
     * @param uid
     * @param sid
     */
    @PostMapping("/collect")
    @ResponseBody
    public void collectAlbum(int uid,int sid){
        singerService.collectSinger(uid, sid);
    }


    /**
     * 通过歌手id获得歌手的详细信息
     * @return
     */
    @GetMapping("/details/{id}")
    @ResponseBody
    public Singer findSingerDetails(@PathVariable(name = "id") int singer_id, HttpSession session){
        //获得用户登录信息
        User user = (User) session.getAttribute("loginUser");
        //调用service方法进行查询
        Singer singer = singerService.findById(singer_id, user);
        return singer;
    }
}
