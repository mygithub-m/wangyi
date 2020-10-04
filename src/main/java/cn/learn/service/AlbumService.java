package cn.learn.service;

import cn.learn.pojo.Album;
import cn.learn.pojo.User;

import java.util.List;

/**
 * 专辑service
 */
public interface AlbumService {

    /**
     * 通过专辑id获取专辑的详细信息
     * @param aid
     * @return
     */
    public Album getAlbumDetails(int aid, User user);

    /**
     * 用户收藏专辑
     * @param uid
     * @param aid
     */
    public void collectAlbum(int uid,int aid);

    /**
     * 移除收藏的专辑
     * @param uid
     * @param aid
     */
    public void deCollectAlbum(int uid,int aid);

    /**
     * 获取用户收藏的全部专辑信息
     * @param uid
     * @return
     */
    public List<Album> findCollectAlbum(int uid);

    /**
     * 通过关键字查询专辑
     * @param keyword
     * @return
     */
    public List<Album> searchAlbum(String keyword);
}
