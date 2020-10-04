package cn.learn.service;

import cn.learn.pojo.Comments;

import java.util.List;

/**
 * 评论 service
 */
public interface CommentsService {

    /**
     * 保存评论
     *
     * @param comments
     * @return
     */
    public Integer saveComments(Comments comments);

    /**
     * 获取歌曲评论
     *
     * @param id
     * @return
     */
    public List<Comments> findSongComments(int id);


    /**
     * 更新歌曲获赞数
     *
     * @param comments
     * @return
     */
    public Integer updateSupport(Comments comments);

    /**
     * 通过id查询评论信息
     * @param id
     * @return
     */
    public Comments findById(int id);

}
