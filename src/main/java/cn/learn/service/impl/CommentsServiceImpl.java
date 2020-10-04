package cn.learn.service.impl;

import cn.learn.dao.CommentsMapper;
import cn.learn.dao.LoginMapper;
import cn.learn.pojo.Comments;
import cn.learn.pojo.User;
import cn.learn.service.CommentsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CommentsServiceImpl implements CommentsService {

    @Autowired
    private CommentsMapper commentsMapper;

    @Autowired
    private LoginMapper loginMapper;

    @Transactional
    //添加评论
    public Integer saveComments(Comments comments) {
        return commentsMapper.save(comments);
    }

    @Transactional
    //查询歌曲的评论信息
    public List<Comments> findSongComments(int id) {
        List<Comments> comments = commentsMapper.findBySingId(id);

        for (Comments comment : comments) {
            User user = loginMapper.selectById(comment.getUser_id());
            comment.setUser(user);
        }

        return comments;
    }

    @Transactional
    //更新歌曲获赞数
    public Integer updateSupport(Comments comments) {
        return commentsMapper.updateSupport(comments);
    }

    @Transactional
    //通过id查询评论信息
    public Comments findById(int id) {
        return commentsMapper.findById(id);
    }
}
