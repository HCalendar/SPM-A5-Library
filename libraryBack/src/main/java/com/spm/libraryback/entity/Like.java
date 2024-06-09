package com.spm.libraryback.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@TableName("like")
@Data
public class Like {
    @TableId(type = IdType.AUTO)
    private Integer id;
    private Integer userid;
    private Integer bookid;
}
