-- MySQL dump 10.11
--
-- Host: 216.121.76.220    Database: cda_new
-- ------------------------------------------------------
-- Server version	5.0.22
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary table structure for view `Logins`
--

/*!50001 CREATE TABLE `Logins` (
  `id` int(11),
  `visitor_profile_id` char(36),
  `action_time` datetime,
  `page_name` varchar(100),
  `ip_address` varchar(30),
  `referrer` varchar(300),
  `action_name` varchar(50),
  `action_param1` varchar(300),
  `action_param2` varchar(100),
  `action_param3` varchar(100)
) */;

--
-- Temporary table structure for view `Products_Per_Categories`
--

/*!50001 CREATE TABLE `Products_Per_Categories` (
  `name` varchar(150),
  `COUNT(product.id)` bigint(21)
) */;

--
-- Temporary table structure for view `Review per Site`
--

/*!50001 CREATE TABLE `Review per Site` (
  `COUNT(review.id)` bigint(21),
  `site` varchar(100)
) */;

--
-- Temporary table structure for view `Total Products in DB`
--

/*!50001 CREATE TABLE `Total Products in DB` (
  `count(*)` bigint(21)
) */;

--
-- Temporary table structure for view `Total Reviews in DB`
--

/*!50001 CREATE TABLE `Total Reviews in DB` (
  `count(*)` bigint(21)
) */;

--
-- Temporary table structure for view `Visitor Analytics`
--

/*!50001 CREATE TABLE `Visitor Analytics` (
  `Date/Time` datetime,
  `IP Address` varchar(30),
  `OEM User ID` int(11),
  `Browser` varchar(255),
  `Referrer` varchar(300),
  `Page Name` varchar(100),
  `Action Name` varchar(50),
  `Action Param1` varchar(300),
  `Action Param2` varchar(100),
  `Action Param3` varchar(100)
) */;

--
-- Table structure for table `auth_token`
--

CREATE TABLE `auth_token` (
  `token` varchar(255) NOT NULL,
  `oem_user_id` int(11) default NULL,
  PRIMARY KEY  (`token`),
  UNIQUE KEY `token` (`token`),
  KEY `FK8B5E1CA22AD395FD` (`oem_user_id`)
);

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `parent_id` int(11) default NULL,
  `name` varchar(150) default NULL,
  `products_count` int(11) default NULL,
  `attrib_left` int(11) default NULL,
  `attrib_right` int(11) default NULL,
  PRIMARY KEY  (`id`)
);

--
-- Table structure for table `competing_product`
--

CREATE TABLE `competing_product` (
  `oem_user_id` int(11) NOT NULL,
  `primary_id` char(32) NOT NULL,
  `secondary_id` char(32) default NULL,
  KEY `FKD4970AD47E57BDEB` (`primary_id`),
  KEY `FKD4970AD4142DE96D` (`oem_user_id`),
  KEY `FKD4970AD4B8254D39` (`secondary_id`),
  KEY `FKD4970AD494FD6A7B` (`primary_id`),
  KEY `FKD4970AD42AD395FD` (`oem_user_id`),
  KEY `FKD4970AD4CECAF9C9` (`secondary_id`),
  CONSTRAINT `FKD4970AD4142DE96D` FOREIGN KEY (`oem_user_id`) REFERENCES `oem_user` (`id`),
  CONSTRAINT `FKD4970AD42AD395FD` FOREIGN KEY (`oem_user_id`) REFERENCES `oem_user` (`id`),
  CONSTRAINT `FKD4970AD47E57BDEB` FOREIGN KEY (`primary_id`) REFERENCES `product` (`id`),
  CONSTRAINT `FKD4970AD494FD6A7B` FOREIGN KEY (`primary_id`) REFERENCES `product` (`id`),
  CONSTRAINT `FKD4970AD4B8254D39` FOREIGN KEY (`secondary_id`) REFERENCES `product` (`id`),
  CONSTRAINT `FKD4970AD4CECAF9C9` FOREIGN KEY (`secondary_id`) REFERENCES `product` (`id`)
);

