package cn.learn.controller;

import cn.learn.pojo.Song;
import cn.learn.pojo.SongList;
import cn.learn.service.SongListService;
import cn.learn.service.SongListToSongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 自定义歌单controller
 */
@Controller
@RequestMapping("/songList")
public class SongListController {

    @Autowired
    private SongListService songListService;

    @Autowired
    private SongListToSongService songListToSongService;

    /**
     * 删除歌单中的某一首歌曲
     * @param slId
     * @param sid
     */
    @PostMapping("/deleteSong")
    @ResponseBody
    public void deleteSong(int slId,int sid){
        songListService.deleteSong(slId, sid);
    }


    /**
     * 删除用户歌单
     * @param slId
     */
    @PostMapping("/delete/{slId}")
    @ResponseBody
    public void deleteSongList(@PathVariable(name = "slId") int slId){
        songListService.deleteBySlId(slId);
    }


    /**
     * 创建歌单并添加歌曲
     */
    @PostMapping("/createAndAdd")
    @ResponseBody
    public void createAndAdd(int uid,@RequestParam("sid[]") int[] sid,String listName){
        //将得到的参数封装为一个歌单对象
        SongList songList = new SongList();
        songList.setSl_name(listName);  //歌单名
        songList.setU_id(uid);  //用户id
        songList.setSl_date(new Date()); //创建时间
        songList.setSl_playnum(0);  //播放次数,默认为0
        //创建歌单
        Integer res = songListService.createList(songList);
        //通过除id之外的所有字段查询歌单信息，就是为了得到刚刚创建的歌单的id
        if (res == 1){  //说明创建成功
            SongList others = songListService.findByOthers(songList);
            //添加歌曲到歌单
            for (int id : sid) {
                songListToSongService.addSong(others.getSl_id(),id);
            }
        }
    }


    /**
     * 修改歌单的播放次数
     * @param sl_id
     */
    @PostMapping("/update/{slid}")
    @ResponseBody
    public void updatePlayNum(@PathVariable(name = "slid") int sl_id){
        //通过歌单id获取歌单信息
        SongList songList = songListService.findById(sl_id);
        //播放次数+1
        songList.setSl_playnum(songList.getSl_playnum()+1);
        songListService.updatePlayNum(songList);
    }

    /**
     * 自定义歌单的歌曲查询
     * @param keyword
     * @param sl_id
     * @return
     */
    @GetMapping("/search")
    @ResponseBody
    public List<Song> searchKeyword(String keyword,int sl_id){
        //查询当前歌单的所有信息
        SongList songList = songListService.findById(sl_id);
        //用来存储满足条件的歌曲
        List<Song> songs = new ArrayList<Song>();

        for (Song song : songList.getSongList()) {
            if (song.getS_name().indexOf(keyword) != -1 || song.getSinger().getSinger_name().indexOf(keyword) != -1){ //查询歌名和用户名
                songs.add(song);
            }
        }
        return songs;
    }


    /**
     * 向自定义歌单中添加多首歌曲
     * @param sids
     * @param sl_id
     */
    @PostMapping("/addMul")
    @ResponseBody
    public void addMultiple(@RequestParam("sid[]") int[] sids,int sl_id){
        //遍历获得每首歌曲的id
        for (int sid : sids) {
            //通过歌曲id和歌单id判断歌曲是否已经被收藏了
            Integer res = songListToSongService.findBySlidAndSid(sl_id, sid);
            if (res == null){  //说明没有被收藏，进行收藏
                songListToSongService.addSong(sl_id,sid);
            }
        }
    }

    /**
     * 用于向自定义歌单中添加歌曲
     * @param sl_id
     * @param s_id
     * @return
     */
    @PostMapping("/add")
    @ResponseBody
    public Integer saveSong(int sl_id,int s_id){
        //判断歌曲是否已经收藏在该歌单中了
        Integer res = songListToSongService.findBySlidAndSid(sl_id, s_id);
        if (res != null){
            return 0;  //不允许收藏
        }
        return songListToSongService.addSong(sl_id, s_id);
    }

    /**
     * 新建歌单
     * @param uid
     * @param listName
     * @return
     */
    @PostMapping("/create")
    @ResponseBody
    public Integer createSongList(int uid,String listName){
        //将信息封装为一个歌单对象
        SongList songList = new SongList();
        songList.setSl_name(listName);  //歌单名
        songList.setU_id(uid);  //用户id
        songList.setSl_date(new Date()); //创建时间
        songList.setSl_playnum(0);  //播放次数,默认为0
        Integer res = songListService.createList(songList);
        return res;
    }

    /**
     * 通过歌单id查询该歌单的所有信息
     * @param id
     * @return
     */
    @GetMapping("/get/{id}")
    @ResponseBody
    public SongList getSongList(@PathVariable(name = "id") int id){
        return songListService.findById(id);
    }



    /**
     * 通过用户id查询歌单
     * @param id
     * @return
     */
    @GetMapping("/all/{id}")
    @ResponseBody
    public List<SongList> findAll(@PathVariable(name = "id") int id){
        //获得歌单基本信息
        List<SongList> songLists = songListService.findByUId(id);
        //用来存储新的歌单信息
        List<SongList> result = new ArrayList<SongList>();

        for (SongList songList : songLists) {
            SongList newSongList = songListService.findById(songList.getSl_id());  //通过基本信息得到一个具有完整信息的歌单
            result.add(newSongList);
        }
        return result;
    }
}
