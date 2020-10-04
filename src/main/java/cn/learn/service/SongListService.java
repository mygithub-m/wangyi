package cn.learn.service;

import cn.learn.pojo.SongList;

import java.util.List;

/**
 * 歌单service
 */
public interface SongListService {

    /**
     * 通过用户id查询用户喜欢歌单
     * @param id
     * @return
     */
    public List<SongList> findByUId(int id);

    /**
     * 通过歌单id查询歌单信息
     * @param id
     * @return
     */
    public SongList findById(int id);

    /**
     * 新建歌单
     * @param songList
     * @return
     */
    public Integer createList(SongList songList);

    /**
     * 修改歌单的播放次数
     * @param songList
     */
    public void updatePlayNum(SongList songList);


    /**
     * 通过除id之外的字段查询歌单信息
     * @return
     */
    public SongList findByOthers(SongList songList);


    /**
     * 删除歌单
     * @param slId
     */
    public void deleteBySlId(int slId);

    /**
     * 删除歌单中的一首歌曲
     * @param slId
     * @param sid
     */
    public void deleteSong(int slId,int sid);

}
