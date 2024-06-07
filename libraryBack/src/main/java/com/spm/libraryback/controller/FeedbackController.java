package com.spm.libraryback.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.spm.libraryback.commom.Result;
import com.spm.libraryback.entity.Book;
import com.spm.libraryback.entity.Comment;
import com.spm.libraryback.entity.Feedback;
import com.spm.libraryback.mapper.FeedbackMapper;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/feedback")
@CrossOrigin
public class FeedbackController {
    @Resource
    FeedbackMapper feedbackMapper;
//
//    @PostMapping
//    public Result<?> save(@RequestBody Book Book){
//        BookMapper.insert(Book);
//        return Result.success();
//    }

//    //    批量删除
//    @PostMapping("/deleteBatch")
//    public  Result<?> deleteBatch(@RequestBody List<Integer> ids){
//        BookMapper.deleteBatchIds(ids);
//        return Result.success();
//    }
//    @PutMapping
//    public  Result<?> update(@RequestBody Book Book){
//        BookMapper.updateById(Book);
//        return Result.success();
//    }
//    @DeleteMapping("/{id}")
//    public Result<?> delete(@PathVariable Long id){
//        BookMapper.deleteById(id);
//        return Result.success();
//    }

    @PostMapping("/insertNew")
    @CrossOrigin
    public Result<?> insertNew(@RequestBody Feedback feedback){
        feedbackMapper.insert(feedback);
        return Result.success();
    }
    @PostMapping("/updateCom")
    @CrossOrigin
    public Result<?> update(@RequestBody Feedback feedback){
        UpdateWrapper<Feedback> updateWrapper = new UpdateWrapper<>();
        updateWrapper.eq("id",feedback.getId());
        feedbackMapper.update(feedback, updateWrapper);
        return Result.success();
    }


//根据书号查看评论
//    @PostMapping("/readCom")
//    public  Result<?> selectRecord(@RequestBody Book book){
//        CommentMapper.selectByBookId(book.getId());
//        return Result.success();
//    }

    @GetMapping("/selectByUserId")
    @CrossOrigin
    public Result<?> selectByBookId(@RequestParam long userid) {
        if(userid!=0){
            QueryWrapper<Feedback> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("userid", userid);
            return Result.success(feedbackMapper.selectList(queryWrapper));
        }
        else{
            return Result.success(feedbackMapper.getAllFeedback());
        }
    }




//    @PostMapping("/deleteRecords")
//    public Result<?> deleteRecords(@RequestBody List<Comment> Comments){
//        int len = Comments.size();
//        for(int i=0;i<len;i++) {
//            Comment curRecord = Comments.get(i);
//            Map<String,Object> map = new HashMap<>();
//            map.put("isbn",curRecord.getIsbn());
//            map.put("id",curRecord.getId());
//            CommentMapper.deleteByMap(map);
//        }
//        return Result.success();
//    }
//    @GetMapping
//    public Result<?> findPage(@RequestParam(defaultValue = "1") Integer pageNum,
//                              @RequestParam(defaultValue = "10") Integer pageSize,
//                              @RequestParam(defaultValue = "") String search1,
//                              @RequestParam(defaultValue = "") String search2,
//                              @RequestParam(defaultValue = "") String search3){
//        LambdaQueryWrapper<Comment> wrappers = Wrappers.<Comment>lambdaQuery();
//        if(StringUtils.isNotBlank(search1)){
//            wrappers.like(Comment::getIsbn,search1);
//        }
//        if(StringUtils.isNotBlank(search2)){
//            wrappers.like(Comment::getBookName,search2);
//        }
//        if(StringUtils.isNotBlank(search3)){
//            wrappers.like(Comment::getId,search3);
//        }
//        Page<Comment> BookPage =CommentMapper.selectPage(new Page<>(pageNum,pageSize), wrappers);
//        return Result.success(BookPage);
//    }
}
