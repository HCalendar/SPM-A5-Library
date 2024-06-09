package com.spm.libraryback.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.spm.libraryback.LoginUser;
import com.spm.libraryback.commom.Result;
import com.spm.libraryback.entity.Book;
import com.spm.libraryback.entity.LendRecord;
import com.spm.libraryback.entity.User;
import com.spm.libraryback.mapper.BookMapper;
import com.spm.libraryback.mapper.LendRecordMapper;
import com.spm.libraryback.mapper.UserMapper;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/dashboard")
@CrossOrigin
public class DashboardController {
    @Resource
    private UserMapper userMapper;
    @Resource
    private LendRecordMapper lendRecordMapper;
    @Resource
    private BookMapper bookMapper;
    @GetMapping
    public  Result<?> dashboardrecords(){
        int visitCount = LoginUser.getVisitCount();
        QueryWrapper<User> queryWrapper1=new QueryWrapper();
        int userCount = Math.toIntExact(userMapper.selectCount(queryWrapper1));
        QueryWrapper<LendRecord> queryWrapper2=new QueryWrapper();
        int lendRecordCount = Math.toIntExact(lendRecordMapper.selectCount(queryWrapper2));
        QueryWrapper<Book> queryWrapper3=new QueryWrapper();
        int bookCount = Math.toIntExact(bookMapper.selectCount(queryWrapper3));
        Map<String, Object> map = new HashMap<>();//键值对形式
        map.put("visitCount", visitCount);//放置visitCount到map中
        map.put("userCount", userCount);
        map.put("lendRecordCount", lendRecordCount);
        map.put("bookCount", bookCount);
        return Result.success(map);
    }



}
