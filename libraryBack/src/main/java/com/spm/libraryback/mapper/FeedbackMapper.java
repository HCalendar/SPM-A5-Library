package com.spm.libraryback.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.spm.libraryback.entity.Feedback;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface FeedbackMapper extends BaseMapper<Feedback> {
    @Select("select * from feedback")
    List<Feedback> getAllFeedback();
}