--
-- Table structure for table `country`
--

CREATE TABLE `country` (
  `name` varchar(80) NOT NULL,
  `printable_name` varchar(80) NOT NULL,
  `iso` char(2) NOT NULL,
  PRIMARY KEY  (`iso`)
);

--
-- Table structure for table `country_state`
--

CREATE TABLE `country_state` (
  `id` int(10) unsigned NOT NULL,
  `country_iso` char(2) NOT NULL,
  `short_name` varchar(5) default NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY  (`id`)
);

--
-- Table structure for table `login_history`
--

CREATE TABLE `login_history` (
  `oem_user_id` int(11) NOT NULL,
  `login_time` timestamp NOT NULL default CURRENT_TIMESTAMP,
  KEY `FK88A801BE142DE96D` (`oem_user_id`),
  KEY `FK88A801BE2AD395FD` (`oem_user_id`),
  CONSTRAINT `FK88A801BE142DE96D` FOREIGN KEY (`oem_user_id`) REFERENCES `oem_user` (`id`),
  CONSTRAINT `FK88A801BE2AD395FD` FOREIGN KEY (`oem_user_id`) REFERENCES `oem_user` (`id`)
);

--
-- Table structure for table `maillist`
--

CREATE TABLE `maillist` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(300) default NULL,
  PRIMARY KEY  (`id`)
);

--
-- Table structure for table `maillist_member`
--

CREATE TABLE `maillist_member` (
  `id` int(11) NOT NULL,
  `maillist_id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `oem_user_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `maillist_id` (`maillist_id`),
  KEY `oem_user_id` (`oem_user_id`),
  CONSTRAINT `maillist_member_ibfk_1` FOREIGN KEY (`maillist_id`) REFERENCES `maillist` (`id`),
  CONSTRAINT `maillist_member_ibfk_2` FOREIGN KEY (`oem_user_id`) REFERENCES `oem_user` (`id`)
);

--
-- Table structure for table `manufacturer`
--

CREATE TABLE `manufacturer` (
  `id` char(32) NOT NULL,
  `name` varchar(100) character set latin1 collate latin1_bin NOT NULL,
  `hidden` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`name`),
  KEY `id` (`id`)
);

--
-- Table structure for table `oem_user`
--

CREATE TABLE `oem_user` (
  `id` int(11) NOT NULL,
  `isActive` int(11) default NULL,
  `phone_num` varchar(20) default NULL,
  `last_name` varchar(100) default NULL,
  `first_name` varchar(100) default NULL,
  `isWidgetDemo` int(11) default NULL,
  `email` varchar(100) default NULL,
  `company` varchar(200) default NULL,
  `isAdmin` int(11) default NULL,
  `password` varchar(50) default NULL,
  `username` varchar(100) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `idx_username` (`username`)
);

--
-- Table structure for table `oem_user_backup`
--

CREATE TABLE `oem_user_backup` (
  `id` int(11) NOT NULL,
  `isActive` int(11) default NULL,
  `phone_num` varchar(20) default NULL,
  `last_name` varchar(100) default NULL,
  `first_name` varchar(100) default NULL,
  `isWidgetDemo` int(11) default NULL,
  `email` varchar(100) default NULL,
  `company` varchar(200) default NULL,
  `isAdmin` int(11) default NULL,
  `password` varchar(50) default NULL,
  `username` varchar(100) NOT NULL,
  PRIMARY KEY  (`id`)
);

--
-- Table structure for table `oem_user_product`
--

CREATE TABLE `oem_user_product` (
  `product_id` char(32) NOT NULL,
  `oem_user_id` int(11) NOT NULL,
  KEY `FK385BC66332D1FBDE` (`product_id`),
  KEY `FK385BC663142DE96D` (`oem_user_id`),
  KEY `FK385BC6634977A86E` (`product_id`),
  KEY `FK385BC6632AD395FD` (`oem_user_id`),
  CONSTRAINT `FK385BC663142DE96D` FOREIGN KEY (`oem_user_id`) REFERENCES `oem_user` (`id`),
  CONSTRAINT `FK385BC6632AD395FD` FOREIGN KEY (`oem_user_id`) REFERENCES `oem_user` (`id`),
  CONSTRAINT `FK385BC66332D1FBDE` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `FK385BC6634977A86E` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
);

