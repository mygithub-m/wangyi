package cn.learn.service;

import cn.learn.pojo.Singer;
import cn.learn.pojo.User;

import java.util.List;

/**
 * 歌手 service
 */
public interface SingerService {

    /**
     * 通过歌手id获得歌手的详细信息
     * @param id
     * @return
     */
    public Singer findById(int id, User user);

    /**
     * 取消收藏歌手
     * @param uid
     * @param sid
     */
    public void deCollectSinger(int uid, int sid);

    /**
     * 收藏歌手
     * @param uid
     * @param sid
     */
    public void collectSinger(int uid, int sid);

    /**
     * 获取用户收藏的所有歌手信息
     * @param uid
     * @return
     */
    public List<Singer> findCollectSinger(int uid);

    /**
     * 通过关键字搜索歌手
     * @param keyword
     * @return
     */
    public List<Singer> searchSinger(String keyword);
}
