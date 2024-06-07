package com.spm.libraryback.controller;

import com.spm.libraryback.entity.Student;
import com.spm.libraryback.mapper.BookWithUserMapper;
import com.spm.libraryback.mapper.StudentMapper;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/student")
@CrossOrigin
public class StudentController {
    @Resource
    StudentMapper studentMapper;

    @GetMapping("/search")
    public Student search(@RequestParam String id){
        return studentMapper.search(id);
    }
}
