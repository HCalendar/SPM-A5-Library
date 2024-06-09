package com.spm.libraryback.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.spm.libraryback.entity.Feedback;
import com.spm.libraryback.entity.Like;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface LikeMapper extends BaseMapper<Like> {
    @Select("select * from `like` where userid=#{userid}")
    List<Like> selectByUserid(@Param("userid") Integer userid);
    @Delete("delete from `like` where userid=#{userid} and bookid=#{bookid}")
    void deleteBy2id(@Param("userid") Integer userid,@Param("bookid") Integer bookid);
    @Insert("insert into `like`(userid,bookid) values (#{userid},#{bookid})")
    void insert(@Param("userid") Integer userid,@Param("bookid") Integer bookid);
}
