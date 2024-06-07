package com.spm.libraryback.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonSubTypes;
import lombok.Data;

import java.time.LocalDateTime;
@TableName("comments")
@Data
public class Comment {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String content;
    private String createdtime;
    private String userid;
    private String username;
    private Long bookid;

    // getters and setters
}

//数据库comments表
//use library;
//CREATE TABLE comments (
   // id BIGINT AUTO_INCREMENT PRIMARY KEY,
   // bookid BIGINT NOT NULL,
   // userid BIGINT NOT NULL,
   // content TEXT NOT NULL,
   // createdTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   //FOREIGN KEY (bookid) REFERENCES book(id),
   //FOREIGN KEY (userid) REFERENCES user(id)
//);
