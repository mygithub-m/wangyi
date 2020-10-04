package cn.learn.dao;

import cn.learn.pojo.Song;
import cn.learn.pojo.SongList;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用户喜欢的歌曲
 */
public interface LikeSongsMapper {

    /**
     * 根据用户id查询用户喜欢的歌曲
     * @param id
     * @return
     */
    public List<Integer> findLike(int id);

    /**
     * 判断一首歌曲是不是用户喜欢的歌曲
     * @return
     */
    public Integer findByUIdAndSId(@Param("uid") int uid,@Param("sid") int sid);

    /**
     * 添加歌曲到我喜欢歌单
     * @param uid
     * @param sid
     */
    public void addLikeSong(@Param("uid") int uid,@Param("sid") int sid);

    /**
     * 将歌曲从我喜欢中移除
     * @param uid
     * @param sid
     */
    public void deleteSong(@Param("uid") int uid,@Param("sid") int sid);
}
