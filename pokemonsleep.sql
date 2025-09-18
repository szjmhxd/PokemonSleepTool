/*
 Navicat Premium Data Transfer

 Source Server         : 0.1-本地-8.4.4
 Source Server Type    : MySQL
 Source Server Version : 80404 (8.4.4)
 Source Host           : localhost:3306
 Source Schema         : pokemonsleep

 Target Server Type    : MySQL
 Target Server Version : 80404 (8.4.4)
 File Encoding         : 65001

 Date: 27/06/2025 15:32:19
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for dict
-- ----------------------------
DROP TABLE IF EXISTS `dict`;
CREATE TABLE `dict`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `type_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称（如：甜点类/汤类/主食类）',
  `parent_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '父级分类ID',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态（1=启用 0=停用）',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序字段',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `delete_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_status`(`parent_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_delete_time`(`delete_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '食谱分类字典表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dict
-- ----------------------------
INSERT INTO `dict` VALUES (1, '食谱类型', 0, 1, 1, '2025-06-27 11:05:03', '2025-06-27 11:05:20', NULL);
INSERT INTO `dict` VALUES (2, '咖喱、浓汤', 1, 1, 1, '2025-06-27 11:05:30', '2025-06-27 11:05:30', NULL);
INSERT INTO `dict` VALUES (3, '沙拉', 1, 1, 2, '2025-06-27 11:05:35', '2025-06-27 11:05:40', NULL);
INSERT INTO `dict` VALUES (4, '点心、饮料', 1, 1, 3, '2025-06-27 11:05:53', '2025-06-27 11:05:53', NULL);

-- ----------------------------
-- Table structure for ingredients
-- ----------------------------
DROP TABLE IF EXISTS `ingredients`;
CREATE TABLE `ingredients`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '食材名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '食材说明',
  `calories` int NULL DEFAULT NULL COMMENT '能量（卡路里）',
  `dream_shards` int NULL DEFAULT NULL COMMENT '出售获得的梦之碎片',
  `quantity` int NULL DEFAULT NULL COMMENT '我拥有的数量',
  `image_base64` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '食材图片(base64编码)',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `delete_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_delete_time`(`delete_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '食材表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ingredients
-- ----------------------------
INSERT INTO `ingredients` VALUES (1, '粗枝大葱', '不知道是不是大葱鸭所喜爱的那种植物的茎。', 185, 7, 64, NULL, 1, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);
INSERT INTO `ingredients` VALUES (2, '品鲜蘑菇', '鲜味满溢的多汁蘑菇。', 167, 7, 3, NULL, 2, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);
INSERT INTO `ingredients` VALUES (3, '特选蛋', '适合许多不同的调味方式，而且营养价值也很高。', 115, 5, 49, NULL, 3, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);
INSERT INTO `ingredients` VALUES (4, '窝心洋芋', '圆润的口感，让身心都暖洋洋的。', 124, 5, 29, NULL, 4, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);
INSERT INTO `ingredients` VALUES (5, '特选苹果', '经过严格挑选的苹果，不但形状漂亮，而且充满光泽。', 90, 4, 59, NULL, 5, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);
INSERT INTO `ingredients` VALUES (6, '火辣香草', '大红色的香草。辣得会让人醒过来。', 130, 5, 3, NULL, 6, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);
INSERT INTO `ingredients` VALUES (7, '豆制肉', '从宝可梦喜爱的豆子制作而成的健康肉品。', 103, 4, 36, NULL, 7, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);
INSERT INTO `ingredients` VALUES (8, '哞哞鲜奶', '营养满分的鲜奶，让喝下去的宝可梦活力十足。', 98, 4, 48, NULL, 8, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);
INSERT INTO `ingredients` VALUES (9, '甜甜蜜', '宝可梦采集的香甜花蜜。', 101, 4, 34, NULL, 9, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);
INSERT INTO `ingredients` VALUES (10, '纯粹油', '适用任何调味方式的万能油。', 121, 5, 50, NULL, 10, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);
INSERT INTO `ingredients` VALUES (11, '暖暖姜', '比任何食材都更具有暖身成分的辛辣食材。', 109, 4, 17, NULL, 11, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);
INSERT INTO `ingredients` VALUES (12, '好眠番茄', '大红色的番茄。吃了就能好好睡上一觉。', 110, 4, 45, NULL, 12, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);
INSERT INTO `ingredients` VALUES (13, '放松可可', '虽然加工很麻烦，但能获得不负一番功夫的放松效果。', 151, 6, 63, NULL, 13, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);
INSERT INTO `ingredients` VALUES (14, '美味尾巴', '非常美味的某种尾巴。就算它从主人身上掉下，也会马上长出来。', 342, 14, 57, NULL, 14, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);
INSERT INTO `ingredients` VALUES (15, '萌绿大豆', '适合搭配训练来摄取，是容易加工的萌草特产。', 100, 4, 30, NULL, 15, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);
INSERT INTO `ingredients` VALUES (16, '萌绿玉米', '有著出色甜味的萌草特产。生吃也没问题。', 140, 6, 25, NULL, 16, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);
INSERT INTO `ingredients` VALUES (17, '醒脑咖啡豆', '喝太多的话，就会睡不著。在想要神清气爽地醒来时很方便。', 153, 6, 9, NULL, 17, '2025-06-27 13:17:16', '2025-06-27 13:47:55', NULL);

-- ----------------------------
-- Table structure for recipe_ingredients
-- ----------------------------
DROP TABLE IF EXISTS `recipe_ingredients`;
CREATE TABLE `recipe_ingredients`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `recipe_id` bigint UNSIGNED NOT NULL,
  `ingredient_id` bigint UNSIGNED NOT NULL,
  `quantity_required` int NOT NULL COMMENT '所需数量/份量',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `recipe_id`(`recipe_id` ASC) USING BTREE,
  INDEX `ingredient_id`(`ingredient_id` ASC) USING BTREE,
  CONSTRAINT `recipe_ingredients_ibfk_1` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `recipe_ingredients_ibfk_2` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 253 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recipe_ingredients
-- ----------------------------
INSERT INTO `recipe_ingredients` VALUES (1, 1, 5, 7);
INSERT INTO `recipe_ingredients` VALUES (2, 2, 8, 7);
INSERT INTO `recipe_ingredients` VALUES (3, 3, 7, 7);
INSERT INTO `recipe_ingredients` VALUES (4, 4, 9, 7);
INSERT INTO `recipe_ingredients` VALUES (5, 5, 12, 10);
INSERT INTO `recipe_ingredients` VALUES (6, 5, 6, 5);
INSERT INTO `recipe_ingredients` VALUES (7, 6, 7, 10);
INSERT INTO `recipe_ingredients` VALUES (8, 6, 10, 5);
INSERT INTO `recipe_ingredients` VALUES (9, 7, 8, 8);
INSERT INTO `recipe_ingredients` VALUES (10, 7, 7, 8);
INSERT INTO `recipe_ingredients` VALUES (11, 8, 3, 10);
INSERT INTO `recipe_ingredients` VALUES (12, 8, 12, 6);
INSERT INTO `recipe_ingredients` VALUES (13, 9, 8, 10);
INSERT INTO `recipe_ingredients` VALUES (14, 9, 4, 8);
INSERT INTO `recipe_ingredients` VALUES (15, 9, 2, 4);
INSERT INTO `recipe_ingredients` VALUES (16, 10, 2, 14);
INSERT INTO `recipe_ingredients` VALUES (17, 10, 4, 9);
INSERT INTO `recipe_ingredients` VALUES (18, 11, 15, 12);
INSERT INTO `recipe_ingredients` VALUES (19, 11, 7, 6);
INSERT INTO `recipe_ingredients` VALUES (20, 11, 6, 4);
INSERT INTO `recipe_ingredients` VALUES (21, 11, 3, 4);
INSERT INTO `recipe_ingredients` VALUES (22, 12, 16, 14);
INSERT INTO `recipe_ingredients` VALUES (23, 12, 8, 8);
INSERT INTO `recipe_ingredients` VALUES (24, 12, 4, 8);
INSERT INTO `recipe_ingredients` VALUES (25, 13, 1, 14);
INSERT INTO `recipe_ingredients` VALUES (26, 13, 11, 10);
INSERT INTO `recipe_ingredients` VALUES (27, 13, 6, 8);
INSERT INTO `recipe_ingredients` VALUES (28, 14, 14, 8);
INSERT INTO `recipe_ingredients` VALUES (29, 14, 6, 25);
INSERT INTO `recipe_ingredients` VALUES (30, 15, 17, 11);
INSERT INTO `recipe_ingredients` VALUES (31, 15, 6, 11);
INSERT INTO `recipe_ingredients` VALUES (32, 15, 9, 11);
INSERT INTO `recipe_ingredients` VALUES (33, 16, 9, 12);
INSERT INTO `recipe_ingredients` VALUES (34, 16, 5, 11);
INSERT INTO `recipe_ingredients` VALUES (35, 16, 3, 8);
INSERT INTO `recipe_ingredients` VALUES (36, 16, 4, 4);
INSERT INTO `recipe_ingredients` VALUES (37, 17, 15, 24);
INSERT INTO `recipe_ingredients` VALUES (38, 17, 7, 9);
INSERT INTO `recipe_ingredients` VALUES (39, 17, 1, 12);
INSERT INTO `recipe_ingredients` VALUES (40, 17, 2, 5);
INSERT INTO `recipe_ingredients` VALUES (41, 18, 4, 18);
INSERT INTO `recipe_ingredients` VALUES (42, 18, 12, 15);
INSERT INTO `recipe_ingredients` VALUES (43, 18, 13, 12);
INSERT INTO `recipe_ingredients` VALUES (44, 18, 8, 10);
INSERT INTO `recipe_ingredients` VALUES (45, 19, 6, 27);
INSERT INTO `recipe_ingredients` VALUES (46, 19, 7, 24);
INSERT INTO `recipe_ingredients` VALUES (47, 19, 16, 14);
INSERT INTO `recipe_ingredients` VALUES (48, 19, 11, 12);
INSERT INTO `recipe_ingredients` VALUES (49, 20, 15, 28);
INSERT INTO `recipe_ingredients` VALUES (50, 20, 12, 25);
INSERT INTO `recipe_ingredients` VALUES (51, 20, 2, 23);
INSERT INTO `recipe_ingredients` VALUES (52, 20, 17, 16);
INSERT INTO `recipe_ingredients` VALUES (53, 21, 1, 27);
INSERT INTO `recipe_ingredients` VALUES (54, 21, 7, 26);
INSERT INTO `recipe_ingredients` VALUES (55, 21, 9, 26);
INSERT INTO `recipe_ingredients` VALUES (56, 21, 3, 22);
INSERT INTO `recipe_ingredients` VALUES (57, 23, 7, 8);
INSERT INTO `recipe_ingredients` VALUES (58, 24, 12, 8);
INSERT INTO `recipe_ingredients` VALUES (59, 25, 5, 8);
INSERT INTO `recipe_ingredients` VALUES (60, 26, 1, 10);
INSERT INTO `recipe_ingredients` VALUES (61, 26, 11, 5);
INSERT INTO `recipe_ingredients` VALUES (62, 27, 8, 10);
INSERT INTO `recipe_ingredients` VALUES (63, 27, 7, 6);
INSERT INTO `recipe_ingredients` VALUES (64, 28, 15, 10);
INSERT INTO `recipe_ingredients` VALUES (65, 28, 6, 6);
INSERT INTO `recipe_ingredients` VALUES (66, 29, 16, 9);
INSERT INTO `recipe_ingredients` VALUES (67, 29, 10, 8);
INSERT INTO `recipe_ingredients` VALUES (68, 30, 7, 9);
INSERT INTO `recipe_ingredients` VALUES (69, 30, 11, 6);
INSERT INTO `recipe_ingredients` VALUES (70, 30, 3, 5);
INSERT INTO `recipe_ingredients` VALUES (71, 30, 4, 3);
INSERT INTO `recipe_ingredients` VALUES (72, 31, 8, 12);
INSERT INTO `recipe_ingredients` VALUES (73, 31, 12, 6);
INSERT INTO `recipe_ingredients` VALUES (74, 31, 10, 5);
INSERT INTO `recipe_ingredients` VALUES (75, 32, 13, 14);
INSERT INTO `recipe_ingredients` VALUES (76, 32, 7, 9);
INSERT INTO `recipe_ingredients` VALUES (77, 33, 5, 15);
INSERT INTO `recipe_ingredients` VALUES (78, 33, 8, 5);
INSERT INTO `recipe_ingredients` VALUES (79, 33, 10, 3);
INSERT INTO `recipe_ingredients` VALUES (80, 34, 15, 15);
INSERT INTO `recipe_ingredients` VALUES (81, 34, 12, 9);
INSERT INTO `recipe_ingredients` VALUES (82, 35, 2, 17);
INSERT INTO `recipe_ingredients` VALUES (83, 35, 12, 8);
INSERT INTO `recipe_ingredients` VALUES (84, 35, 10, 8);
INSERT INTO `recipe_ingredients` VALUES (85, 36, 14, 10);
INSERT INTO `recipe_ingredients` VALUES (86, 36, 6, 10);
INSERT INTO `recipe_ingredients` VALUES (87, 36, 10, 15);
INSERT INTO `recipe_ingredients` VALUES (88, 37, 6, 17);
INSERT INTO `recipe_ingredients` VALUES (89, 37, 11, 10);
INSERT INTO `recipe_ingredients` VALUES (90, 37, 12, 8);
INSERT INTO `recipe_ingredients` VALUES (91, 38, 4, 14);
INSERT INTO `recipe_ingredients` VALUES (92, 38, 3, 9);
INSERT INTO `recipe_ingredients` VALUES (93, 38, 7, 7);
INSERT INTO `recipe_ingredients` VALUES (94, 38, 5, 6);
INSERT INTO `recipe_ingredients` VALUES (95, 39, 5, 21);
INSERT INTO `recipe_ingredients` VALUES (96, 39, 9, 16);
INSERT INTO `recipe_ingredients` VALUES (97, 39, 16, 12);
INSERT INTO `recipe_ingredients` VALUES (98, 40, 3, 20);
INSERT INTO `recipe_ingredients` VALUES (99, 40, 7, 15);
INSERT INTO `recipe_ingredients` VALUES (100, 40, 16, 11);
INSERT INTO `recipe_ingredients` VALUES (101, 40, 12, 10);
INSERT INTO `recipe_ingredients` VALUES (102, 41, 1, 15);
INSERT INTO `recipe_ingredients` VALUES (103, 41, 15, 19);
INSERT INTO `recipe_ingredients` VALUES (104, 41, 2, 12);
INSERT INTO `recipe_ingredients` VALUES (105, 41, 11, 11);
INSERT INTO `recipe_ingredients` VALUES (106, 42, 10, 22);
INSERT INTO `recipe_ingredients` VALUES (107, 42, 16, 17);
INSERT INTO `recipe_ingredients` VALUES (108, 42, 12, 14);
INSERT INTO `recipe_ingredients` VALUES (109, 42, 4, 9);
INSERT INTO `recipe_ingredients` VALUES (110, 43, 3, 25);
INSERT INTO `recipe_ingredients` VALUES (111, 43, 10, 17);
INSERT INTO `recipe_ingredients` VALUES (112, 43, 4, 15);
INSERT INTO `recipe_ingredients` VALUES (113, 43, 7, 12);
INSERT INTO `recipe_ingredients` VALUES (114, 44, 17, 28);
INSERT INTO `recipe_ingredients` VALUES (115, 44, 7, 28);
INSERT INTO `recipe_ingredients` VALUES (116, 44, 10, 22);
INSERT INTO `recipe_ingredients` VALUES (117, 44, 4, 22);
INSERT INTO `recipe_ingredients` VALUES (118, 45, 3, 35);
INSERT INTO `recipe_ingredients` VALUES (119, 45, 5, 28);
INSERT INTO `recipe_ingredients` VALUES (120, 45, 12, 23);
INSERT INTO `recipe_ingredients` VALUES (121, 45, 8, 18);
INSERT INTO `recipe_ingredients` VALUES (187, 46, 8, 7);
INSERT INTO `recipe_ingredients` VALUES (188, 47, 5, 8);
INSERT INTO `recipe_ingredients` VALUES (189, 48, 9, 9);
INSERT INTO `recipe_ingredients` VALUES (190, 49, 4, 9);
INSERT INTO `recipe_ingredients` VALUES (191, 49, 8, 5);
INSERT INTO `recipe_ingredients` VALUES (192, 50, 3, 8);
INSERT INTO `recipe_ingredients` VALUES (193, 50, 15, 7);
INSERT INTO `recipe_ingredients` VALUES (194, 51, 11, 9);
INSERT INTO `recipe_ingredients` VALUES (195, 51, 5, 7);
INSERT INTO `recipe_ingredients` VALUES (196, 52, 5, 12);
INSERT INTO `recipe_ingredients` VALUES (197, 52, 8, 4);
INSERT INTO `recipe_ingredients` VALUES (198, 53, 12, 9);
INSERT INTO `recipe_ingredients` VALUES (199, 53, 5, 7);
INSERT INTO `recipe_ingredients` VALUES (200, 54, 13, 11);
INSERT INTO `recipe_ingredients` VALUES (201, 54, 5, 11);
INSERT INTO `recipe_ingredients` VALUES (202, 55, 15, 15);
INSERT INTO `recipe_ingredients` VALUES (203, 55, 13, 8);
INSERT INTO `recipe_ingredients` VALUES (204, 56, 10, 10);
INSERT INTO `recipe_ingredients` VALUES (205, 56, 8, 7);
INSERT INTO `recipe_ingredients` VALUES (206, 56, 9, 6);
INSERT INTO `recipe_ingredients` VALUES (207, 57, 9, 9);
INSERT INTO `recipe_ingredients` VALUES (208, 57, 13, 8);
INSERT INTO `recipe_ingredients` VALUES (209, 57, 8, 7);
INSERT INTO `recipe_ingredients` VALUES (210, 58, 9, 14);
INSERT INTO `recipe_ingredients` VALUES (211, 58, 11, 12);
INSERT INTO `recipe_ingredients` VALUES (212, 58, 13, 5);
INSERT INTO `recipe_ingredients` VALUES (213, 58, 3, 4);
INSERT INTO `recipe_ingredients` VALUES (214, 59, 5, 11);
INSERT INTO `recipe_ingredients` VALUES (215, 59, 8, 9);
INSERT INTO `recipe_ingredients` VALUES (216, 59, 9, 7);
INSERT INTO `recipe_ingredients` VALUES (217, 59, 13, 8);
INSERT INTO `recipe_ingredients` VALUES (218, 60, 11, 11);
INSERT INTO `recipe_ingredients` VALUES (219, 60, 5, 15);
INSERT INTO `recipe_ingredients` VALUES (220, 60, 2, 9);
INSERT INTO `recipe_ingredients` VALUES (221, 61, 10, 12);
INSERT INTO `recipe_ingredients` VALUES (222, 61, 15, 16);
INSERT INTO `recipe_ingredients` VALUES (223, 61, 13, 7);
INSERT INTO `recipe_ingredients` VALUES (224, 62, 16, 15);
INSERT INTO `recipe_ingredients` VALUES (225, 62, 10, 14);
INSERT INTO `recipe_ingredients` VALUES (226, 62, 8, 7);
INSERT INTO `recipe_ingredients` VALUES (227, 63, 17, 14);
INSERT INTO `recipe_ingredients` VALUES (228, 63, 16, 14);
INSERT INTO `recipe_ingredients` VALUES (229, 63, 8, 12);
INSERT INTO `recipe_ingredients` VALUES (230, 64, 17, 16);
INSERT INTO `recipe_ingredients` VALUES (231, 64, 8, 14);
INSERT INTO `recipe_ingredients` VALUES (232, 64, 9, 12);
INSERT INTO `recipe_ingredients` VALUES (233, 65, 9, 20);
INSERT INTO `recipe_ingredients` VALUES (234, 65, 3, 15);
INSERT INTO `recipe_ingredients` VALUES (235, 65, 8, 10);
INSERT INTO `recipe_ingredients` VALUES (236, 65, 5, 10);
INSERT INTO `recipe_ingredients` VALUES (237, 66, 5, 20);
INSERT INTO `recipe_ingredients` VALUES (238, 66, 11, 20);
INSERT INTO `recipe_ingredients` VALUES (239, 66, 16, 18);
INSERT INTO `recipe_ingredients` VALUES (240, 66, 8, 9);
INSERT INTO `recipe_ingredients` VALUES (241, 67, 13, 25);
INSERT INTO `recipe_ingredients` VALUES (242, 67, 3, 25);
INSERT INTO `recipe_ingredients` VALUES (243, 67, 9, 17);
INSERT INTO `recipe_ingredients` VALUES (244, 67, 8, 10);
INSERT INTO `recipe_ingredients` VALUES (245, 68, 5, 35);
INSERT INTO `recipe_ingredients` VALUES (246, 68, 11, 20);
INSERT INTO `recipe_ingredients` VALUES (247, 68, 1, 20);
INSERT INTO `recipe_ingredients` VALUES (248, 68, 17, 12);
INSERT INTO `recipe_ingredients` VALUES (249, 69, 13, 30);
INSERT INTO `recipe_ingredients` VALUES (250, 69, 8, 26);
INSERT INTO `recipe_ingredients` VALUES (251, 69, 17, 24);
INSERT INTO `recipe_ingredients` VALUES (252, 69, 9, 22);

-- ----------------------------
-- Table structure for recipes
-- ----------------------------
DROP TABLE IF EXISTS `recipes`;
CREATE TABLE `recipes`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '食谱名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '食谱说明',
  `category_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '分类ID',
  `calories` int NULL DEFAULT NULL COMMENT '总能量（卡路里）',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `image_base64` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '食谱图片(base64编码)',
  `is_made` tinyint NOT NULL DEFAULT 2 COMMENT '是否做过 (1=已做, 2=未做)',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `delete_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_delete_time`(`delete_time` ASC) USING BTREE,
  INDEX `fk_recipe_dict`(`category_id` ASC) USING BTREE,
  CONSTRAINT `fk_recipe_category` FOREIGN KEY (`category_id`) REFERENCES `dict` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_recipe_dict` FOREIGN KEY (`category_id`) REFERENCES `dict` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 70 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '食谱表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recipes
-- ----------------------------
INSERT INTO `recipes` VALUES (1, '特选苹果咖喱', '能感受到苹果天然甜味的朴实咖喱。', 2, 668, 1, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (2, '单纯白酱浓汤', '能感受到甘醇奶味的朴实浓汤。', 2, 727, 2, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (3, '豆制肉排咖喱', '这份咖喱的主角，是以豆子制成的柔软汉堡排。', 2, 764, 3, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (4, '宝宝甜蜜咖喱', '放了很多蜜的甜咖喱，小孩也能吃。', 2, 749, 4, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (5, '太阳之力番茄咖喱', '使用了在阳光下长得通红的番茄所做出的咖喱。', 2, 1943, 5, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (6, '日照炸肉排咖喱', '刚炸好的肉排闪闪发亮。', 2, 1815, 6, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (7, '吃饱饱起司肉排咖喱', '分量满分的咖喱，连卡比兽也会大吃一惊。', 2, 1785, 7, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (8, '入口即化蛋卷咖喱', '咖喱上的蛋卷由绝妙火候烹调，会在舌上融化。', 2, 2009, 8, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (9, '窝心白酱浓汤', '把洋芋煮到几乎要融化的醇郁浓汤。', 2, 3089, 9, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (10, '蘑菇孢子咖喱', '吃下就会像淋到蘑菇孢子似地沉沉睡著的咖喱。', 2, 4041, 10, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (11, '健美豆子咖喱', '满载著打造健康体魄所需的营养，是分量十足的咖喱。', 2, 3274, 11, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (12, '柔软玉米浓汤', '鲜奶与玉米的柔和甜味，交织成了顺口的白酱浓汤。', 2, 4670, 12, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (13, '辣味葱劲十足咖喱', '香气四溢的烤葱犹如果实般甘甜，和咖喱酱的辣达到绝妙的平衡。', 2, 5900, 13, NULL, 2, '2025-06-27 13:45:48', '2025-06-27 13:46:40', NULL);
INSERT INTO `recipes` VALUES (14, '炙烧尾肉咖喱', '尾肉的鲜味让咖喱酱的味道更上一层楼。', 2, 7483, 14, NULL, 2, '2025-06-27 13:45:48', '2025-06-27 13:46:40', NULL);
INSERT INTO `recipes` VALUES (15, '迷昏拳辣味咖喱', '甜味与辣味有节奏地在口中扩散，最后以苦味收尾的咖喱。', 2, 5702, 15, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (16, '亲子爱咖喱', '只使用了体贴孩子们的食材制成，是充满爱情的咖喱。', 2, 4523, 16, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (17, '忍者咖喱', '豆腐咖喱，据说这是忍者喜爱的吃法。', 2, 9445, 17, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (18, '绝对睡眠奶油咖喱', '以熟睡作为主题精选了食材的咖喱。', 2, 9010, 18, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (19, '炼狱玉米干咖喱', '在玉米的甜味过后，会感受到炼狱般的辛辣。', 2, 13690, 19, NULL, 1, '2025-06-27 13:45:48', '2025-06-27 13:51:23', NULL);
INSERT INTO `recipes` VALUES (20, '觉醒力量浓汤', '使用许多食材的番茄浓汤，能为梦醒时分增添豪华色彩。', 2, 19061, 20, NULL, 2, '2025-06-27 13:45:48', '2025-06-27 13:46:40', NULL);
INSERT INTO `recipes` VALUES (21, '切寿喜烧咖喱', NULL, 2, NULL, 21, NULL, 2, '2025-06-27 13:46:58', '2025-06-27 13:47:02', NULL);
INSERT INTO `recipes` VALUES (23, '豆制火腿沙拉', '质朴的沙拉，放了用豆制肉做成的火腿。', 3, 873, 1, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:20', NULL);
INSERT INTO `recipes` VALUES (24, '好眠番茄沙拉', '利用好眠番茄的成分，帮助睡眠的质朴沙拉。', 3, 933, 2, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (25, '特选苹果沙拉', '质朴的沙拉，上面淋著苹果泥做的酱汁。', 3, 763, 3, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (26, '免疫葱花沙拉', '满满的葱花口感爽脆，是能使免疫力提升的沙拉。', 3, 2658, 4, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (27, '拨雪凯撒沙拉', '上面撒著细雪般的起司的培根沙拉，吃的时候就像是在拨雪。', 3, 1774, 5, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (28, '热风豆腐沙拉', '淋上鲜红色辣酱的豆腐沙拉。', 3, 1976, 6, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (29, '乱击玉米沙拉', '有著满满玉米粒的沙拉，得又戳又插地吃。', 3, 2785, 7, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (30, '蛮力豪迈沙拉', '大分量的沙拉，可摄取到一天所需的营养。', 3, 2958, 8, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (31, '哞哞起司番茄沙拉', '简单地在起司和番茄上，淋了油的质朴沙拉。', 3, 2856, 9, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (32, '心情不定肉沙拉淋巧克力酱', '能享受咸味酱汁和甜巧克力酱带来的滋味变化。', 3, 3558, 10, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (33, '迷人苹果起司沙拉', '只用了简单的调味，让绝配的食材衬托出彼此的风味。', 3, 2578, 11, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (34, '湿润豆腐沙拉', '上面放著弹嫩豆腐的沙拉。', 3, 3113, 12, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (35, '蘑菇孢子沙拉', '富含有助于睡眠的成分的沙拉。', 3, 5859, 13, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (36, '呆呆兽尾巴的胡椒沙拉', '略带刺激的辛香料，让尾巴的甜味更加突出。', 3, 8169, 14, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (37, '过热沙拉', '特制的生姜淋酱，能让身体暖呼呼。', 3, 5225, 15, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (38, '贪吃鬼洋芋沙拉', '以特选苹果提味的洋芋沙拉。', 3, 5040, 16, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (39, '冥想香甜沙拉', '清爽的甘甜口味，能使心情平静。', 3, 7675, 17, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (40, '十字切碎丁沙拉', '把材料不断地切切切，', 3, 8755, 18, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (41, '忍者沙拉', '使用了豆腐，且味道深受忍者喜爱，能迅速入肚。', 3, 11659, 19, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (42, '萌绿沙拉', '只使用了在萌绿之岛采收的新鲜蔬菜制作的沙拉。', 3, 11393, 20, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (43, '落英缤纷含羞草蛋沙拉', '如花般蓬松且粒粒分明的碎蛋，', 3, 11811, 21, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (44, '不服输咖啡沙拉', '不服输地挑战了无数次，', 3, 20218, 22, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (45, '苹果酸酸奶沙拉', '苹果醋与酸奶的酸味', 3, 19293, 23, NULL, 2, '2025-06-27 14:26:07', '2025-06-27 15:14:24', NULL);
INSERT INTO `recipes` VALUES (46, '哞哞热鲜奶', '加热后更增香甜的哞哞鲜奶。', 4, 727, 1, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:05', NULL);
INSERT INTO `recipes` VALUES (47, '特选苹果汁', '浓厚香醇的果汁，只使用了严格挑选的苹果制成。', 4, 763, 2, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (48, '手制劲爽汽水', '冒著气泡的手工汽水。', 4, 964, 3, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (49, '熟成甜薯烧', '借由让洋芋熟成得恰恰好，来达到不需加蜜的甜度。', 4, 1783, 4, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (50, '轻装豆香蛋糕', '口感轻盈的豆香蛋糕。', 4, 1798, 5, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (51, '火花姜茶', '呛辣的姜配上甜甜的苹果，调出了一杯顺口的饮料。', 4, 1788, 6, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (52, '祈愿苹果派', '如果吃到整块苹果的部分，就代表非常幸运。', 4, 1634, 7, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (53, '我行我素蔬菜汁', '带有自然甘甜和酸味的简单果汁。', 4, 1798, 8, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (54, '花瓣舞巧克力塔', '难以驾驭的点心塔，吃下时苹果花瓣会翩翩起舞。', 4, 3314, 9, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (55, '活力蛋白饮', '在锻炼一番之后，就用甜甜的一杯饮料当作奖赏吧。', 4, 3168, 10, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (56, '大马拉萨达', '特别的油炸面包，照著从阿罗拉地区要来的食谱重现而成。', 4, 2927, 11, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (57, '甜甜香气巧克力蛋糕', '散发出的甜甜香气，让人和宝可梦都难以抵挡。', 4, 3280, 12, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (58, '不屈姜饼', '吃下后会涌出继续努力的力量，遇上困难也不会轻易灰心。', 4, 4921, 13, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (59, '恶魔之吻水果牛奶', '能疗愈疲惫的身体，有助于入眠的放松饮料。', 4, 4734, 14, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (60, '橙梦的排毒茶', '博士特制的排毒茶。', 4, 5065, 15, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (61, '大力士豆香甜甜圈', '炸得酥脆的豆香甜甜圈，是想要打造健康体魄时的好伙伴。', 4, 5547, 16, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (62, '大爆炸爆米花', '用甚至会引发大爆炸的强大火力瞬间完成。', 4, 6048, 17, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (63, '破格玉米香提拉米苏', '以突破常规的方式制作，仅靠玉米的甜味来取胜的提拉米苏。', 4, 7125, 18, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (64, '早起咖啡冻', '味道偏苦的咖啡冻，能够加速清醒。', 4, 6793, 19, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (65, '胖丁百汇布丁', '像气球一样有弹性的特制布丁。', 4, 7594, 20, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (66, '茶会玉米司康', '口感酥松的司康与姜汁苹果果酱以1比1的比例搭配而成。', 4, 10925, 21, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (67, '花之礼马卡龙', '会令人绽放笑容的马卡龙，是作为礼物的首选。', 4, 13834, 22, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (68, '电光香料可乐', '刺激性很强的可乐，喝下就会瞬间清醒。', 4, 17494, 23, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);
INSERT INTO `recipes` VALUES (69, '土王闪电泡芙', '令人心花怒放的土王造型苦味闪电泡芙。内馅也非常扎实饱满。', 4, 20885, 24, NULL, 2, '2025-06-27 15:20:42', '2025-06-27 15:21:10', NULL);

SET FOREIGN_KEY_CHECKS = 1;
