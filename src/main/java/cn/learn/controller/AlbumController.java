package cn.learn.controller;

import cn.learn.pojo.Album;
import cn.learn.pojo.Singer;
import cn.learn.pojo.User;
import cn.learn.service.AlbumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 * 专辑controller
 */
@Controller
@RequestMapping("/album")
public class AlbumController {

    @Autowired
    private AlbumService albumService;

    /**
     * 用于头部搜索栏进行专辑搜索
     * @param keyword
     * @return
     */
    @GetMapping("/hSearch/{keyword}")
    @ResponseBody
    public List<Album> searchCollectAlbum(@PathVariable(name = "keyword") String keyword){
        //将关键字转变成可以进行模糊查询的形式
        char[] chars = keyword.toCharArray();
        keyword = "%";
        for (char aChar : chars) {
            keyword += (aChar + "%");
        }
        //调用service方法搜索
        List<Album> albums = albumService.searchAlbum(keyword);
        return albums;
    }

    /**
     * 用于关键字搜索用户收藏的专辑
     * @param keyword
     * @return
     */
    @GetMapping("/search/{keyword}")
    @ResponseBody
    public List<Album> searchCollectAlbum(@PathVariable(name = "keyword") String keyword, HttpSession session){
        //获取用户登录信息
        User user = (User) session.getAttribute("loginUser");
        //调用service方法，获取用户收藏的全部专辑信息
        List<Album> albums = new ArrayList<Album>();
        if (user != null ){
            List<Album> albums1 = albumService.findCollectAlbum(user.getU_id());
            //查找满足条件的专辑信息
            for (Album album : albums1) {
                if (album.getA_name().indexOf(keyword) != -1){
                    albums.add(album);
                }
            }
        }
        return albums;
    }

    /**
     * 获取用户收藏的全部专辑信息
     * @param uid
     * @return
     */
    @GetMapping("/getAll")
    @ResponseBody
    public List<Album> getCollectAlbum(int uid){
        List<Album> albums = albumService.findCollectAlbum(uid);
        return albums;
    }

    /**
     * 取消收藏专辑
     * @param uid
     * @param aid
     */
    @PostMapping("/deCollect")
    @ResponseBody
    public void deCollectAlbum(int uid,int aid){
        albumService.deCollectAlbum(uid, aid);
    }


    /**
     * 收藏专辑
     * @param uid
     * @param aid
     */
    @PostMapping("/collect")
    @ResponseBody
    public void collectAlbum(int uid,int aid){
        albumService.collectAlbum(uid, aid);
    }

    /**
     * 通过专辑id获取专辑的所有信息
     * @param aid
     * @return
     */
    @GetMapping("/details/{id}")
    @ResponseBody
    public Album getAlbum(@PathVariable(name = "id") int aid, HttpSession session){
        //获得用户的登录情况
        User user = (User) session.getAttribute("loginUser");
        //获取专辑详细信息
        Album album = albumService.getAlbumDetails(aid, user);
        return album;
    }
}
