package cn.learn.dao;

import cn.learn.pojo.SongList;

import java.util.List;

/**
 * 歌单dao
 */
public interface SongListMapper {

    /**
     * 通过用户id查询所有的歌单
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
    public Integer saveList(SongList songList);

    /**
     * 改变歌单的播放次数
     * @param songList
     */
    public void updatePlayNum(SongList songList);

    /**
     * 通过除id之外的所有字段查询歌单信息
     * @param songList
     * @return
     */
    public SongList findByOthers(SongList songList);

    /**
     * 根据歌单id删除歌单
     * @param slId
     */
    public void deleteById(int slId);

}
