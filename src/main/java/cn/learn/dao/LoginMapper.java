package cn.learn.dao;

import cn.learn.pojo.User;

/**
 * 用户登录dao
 */
public interface LoginMapper {

    /**
     * 用于验证用户登录
     * @return
     */
    public User selectByNameAndPwd(User user);

    /**
     * 用户自动登录
     * @param u_id
     * @return
     */
    public User selectById(Integer u_id);
}
