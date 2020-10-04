package cn.learn.service;

import cn.learn.pojo.User;

/**
 * 用户信息注册及修改
 */
public interface RegisterService {

    //用户注册
    Integer registerUser(User user);

    //修改用户信息（除头像信息之外）
    Integer updateUser(User user);

    //修改用户头像信息
    Integer updateHead(User user);
}
