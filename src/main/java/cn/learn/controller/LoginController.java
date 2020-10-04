package cn.learn.controller;

import cn.learn.dao.LoginMapper;
import cn.learn.pojo.User;
import cn.learn.service.LoginService;
import cn.learn.service.impl.LoginServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 * 控制用户登录
 */
@Controller
@RequestMapping("/login")
public class LoginController {

    @Autowired
    private LoginService loginService;

    @Autowired
    private PlayListController playListController;

    /**
     * 用于用户退出登录
     * @return
     */
    @GetMapping("exit")
    @ResponseBody
    public void exitLogin(HttpServletRequest request,HttpServletResponse response){
        //清除session中的用户信息
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loginUser");
        if(user != null){
            session.removeAttribute("loginUser");
        }
        //清除cookie中的用户信息
        Cookie[] cookies = request.getCookies();
        for (Cookie cookie : cookies) {
            if ("autoLogin".equals(cookie.getName())){
                cookie.setMaxAge(0);  //删除cookie信息
                response.addCookie(cookie);    //注：这步很重要，如果没有这一步删除cookie就不会成功
                break;
            }
        }
        //播放列表下标清零
        playListController.initIndex();
    }

    /**
     * 用于判断用户是否登录
     *
     * @return
     */
    @GetMapping("/isLogin")
    @ResponseBody
    public String isLogin(HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user != null) {
            //说明用户已经登录
            return "true";
        }
        return "false";
    }


    /**
     * 用户的自动登录功能
     *
     * @param request
     * @return
     */
    @GetMapping(value = "/auto")
    @ResponseBody
    public User checkAutoLogin(HttpServletRequest request, HttpSession session) {

        //从session域中获取用户登录信息
        User s_user = (User) session.getAttribute("loginUser");
        if (s_user != null){

            User user = loginService.userAutoLogin(s_user.getU_id());  //之所以要查询一次，是为了更新用户信息
            session.setAttribute("loginUser",user); //重新存进session域
            return user;
        }
        //从cookie中获取用户登录信息
        Cookie[] cookies = request.getCookies();
        for (Cookie cookie : cookies) {
            if ("autoLogin".equals(cookie.getName())) {  //如果在cookies中找到了用户信息
                String autoLogin = cookie.getValue();
                String[] s = autoLogin.split("_");

                User user = new User();  //封装为对象
                user.setU_nickname(s[0]);
                user.setU_password(s[1]);

                User userLogin = loginService.userLogin(user);  //查询
                if (userLogin != null) {
                    //存储用户登录信息
                    session.setAttribute("loginUser", userLogin);

                    return userLogin;
                } else {
                    return null;
                }
            }
        }
        return null;
    }

    /**
     * 用户登录功能
     *
     * @param nickname
     * @param pwd
     * @param auto
     * @param model
     * @param response
     * @return
     */
    @GetMapping("/user")
    @ResponseBody
    public User UserLogin(@RequestParam("nickname") String nickname,
                          @RequestParam("password") String pwd,
                          String auto,
                          Model model,
                          HttpServletResponse response,
                          HttpServletRequest request) {

        //播放列表下标清零
        playListController.initIndex();

        if (nickname != null && pwd != null) {  //进行验证
            User user = new User();  //封装为对象
            user.setU_nickname(nickname);
            user.setU_password(pwd);
            User userLogin = loginService.userLogin(user);

            if (userLogin != null) {  //说明验证通过

                //登录成功
                if (auto != null && auto != "") {  //判断用户是否勾选了自动登录，如果勾选了，将用户信息存进Cookie中并持久化
                    Cookie cookie = new Cookie("autoLogin", nickname + "_" + pwd);
                    cookie.setMaxAge(60 * 60 * 24);
                    response.addCookie(cookie);
                }
                //将已登录的用户信息存进session域中
                HttpSession session = request.getSession();
                session.setAttribute("loginUser", userLogin);

                return userLogin;
            } else {
                model.addAttribute("login_msg", "密码或用户名错误");
                return null;
            }
        } else {  //提示用户输入信息
            model.addAttribute("login_msg", "请输入信息");
            return null;
        }

    }
}
