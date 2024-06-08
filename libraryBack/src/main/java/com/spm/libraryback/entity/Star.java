package com.spm.libraryback.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@TableName("star")
@Data
public class Star {
    private Integer userId;
    private Integer bookId;
    private String isbn;
    private String title;
}
