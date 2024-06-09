package com.spm.libraryback.entity;


import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonSubTypes;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@TableName("book")
@Data

public class Book {

    @TableId (type = IdType.AUTO)
    private Integer id;
    private String isbn;
    private String name;
    private BigDecimal price;
    private String author;
    private Integer borrownum;
    private String publisher;
    @JsonFormat(locale="zh",timezone="GMT+8", pattern="yyyy-MM-dd")
    private String createTime;
    private String status;
    private String location;
    private Integer likeNum;

}
