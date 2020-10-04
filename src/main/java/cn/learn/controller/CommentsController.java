package cn.learn.controller;

import cn.learn.pojo.Comments;
import cn.learn.service.CommentsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;

/**
 * 评论 controller
 */
@Controller
@RequestMapping("/comments")
public class CommentsController {

    @Autowired
    private CommentsService commentsService;


    /**
     * 评论获赞数--
     * @param cid
     */
    @PostMapping("/decrease/{cid}")
    @ResponseBody
    public void decreaseSupport(@PathVariable(name = "cid")int cid){
        //先查询评论信息
        Comments comments = commentsService.findById(cid);
        //评论的获赞数--
        comments.setC_support(comments.getC_support()-1);
        //修改评论获赞数
        commentsService.updateSupport(comments);
    }


    /**
     * 评论获赞数++
     */
     @PostMapping("/increase/{cid}")
     @ResponseBody
     public void increaseSupport(@PathVariable(name = "cid") int cid){
         //先查询评论信息
         Comments comments = commentsService.findById(cid);
         //评论的获赞数++
         comments.setC_support(comments.getC_support()+1);
         //修改评论获赞数
         commentsService.updateSupport(comments);
     }

    /**
     * 添加评论
     *
     * @return
     */
    @PostMapping("/add")
    @ResponseBody
    public String addComments(Comments comments) {
        //评论时间
        Date date = new Date();

        comments.setC_date(date);
        comments.setC_support(0);

        //添加评论
        Integer res = commentsService.saveComments(comments);

        if (res == 1) {  //添加成功
            return "添加成功";
        }
        return null;
    }

    /**
     * 通过歌曲id查询歌曲评论信息
     *
     * @param id
     * @return
     */
    @GetMapping("/find/{id}")
    @ResponseBody
    public List<Comments> findSongComments(@PathVariable(name = "id") int id) {
        List<Comments> comments = commentsService.findSongComments(id);
        return comments;
    }
}
