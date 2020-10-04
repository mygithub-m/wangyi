package cn.learn.dao;

import cn.learn.pojo.Album;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 专辑dao
 */
public interface AlbumMapper {

    /**
     * 添加专辑
     * @param album
     * @return
     */
    public Integer insertAlbum(Album album);

    /**
     * 通过专辑名查询专辑信息
     * @param albumName
     * @return
     */
    public Album selectByName(String albumName);

    /**
     * 通过专辑id查询专辑信息
     * @param id
     * @return
     */
    public Album findById(int id);


    /**
     * 通过歌手id获得歌手的专辑集合
     * @param id
     * @return
     */
    public List<Album> findBySingerId(int id);

    /**
     * 用户收藏专辑
     * @param uid
     * @param aid
     */
    public void collectAlbum(@Param("uid")int uid, @Param("aid") int aid);


    /**
     * 移除收藏的专辑
     * @param uid
     * @param aid
     */
    public void deCollectAlbum(@Param("uid")int uid,@Param("aid") int aid);

    /**
     * 查询用户收藏的专辑信息
     * @param uid
     * @return
     */
    public List<Integer> findCollectAlbum(@Param("uid")int uid);

    /**
     * 判断一个专辑是否是用户收藏
     * @param uid
     * @param aid
     * @return
     */
    public Integer checkAlbum(@Param("uid")int uid,@Param("aid") int aid);

    /**
     * 通过关键字搜索专辑信息
     * @param keyword
     * @return
     */
    public List<Album> searchAlbum(String keyword);
}
