/*
 Navicat Premium Data Transfer

 Source Server         : Database
 Source Server Type    : MySQL
 Source Server Version : 50525
 Source Host           : localhost:3306
 Source Schema         : music_player

 Target Server Type    : MySQL
 Target Server Version : 50525
 File Encoding         : 65001

 Date: 02/10/2020 17:49:03
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for album
-- ----------------------------
DROP TABLE IF EXISTS `album`;
CREATE TABLE `album`  (
  `a_id` int(11) NOT NULL AUTO_INCREMENT,
  `a_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `a_image` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `s_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`a_id`) USING BTREE,
  INDEX `album_song`(`s_id`) USING BTREE,
  CONSTRAINT `album_song` FOREIGN KEY (`s_id`) REFERENCES `singer` (`singer_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of album
-- ----------------------------
INSERT INTO `album` VALUES (1, '南极光', 'http://localhost:8080/music_player_song_image/南极光.png', 12);
INSERT INTO `album` VALUES (2, '像梦一样自由', 'http://localhost:8080/music_player_song_image/像梦一样自由.png', 13);
INSERT INTO `album` VALUES (3, '怒放的生命', 'http://localhost:8080/music_player_song_image/怒放的生命.png', 13);
INSERT INTO `album` VALUES (4, '太歌', 'http://localhost:8080/music_player_song_image/太歌.png', 15);
INSERT INTO `album` VALUES (5, '还魂门', 'http://localhost:8080/music_player_song_image/还魂门.png', 15);
INSERT INTO `album` VALUES (6, 'Vae新歌+精选珍藏合辑', 'http://localhost:8080/music_player_song_image/Vae新歌+精选珍藏合辑.png', 17);
INSERT INTO `album` VALUES (8, '忘记我还是忘记他', 'http://localhost:8080/music_player_song_image/忘记我还是忘记他.png', 19);
INSERT INTO `album` VALUES (9, '打上花火 (初回限定盤)', 'http://localhost:8080/music_player_song_image/打上花火 (初回限定盤).png', 20);
INSERT INTO `album` VALUES (10, '爱你一万年 99演唱会', 'http://localhost:8080/music_player_song_image/爱你一万年 99演唱会.png', 21);
INSERT INTO `album` VALUES (11, '安河桥（正经版本）-包师语Cover宋冬野', 'http://localhost:8080/music_player_song_image/安河桥（正经版本）-包师语Cover宋冬野.png', 22);
INSERT INTO `album` VALUES (12, '那女孩对我说', 'http://localhost:8080/music_player_song_image/那女孩对我说.png', 23);
INSERT INTO `album` VALUES (21, '深秋', 'http://localhost:8080/music_player_song_image/深秋.png', 32);
INSERT INTO `album` VALUES (27, '家风', 'http://localhost:8080/music_player_song_image/家风.png', 45);

-- ----------------------------
-- Table structure for albumcollect
-- ----------------------------
DROP TABLE IF EXISTS `albumcollect`;
CREATE TABLE `albumcollect`  (
  `cola_id` int(11) NOT NULL AUTO_INCREMENT,
  `a_id` int(11) NOT NULL,
  `u_id` int(11) NOT NULL,
  PRIMARY KEY (`cola_id`) USING BTREE,
  INDEX `cola_a`(`a_id`) USING BTREE,
  INDEX `cola_u`(`u_id`) USING BTREE,
  CONSTRAINT `cola_a` FOREIGN KEY (`a_id`) REFERENCES `album` (`a_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `cola_u` FOREIGN KEY (`u_id`) REFERENCES `user` (`u_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of albumcollect
-- ----------------------------
INSERT INTO `albumcollect` VALUES (4, 27, 1);
INSERT INTO `albumcollect` VALUES (5, 3, 3);
INSERT INTO `albumcollect` VALUES (6, 1, 4);
INSERT INTO `albumcollect` VALUES (7, 6, 4);
INSERT INTO `albumcollect` VALUES (8, 8, 2);

-- ----------------------------
-- Table structure for comments
-- ----------------------------
DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments`  (
  `c_id` int(20) NOT NULL AUTO_INCREMENT,
  `song_id` int(20) NOT NULL,
  `user_id` int(16) NOT NULL,
  `c_date` datetime NOT NULL,
  `c_content` varchar(160) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `c_support` int(20) NOT NULL,
  PRIMARY KEY (`c_id`) USING BTREE,
  INDEX `c_song`(`song_id`) USING BTREE,
  INDEX `c_user`(`user_id`) USING BTREE,
  CONSTRAINT `c_song` FOREIGN KEY (`song_id`) REFERENCES `song` (`s_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `c_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`u_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of comments
-- ----------------------------
INSERT INTO `comments` VALUES (1, 10, 1, '2020-09-13 11:02:14', '哈哈哈，我是一楼', 3);
INSERT INTO `comments` VALUES (2, 10, 1, '2020-09-13 11:03:18', '我是二楼', 2);
INSERT INTO `comments` VALUES (3, 10, 3, '2020-09-13 11:13:00', '我是三楼', 4);
INSERT INTO `comments` VALUES (4, 10, 2, '2020-09-13 11:14:04', '我是四楼', 4);
INSERT INTO `comments` VALUES (5, 11, 1, '2020-09-13 15:37:30', '世界第一等，虽然听不懂，但就是觉得好听', 0);
INSERT INTO `comments` VALUES (6, 22, 4, '2020-09-13 15:52:22', '一首歌，一个故事，一份伤感', 2);
INSERT INTO `comments` VALUES (7, 12, 4, '2020-09-13 18:54:12', '一楼', 1);
INSERT INTO `comments` VALUES (8, 12, 1, '2020-09-13 18:55:56', '二楼', 0);
INSERT INTO `comments` VALUES (9, 7, 1, '2020-09-14 21:51:01', '文艺气息十足', 4);
INSERT INTO `comments` VALUES (10, 7, 4, '2020-09-15 09:45:34', '许嵩牛逼', 1);
INSERT INTO `comments` VALUES (11, 13, 1, '2020-09-17 21:41:43', '这是真的牛逼', 0);
INSERT INTO `comments` VALUES (12, 9, 4, '2020-09-19 14:42:44', '三万英里', 3);
INSERT INTO `comments` VALUES (13, 4, 4, '2020-09-19 16:37:28', '6666', 0);
INSERT INTO `comments` VALUES (14, 4, 4, '2020-09-19 16:39:19', '我也不知道发什么了', 0);
INSERT INTO `comments` VALUES (15, 2, 4, '2020-09-19 16:42:31', '好听', 6);
INSERT INTO `comments` VALUES (16, 10, 4, '2020-09-19 18:37:46', '狼来了', 1);
INSERT INTO `comments` VALUES (17, 2, 1, '2020-09-19 19:53:42', '占楼', 1);
INSERT INTO `comments` VALUES (18, 8, 4, '2020-09-21 17:50:24', '111111', 1);
INSERT INTO `comments` VALUES (19, 28, 3, '2020-09-24 21:36:24', '家的味道', 1);
INSERT INTO `comments` VALUES (20, 10, 1, '2020-09-27 11:26:21', '66666', 0);
INSERT INTO `comments` VALUES (21, 9, 2, '2020-09-29 20:05:39', '我也来占一个楼', 1);

-- ----------------------------
-- Table structure for mydownload
-- ----------------------------
DROP TABLE IF EXISTS `mydownload`;
CREATE TABLE `mydownload`  (
  `m_id` int(11) NOT NULL AUTO_INCREMENT,
  `s_id` int(11) NOT NULL,
  `u_id` int(11) NOT NULL,
  `m_date` datetime NOT NULL,
  `status` bigint(255) NOT NULL,
  PRIMARY KEY (`m_id`) USING BTREE,
  INDEX `m_s`(`s_id`) USING BTREE,
  INDEX `m_u`(`u_id`) USING BTREE,
  CONSTRAINT `m_s` FOREIGN KEY (`s_id`) REFERENCES `song` (`s_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `m_u` FOREIGN KEY (`u_id`) REFERENCES `user` (`u_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 68 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of mydownload
-- ----------------------------
INSERT INTO `mydownload` VALUES (23, 4, 4, '2020-09-26 16:35:07', 100);
INSERT INTO `mydownload` VALUES (38, 7, 4, '2020-09-26 17:24:57', 100);
INSERT INTO `mydownload` VALUES (39, 9, 4, '2020-09-26 17:25:52', 100);
INSERT INTO `mydownload` VALUES (40, 22, 1, '2020-09-26 17:41:41', 100);
INSERT INTO `mydownload` VALUES (57, 7, 1, '2020-09-26 21:47:40', 100);
INSERT INTO `mydownload` VALUES (58, 28, 1, '2020-09-26 21:49:03', 100);
INSERT INTO `mydownload` VALUES (60, 2, 1, '2020-09-27 10:05:29', 100);
INSERT INTO `mydownload` VALUES (61, 10, 1, '2020-09-27 10:22:32', 100);
INSERT INTO `mydownload` VALUES (62, 7, 2, '2020-09-29 17:08:59', 100);
INSERT INTO `mydownload` VALUES (63, 8, 2, '2020-09-29 17:43:05', 100);
INSERT INTO `mydownload` VALUES (64, 9, 2, '2020-09-29 21:02:13', 100);

-- ----------------------------
-- Table structure for mylike
-- ----------------------------
DROP TABLE IF EXISTS `mylike`;
CREATE TABLE `mylike`  (
  `like_id` int(11) NOT NULL AUTO_INCREMENT,
  `s_id` int(11) NOT NULL,
  `u_id` int(11) NOT NULL,
  PRIMARY KEY (`like_id`) USING BTREE,
  INDEX `like_s`(`s_id`) USING BTREE,
  INDEX `like_u`(`u_id`) USING BTREE,
  CONSTRAINT `like_s` FOREIGN KEY (`s_id`) REFERENCES `song` (`s_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `like_u` FOREIGN KEY (`u_id`) REFERENCES `user` (`u_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 90 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of mylike
-- ----------------------------
INSERT INTO `mylike` VALUES (4, 5, 3);
INSERT INTO `mylike` VALUES (41, 4, 4);
INSERT INTO `mylike` VALUES (52, 6, 4);
INSERT INTO `mylike` VALUES (58, 9, 4);
INSERT INTO `mylike` VALUES (59, 2, 4);
INSERT INTO `mylike` VALUES (72, 28, 3);
INSERT INTO `mylike` VALUES (75, 13, 3);
INSERT INTO `mylike` VALUES (76, 4, 3);
INSERT INTO `mylike` VALUES (78, 7, 4);
INSERT INTO `mylike` VALUES (83, 22, 1);
INSERT INTO `mylike` VALUES (85, 28, 1);
INSERT INTO `mylike` VALUES (86, 11, 1);
INSERT INTO `mylike` VALUES (87, 8, 1);
INSERT INTO `mylike` VALUES (88, 9, 2);
INSERT INTO `mylike` VALUES (89, 28, 2);

-- ----------------------------
-- Table structure for playlist
-- ----------------------------
DROP TABLE IF EXISTS `playlist`;
CREATE TABLE `playlist`  (
  `p_id` int(11) NOT NULL AUTO_INCREMENT,
  `s_id` int(11) NULL DEFAULT NULL,
  `s_type` int(5) NOT NULL,
  `u_id` int(11) NOT NULL,
  PRIMARY KEY (`p_id`) USING BTREE,
  INDEX `uid`(`u_id`) USING BTREE,
  INDEX `s_id`(`s_id`) USING BTREE,
  CONSTRAINT `sid` FOREIGN KEY (`s_id`) REFERENCES `song` (`s_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `uid` FOREIGN KEY (`u_id`) REFERENCES `user` (`u_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 164 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of playlist
-- ----------------------------
INSERT INTO `playlist` VALUES (89, 28, 1, 3);
INSERT INTO `playlist` VALUES (90, 10, 0, 3);
INSERT INTO `playlist` VALUES (137, 28, 1, 2);
INSERT INTO `playlist` VALUES (138, 2, 1, 2);
INSERT INTO `playlist` VALUES (157, 28, 1, 4);
INSERT INTO `playlist` VALUES (158, 9, 0, 4);
INSERT INTO `playlist` VALUES (159, 4, 1, 4);
INSERT INTO `playlist` VALUES (160, 7, 0, 4);
INSERT INTO `playlist` VALUES (161, 9, 0, 1);
INSERT INTO `playlist` VALUES (162, 8, 0, 1);
INSERT INTO `playlist` VALUES (163, 7, 0, 1);

-- ----------------------------
-- Table structure for singer
-- ----------------------------
DROP TABLE IF EXISTS `singer`;
CREATE TABLE `singer`  (
  `singer_id` int(11) NOT NULL AUTO_INCREMENT,
  `singer_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `singer_image` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`singer_id`) USING BTREE,
  UNIQUE INDEX `singer_name`(`singer_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of singer
-- ----------------------------
INSERT INTO `singer` VALUES (12, '孙楠', 'http://localhost:8080/music_player_singer_image/shunlan.png');
INSERT INTO `singer` VALUES (13, '汪峰', 'http://localhost:8080/music_player_singer_image/wangfeng.png');
INSERT INTO `singer` VALUES (15, '胡彦斌', 'http://localhost:8080/music_player_singer_image/huyan.png');
INSERT INTO `singer` VALUES (17, '许嵩', 'http://localhost:8080/music_player_singer_image/xusong.png');
INSERT INTO `singer` VALUES (19, '迪克牛仔', 'http://localhost:8080/music_player_singer_image/dike.png');
INSERT INTO `singer` VALUES (20, 'DAOKO (ダヲコ)', 'http://localhost:8080/music_player_singer_image/daoko.png');
INSERT INTO `singer` VALUES (21, '刘德华', 'http://localhost:8080/music_player_singer_image/liudehua.png');
INSERT INTO `singer` VALUES (22, '包包.suyi', 'http://localhost:8080/music_player_singer_image/baobao.png');
INSERT INTO `singer` VALUES (23, '周黑猫', 'http://localhost:8080/music_player_singer_image/heimao.png');
INSERT INTO `singer` VALUES (32, '马昊也', 'http://localhost:8080/music_player_singer_image/hao.png');
INSERT INTO `singer` VALUES (45, '庞龙', 'http://localhost:8080/music_player_singer_image/panglong.png');

-- ----------------------------
-- Table structure for singercollect
-- ----------------------------
DROP TABLE IF EXISTS `singercollect`;
CREATE TABLE `singercollect`  (
  `cols_id` int(11) NOT NULL AUTO_INCREMENT,
  `singer_id` int(11) NOT NULL,
  `u_id` int(11) NOT NULL,
  PRIMARY KEY (`cols_id`) USING BTREE,
  INDEX `cols_u`(`u_id`) USING BTREE,
  INDEX `cols_s`(`singer_id`) USING BTREE,
  CONSTRAINT `cols_s` FOREIGN KEY (`singer_id`) REFERENCES `singer` (`singer_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `cols_u` FOREIGN KEY (`u_id`) REFERENCES `user` (`u_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of singercollect
-- ----------------------------
INSERT INTO `singercollect` VALUES (4, 45, 3);
INSERT INTO `singercollect` VALUES (5, 12, 4);
INSERT INTO `singercollect` VALUES (6, 17, 4);
INSERT INTO `singercollect` VALUES (7, 19, 4);
INSERT INTO `singercollect` VALUES (8, 32, 1);
INSERT INTO `singercollect` VALUES (9, 20, 3);
INSERT INTO `singercollect` VALUES (10, 19, 2);

-- ----------------------------
-- Table structure for song
-- ----------------------------
DROP TABLE IF EXISTS `song`;
CREATE TABLE `song`  (
  `s_id` int(20) NOT NULL AUTO_INCREMENT,
  `s_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `album_id` int(11) NOT NULL,
  `singer_id` int(11) NOT NULL,
  `s_length` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `s_size` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `s_path` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`s_id`) USING BTREE,
  INDEX `song_album`(`album_id`) USING BTREE,
  INDEX `song_singer`(`singer_id`) USING BTREE,
  CONSTRAINT `song_album` FOREIGN KEY (`album_id`) REFERENCES `album` (`a_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `song_singer` FOREIGN KEY (`singer_id`) REFERENCES `singer` (`singer_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of song
-- ----------------------------
INSERT INTO `song` VALUES (2, '风往北吹', 1, 12, '04:52', '4.5', 'http://localhost:8080/music_player_remote_song/孙楠 - 风往北吹.mp3');
INSERT INTO `song` VALUES (3, '像梦一样自由', 2, 13, '04:00', '3.7', 'http://localhost:8080/music_player_remote_song/汪峰 - 像梦一样自由.mp3');
INSERT INTO `song` VALUES (4, '我爱你中国', 3, 13, '06:15', '5.8', 'http://localhost:8080/music_player_remote_song/汪峰 - 我爱你中国.mp3');
INSERT INTO `song` VALUES (5, '为你我受冷风吹', 4, 15, '04:39', '4.3', 'http://localhost:8080/music_player_remote_song/胡彦斌 - 为你我受冷风吹.mp3');
INSERT INTO `song` VALUES (6, '还魂门', 5, 15, '04:16', '4.0', 'http://localhost:8080/music_player_remote_song/胡彦斌 - 还魂门.mp3');
INSERT INTO `song` VALUES (7, '断桥残雪', 6, 17, '03:47', '3.5', 'http://localhost:8080/music_player_remote_song/许嵩 - 断桥残雪.mp3');
INSERT INTO `song` VALUES (8, '玫瑰花的葬礼', 6, 17, '04:19', '4.0', 'http://localhost:8080/music_player_remote_song/许嵩 - 玫瑰花的葬礼.mp3');
INSERT INTO `song` VALUES (9, '三万英尺', 8, 19, '04:43', '4.4', 'http://localhost:8080/music_player_remote_song/迪克牛仔 - 三万英尺.mp3');
INSERT INTO `song` VALUES (10, '打上花火', 9, 20, '04:49', '4.5', 'http://localhost:8080/music_player_remote_song/DAOKO (ダヲコ) _ 米津玄師 (よねづ けんし) - 打上花火.mp3');
INSERT INTO `song` VALUES (11, '世界第一等(Live)', 10, 21, '04:21', '10.2', 'http://localhost:8080/music_player_remote_song/刘德华 - 世界第一等(Live).mp3');
INSERT INTO `song` VALUES (12, '安河桥（正经版本）-包师语Cover宋冬野', 11, 22, '03:57', '9.2', 'http://localhost:8080/music_player_remote_song/包包.suyi - 安河桥（正经版本）-包师语Cover宋冬野.mp3');
INSERT INTO `song` VALUES (13, '那女孩对我说', 12, 23, '03:18', '3.0', 'http://localhost:8080/music_player_remote_song/周黑猫 - 那女孩对我说.mp3');
INSERT INTO `song` VALUES (22, '深秋', 21, 32, '03:40', '3.4', 'http://localhost:8080/music_player_remote_song/马昊也 - 深秋.mp3');
INSERT INTO `song` VALUES (28, '家风', 27, 45, '03:43', '8.9', 'http://localhost:8080/music_player_remote_song/庞龙 - 家风.mp3');

-- ----------------------------
-- Table structure for songlist
-- ----------------------------
DROP TABLE IF EXISTS `songlist`;
CREATE TABLE `songlist`  (
  `sl_id` int(11) NOT NULL AUTO_INCREMENT,
  `sl_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `u_id` int(11) NOT NULL,
  `sl_date` datetime NOT NULL,
  `sl_introduce` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sl_tag` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sl_playnum` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`sl_id`) USING BTREE,
  INDEX `sl_u`(`u_id`) USING BTREE,
  CONSTRAINT `sl_u` FOREIGN KEY (`u_id`) REFERENCES `user` (`u_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of songlist
-- ----------------------------
INSERT INTO `songlist` VALUES (5, '歌声中有故事', 4, '2020-09-18 20:08:16', NULL, NULL, 4);
INSERT INTO `songlist` VALUES (6, '歌单一', 4, '2020-09-18 20:15:24', NULL, NULL, 2);
INSERT INTO `songlist` VALUES (9, '你的眼', 3, '2020-09-24 17:05:21', NULL, NULL, 0);
INSERT INTO `songlist` VALUES (10, '会痛的石头', 3, '2020-09-24 17:35:54', NULL, NULL, 0);
INSERT INTO `songlist` VALUES (11, '你的泪', 3, '2020-09-24 17:41:07', NULL, NULL, 0);
INSERT INTO `songlist` VALUES (13, '你的眼', 1, '2020-09-28 17:03:09', NULL, NULL, 0);
INSERT INTO `songlist` VALUES (15, '回忆', 2, '2020-09-29 21:03:34', NULL, NULL, 1);

-- ----------------------------
-- Table structure for songlisttosong
-- ----------------------------
DROP TABLE IF EXISTS `songlisttosong`;
CREATE TABLE `songlisttosong`  (
  `sls_id` int(11) NOT NULL AUTO_INCREMENT,
  `sl_id` int(11) NOT NULL,
  `s_id` int(11) NOT NULL,
  PRIMARY KEY (`sls_id`) USING BTREE,
  INDEX `sls_sl`(`sl_id`) USING BTREE,
  INDEX `sls_s`(`s_id`) USING BTREE,
  CONSTRAINT `sls_s` FOREIGN KEY (`s_id`) REFERENCES `song` (`s_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `sls_sl` FOREIGN KEY (`sl_id`) REFERENCES `songlist` (`sl_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of songlisttosong
-- ----------------------------
INSERT INTO `songlisttosong` VALUES (5, 6, 2);
INSERT INTO `songlisttosong` VALUES (8, 6, 5);
INSERT INTO `songlisttosong` VALUES (9, 6, 9);
INSERT INTO `songlisttosong` VALUES (12, 5, 7);
INSERT INTO `songlisttosong` VALUES (13, 5, 8);
INSERT INTO `songlisttosong` VALUES (14, 5, 4);
INSERT INTO `songlisttosong` VALUES (15, 6, 7);
INSERT INTO `songlisttosong` VALUES (16, 6, 4);
INSERT INTO `songlisttosong` VALUES (17, 6, 8);
INSERT INTO `songlisttosong` VALUES (18, 9, 13);
INSERT INTO `songlisttosong` VALUES (19, 10, 4);
INSERT INTO `songlisttosong` VALUES (20, 11, 4);
INSERT INTO `songlisttosong` VALUES (21, 11, 10);
INSERT INTO `songlisttosong` VALUES (22, 9, 7);
INSERT INTO `songlisttosong` VALUES (23, 9, 8);
INSERT INTO `songlisttosong` VALUES (31, 13, 10);
INSERT INTO `songlisttosong` VALUES (33, 15, 28);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `u_id` int(16) NOT NULL AUTO_INCREMENT,
  `u_nickname` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `u_password` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `u_sex` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `u_birthday` datetime NULL DEFAULT NULL,
  `u_address` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `u_head_image` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `u_introduce` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `u_register_date` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`u_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, '滑翔的人儿', '123456', '男', '2020-08-29 00:00:00', '四川省 成都市 金牛区', 'http://localhost:8080/music_player_user_headImage/1.png', '该用户没有什么好介绍的', '2020-09-05 10:49:03');
INSERT INTO `user` VALUES (2, '马大叔', '123456', '保密', '1980-01-28 00:00:00', '北京市 北京市 东城区', 'http://localhost:8080/music_player_user_headImage/2.png', '这是一个帅气的男孩', '2020-09-05 10:49:03');
INSERT INTO `user` VALUES (3, '夜空中最亮的星', '147258369', '男', '2000-10-01 00:00:00', '四川省', 'http://localhost:8080/music_player_user_headImage/3.png', '一闪一闪亮晶晶，漫天都是小星星', '2020-09-05 10:44:46');
INSERT INTO `user` VALUES (4, '西部牛仔', '123456', '保密', '2008-05-12 00:00:00', '四川省', 'http://localhost:8080/music_player_user_headImage/4.png', '一个来自西部的双枪牛仔', '2020-09-05 10:49:03');

SET FOREIGN_KEY_CHECKS = 1;
