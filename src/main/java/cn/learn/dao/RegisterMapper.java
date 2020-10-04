package cn.learn.dao;

import cn.learn.pojo.User;

/**
 * 用户信息注册及修改
 */
public interface RegisterMapper {
    //注册用户
    Integer addUser(User user);

    //修改用户信息（除头像信息之外）
    Integer updateUser(User user);

    //修改用户头像信息
    Integer updateHead(User user);
}
