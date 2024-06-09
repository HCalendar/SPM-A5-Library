CREATE DATABASE library;
USE library;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for book
-- ----------------------------
DROP TABLE IF EXISTS `book`;
CREATE TABLE `book`  (
                         `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
                         `isbn` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图书编号',
                         `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
                         `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格',
                         `author` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '作者',
                         `publisher` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出版社',
                         `create_time` date NULL DEFAULT NULL COMMENT '出版时间',
                         `status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '0：未归还 1：已归还',
                         `borrownum` int(0) NOT NULL COMMENT '此书被借阅次数',
                         `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图书存放地点',
                         `like_num` int DEFAULT 0 COMMENT '此书被收藏次数',
                         PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book
-- ----------------------------
insert into book (id, isbn, name, price, author, publisher, create_time, status, borrownum, location, like_num)
values  (1, '9787115545138', 'Python数据可视化', 0.00, '黑马程序员编著', 'BEIJING BOOK CO. INC.', '2021-04-01', '0', 5, 'A333', 2),
        (2, '9787115545138', 'Python数据可视化', 0.00, '黑马程序员编著', 'BEIJING BOOK CO. INC.', '2021-04-01', '1', 2, 'A333', 1),
        (3, '9787115545222', '人像摄影师必会的99个技巧 王艺萌', 0.00, '王艺萌', '人民邮电出版社', '2020-11-01', '0', 4, 'A444', 2),
        (4, '9787115545444', '智能时代下的创新创业实践', 0.00, '黄彦辉著', 'BEIJING BOOK CO. INC.', '2020-10-01', '1', 0, 'A555', 0),
        (5, '9787115545555', '残疾人游泳指导教程', 0.00, '', '人民邮电出版社', '', '0', 2, 'A222', 0),
        (6, '9787115545138', 'Python', 0.00, '黑马程序员编著', 'BEIJING BOOK CO. INC.', '2021-04-02', '1', 0, 'A234', 0);
-- ----------------------------
-- Table structure for bookwithuser
-- ----------------------------
DROP TABLE IF EXISTS `bookwithuser`;
CREATE TABLE `bookwithuser`  (
                                 `id` bigint(0) NOT NULL COMMENT '读者id',
                                 `isbn` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图书编号',
                                 `book_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图书名',
                                 `nick_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '读者姓名',
                                 `lendtime` datetime(0) NULL DEFAULT NULL COMMENT '借阅时间',
                                 `deadtime` datetime(0) NULL DEFAULT NULL COMMENT '应归还时间',
                                 `prolong` int(0) NULL DEFAULT NULL COMMENT '续借次数',
                                 PRIMARY KEY (`book_name`) USING BTREE,
                                 INDEX `id`(`id`) USING BTREE,
                                 `bookid` int not null comment '图书id'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bookwithuser
-- ----------------------------
insert into bookwithuser (id, isbn, book_name, nick_name, lendtime, deadtime, prolong, bookid)
values  (3, '9787115545555', '残疾人游泳指导教程', 'bbb', '2024-06-09 10:16:16', '2024-09-07 10:16:16', 1, 5),
        (2, '9787115545138', 'Python数据可视化', 'aaa', '2024-05-01 10:20:24', '2024-06-10 10:24:56', 1, 1),
        (2, '9787115545222', '人像摄影师必会的99个技巧 王艺萌', 'aaa', '2024-06-09 10:33:31', '2024-07-09 10:33:31', 1, 3);
-- ----------------------------
-- Table structure for lend_record
-- ----------------------------
DROP TABLE IF EXISTS `lend_record`;
CREATE TABLE `lend_record`  (
                                `bookid` int not null comment '图书id',
                                `reader_id` bigint(0) NOT NULL COMMENT '读者id',
                                `isbn` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图书编号',
                                `bookname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图书名',
                                `lend_time` datetime(0) NULL DEFAULT NULL COMMENT '借书日期',
                                `return_time` datetime(0) NULL DEFAULT NULL COMMENT '还书日期',
                                `status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '0：未归还 1：已归还',
                                `borrownum` int(0) NOT NULL COMMENT '此书被借阅次数'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of lend_record
-- ----------------------------
insert into lend_record (reader_id, isbn, bookname, lend_time, return_time, status, borrownum, bookid)
values  (2, '9787115545138', 'Python数据可视化', '2024-06-08 23:33:33', '2024-06-10 10:14:36', '1', 2, 1),
        (2, '9787115545138', 'Python数据可视化', '2024-06-09 09:26:05', '2024-06-10 10:14:36', '1', 3, 1),
        (3, '9787115545222', '人像摄影师必会的99个技巧 王艺萌', '2024-06-09 10:04:32', '2024-06-09 10:33:20', '1', 1, 3),
        (3, '9787115545555', '残疾人游泳指导教程', '2024-06-09 10:05:42', '2024-06-09 10:12:57', '1', 1, 5),
        (3, '9787115545138', 'Python数据可视化', '2024-06-09 10:13:26', '2024-06-10 10:14:36', '1', 4, 1),
        (3, '9787115545138', 'Python数据可视化', '2024-06-09 10:13:27', '2024-06-09 10:15:05', '1', 2, 2),
        (3, '9787115545222', '人像摄影师必会的99个技巧 王艺萌', '2024-06-09 10:13:28', '2024-06-09 10:33:20', '1', 2, 3),
        (3, '9787115545555', '残疾人游泳指导教程', '2024-06-09 10:16:16', null, '0', 2, 5),
        (2, '9787115545138', 'Python数据可视化', '2024-06-09 10:20:24', null, '0', 5, 1),
        (2, '9787115545222', '人像摄影师必会的99个技巧 王艺萌', '2024-06-09 10:31:33', '2024-06-09 10:33:20', '1', 3, 3),
        (2, '9787115545222', '人像摄影师必会的99个技巧 王艺萌', '2024-06-09 10:33:31', null, '0', 4, 3);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
                         `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'ID',
                         `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
                         `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
                         `nick_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名',
                         `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话号码',
                         `sex` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别',
                         `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
                         `role` int(0) NOT NULL COMMENT '角色、1：管理员 2：普通用户',
                         PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
insert into library.user (id, username, password, nick_name, phone, sex, address, role)
values  (1, 'hy', '12345', 'Han Yu', '18264109812', '女', 'Xidian', 1),
        (2, 'aaa', 'aaaaa', 'AAA', '1234567890', 'Male', 'Xi''an', 2),
        (3, 'bbb', 'bbbbb', 'BBB', '1234567809', 'Female', 'BeiJing', 2),
        (4, 'ccc', 'ccccc', null, null, null, null, 1);

DROP TABLE IF EXISTS `comments`;
CREATE TABLE comments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    bookid BIGINT NOT NULL,
    userid BIGINT NOT NULL,
    username char(255) NOT NULL,
    content TEXT NOT NULL,
    createdTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS `feedback`;
CREATE TABLE feedback (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    userid BIGINT NOT NULL,
    content TEXT NOT NULL,
    adminname char(255) ,
    backcontent TEXT
);

DROP TABLE IF EXISTS `like`;
CREATE TABLE `like` (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    userid BIGINT NOT NULL,
    bookid BIGINT NOT NULL
);

DELIMITER //
CREATE TRIGGER after_like_delete
    AFTER DELETE ON `like`
    FOR EACH ROW
BEGIN
    UPDATE book SET like_num = like_num - 1 WHERE id = OLD.bookid;
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER after_like_insert
    AFTER INSERT ON `like`
    FOR EACH ROW
BEGIN
    UPDATE book SET like_num = like_num + 1 WHERE id = NEW.bookid;
END;
//
DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;
