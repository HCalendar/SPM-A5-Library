package com.spm.libraryback.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.spm.libraryback.entity.BookWithUser;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

import java.util.Date;


public interface BookWithUserMapper extends BaseMapper<BookWithUser> {
    @Update("update bookwithuser set deadtime=#{deadtime} where id=#{id}")
    void updateDeadtime(@Param("id") int id,@Param("deadtime") Date deadtime);
}
