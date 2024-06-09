package com.spm.libraryback.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.spm.libraryback.entity.Book;
import org.apache.ibatis.annotations.Select;

import java.util.List;



public interface BookMapper extends BaseMapper<Book> {
    @Select("select * from book")
    List<Book> selectAll();
}
