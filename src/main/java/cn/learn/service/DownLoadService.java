package cn.learn.service;

import cn.learn.pojo.DownLoad;
import cn.learn.pojo.Song;

import java.util.List;

/**
 * 用户下载service
 */
public interface DownLoadService {

    /**
     * 用户添加歌曲到下载列表
     * @param downLoad
     */
    public void addSong(DownLoad downLoad);

    /**
     * 修改歌曲下载状态
     * @param downLoad
     */
    public void updateStatus(DownLoad downLoad);

    /**
     * 获取用户已经下载的歌曲列表
     * @param uid
     * @return
     */
    public List<DownLoad>  findLoaded(int uid);

    /**
     * 获取用户正在下载的歌曲列表
     * @param uid
     * @return
     */
    public List<DownLoad> findLoading(int uid);

    /**
     * 清空用户正在下载的音乐列表
     * @param uid
     */
    public void clearUser(int uid);

    /**
     * 判断一首歌曲是否已经成功下载了
     * @param uid
     * @param sid
     * @return
     */
    public Integer isDownload(int uid,int sid);
}
