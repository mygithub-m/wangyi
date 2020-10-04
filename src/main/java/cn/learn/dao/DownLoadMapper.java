package cn.learn.dao;

import cn.learn.pojo.DownLoad;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用户下载mapper
 */
public interface DownLoadMapper {

    /**
     * 保存用户的下载
     * @param downLoad
     */
    public void saveSong(DownLoad downLoad);

    /**
     * 修改歌曲下载列表
     * @param downLoad
     */
    public void updateStatus(DownLoad downLoad);

    /**
     * 查询用户正在下载的歌曲信息
     * @param uid
     */
    public List<DownLoad> findUserLoading(int uid);

    /**
     * 查询用户下载完毕的歌曲信息
     * @param uid
     */
    public List<DownLoad> findUserLoaded(int uid);

    /**
     * 清空用户正在下载的音乐列表
     * @param uid
     */
    public void clearUser(int uid);


    /**
     * 检查一首歌曲是否是用户下载过的
     * @param uid
     * @param sid
     * @return
     */
    public Integer isDownload(@Param("uid") int uid, @Param("sid") int sid);
}