--
-- Table structure for table `oem_user_role`
--

CREATE TABLE `oem_user_role` (
  `oem_user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY  (`oem_user_id`,`role_id`),
  KEY `FK94C31B82BC63A9D1` (`role_id`),
  KEY `FK94C31B822AD395FD` (`oem_user_id`)
);

--
-- Table structure for table `prm_category_subscriptions`
--

CREATE TABLE `prm_category_subscriptions` (
  `id` int(11) NOT NULL,
  `category_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_prm_category_subscriptions_on_id` (`id`),
  KEY `index_prm_category_subscriptions_on_user_id` (`user_id`),
  KEY `category_id` (`category_id`)
);

--
-- Table structure for table `prm_delayed_jobs`
--

CREATE TABLE `prm_delayed_jobs` (
  `id` int(11) NOT NULL,
  `priority` int(11) default '0',
  `attempts` int(11) default '0',
  `handler` text,
  `last_error` text,
  `run_at` datetime default NULL,
  `locked_at` datetime default NULL,
  `failed_at` datetime default NULL,
  `locked_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
);

--
-- Table structure for table `prm_product_reports`
--

CREATE TABLE `prm_product_reports` (
  `id` int(11) NOT NULL,
  `product_category_id` int(11) default NULL,
  `manufacturer_id` char(32) default NULL,
  `sorting_field` int(11) default NULL,
  `sorting_order` int(11) default NULL,
  `number_of_reviews` int(11) default NULL,
  `csi_range` int(11) default NULL,
  `pfs_range` int(11) default NULL,
  `prs_range` int(11) default NULL,
  `pss_range` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `per_page` int(11) default NULL,
  `filtered` tinyint(1) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_prm_product_reports_on_id` (`id`),
  KEY `index_prm_product_reports_on_user_id` (`user_id`),
  KEY `product_category_id` (`product_category_id`),
  KEY `manufacturer_id` (`manufacturer_id`)
);

--
-- Table structure for table `prm_report_manufacturers`
--

CREATE TABLE `prm_report_manufacturers` (
  `id` int(11) NOT NULL,
  `report_id` int(11) default NULL,
  `manufacturer_id` char(32) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_prm_report_manufacturers_on_report_id` (`report_id`),
  KEY `manufacturer_id` (`manufacturer_id`)
);

--
-- Table structure for table `prm_report_product_filters`
--

CREATE TABLE `prm_report_product_filters` (
  `id` int(11) NOT NULL,
  `report_id` int(11) default NULL,
  `product_id` char(32) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_prm_report_product_filters_on_report_id` (`report_id`),
  KEY `product_id` (`product_id`)
);

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` char(32) NOT NULL,
  `name` varchar(300) default NULL,
  `model` varchar(100) default NULL,
  `csi_score` float default NULL,
  `functionality_score` float default NULL,
  `reliability_score` float default NULL,
  `support_score` float default NULL,
  `manufacturer` char(32) default NULL,
  `last_update` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `all_reviews_count` int(11) default NULL,
  `func_reviews_count` int(11) default NULL,
  `sup_review_count` int(11) default NULL,
  `rel_reviews_count` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `idx_product_name` (`name`),
  KEY `FKED8DCCEF6272C30E` (`manufacturer`)
);

--
-- Table structure for table `product_category`
--

CREATE TABLE `product_category` (
  `product_id` char(32) NOT NULL,
  `category_id` int(11) default NULL,
  KEY `FK_pc_category` (`category_id`),
  KEY `FK_pc_product` (`product_id`)
);

--
-- Table structure for table `retailer_site`
--

