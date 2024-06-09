package com.spm.libraryback.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.spm.libraryback.entity.BookWithUser;
import com.spm.libraryback.entity.Comment;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.web.bind.annotation.CrossOrigin;

@CrossOrigin
public interface CommentMapper extends BaseMapper<Comment> {
    @Update("update comments set username=#{username} where id=#{id}")
    void updateComment(@Param("username") String username,@Param("id") long id);
//    @Select("SELECT * FROM comments WHERE bookid = #{bookId}")
//    Comment selectByBookId(@Param("bookId") Integer bookId);
}
