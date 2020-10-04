package cn.learn.dao;

import cn.learn.pojo.Comments;

import java.util.List;

/**
 * 评论dao
 */
public interface CommentsMapper {

    /**
     * 添加评论
     * @return
     */
    public Integer save(Comments comments);


    /**
     * 通过歌曲id获取歌曲评论
     * @param id
     * @return
     */
    public List<Comments> findBySingId(int id);


    /**
     * 更新评论获赞数
     * @param comments
     * @return
     */
    public Integer updateSupport(Comments comments);


    /**
     * 通过评论id获取评论信息
     * @param id
     * @return
     */
    public Comments findById(int id);


}
