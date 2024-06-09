package com.spm.libraryback.controller;

import com.spm.libraryback.commom.Result;
import com.spm.libraryback.entity.Book;
import com.spm.libraryback.entity.Like;
import com.spm.libraryback.mapper.BookMapper;
import com.spm.libraryback.mapper.LikeMapper;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/like")
@CrossOrigin
public class LikeController {
    @Resource
    LikeMapper likeMapper;

    @GetMapping
    public List<Like> allLike(@RequestParam Integer userid){
        return likeMapper.selectByUserid(userid);
    }
    @PostMapping("/save")
    public Result<?> save(@RequestBody Like like){
        likeMapper.insert(like.getUserid(),like.getBookid());
        return Result.success();
    }
    @PostMapping("/delete")
    public Result<?> delete(@RequestBody Like like){
        likeMapper.deleteBy2id(like.getUserid(),like.getBookid());
        return Result.success();
    }
}
