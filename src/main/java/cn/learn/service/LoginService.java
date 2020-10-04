package cn.learn.service;

import cn.learn.pojo.User;
import org.springframework.stereotype.Service;

/**
 * 用户登录service
 */
public interface LoginService {

    /**
     * 用户登录验证
     * @param user
     * @return
     */
    public User userLogin(User user);

    /**
     * 用户自动登录
     * @param u_id
     * @return
     */
    public User userAutoLogin(Integer u_id);
}
