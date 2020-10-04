package cn.learn.controller;

import cn.learn.pojo.User;
import cn.learn.service.RegisterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.Date;

/**
 * 与用户信息相关的操作
 */
@Controller
@RequestMapping("/register")
public class RegisterController {

    @Autowired
    private RegisterService registerService;

    /**
     * 用户修改头像
     * @param file
     * @param session
     * @return
     */
    @PostMapping("/uploadImage")
    @ResponseBody
    public String uploadHead(@RequestParam("file") MultipartFile file,
                             HttpSession session){
        String uploadPath = "/usr/local/tomcat8/apache-tomcat-8.5.57/webapps/music_player_user_headImage/";  //文件上传位置
        User user = (User) session.getAttribute("loginUser");  //获取现在的用户信息
        String filename = uploadPath + user.getU_id() + ".png";   //拼接一个用户头像路径

        try {
            /*这个位置应该要考虑到文件夹不存在的情况，需要先判断文件路径是否存在，不存在需要先创建*/
            file.transferTo(new File(filename));   //存储用户头像信息

            //如果上传成功，则修改用户头像信息
            String httpPath = "http://116.62.224.97:8080/music_player_user_headImage/"+user.getU_id()+".png";   //头像网络地址
            user.setU_head_image(httpPath);
            Integer result = registerService.updateHead(user);  //修改头像信息
            if (result == 1){  //修改成功
                return httpPath;
            } else {
                return "";
            }
        } catch (IOException e) {
            e.printStackTrace();
            return "";
        }

    }


    /**
     * 修改用户信息
     * @param user
     * @param year
     * @param mouth
     * @param day
     * @param session
     * @return
     */
    @PostMapping(value = "/update",produces = "text/html;charset=utf-8")
    @ResponseBody
    public String updateUser(User user,Integer year,Integer mouth,Integer day ,HttpSession session){
        User loginUser = (User) session.getAttribute("loginUser");  //从session域中拿出已经登录了的用户信息

        Date date = new Date(year-1900,mouth-1,day);  //将年月日转化为日期类型  生日

        if (user != null){

            user.setU_id(loginUser.getU_id());
            user.setU_password(loginUser.getU_password());
            user.setU_birthday(date);

            Integer integer = registerService.updateUser(user);
            if (integer == 1){
                return "修改用户资料成功";
            } else {
                return "修改用户资料失败";
            }
        } else {
            return "修改用户资料失败";
        }

    }

    /**
     * 获取当前用户信息，并回显
     * @param session
     * @return
     */
    @GetMapping("/logined")
    @ResponseBody
    public User getLoginedUser(HttpSession session){
        User user = (User) session.getAttribute("loginUser");
        return user;
    }

    /**
     * 新用户的注册
     * @param nickname
     * @param password
     * @return
     */
    @PostMapping(value = "/user",produces = "text/html;charset=utf-8")
    @ResponseBody
    public String userRegister(String nickname,String password){

        Date rigster_date = new Date(); //注册时间

        if (nickname != null && password != null){
            User user = new User();
            user.setU_nickname(nickname);
            user.setU_password(password);
            user.setU_register_date(rigster_date);

            Integer result = registerService.registerUser(user);
            if (result == 1){
                return "注册成功,<a href='javaScript:;'>去登录</a>";
            } else {
                return "注册失败,请重试";
            }
        } else {
            return "输入内容不能为空";
        }

    }



}