CREATE TABLE `retailer_site` (
  `id` char(32) NOT NULL,
  `url` varchar(3000) NOT NULL,
  `description` varchar(500) default NULL,
  PRIMARY KEY  (`id`)
);

--
-- Table structure for table `retailer_site_product`
--

CREATE TABLE `retailer_site_product` (
  `product_id` char(32) NOT NULL,
  `retailer_site_id` char(32) NOT NULL,
  KEY `FKA69AC2E63F76EB17` (`retailer_site_id`),
  KEY `FKA69AC2E632D1FBDE` (`product_id`),
  KEY `FKA69AC2E6FF369887` (`retailer_site_id`),
  KEY `FKA69AC2E64977A86E` (`product_id`),
  CONSTRAINT `FKA69AC2E632D1FBDE` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `FKA69AC2E63F76EB17` FOREIGN KEY (`retailer_site_id`) REFERENCES `retailer_site` (`id`),
  CONSTRAINT `FKA69AC2E64977A86E` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `FKA69AC2E6FF369887` FOREIGN KEY (`retailer_site_id`) REFERENCES `retailer_site` (`id`)
);

--
-- Table structure for table `review`
--

CREATE TABLE `review` (
  `id` char(32) NOT NULL,
  `product_id` char(32) NOT NULL,
  `last_update_date` date default NULL,
  `title` varchar(300) default NULL,
  `csi_score` float default NULL,
  `reliability_score` float default NULL,
  `reviewer_name` varchar(100) default NULL,
  `functionality_score` float default NULL,
  `site` varchar(100) default NULL,
  `reviewer_email` varchar(100) default NULL,
  `reviewer_country` char(2) default NULL,
  `source_url` varchar(3000) default NULL,
  `recieve_date` datetime default NULL,
  `reviewer_state` varchar(20) default NULL,
  `text` text,
  `reviewer_city` varchar(100) default NULL,
  `support_score` float default NULL,
  `sync_date` datetime default NULL,
  `visibility` char(1) default NULL COMMENT 'NULL or ''A'' - visible everywhere;\n         ''D'' - visible only in PRD;\n         ''M'' - visible only in PRM.',
  PRIMARY KEY  (`id`),
  KEY `idx_r_score` (`reliability_score`),
  KEY `idx_f_score` (`functionality_score`),
  KEY `idx_s_score` (`support_score`),
  KEY `FKC84EF75858DC7376` (`reviewer_country`),
  KEY `FKC84EF75832D1FBDE` (`product_id`),
  KEY `FKC84EF7586F822006` (`reviewer_country`),
  KEY `FKC84EF7584977A86E` (`product_id`),
  CONSTRAINT `FKC84EF75832D1FBDE` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `FKC84EF7584977A86E` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `FKC84EF75858DC7376` FOREIGN KEY (`reviewer_country`) REFERENCES `country` (`iso`),
  CONSTRAINT `FKC84EF7586F822006` FOREIGN KEY (`reviewer_country`) REFERENCES `country` (`iso`)
);

--
-- Table structure for table `review_audit`
--

CREATE TABLE `review_audit` (
  `id` int(11) NOT NULL,
  `audit_date` datetime NOT NULL,
  `csi_score_comment` varchar(500) default NULL,
  `functionality_score_comment` varchar(500) default NULL,
  `new_csi_score` float default NULL,
  `new_functionality_score` float default NULL,
  `new_reliability_score` float default NULL,
  `new_support_score` float default NULL,
  `oem_user_id` int(11) NOT NULL,
  `old_csi_score` float default NULL,
  `old_functionality_score` float default NULL,
  `old_reliability_score` float default NULL,
  `old_support_score` float default NULL,
  `reliability_score_comment` varchar(500) default NULL,
  `review_id` varchar(32) NOT NULL,
  `support_score_comment` varchar(500) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `id` (`id`)
);

--
-- Table structure for table `review_feedback`
--

