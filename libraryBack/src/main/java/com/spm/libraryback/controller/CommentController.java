package com.spm.libraryback.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.spm.libraryback.commom.Result;
import com.spm.libraryback.entity.Book;
import com.spm.libraryback.entity.Comment;
import com.spm.libraryback.mapper.CommentMapper;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/comment")
@CrossOrigin
public class CommentController {
    @Resource
    CommentMapper commentMapper;
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
    public Result<?> insertNew(@RequestBody Comment Comment){
        commentMapper.insert(Comment);
        return Result.success();
    }
    @PostMapping("/updateCom")
    @CrossOrigin
    public Result<?> update(@RequestBody Comment Comment){
        UpdateWrapper<Comment> updateWrapper = new UpdateWrapper<>();
        updateWrapper.eq("id",Comment.getId());
        commentMapper.update(Comment, updateWrapper);
        return Result.success();
    }
//删除一条记录
    @DeleteMapping("/deleteRecord/{id}")
    @CrossOrigin
    public  Result<?> deleteRecord(@PathVariable long id){
       commentMapper.deleteById(id);
        return Result.success();
    }

//根据书号查看评论
//    @PostMapping("/readCom")
//    public  Result<?> selectRecord(@RequestBody Book book){
//        CommentMapper.selectByBookId(book.getId());
//        return Result.success();
//    }

    @GetMapping("/selectByBookId")
    @CrossOrigin
    public Result<?> selectByBookId(@RequestParam long bookId) {
        QueryWrapper<Comment> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("bookid", bookId);
        return Result.success(commentMapper.selectList(queryWrapper));
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
