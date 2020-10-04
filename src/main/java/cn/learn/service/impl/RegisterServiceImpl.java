package cn.learn.service.impl;

import cn.learn.dao.RegisterMapper;
import cn.learn.pojo.User;
import cn.learn.service.RegisterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RegisterServiceImpl implements RegisterService {

    @Autowired
    private RegisterMapper registerMapper;

    public Integer registerUser(User user) {
        Integer result = registerMapper.addUser(user);
        return result;
    }

    @Transactional
    //修改用户信息
    public Integer updateUser(User user) {
        return registerMapper.updateUser(user);
    }

    @Transactional
    //修改用户头像信息
    public Integer updateHead(User user) {
        return registerMapper.updateHead(user);
    }
}
