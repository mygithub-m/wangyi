package cn.learn.dao;

import cn.learn.pojo.Singer;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 歌手dao
 */
public interface SingerMapper {

    /**
     * 添加歌手
     * @param singer
     * @return
     */
    public Integer insertSinger(Singer singer);


    /**
     * 通过歌手名查询歌手
     * @param singerName
     * @return
     */
    public Singer selectBySingerName(String singerName);


    /**
     * 通过id查询歌手信息
     * @param id
     * @return
     */
    public Singer findById(int id);


    /**
     * 用户收藏歌手
     * @param uid
     * @param sid
     */
    public void collectSinger(@Param("uid")int uid, @Param("sid") int sid);


    /**
     * 移除收藏的歌手
     * @param uid
     * @param sid
     */
    public void deCollectSinger(@Param("uid")int uid,@Param("sid") int sid);

    /**
     * 查询用户收藏的歌手信息
     * @param uid
     * @return
     */
    public List<Integer> findCollectSinger(@Param("uid")int uid);

    /**
     * 判断一个歌手是否是用户收藏
     * @param uid
     * @param sid
     * @return
     */
    public Integer checkSinger(@Param("uid")int uid,@Param("sid") int sid);

    /**
     * 通过关键字搜索歌手
     * @param keyword
     * @return
     */
    public List<Singer> searchSinger(String keyword);
}
