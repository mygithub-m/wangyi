package cn.learn.service.impl;

import cn.learn.dao.LoginMapper;
import cn.learn.pojo.User;
import cn.learn.service.LoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LoginServiceImpl implements LoginService {

    @Autowired
    private LoginMapper loginMapper;

    @Transactional
    //用户登录
    public User userLogin(User user) {
        User user1 = loginMapper.selectByNameAndPwd(user);
        return user1;
    }

    @Transactional
    //用户自动登录
    public User userAutoLogin(Integer u_id) {
        return loginMapper.selectById(u_id);
    }
}