CREATE TABLE `review_feedback` (
  `id` int(11) NOT NULL,
  `review_id` char(32) NOT NULL,
  `oem_user_id` int(11) default NULL,
  `feedback` varchar(4000) NOT NULL,
  `tag_functionality` int(11) default NULL,
  `tag_reliability` int(11) default NULL,
  `tag_support` int(11) default NULL,
  `disclaimer` char(1) default NULL,
  `feedback_time` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  KEY `review_id` (`review_id`),
  KEY `oem_user_id` (`oem_user_id`)
);

--
-- Table structure for table `role`
--

CREATE TABLE `role` (
  `id` int(11) NOT NULL,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `id` (`id`)
);

--
-- Table structure for table `statistic`
--

CREATE TABLE `statistic` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `value_int` int(11) default NULL,
  `value_str` varchar(200) default NULL,
  `value_date` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
);

--
-- Table structure for table `user_action`
--

CREATE TABLE `user_action` (
  `id` int(11) NOT NULL,
  `visitor_profile_id` char(36) default NULL,
  `action_time` datetime default NULL,
  `page_name` varchar(100) default NULL,
  `ip_address` varchar(30) default NULL,
  `referrer` varchar(300) default NULL,
  `action_name` varchar(50) default NULL,
  `action_param1` varchar(300) default NULL,
  `action_param2` varchar(100) default NULL,
  `action_param3` varchar(100) default NULL,
  PRIMARY KEY  (`id`)
);

--
-- Table structure for table `visitor`
--

CREATE TABLE `visitor` (
  `id` char(36) NOT NULL,
  `ua_name` varchar(255) default NULL,
  `ua_platform` varchar(255) default NULL,
  `ua_version` varchar(255) default NULL,
  `oem_user_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `id` (`id`)
);

--
-- Final view structure for view `Logins`
--

/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `Logins` AS select `user_action`.`id` AS `id`,`user_action`.`visitor_profile_id` AS `visitor_profile_id`,`user_action`.`action_time` AS `action_time`,`user_action`.`page_name` AS `page_name`,`user_action`.`ip_address` AS `ip_address`,`user_action`.`referrer` AS `referrer`,`user_action`.`action_name` AS `action_name`,`user_action`.`action_param1` AS `action_param1`,`user_action`.`action_param2` AS `action_param2`,`user_action`.`action_param3` AS `action_param3` from `user_action` where (`user_action`.`action_name` = _latin1'Login') order by `user_action`.`action_time` desc */;

--
-- Final view structure for view `Products_Per_Categories`
--

/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cdaadmin1`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `Products_Per_Categories` AS select `category`.`name` AS `name`,count(`product`.`id`) AS `COUNT(product.id)` from ((`product_category` join `category` on((`product_category`.`category_id` = `category`.`id`))) join `product` on((`product_category`.`product_id` = `product`.`id`))) group by `category`.`name` order by 2 desc */;

--
-- Final view structure for view `Review per Site`
--

/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `Review per Site` AS select count(`review`.`id`) AS `COUNT(review.id)`,`review`.`site` AS `site` from `review` group by `review`.`site` */;

--
-- Final view structure for view `Total Products in DB`
--

/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `Total Products in DB` AS select count(0) AS `count(*)` from `product` */;

--
-- Final view structure for view `Total Reviews in DB`
--

/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `Total Reviews in DB` AS select count(0) AS `count(*)` from `review` */;

--
-- Final view structure for view `Visitor Analytics`
--

/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `Visitor Analytics` AS select `user_action`.`action_time` AS `Date/Time`,`user_action`.`ip_address` AS `IP Address`,`visitor`.`oem_user_id` AS `OEM User ID`,`visitor`.`ua_name` AS `Browser`,`user_action`.`referrer` AS `Referrer`,`user_action`.`page_name` AS `Page Name`,`user_action`.`action_name` AS `Action Name`,`user_action`.`action_param1` AS `Action Param1`,`user_action`.`action_param2` AS `Action Param2`,`user_action`.`action_param3` AS `Action Param3` from (`user_action` join `visitor` on((`user_action`.`visitor_profile_id` = `visitor`.`id`))) order by `user_action`.`action_time` desc */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-03-26  6:01:15
