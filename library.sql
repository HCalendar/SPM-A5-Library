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
                         PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book
-- ----------------------------
INSERT INTO `book` VALUES (16, '00001', 'A Dream of Red Mansions', 58.00, 'Cao Xueqin', 'Electronic Industry Press', '2020-01-01', '1', 6,'B401 five A-side,column3,tiers1-3');
INSERT INTO `book` VALUES (17, '00002', 'Journey to the West', 68.00, 'Wu Cheng''en', 'Beijing Institute of Technology Press', '2021-05-01', '0', 1,'B402 five B-side,column2,tiers1-6');
INSERT INTO `book` VALUES (18, '00003', 'Water Margin', 72.00, 'Shi Nai''an', 'Changjiang Literary and Art Publishing House', '2022-03-01', '0', 1,'B403 four B-side,column1,tiers2-4');
INSERT INTO `book` VALUES (19, '00004', 'The Great Gatsby', 19.99, 'F. Scott Fitzgerald', 'Scribner', '1925-01-01', '1', 1,'B404 two B-side,column2,tiers1-6');
INSERT INTO `book` VALUES (20, '00005', 'To Kill a Mockingbird', 14.95, 'Harper Lee', 'J.B. Lippincott & Co.', '1960-01-01', '1', 0,'B405 five B-side,column2,tiers1-6');
INSERT INTO `book` VALUES (21, '00006', 'Pride and Prejudice', 16.99, 'Jane Austen', 'Penguin Classics', '2020-07-01', '1', 0,'B406 four A-side,column3,tiers2-6');
INSERT INTO `book` VALUES (22, '00007', 'Animal Farm', 11.99, 'George Orwell', 'Secker & Warburg', '2017-06-07', '1', 0,'B407 one B-side,column2,tiers1-6');
INSERT INTO `book` VALUES (23, '00008', 'The Lord of the Rings', 29.99, 'J.R.R. Tolkien', 'Allen & Unwin', '2000-06-08', '1', 3,'B408 five A-side,column1,tiers3-5');
INSERT INTO `book` VALUES (24, '00009', 'One Hundred Years of Solitude', 24.95, 'Gabriel García Márquez', 'Editorial Monte Ávila', '2023-07-04', '1', 0,'B409 five B-side,column2,tiers1-6');
INSERT INTO `book` VALUES (25, '00010', 'The Catcher in the Rye', 17.95, 'J.D. Salinger', 'Little, Brown and Company', '2012-07-06', '1', 0,'B410 two B-side,column1,tiers5-6');
INSERT INTO `book` VALUES (26, '12345', 'spm', 23.00, 'aaa', 'aaa', '2024-04-10', '0', 1,'B411 five A-side,column1,tiers3-6');
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
                                 INDEX `id`(`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bookwithuser
-- ----------------------------
INSERT INTO `bookwithuser` VALUES (21, '00002', 'Journey to the West', 'bbb', '2024-04-21 18:48:07', '2024-05-21 18:48:07', 2);
INSERT INTO `bookwithuser` VALUES (22, '12345', 'spm', 'aaaa', '2024-04-23 14:43:27', '2024-05-23 14:43:27', 1);
INSERT INTO `bookwithuser` VALUES (20, '00003', 'Water Margin', 'aaa', '2024-04-22 22:26:34', '2024-04-22 22:27:34', 1);

-- ----------------------------
-- Table structure for lend_record
-- ----------------------------
DROP TABLE IF EXISTS `lend_record`;
CREATE TABLE `lend_record`  (
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
INSERT INTO `lend_record` VALUES (21, '00001', 'A Dream of Red Mansions', '2024-04-21 18:09:02', '2024-04-21 18:11:15', '1', 3);
INSERT INTO `lend_record` VALUES (21, '00002', 'Journey to the West', '2024-04-21 18:48:07', NULL, '0', 1);
INSERT INTO `lend_record` VALUES (20, '00001', 'A Dream of Red Mansions', '2024-04-22 22:18:46', '2024-04-22 22:18:49', '1', 4);
INSERT INTO `lend_record` VALUES (20, '00004', 'The Great Gatsby', '2024-04-22 22:21:37', '2024-04-22 22:26:28', '1', 1);
INSERT INTO `lend_record` VALUES (20, '00003', 'Water Margin', '2024-04-22 22:26:34', NULL, '0', 1);
INSERT INTO `lend_record` VALUES (22, '00001', 'A Dream of Red Mansions', '2024-04-23 14:39:31', '2024-04-23 14:41:01', '1', 5);
INSERT INTO `lend_record` VALUES (22, '12345', 'spm', '2024-04-23 14:43:27', NULL, '0', 1);

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
INSERT INTO `user` VALUES (19, 'hy', '12345', 'Han Yu', '18264109812', '女', 'Xidian', 1);
INSERT INTO `user` VALUES (20, 'aaa', 'aaaaa', 'Andy', '1234567890', '男', 'Beijing', 2);
INSERT INTO `user` VALUES (21, 'bbb', 'bbbbb', NULL, NULL, NULL, NULL, 2);

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

SET FOREIGN_KEY_CHECKS = 1;
