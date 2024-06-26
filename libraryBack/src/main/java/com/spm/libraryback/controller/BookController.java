package com.spm.libraryback.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.spm.libraryback.commom.Result;
import com.spm.libraryback.entity.Book;
import com.spm.libraryback.entity.BookWithUser;
import com.spm.libraryback.mapper.BookMapper;
import com.spm.libraryback.mapper.BookWithUserMapper;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

@RestController
@RequestMapping("/book")
@CrossOrigin
public class BookController {
    @Resource
    BookMapper BookMapper;
    @Resource
    BookWithUserMapper bookWithUserMapper;

    @PostMapping
    public Result<?> save(@RequestBody Book Book){
        BookMapper.insert(Book);
        return Result.success();
    }
    @PutMapping
    public  Result<?> update(@RequestBody Book Book){
        BookMapper.updateById(Book);
        return Result.success();
    }

    //    批量删除
    @PostMapping("/deleteBatch")
    public  Result<?> deleteBatch(@RequestBody List<Integer> ids){
        BookMapper.deleteBatchIds(ids);
        return Result.success();
    }
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id){
        BookMapper.deleteById(id);
        return Result.success();
    }
    @GetMapping
    public Result<?> findPage(@RequestParam(defaultValue = "1") Integer pageNum,
                              @RequestParam(defaultValue = "10") Integer pageSize,
                              @RequestParam(defaultValue = "") String search1,
                              @RequestParam(defaultValue = "") String search2,
                              @RequestParam(defaultValue = "") String search3){
        LambdaQueryWrapper<Book> wrappers = Wrappers.<Book>lambdaQuery();
        if(StringUtils.isNotBlank(search1)){
            wrappers.like(Book::getIsbn,search1);
        }
        if(StringUtils.isNotBlank(search2)){
            wrappers.like(Book::getName,search2);
        }
        if(StringUtils.isNotBlank(search3)){
            wrappers.like(Book::getAuthor,search3);
        }
        Page<Book> BookPage =BookMapper.selectPage(new Page<>(pageNum,pageSize), wrappers);
        return Result.success(BookPage);
    }
    @GetMapping("/All")
    public Result<?> getPage(@RequestParam(defaultValue = "1") Integer pageNum,
                              @RequestParam(defaultValue = "10") Integer pageSize,
                              @RequestParam(defaultValue = "") String search1
            ,
                              @RequestParam(defaultValue = "") String search2,
                              @RequestParam(defaultValue = "") String search3){
        LambdaQueryWrapper<Book> wrappers = Wrappers.<Book>lambdaQuery();
        if(StringUtils.isNotBlank(search1)){
            wrappers.like(Book::getIsbn,search1);
        }
        if(StringUtils.isNotBlank(search2)){
            wrappers.like(Book::getName,search2);
        }
        if(StringUtils.isNotBlank(search3)){
            wrappers.like(Book::getAuthor,search3);
        }
        Page<Book> BookPage =BookMapper.selectPage(new Page<>(pageNum,pageSize), wrappers);
        return Result.success(BookPage);
    }
    @GetMapping("/all")
    public Result<?> getAll(){
        return Result.success(BookMapper.selectAll());
    }
    @GetMapping("/searchById")
    public Result<?> getId(@RequestParam Integer id){
        return Result.success(BookMapper.selectById(id));
    }
}
