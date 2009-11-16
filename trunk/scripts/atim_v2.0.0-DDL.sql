﻿-- ATiM v2.0.0 Database Creation Script

-- DROP DATABASE IF EXISTS `atim`;
-- CREATE DATABASE `atim`;
-- USE `atim`;

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Table structure for table `acos`
--

CREATE TABLE `acos` (
  `id` int(10) NOT NULL auto_increment,
  `parent_id` int(10) default NULL,
  `model` varchar(255) character set latin1 default NULL,
  `foreign_key` int(10) default NULL,
  `alias` varchar(255) character set latin1 default NULL,
  `lft` int(10) default NULL,
  `rght` int(10) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci ;

--
-- Table structure for table `ad_blocks`
--

CREATE TABLE IF NOT EXISTS `ad_blocks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `block_type` varchar(30) DEFAULT NULL,
  `patho_dpt_block_code` varchar(30) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ad_blocks_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `block_type` varchar(30) DEFAULT NULL,
  `patho_dpt_block_code` varchar(30) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ad_bags`
--

CREATE TABLE `ad_bags` (
  `id` int(11) NOT NULL auto_increment,
  `aliquot_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `aliquot_master_id` (`aliquot_master_id` )
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `ad_bags_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `ad_cell_cores`
-- 

CREATE TABLE IF NOT EXISTS `ad_cell_cores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `gel_matrix_aliquot_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `ad_gel_matrix_id` (`gel_matrix_aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ad_cell_cores_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `gel_matrix_aliquot_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `ad_gel_matrix_id` (`gel_matrix_aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ad_cell_slides`
-- 

CREATE TABLE `ad_cell_slides` (
  `id` int(11) NOT NULL auto_increment,
  `aliquot_master_id` int(11) default NULL,
  `immunochemistry` varchar(30) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ad_cell_slides_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) default NULL,
  `immunochemistry` varchar(30) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ad_gel_matrices`
-- 

CREATE TABLE `ad_gel_matrices` (
  `id` int(11) NOT NULL auto_increment,
  `aliquot_master_id` int(11) default NULL,
  `cell_count` decimal(10,2) default NULL,
  `cell_count_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ad_gel_matrices_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) default NULL,
  `cell_count` decimal(10,2) default NULL,
  `cell_count_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ad_tissue_cores`
--

CREATE TABLE IF NOT EXISTS `ad_tissue_cores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `block_aliquot_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `ad_block_id` (`block_aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ad_tissue_cores_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `block_aliquot_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `ad_block_id` (`block_aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ad_tissue_slides`
-- 

CREATE TABLE IF NOT EXISTS `ad_tissue_slides` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `immunochemistry` varchar(30) DEFAULT NULL,
  `block_aliquot_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `ad_block_id` (`block_aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ad_tissue_slides_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `immunochemistry` varchar(30) DEFAULT NULL,
  `block_aliquot_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `ad_block_id` (`block_aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ad_tubes`
-- 

CREATE TABLE IF NOT EXISTS `ad_tubes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `lot_number` varchar(30) DEFAULT NULL,
  `concentration` decimal(10,2) DEFAULT NULL,
  `concentration_unit` varchar(20) DEFAULT NULL,
  `cell_count` decimal(10,2) DEFAULT NULL,
  `cell_count_unit` varchar(20) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ad_tubes_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `lot_number` varchar(30) DEFAULT NULL,
  `concentration` decimal(10,2) DEFAULT NULL,
  `concentration_unit` varchar(20) DEFAULT NULL,
  `cell_count` decimal(10,2) DEFAULT NULL,
  `cell_count_unit` varchar(20) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ad_whatman_papers`
-- 

CREATE TABLE `ad_whatman_papers` (
  `id` int(11) NOT NULL auto_increment,
  `aliquot_master_id` int(11) default NULL,
  `used_blood_volume` decimal(10,5) default NULL,
  `used_blood_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ad_whatman_papers_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) default NULL,
  `used_blood_volume` decimal(10,5) default NULL,
  `used_blood_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `aliquot_controls`
-- 

CREATE TABLE IF NOT EXISTS `aliquot_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aliquot_type` varchar(30) NOT NULL DEFAULT '',
  `status` enum('inactive','active') DEFAULT 'inactive',
  `form_alias` varchar(255) NOT NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `volume_unit` varchar(20) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `display_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Table structure for table `aliquot_masters`
-- 

CREATE TABLE IF NOT EXISTS `aliquot_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `barcode` varchar(60) NOT NULL DEFAULT '',
  `aliquot_type` varchar(30) NOT NULL DEFAULT '',
  `aliquot_control_id` int(11) NOT NULL DEFAULT '0',
  `collection_id` int(11) DEFAULT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `sop_master_id` int(11) DEFAULT NULL,
  `initial_volume` decimal(10,5) DEFAULT NULL,
  `current_volume` decimal(10,5) DEFAULT NULL,
  `aliquot_volume_unit` varchar(20) DEFAULT NULL,
  `status` varchar(30) DEFAULT NULL,
  `status_reason` varchar(30) DEFAULT NULL,
  `study_summary_id` int(11) DEFAULT NULL,
  `storage_datetime` datetime DEFAULT NULL,
  `storage_master_id` int(11) DEFAULT NULL,
  `storage_coord_x` varchar(11) DEFAULT NULL,
  `coord_x_order` int(3) DEFAULT NULL,
  `storage_coord_y` varchar(11) DEFAULT NULL,
  `coord_y_order` int(3) DEFAULT NULL,
  `product_code` varchar(20) DEFAULT NULL,
  `notes` text,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `aliquot_control_id` (`aliquot_control_id`),
  KEY `collection_id` (`collection_id`),
  KEY `sample_master_id` (`sample_master_id`),
  KEY `sop_master_id` (`sop_master_id`),
  KEY `study_summary_id` (`study_summary_id`),
  KEY `aliquot_masters_ibfk_6` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `aliquot_masters_revs` (
  `id` int(11) NOT NULL,
  `barcode` varchar(60) NOT NULL DEFAULT '',
  `aliquot_type` varchar(30) NOT NULL DEFAULT '',
  `aliquot_control_id` int(11) NOT NULL DEFAULT '0',
  `collection_id` int(11) DEFAULT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `sop_master_id` int(11) DEFAULT NULL,
  `initial_volume` decimal(10,5) DEFAULT NULL,
  `current_volume` decimal(10,5) DEFAULT NULL,
  `aliquot_volume_unit` varchar(20) DEFAULT NULL,
  `status` varchar(30) DEFAULT NULL,
  `status_reason` varchar(30) DEFAULT NULL,
  `study_summary_id` int(11) DEFAULT NULL,
  `storage_datetime` datetime DEFAULT NULL,
  `storage_master_id` int(11) DEFAULT NULL,
  `storage_coord_x` varchar(11) DEFAULT NULL,
  `coord_x_order` int(3) DEFAULT NULL,
  `storage_coord_y` varchar(11) DEFAULT NULL,
  `coord_y_order` int(3) DEFAULT NULL,
  `product_code` varchar(20) DEFAULT NULL,
  `notes` text,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `aliquot_control_id` (`aliquot_control_id`),
  KEY `collection_id` (`collection_id`),
  KEY `sample_master_id` (`sample_master_id`),
  KEY `sop_master_id` (`sop_master_id`),
  KEY `study_summary_id` (`study_summary_id`),
  KEY `aliquot_masters_ibfk_6` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `aliquot_uses`
-- 

CREATE TABLE `aliquot_uses` (
  `id` int(11) NOT NULL auto_increment,
  `aliquot_master_id` int(11) default NULL,
  `use_definition` varchar(30) default NULL,
  `use_details` varchar(250) default NULL,
  `use_recorded_into_table` varchar(40) default NULL,
  `used_volume` decimal(10,5) default NULL,
  `use_datetime` datetime default NULL,
  `study_summary_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `study_summary_id` (`study_summary_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `aliquot_uses_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) default NULL,
  `use_definition` varchar(30) default NULL,
  `use_details` varchar(250) default NULL,
  `use_recorded_into_table` varchar(40) default NULL,
  `used_volume` decimal(10,5) default NULL,
  `use_datetime` datetime default NULL,
  `study_summary_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `study_summary_id` (`study_summary_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `announcements`
-- 

CREATE TABLE `announcements` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `group_id` int(11) default NULL,
  `bank_id` int(11) default NULL default '0',
  `date` date NOT NULL default '0000-00-00',
  `title` varchar(255) NOT NULL default '',
  `body` text NOT NULL,
  `date_start` date NOT NULL default '0000-00-00',
  `date_end` date NOT NULL default '0000-00-00',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(255) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `aros`
-- 

CREATE TABLE `aros` (
  `id` int(10) NOT NULL auto_increment,
  `parent_id` int(10) default NULL,
  `model` varchar(255) character set latin1 default NULL,
  `foreign_key` int(10) default NULL,
  `alias` varchar(255) character set latin1 default NULL,
  `lft` int(10) default NULL,
  `rght` int(10) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `aros_acos`
-- 

CREATE TABLE `aros_acos` (
  `id` int(10) NOT NULL auto_increment,
  `aro_id` int(10) NOT NULL,
  `aco_id` int(10) NOT NULL,
  `_create` varchar(2) character set latin1 NOT NULL default '0',
  `_read` varchar(2) character set latin1 NOT NULL default '0',
  `_update` varchar(2) character set latin1 NOT NULL default '0',
  `_delete` varchar(2) character set latin1 NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `ARO_ACO_KEY` (`aro_id`,`aco_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci ;

-- 
-- Table structure for table `atim_information`
-- 

CREATE TABLE `atim_information` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `tablename` VARCHAR(255),
  `field` VARCHAR(255),
  `data_element_identifier` VARCHAR(225),
  `datatype` VARCHAR(255),
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) default NULL,
  PRIMARY KEY( `id` )
) ENGINE=INNODB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

--
-- Table structure for table `banks`
-- 

CREATE TABLE `banks` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `description` text NOT NULL,
  `created_by` int(11) NOT NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` int(11) NOT NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `banks_revs` (
  `version_id` int(11) NOT NULL auto_increment,
  `version_created` datetime NOT NULL,
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL default '',
  `description` text NOT NULL,
  `created_by` int(11) NOT NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` int(11) NOT NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `cd_atypes`
--

CREATE TABLE IF NOT EXISTS `cd_atypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consent_master_id` int(11) NOT NULL,
  `data` varchar(50) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `cd_atypes_revs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consent_master_id` int(11) NOT NULL,
  `data` varchar(50) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `cd_btypes`
--

CREATE TABLE IF NOT EXISTS `cd_btypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consent_master_id` int(11) NOT NULL,
  `data` varchar(50) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `cd_btypes_revs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consent_master_id` int(11) NOT NULL,
  `data` varchar(50) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `clinical_collection_links`
-- 

CREATE TABLE IF NOT EXISTS `clinical_collection_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `participant_id` int(11) DEFAULT NULL,
  `collection_id` int(11) DEFAULT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  `consent_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL DEFAULT '',
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `participant_id` (`participant_id`),
  INDEX `collection_id` (`collection_id`),
  INDEX `diagnosis_master_id` (`diagnosis_master_id`),
  INDEX `consent_master_id` (`consent_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `clinical_collection_links_revs` (
  `id` int(11) NOT NULL,
  `participant_id` int(11) DEFAULT NULL,
  `collection_id` int(11) DEFAULT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  `consent_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL DEFAULT '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  INDEX `participant_id` (`participant_id`),
  INDEX `collection_id` (`collection_id`),
  INDEX `diagnosis_master_id` (`diagnosis_master_id`),
  INDEX `consent_master_id` (`consent_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `coding_adverse_events`
-- 

CREATE TABLE `coding_adverse_events` (
  `id` int(11) NOT NULL auto_increment,
  `category` varchar(50) NOT NULL default '',
  `supra-ordinate_term` varchar(255) NOT NULL default '',
  `select_ae` varchar(255) default NULL,
  `grade` int(11) NOT NULL default '0',
  `description` text NOT NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `coding_adverse_events_revs` (
  `id` int(11) NOT NULL,
  `category` varchar(50) NOT NULL default '',
  `supra-ordinate_term` varchar(255) NOT NULL default '',
  `select_ae` varchar(255) default NULL,
  `grade` int(11) NOT NULL default '0',
  `description` text NOT NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `coding_icd10`
-- 

CREATE TABLE `coding_icd10` (
  `id` varchar(10) NOT NULL default '',
  `category` varchar(50) NOT NULL default '',
  `icd_group` varchar(50) NOT NULL default '',
  `site` varchar(50) NOT NULL default '',
  `subsite` varchar(50) NOT NULL default '',
  `description` varchar(250) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 
-- Table structure for table `collections`
-- 

CREATE TABLE IF NOT EXISTS `collections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `acquisition_label` varchar(50) NOT NULL DEFAULT '',
  `bank_id` int(11) DEFAULT NULL,
  `collection_site` varchar(30) DEFAULT NULL,
  `collection_datetime` datetime DEFAULT NULL,
  `reception_by` varchar(50) DEFAULT NULL,
  `reception_datetime` datetime DEFAULT NULL,
  `sop_master_id` int(11) DEFAULT NULL,
  `collection_property` varchar(50) DEFAULT NULL,
  `collection_notes` text,
  `erlab_number` int(11) DEFAULT NULL,
  `mb_tbnumber` varchar(50) DEFAULT NULL,
  `path_report_num` varchar(50) DEFAULT NULL,
  `protected` varchar(20) DEFAULT NULL,
  `case_type` varchar(50) DEFAULT NULL,
  `case_other` varchar(20) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sop_master_id` (`sop_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `collections_revs` (
  `id` int(11) NOT NULL,
  `acquisition_label` varchar(50) NOT NULL DEFAULT '',
  `bank` varchar(50) DEFAULT NULL,
  `collection_site` varchar(30) DEFAULT NULL,
  `collection_datetime` datetime DEFAULT NULL,
  `reception_by` varchar(50) DEFAULT NULL,
  `reception_datetime` datetime DEFAULT NULL,
  `sop_master_id` int(11) DEFAULT NULL,
  `collection_property` varchar(50) DEFAULT NULL,
  `collection_notes` text,
  `erlab_number` int(11) DEFAULT NULL,
  `mb_tbnumber` varchar(50) DEFAULT NULL,
  `path_report_num` varchar(50) DEFAULT NULL,
  `protected` varchar(20) DEFAULT NULL,
  `case_type` varchar(50) DEFAULT NULL,
  `case_other` varchar(20) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `sop_master_id` (`sop_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `configs`
-- 

CREATE TABLE `configs` (
  `id` int(11) NOT NULL auto_increment,
  `bank_id` int(11) default NULL,
  `group_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `config_debug` varchar(255) NOT NULL default '0',
  `config_language` varchar(255) NOT NULL default 'eng',
  `define_date_format` varchar(255) NOT NULL default 'MDY',
  `define_csv_separator` varchar(255) NOT NULL default ',',
  `define_show_help` varchar(255) NOT NULL default '1',
  `define_show_summary` varchar(255) NOT NULL default '1',
  `define_pagination_amount` varchar(255) NOT NULL default '10',
  `created` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  `modified` datetime NOT NULL,
  `modified_by` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci AUTO_INCREMENT=1 ;

--
-- Table structure for table `consent_controls`
--

CREATE TABLE IF NOT EXISTS `consent_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `controls_type` varchar(6) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'active',
  `form_alias` varchar(255) NOT NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `consent_masters`
--

CREATE TABLE IF NOT EXISTS `consent_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date DEFAULT NULL,
  `form_version` varchar(50) DEFAULT NULL,
  `reason_denied` varchar(200) DEFAULT NULL,
  `consent_status` varchar(50) DEFAULT NULL,
  `status_date` date DEFAULT NULL,
  `surgeon` varchar(50) DEFAULT NULL,
  `contact_method` varchar(50) DEFAULT NULL,
  `operation_date` datetime DEFAULT NULL,
  `facility` varchar(50) DEFAULT NULL,
  `memo` text,
  `biological_material_use` varchar(50) DEFAULT NULL,
  `use_of_tissue` varchar(50) DEFAULT NULL,
  `contact_future_research` varchar(50) DEFAULT NULL,
  `access_medical_information` varchar(50) DEFAULT NULL,
  `use_of_blood` varchar(50) DEFAULT NULL,
  `use_of_urine` varchar(50) DEFAULT NULL,
  `research_other_disease` varchar(50) DEFAULT NULL,
  `inform_significant_discovery` varchar(50) DEFAULT NULL,
  `facility_other` varchar(50) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `consent_master_id` int(11) DEFAULT NULL,
  `acquisition_id` varchar(10) DEFAULT NULL,
  `participant_id` int(11) DEFAULT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `consent_control_id` int(11) unsigned NOT NULL,
  `type` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  INDEX `diagnosis_id` (`diagnosis_master_id`),
  INDEX `participant_id` (`participant_id`),
  INDEX `consent_control_id` (`consent_control_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `consent_masters_revs` (
  `id` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `form_version` varchar(50) DEFAULT NULL,
  `reason_denied` varchar(200) DEFAULT NULL,
  `consent_status` varchar(50) DEFAULT NULL,
  `status_date` date DEFAULT NULL,
  `surgeon` varchar(50) DEFAULT NULL,
  `contact_method` varchar(50) DEFAULT NULL,
  `operation_date` datetime DEFAULT NULL,
  `facility` varchar(50) DEFAULT NULL,
  `memo` text,
  `biological_material_use` varchar(50) DEFAULT NULL,
  `use_of_tissue` varchar(50) DEFAULT NULL,
  `contact_future_research` varchar(50) DEFAULT NULL,
  `access_medical_information` varchar(50) DEFAULT NULL,
  `use_of_blood` varchar(50) DEFAULT NULL,
  `use_of_urine` varchar(50) DEFAULT NULL,
  `research_other_disease` varchar(50) DEFAULT NULL,
  `inform_significant_discovery` varchar(50) DEFAULT NULL,
  `facility_other` varchar(50) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `consent_master_id` int(11) DEFAULT NULL,
  `acquisition_id` varchar(10) DEFAULT NULL,
  `participant_id` int(11) DEFAULT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `consent_control_id` int(11) unsigned NOT NULL,
  `type` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`version_id`),
  INDEX `diagnosis_id` (`diagnosis_master_id`),
  INDEX `participant_id` (`participant_id`),
  INDEX `consent_control_id` (`consent_control_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `datamart_adhoc`
-- 

CREATE TABLE `datamart_adhoc` (
  `id` int(11) NOT NULL auto_increment,
  `description` text,
  `plugin` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL default '',
  `form_alias_for_search` varchar(255) default NULL,
  `form_alias_for_results` varchar(255) default NULL,
  `form_links_for_results` varchar(255) default NULL,
  `sql_query_for_results` text NOT NULL,
  `flag_use_query_results` tinyint(4) NOT NULL default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(255) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `datamart_adhoc_favourites`
-- 

CREATE TABLE `datamart_adhoc_favourites` (
  `id` int(11) NOT NULL auto_increment,
  `adhoc_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `datamart_adhoc_saved`
-- 

CREATE TABLE `datamart_adhoc_saved` (
  `id` int(11) NOT NULL auto_increment,
  `adhoc_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `search_params` text NOT NULL,
  `description` text NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `datamart_batch_ids`
-- 

CREATE TABLE `datamart_batch_ids` (
  `id` int(11) NOT NULL auto_increment,
  `set_id` int(11) default NULL,
  `lookup_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `datamart_batch_processes`
-- 

CREATE TABLE `datamart_batch_processes` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `plugin` varchar(100) NOT NULL,
  `model` varchar(255) NOT NULL default '',
  `url` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `datamart_batch_sets`
-- 

CREATE TABLE `datamart_batch_sets` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `group_id` int(11) default NULL,
  `description` text NOT NULL,
  `plugin` varchar(100) NOT NULL,
  `model` varchar(255) NOT NULL default '',
  `form_alias_for_results` varchar(255) NOT NULL,
  `sql_query_for_results` text NOT NULL,
  `form_links_for_results` text NOT NULL,
  `flag_use_query_results` tinyint(4) NOT NULL default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(255) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `derivative_details`
-- 

CREATE TABLE `derivative_details` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `creation_site` varchar(30) default NULL,
  `creation_by` varchar(50) default NULL,
  `creation_datetime` datetime default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `derivative_details_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `creation_site` varchar(30) default NULL,
  `creation_by` varchar(50) default NULL,
  `creation_datetime` datetime default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `parent_to_derivative_sample_controls`
-- 

CREATE TABLE `parent_to_derivative_sample_controls` (
  `id` int(11) NOT NULL auto_increment,
  `parent_sample_control_id` int(11) default NULL,
  `derivative_sample_control_id` int(11) default NULL,
  `status` varchar(20) default NULL,
  PRIMARY KEY  (`id`),
  KEY `parent_sample_control_id` (`parent_sample_control_id`),
  KEY `derivative_sample_control_id` (`derivative_sample_control_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `diagnosis_controls`
--

CREATE TABLE IF NOT EXISTS `diagnosis_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `controls_type` varchar(6) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'active',
  `form_alias` varchar(255) NOT NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `diagnosis_controls_revs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `controls_type` varchar(6) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'active',
  `form_alias` varchar(255) NOT NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `diagnosis_masters`
--

CREATE TABLE IF NOT EXISTS `diagnosis_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dx_number` varchar(50) DEFAULT NULL,
  `dx_method` varchar(20) DEFAULT NULL,
  `dx_nature` varchar(20) DEFAULT NULL,
  `dx_origin` varchar(50) DEFAULT NULL,
  `dx_date` date DEFAULT NULL,
  `icd10_id` varchar(10) DEFAULT NULL,
  `morphology` varchar(50) DEFAULT NULL,
  `laterality` varchar(50) DEFAULT NULL,
  `information_source` varchar(30) DEFAULT NULL,
  `age_at_dx` int(11) DEFAULT NULL,
  `age_at_dx_status` varchar(100) DEFAULT NULL,
  `case_number` int(11) DEFAULT NULL,
  `clinical_stage` varchar(50) DEFAULT NULL,
  `collaborative_stage` varchar(50) DEFAULT NULL,
  `tstage` varchar(5) DEFAULT NULL,
  `nstage` varchar(5) DEFAULT NULL,
  `mstage` varchar(5) DEFAULT NULL,
  `stage_grouping` varchar(5) DEFAULT NULL,
  `clinical_tstage` varchar(5) DEFAULT NULL,
  `clinical_nstage` varchar(5) DEFAULT NULL,
  `clinical_mstage` varchar(5) DEFAULT NULL,
  `clinical_stage_grouping` varchar(5) DEFAULT NULL,
  `path_tstage` varchar(5) DEFAULT NULL,
  `path_nstage` varchar(5) DEFAULT NULL,
  `path_mstage` varchar(5) DEFAULT NULL,
  `path_stage_grouping` varchar(5) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `participant_id` int(11) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `diagnosis_control_id` int(11) unsigned NOT NULL DEFAULT '0',
  `type` varchar(6) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  INDEX `participant_id` (`participant_id`),
  INDEX `diagnosis_control_id` (`diagnosis_control_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `diagnosis_masters_revs` (
  `id` int(11) NOT NULL,
  `dx_number` varchar(50) DEFAULT NULL,
  `dx_method` varchar(20) DEFAULT NULL,
  `dx_nature` varchar(20) DEFAULT NULL,
  `dx_origin` varchar(50) DEFAULT NULL,
  `dx_date` date DEFAULT NULL,
  `icd10_id` varchar(10) DEFAULT NULL,
  `morphology` varchar(50) DEFAULT NULL,
  `laterality` varchar(50) DEFAULT NULL,
  `information_source` varchar(30) DEFAULT NULL,
  `age_at_dx` int(11) DEFAULT NULL,
  `age_at_dx_status` varchar(100) DEFAULT NULL,
  `case_number` int(11) DEFAULT NULL,
  `clinical_stage` varchar(50) DEFAULT NULL,
  `collaborative_stage` varchar(50) DEFAULT NULL,
  `tstage` varchar(5) DEFAULT NULL,
  `nstage` varchar(5) DEFAULT NULL,
  `mstage` varchar(5) DEFAULT NULL,
  `stage_grouping` varchar(5) DEFAULT NULL,
  `clinical_tstage` varchar(5) DEFAULT NULL,
  `clinical_nstage` varchar(5) DEFAULT NULL,
  `clinical_mstage` varchar(5) DEFAULT NULL,
  `clinical_stage_grouping` varchar(5) DEFAULT NULL,
  `path_tstage` varchar(5) DEFAULT NULL,
  `path_nstage` varchar(5) DEFAULT NULL,
  `path_mstage` varchar(5) DEFAULT NULL,
  `path_stage_grouping` varchar(5) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `participant_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `diagnosis_control_id` int(11) unsigned NOT NULL DEFAULT '0',
  `type` varchar(6) NOT NULL DEFAULT '',
  PRIMARY KEY (`version_id`),
  INDEX `participant_id` (`participant_id`),
  INDEX `diagnosis_control_id` (`diagnosis_control_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `drugs`
-- 

CREATE TABLE `drugs` (
  `id` int(11) NOT NULL auto_increment,
  `generic_name` varchar(50) NOT NULL default '',
  `trade_name` varchar(50) NOT NULL default '',
  `type` varchar(50) default NULL,
  `description` text default NULL,
  `created` datetime NOT NULL default '0000-00-00',
  `created_by` int(11) NOT NULL default 0,
  `modified` datetime NOT NULL default '0000-00-00',
  `modified_by` int(11) NOT NULL default 0,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `drugs_revs` (
  `id` int(11) NOT NULL,
  `generic_name` varchar(50) NOT NULL default '',
  `trade_name` varchar(50) NOT NULL default '',
  `type` varchar(50) default NULL,
  `description` text default NULL,
  `created` datetime NOT NULL default '0000-00-00',
  `created_by` int(11) NOT NULL default 0,
  `modified` datetime NOT NULL default '0000-00-00',
  `modified_by` int(11) NOT NULL default 0,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `ed_allsolid_lab_pathology`
-- 

CREATE TABLE `ed_allsolid_lab_pathology` (
  `id` int(11) NOT NULL auto_increment,
  `tumour_type` varchar(50) default NULL,
  `resection_margin` varchar(50) default NULL,
  `extra_nodal_invasion` varchar(50) default NULL,
  `lymphatic_vascular_invasion` varchar(50) default NULL,
  `in_situ_component` varchar(50) default NULL,
  `fine_needle_aspirate` varchar(50) default NULL,
  `trucut_core_biopsy` varchar(50) default NULL,
  `open_biopsy` varchar(50) default NULL,
  `frozen_section` varchar(50) default NULL,
  `breast_tumour_size` varchar(50) default NULL,
  `nodes_removed` varchar(50) default NULL,
  `nodes_positive` varchar(50) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_allsolid_lab_pathology_revs` (
  `id` int(11) NOT NULL,
  `tumour_type` varchar(50) default NULL,
  `resection_margin` varchar(50) default NULL,
  `extra_nodal_invasion` varchar(50) default NULL,
  `lymphatic_vascular_invasion` varchar(50) default NULL,
  `in_situ_component` varchar(50) default NULL,
  `fine_needle_aspirate` varchar(50) default NULL,
  `trucut_core_biopsy` varchar(50) default NULL,
  `open_biopsy` varchar(50) default NULL,
  `frozen_section` varchar(50) default NULL,
  `breast_tumour_size` varchar(50) default NULL,
  `nodes_removed` varchar(50) default NULL,
  `nodes_positive` varchar(50) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ed_all_adverse_events_adverse_event`
-- 

CREATE TABLE `ed_all_adverse_events_adverse_event` (
  `id` int(11) NOT NULL auto_increment,
  `supra_ordinate_term` varchar(50) default NULL,
  `select_ae` varchar(50) default NULL,
  `grade` varchar(50) default NULL,
  `description` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_all_adverse_events_adverse_event_revs` (
  `id` int(11) NOT NULL,
  `supra_ordinate_term` varchar(50) default NULL,
  `select_ae` varchar(50) default NULL,
  `grade` varchar(50) default NULL,
  `description` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ed_all_clinical_followup`
-- 

CREATE TABLE `ed_all_clinical_followup` (
  `id` int(11) NOT NULL auto_increment,
  `weight` int(11) default NULL,
  `recurrence_status` varchar(50) default NULL,
  `disease_status` varchar(50) default NULL,
  `vital_status` varchar(50) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_all_clinical_followup_revs` (
  `id` int(11) NOT NULL,
  `weight` int(11) default NULL,
  `recurrence_status` varchar(50) default NULL,
  `disease_status` varchar(50) default NULL,
  `vital_status` varchar(50) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ed_all_clinical_presentation`
-- 

CREATE TABLE `ed_all_clinical_presentation` (
  `id` int(11) NOT NULL auto_increment,
  `weight` int(11) default NULL,
  `height` int(11) default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `event_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_all_clinical_presentation_revs` (
  `id` int(11) NOT NULL,
  `weight` int(11) default NULL,
  `height` int(11) default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `event_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ed_all_lifestyle_base`
--

CREATE TABLE `ed_all_lifestyle_base` (
  `id` int(11) NOT NULL auto_increment,
  `smoking_history` varchar(50) default NULL,
  `smoking_status` varchar(50) default NULL,
  `pack_years` date default NULL,
  `product_used` varchar(50) default NULL,
  `years_quit_smoking` int(11) default NULL,
  `alcohol_history` varchar(50) default NULL,
  `weight_loss` float default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_all_lifestyle_base_revs` (
  `id` int(11) NOT NULL,
  `smoking_history` varchar(50) default NULL,
  `smoking_status` varchar(50) default NULL,
  `pack_years` date default NULL,
  `product_used` varchar(50) default NULL,
  `years_quit_smoking` int(11) default NULL,
  `alcohol_history` varchar(50) default NULL,
  `weight_loss` float default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ed_all_protocol_followup`
--

CREATE TABLE `ed_all_protocol_followup` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_all_protocol_followup_revs` (
  `id` int(11) NOT NULL,
  `title` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ed_all_study_research`
-- 

CREATE TABLE `ed_all_study_research` (
  `id` int(11) NOT NULL auto_increment,
  `field_one` varchar(50) default NULL,
  `field_two` varchar(50) default NULL,
  `field_three` varchar(50) default NULL,
  `event_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_all_study_research_revs` (
  `id` int(11) NOT NULL,
  `field_one` varchar(50) default NULL,
  `field_two` varchar(50) default NULL,
  `field_three` varchar(50) default NULL,
  `event_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ed_breast_lab_pathology`
--

CREATE TABLE `ed_breast_lab_pathology` (
  `id` int(11) NOT NULL auto_increment,
  `path_number` varchar(50) default NULL,
  `report_type` varchar(50) default NULL,
  `facility` varchar(50) default NULL,
  `vascular_lymph_invasion` varchar(50) default NULL,
  `extra_nodal_invasion` varchar(50) default NULL,
  `blood_lymph` varchar(50) default NULL,
  `tumour_type` varchar(50) default NULL,
  `grade` varchar(50) default NULL,
  `multifocal` varchar(50) default NULL,
  `preneoplastic_changes` varchar(50) default NULL,
  `spread_skin_nipple` varchar(50) default NULL,
  `level_nodal_involvement` varchar(50) default NULL,
  `frozen_section` varchar(50) default NULL,
  `er_assay_ligand` varchar(50) default NULL,
  `pr_assay_ligand` varchar(50) default NULL,
  `progesterone` varchar(50) default NULL,
  `estrogen` varchar(50) default NULL,
  `number_resected` varchar(50) default NULL,
  `number_positive` varchar(50) default NULL,
  `nodal_status` varchar(45) default NULL,
  `resection_margins` varchar(50) default NULL,
  `tumour_size` varchar(50) default NULL,
  `tumour_total_size` varchar(45) default NULL,
  `sentinel_only` varchar(50) default NULL,
  `in_situ_type` varchar(50) default NULL,
  `her2_grade` varchar(50) default NULL,
  `her2_method` varchar(50) default NULL,
  `mb_collectionid` varchar(45) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_breast_lab_pathology_revs` (
  `id` int(11) NOT NULL,
  `path_number` varchar(50) default NULL,
  `report_type` varchar(50) default NULL,
  `facility` varchar(50) default NULL,
  `vascular_lymph_invasion` varchar(50) default NULL,
  `extra_nodal_invasion` varchar(50) default NULL,
  `blood_lymph` varchar(50) default NULL,
  `tumour_type` varchar(50) default NULL,
  `grade` varchar(50) default NULL,
  `multifocal` varchar(50) default NULL,
  `preneoplastic_changes` varchar(50) default NULL,
  `spread_skin_nipple` varchar(50) default NULL,
  `level_nodal_involvement` varchar(50) default NULL,
  `frozen_section` varchar(50) default NULL,
  `er_assay_ligand` varchar(50) default NULL,
  `pr_assay_ligand` varchar(50) default NULL,
  `progesterone` varchar(50) default NULL,
  `estrogen` varchar(50) default NULL,
  `number_resected` varchar(50) default NULL,
  `number_positive` varchar(50) default NULL,
  `nodal_status` varchar(45) default NULL,
  `resection_margins` varchar(50) default NULL,
  `tumour_size` varchar(50) default NULL,
  `tumour_total_size` varchar(45) default NULL,
  `sentinel_only` varchar(50) default NULL,
  `in_situ_type` varchar(50) default NULL,
  `her2_grade` varchar(50) default NULL,
  `her2_method` varchar(50) default NULL,
  `mb_collectionid` varchar(45) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ed_breast_screening_mammogram`
-- 

CREATE TABLE `ed_breast_screening_mammogram` (
  `id` int(11) NOT NULL auto_increment,
  `result` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_breast_screening_mammogram_revs` (
  `id` int(11) NOT NULL,
  `result` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `event_controls`
-- 

CREATE TABLE `event_controls` (
  `id` int(11) NOT NULL auto_increment,
  `disease_site` varchar(50) NOT NULL default '',
  `event_group` varchar(50) NOT NULL default '',
  `event_type` varchar(50) NOT NULL default '',
  `status` varchar(50) NOT NULL default '',
  `form_alias` varchar(255) NOT NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL default 0,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `event_masters`
-- 

CREATE TABLE IF NOT EXISTS `event_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_control_id` int(11) NOT NULL DEFAULT '0',
  `disease_site` varchar(255) NOT NULL DEFAULT '',
  `event_group` varchar(50) NOT NULL DEFAULT '',
  `event_type` varchar(50) NOT NULL DEFAULT '',
  `event_status` varchar(50) DEFAULT NULL,
  `event_summary` text,
  `event_date` date DEFAULT NULL,
  `information_source` varchar(255) DEFAULT NULL,
  `urgency` varchar(50) DEFAULT NULL,
  `date_required` date DEFAULT NULL,
  `date_requested` date DEFAULT NULL,
  `reference_number` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL DEFAULT '',
  `participant_id` int(11) DEFAULT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `participant_id` (`participant_id`),
  INDEX `diagnosis_id` (`diagnosis_master_id`),
  INDEX `event_control_id` (`event_control_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `event_masters_revs` (
  `id` int(11) NOT NULL,
  `event_control_id` int(11) NOT NULL DEFAULT '0',
  `disease_site` varchar(255) NOT NULL DEFAULT '',
  `event_group` varchar(50) NOT NULL DEFAULT '',
  `event_type` varchar(50) NOT NULL DEFAULT '',
  `event_status` varchar(50) DEFAULT NULL,
  `event_summary` text,
  `event_date` date DEFAULT NULL,
  `information_source` varchar(255) DEFAULT NULL,
  `urgency` varchar(50) DEFAULT NULL,
  `date_required` date DEFAULT NULL,
  `date_requested` date DEFAULT NULL,
  `reference_number` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL DEFAULT '',
  `form_alias` varchar(255) NOT NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `participant_id` int(11) DEFAULT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  INDEX `participant_id` (`participant_id`),
  INDEX `diagnosis_id` (`diagnosis_master_id`),
  INDEX `event_control_id` (`event_control_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `family_histories`
-- 

CREATE TABLE `family_histories` (
  `id` int(11) NOT NULL auto_increment,
  `relation` varchar(20) default NULL,
  `domain` varchar(20) default NULL,
  `icd10_id` varchar(5) default NULL,
  `dx_date` date default NULL,
  `dx_date_status` char(1) default NULL,
  `age_at_dx` smallint(6) default NULL,
  `age_at_dx_status` varchar(100) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `participant_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  INDEX `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `family_histories_revs` (
  `id` int(11) NOT NULL,
  `relation` varchar(20) default NULL,
  `domain` varchar(20) default NULL,
  `icd10_id` varchar(5) default NULL,
  `dx_date` date default NULL,
  `dx_date_status` char(1) default NULL,
  `age_at_dx` smallint(6) default NULL,
  `age_at_dx_status` varchar(100) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `participant_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  INDEX `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `groups`
-- 

CREATE TABLE `groups` (
  `id` int(11) NOT NULL auto_increment,
  `bank_id` int(11) default NULL,
  `name` varchar(100) character set latin1 NOT NULL,
  `created` datetime default NULL,
  `modified` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `i18n`
--

CREATE TABLE `i18n` (
  `id` varchar(100) NOT NULL default '',
  `page_id` varchar(100) default NULL,
  `en` text NOT NULL,
  `fr` text NOT NULL,
  PRIMARY KEY  (`id`,`page_id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 
-- Table structure for table `langs`
--

CREATE TABLE `langs` (
  `id` varchar(100) NOT NULL default '',
  `name` varchar(100) NOT NULL default '',
  `meta` varchar(100) NOT NULL default '',
  `error_text` varchar(100) NOT NULL default '',
  `encoding` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 
-- Table structure for table `materials`
-- 

CREATE TABLE `materials` (
  `id` int(11) NOT NULL auto_increment,
  `item_name` varchar(50) NOT NULL,
  `item_type` varchar(50) default NULL,
  `description` varchar(255) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `materials_revs` (
  `id` int(11) NOT NULL,
  `item_name` varchar(50) NOT NULL,
  `item_type` varchar(50) default NULL,
  `description` varchar(255) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `menus`
-- 

CREATE TABLE IF NOT EXISTS `menus` (
  `id` varchar(255) NOT NULL DEFAULT '',
  `parent_id` varchar(255) DEFAULT NULL,
  `is_root` int(11) NOT NULL DEFAULT '0',
  `display_order` int(11) NOT NULL DEFAULT '0',
  `language_title` text NOT NULL,
  `language_description` text,
  `use_link` varchar(255) NOT NULL DEFAULT '',
  `use_params` varchar(255) NOT NULL,
  `use_summary` varchar(255) NOT NULL,
  `active` varchar(255) NOT NULL DEFAULT 'yes',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(255) NOT NULL DEFAULT '',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `misc_identifiers`
--

CREATE TABLE `misc_identifiers` (
  `id` int(11) NOT NULL auto_increment,
  `identifier_value` varchar(40) default NULL,
  `name` varchar(50) default NULL,
  `identifier_abrv` varchar(20) default NULL,
  `effective_date` date default NULL,
  `expiry_date` date default NULL,
  `memo` varchar(100) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `participant_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  INDEX `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `misc_identifiers_revs` (
  `id` int(11) NOT NULL,
  `identifier_value` varchar(40) default NULL,
  `name` varchar(50) default NULL,
  `identifier_abrv` varchar(20) default NULL,
  `effective_date` date default NULL,
  `expiry_date` date default NULL,
  `memo` varchar(100) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `participant_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted`  int(11) default NULL,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  INDEX `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `orders`
-- 

CREATE TABLE `orders` (
  `id` int(11) NOT NULL auto_increment,
  `order_number` varchar(255) NOT NULL,
  `short_title` varchar(45) default NULL,
  `description` varchar(255) default NULL,
  `date_order_placed` date default NULL,
  `date_order_completed` date default NULL,
  `processing_status` varchar(45) default NULL,
  `comments` varchar(255) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(45) default NULL,
  `study_summary_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `orders_revs` (
  `id` int(11) NOT NULL,
  `order_number` varchar(255) NOT NULL,
  `short_title` varchar(45) default NULL,
  `description` varchar(255) default NULL,
  `date_order_placed` date default NULL,
  `date_order_completed` date default NULL,
  `processing_status` varchar(45) default NULL,
  `comments` varchar(255) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(45) default NULL,
  `study_summary_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `order_items`
-- 

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL auto_increment,
  `barcode` varchar(255) default NULL,
  `base_price` varchar(255) default NULL,
  `date_added` date default NULL,
  `added_by` varchar(255) default NULL,
  `datetime_scanned_out` datetime default NULL,
  `status` varchar(255) default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `orderline_id` int(11) default NULL,
  `shipment_id` int(11) default NULL,
  `aliquot_master_id` int(11) default NULL,
  `aliquot_use_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `order_items_revs` (
  `id` int(11) NOT NULL,
  `barcode` varchar(255) default NULL,
  `base_price` varchar(255) default NULL,
  `date_added` date default NULL,
  `added_by` varchar(255) default NULL,
  `datetime_scanned_out` datetime default NULL,
  `status` varchar(255) default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `orderline_id` int(11) default NULL,
  `shipment_id` int(11) default NULL,
  `aliquot_master_id` int(11) default NULL,
  `aliquot_use_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `order_lines`
-- 

CREATE TABLE `order_lines` (
  `id` int(11) NOT NULL auto_increment,
  `cancer_type` varchar(255) default NULL,
  `quantity_ordered` int(255) default NULL,
  `quantity_UM` varchar(255) default NULL,
  `min_qty_ordered` int(11) default NULL,
  `min_qty_UM` varchar(50) default NULL,
  `base_price` varchar(255) default NULL,
  `date_required` date default NULL,
  `quantity_shipped` int(11) default NULL,
  `status` varchar(255) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `discount_id` int(11) default NULL,
  `product_id` int(11) default NULL,
  `sample_control_id` int(11) default NULL,
  `order_id` int(11) NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `order_lines_revs` (
  `id` int(11) NOT NULL,
  `cancer_type` varchar(255) default NULL,
  `quantity_ordered` int(255) default NULL,
  `quantity_UM` varchar(255) default NULL,
  `min_qty_ordered` int(11) default NULL,
  `min_qty_UM` varchar(50) default NULL,
  `base_price` varchar(255) default NULL,
  `date_required` date default NULL,
  `quantity_shipped` int(11) default NULL,
  `status` varchar(255) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `discount_id` int(11) default NULL,
  `product_id` int(11) default NULL,
  `sample_control_id` int(11) default NULL,
  `order_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `pages`
-- 

CREATE TABLE `pages` (
  `id` varchar(100) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `error_flag` tinyint(4) NOT NULL default '0',
  `language_title` varchar(255) NOT NULL default '',
  `language_body` text NOT NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(255) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 
-- Table structure for table `participants`
-- 

CREATE TABLE `participants` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(10) NOT NULL default '',
  `first_name` varchar(20) default NULL,
  `last_name` varchar(20) default NULL,
  `middle_name` varchar(50) default NULL,
  `date_of_birth` date default NULL,
  `date_status` char(1) default NULL,
  `marital_status` varchar(50) default NULL,
  `language_preferred` varchar(30) default NULL,
  `sex` char(1) default NULL,
  `race` varchar(30) default NULL,
  `ethnicity` varchar(30) default NULL,
  `vital_status` varchar(50) default NULL,
  `memo` varchar(200) default NULL,
  `status` varchar(10) default NULL,
  `date_of_death` date default NULL,
  `death_certificate_ident` varchar(20) NOT NULL default '',
  `icd10_id` varchar(50) default NULL,
  `confirmation_source` varchar(50) NOT NULL default '',
  `tb_number` varchar(50) default NULL,
  `last_chart_checked_date` date default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `participants_revs` (
  `id` int(11) NOT NULL,
  `title` varchar(10) NOT NULL default '',
  `first_name` varchar(20) default NULL,
  `last_name` varchar(20) default NULL,
  `middle_name` varchar(50) default NULL,
  `date_of_birth` date default NULL,
  `date_status` char(1) default NULL,
  `marital_status` varchar(50) default NULL,
  `language_preferred` varchar(30) default NULL,
  `sex` char(1) default NULL,
  `race` varchar(30) default NULL,
  `ethnicity` varchar(30) default NULL,
  `vital_status` varchar(50) default NULL,
  `memo` varchar(200) default NULL,
  `status` varchar(10) default NULL,
  `date_of_death` date default NULL,
  `death_certificate_ident` varchar(20) NOT NULL default '',
  `icd10_id` varchar(50) default NULL,
  `confirmation_source` varchar(50) NOT NULL default '',
  `tb_number` varchar(50) default NULL,
  `last_chart_checked_date` date default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `participant_contacts`
-- 

CREATE TABLE `participant_contacts` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `facility` varchar(50) default NULL,
  `contact_type` varchar(50) NOT NULL default '',
  `other_contact_type` varchar(100) default NULL,
  `effective_date` date default NULL,
  `expiry_date` date default NULL,
  `memo` text,
  `street` varchar(50) default NULL,
  `city` varchar(50) NOT NULL default '',
  `region` varchar(50) NOT NULL default '',
  `country` varchar(50) NOT NULL default '',
  `mail_code` varchar(10) NOT NULL default '',
  `phone` varchar(15) NOT NULL default '',
  `phone_type` varchar(15) NOT NULL default '',
  `phone_secondary` varchar(15) NOT NULL default '',
  `phone_secondary_type` varchar(15) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `participant_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  INDEX `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `participant_contacts_revs` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL default '',
  `facility` varchar(50) default NULL,
  `contact_type` varchar(50) NOT NULL default '',
  `other_contact_type` varchar(100) default NULL,
  `effective_date` date default NULL,
  `expiry_date` date default NULL,
  `memo` text,
  `street` varchar(50) default NULL,
  `city` varchar(50) NOT NULL default '',
  `region` varchar(50) NOT NULL default '',
  `country` varchar(50) NOT NULL default '',
  `mail_code` varchar(10) NOT NULL default '',
  `phone` varchar(15) NOT NULL default '',
  `phone_type` varchar(15) NOT NULL default '',
  `phone_secondary` varchar(15) NOT NULL default '',
  `phone_secondary_type` varchar(15) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `participant_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  INDEX `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `participant_messages`
--

CREATE TABLE `participant_messages` (
  `id` int(11) NOT NULL auto_increment,
  `date_requested` date default NULL,
  `author` varchar(50) default NULL,
  `type` varchar(20) default NULL,
  `title` varchar(50) default NULL,
  `description` text,
  `due_date` datetime default NULL,
  `expiry_date` date default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `participant_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  INDEX `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `participant_messages_revs` (
  `id` int(11) NOT NULL,
  `date_requested` date default NULL,
  `author` varchar(50) default NULL,
  `type` varchar(20) default NULL,
  `title` varchar(50) default NULL,
  `description` text,
  `due_date` datetime default NULL,
  `expiry_date` date default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `participant_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  INDEX `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `path_collection_reviews`
--

CREATE TABLE `path_collection_reviews` (
  `id` int(11) NOT NULL auto_increment,
  `path_coll_rev_code` varchar(20) NOT NULL default '0',
  `collection_id` int(11) default NULL,
  `sample_master_id` int(11) default NULL,
  `aliquot_master_id` int(11) default NULL,
  `review_date` date NOT NULL default '0000-00-00',
  `review_status` varchar(20) default NULL,
  `pathologist` varchar(30) default '0',
  `tumour_type` varchar(50) default '0',
  `comments` text,
  `tumour_gradecategory` varchar(10) default NULL,
  `tumour_grade_based_on_sample_master_id` int(11) default '0',
  `tumour_grade_score_tubules` decimal(5,1) default NULL,
  `tumour_grade_score_nuclei` decimal(5,1) default NULL,
  `tumour_grade_score_nuclear` decimal(5,1) default NULL,
  `tumour_grade_score_mitosis` decimal(5,1) default NULL,
  `tumour_grade_score_architecture` decimal(5,1) default NULL,
  `tumour_grade_score_total` decimal(5,1) default '0.0',
  `created` datetime default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `collection_id` (`collection_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `path_collection_reviews_revs` (
  `id` int(11) NOT NULL,
  `path_coll_rev_code` varchar(20) NOT NULL default '0',
  `collection_id` int(11) default NULL,
  `sample_master_id` int(11) default NULL,
  `aliquot_master_id` int(11) default NULL,
  `review_date` date NOT NULL default '0000-00-00',
  `review_status` varchar(20) default NULL,
  `pathologist` varchar(30) default '0',
  `tumour_type` varchar(50) default '0',
  `comments` text,
  `tumour_gradecategory` varchar(10) default NULL,
  `tumour_grade_based_on_sample_master_id` int(11) default '0',
  `tumour_grade_score_tubules` decimal(5,1) default NULL,
  `tumour_grade_score_nuclei` decimal(5,1) default NULL,
  `tumour_grade_score_nuclear` decimal(5,1) default NULL,
  `tumour_grade_score_mitosis` decimal(5,1) default NULL,
  `tumour_grade_score_architecture` decimal(5,1) default NULL,
  `tumour_grade_score_total` decimal(5,1) default '0.0',
  `created` datetime default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `collection_id` (`collection_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `pd_chemos`
-- 

CREATE TABLE `pd_chemos` (
  `id` int(11) NOT NULL auto_increment,
  `num_cycles` int(11) default NULL,
  `length_cycles` int(11) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `protocol_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `pd_chemos_revs` (
  `id` int(11) NOT NULL,
  `num_cycles` int(11) default NULL,
  `length_cycles` int(11) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `protocol_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `pe_chemos`
--

CREATE TABLE `pe_chemos` (
  `id` int(11) NOT NULL auto_increment,
  `method` varchar(50) default NULL,
  `dose` varchar(50) default NULL,
  `frequency` varchar(50) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `protocol_master_id` int(11) default NULL,
  `drug_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `pe_chemos_revs` (
  `id` int(11) NOT NULL,
  `method` varchar(50) default NULL,
  `dose` varchar(50) default NULL,
  `frequency` varchar(50) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `protocol_master_id` int(11) default NULL,
  `drug_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `protocol_controls`
-- 

CREATE TABLE `protocol_controls` (
  `id` int(11) NOT NULL auto_increment,
  `tumour_group` varchar(50) default NULL,
  `type` varchar(50) default NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `form_alias` varchar(255) NOT NULL,
  `extend_tablename` varchar(255) NOT NULL default '',
  `extend_form_alias` varchar(255) NOT NULL default '',
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `protocol_masters`
-- 

CREATE TABLE `protocol_masters` (
  `id` int(11) NOT NULL auto_increment,
  `protocol_control_id` int(11) NOT NULL default 0,
  `name` varchar(255) default NULL,
  `notes` text,
  `code` varchar(50) default NULL,
  `arm` varchar(50) default NULL,
  `tumour_group` varchar(50) default NULL,
  `type` varchar(50) NOT NULL default '',
  `status` varchar(50) default NULL,
  `expiry` date default NULL,
  `activated` date default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `form_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `protocol_masters_revs` (
  `id` int(11) NOT NULL,
  `protocol_control_id` int(11) NOT NULL default 0,
  `name` varchar(255) default NULL,
  `notes` text,
  `code` varchar(50) default NULL,
  `arm` varchar(50) default NULL,
  `tumour_group` varchar(50) default NULL,
  `type` varchar(50) NOT NULL default '',
  `status` varchar(50) default NULL,
  `expiry` date default NULL,
  `activated` date default NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `form_alias` varchar(255) NOT NULL,
  `extend_tablename` varchar(255) NOT NULL default '',
  `extend_form_alias` varchar(255) NOT NULL default '',
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `form_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `providers`
-- 

CREATE TABLE `providers` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(55) character set latin1 NOT NULL,
  `type` varchar(55) character set latin1 NOT NULL,
  `date_effective` datetime default NULL,
  `date_expiry` datetime default NULL,
  `active` varchar(55) NOT NULL default 'yes',
  `description` text default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(255) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(255) NOT NULL default '',
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY ( `id` )
)  ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `providers_revs` (
  `id` int(11) NOT NULL,
  `name` varchar(55) character set latin1 NOT NULL,
  `type` varchar(55) character set latin1 NOT NULL,
  `date_effective` datetime default NULL,
  `date_expiry` datetime default NULL,
  `active` varchar(55) NOT NULL default 'yes',
  `description` text default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(255) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(255) NOT NULL default '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY ( `version_id` )
)  ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `qc_tested_aliquots`
-- 

CREATE TABLE `qc_tested_aliquots` (
  `id` int(11) NOT NULL auto_increment,
  `quality_control_id` int(11) default NULL,
  `aliquot_master_id` int(11) default NULL,
  `aliquot_use_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `quality_control_id` (`quality_control_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `aliquot_use_id` (`aliquot_use_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `qc_tested_aliquots_revs` (
  `id` int(11) NOT NULL,
  `quality_control_id` int(11) default NULL,
  `aliquot_master_id` int(11) default NULL,
  `aliquot_use_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `quality_control_id` (`quality_control_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `aliquot_use_id` (`aliquot_use_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `quality_ctrls`
-- 

CREATE TABLE `quality_ctrls` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `type` varchar(30) default NULL,
  `tool` varchar(30) default NULL,
  `run_id` varchar(30) default NULL,
  `date` date default NULL,
  `score` varchar(30) default NULL,
  `unit` varchar(30) default NULL,
  `conclusion` varchar(30) default NULL,
  `notes` text,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `quality_ctrls_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `type` varchar(30) default NULL,
  `tool` varchar(30) default NULL,
  `run_id` varchar(30) default NULL,
  `date` date default NULL,
  `score` varchar(30) default NULL,
  `unit` varchar(30) default NULL,
  `conclusion` varchar(30) default NULL,
  `notes` text,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `rd_bloodcellcounts`
-- 

CREATE TABLE `rd_bloodcellcounts` (
  `id` int(11) NOT NULL auto_increment,
  `review_master_id` int(11) default NULL,
  `count_start_time` time default NULL,
  `wbc_tl_square` int(5) default NULL,
  `wbc_tr_square` int(5) default NULL,
  `wbc_bl_square` int(5) default NULL,
  `wbc_br_square` int(5) default NULL,
  `rbc_tl_square` int(5) default NULL,
  `rbc_tr_square` int(5) default NULL,
  `rbc_bl_square` int(5) default NULL,
  `rbc_br_square` int(5) default NULL,
  `rbc_mid_square` int(5) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `review_master_id` (`review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `rd_bloodcellcounts_revs` (
  `id` int(11) NOT NULL,
  `review_master_id` int(11) default NULL,
  `count_start_time` time default NULL,
  `wbc_tl_square` int(5) default NULL,
  `wbc_tr_square` int(5) default NULL,
  `wbc_bl_square` int(5) default NULL,
  `wbc_br_square` int(5) default NULL,
  `rbc_tl_square` int(5) default NULL,
  `rbc_tr_square` int(5) default NULL,
  `rbc_bl_square` int(5) default NULL,
  `rbc_br_square` int(5) default NULL,
  `rbc_mid_square` int(5) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `review_master_id` (`review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `rd_blood_cells`
-- 

CREATE TABLE `rd_blood_cells` (
  `id` int(11) NOT NULL auto_increment,
  `review_master_id` int(11) default NULL,
  `mmt` varchar(10) default '',
  `fish` decimal(6,2) default NULL,
  `zap70` decimal(6,2) default NULL,
  `nq01` varchar(10) default NULL,
  `cd38` decimal(6,2) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `rd_blood_cells_revs` (
  `id` int(11) NOT NULL,
  `review_master_id` int(11) default NULL,
  `mmt` varchar(10) default '',
  `fish` decimal(6,2) default NULL,
  `zap70` decimal(6,2) default NULL,
  `nq01` varchar(10) default NULL,
  `cd38` decimal(6,2) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `rd_breastcancertypes`
-- 

CREATE TABLE `rd_breastcancertypes` (
  `id` int(11) NOT NULL auto_increment,
  `review_master_id` int(11) default NULL,
  `invasive_percentage` decimal(5,1) default NULL,
  `in_situ_percentage` decimal(5,1) default NULL,
  `normal_percentage` decimal(5,1) default NULL,
  `stroma_percentage` decimal(5,1) default NULL,
  `necrosis_inv_percentage` decimal(5,1) default NULL,
  `necrosis_is_percentage` decimal(5,1) default NULL,
  `inflammation` tinyint(4) default NULL,
  `quality_score` tinyint(4) default NULL,
  `created` datetime default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `review_master_id` (`review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `rd_breastcancertypes_revs` (
  `id` int(11) NOT NULL,
  `review_master_id` int(11) default NULL,
  `invasive_percentage` decimal(5,1) default NULL,
  `in_situ_percentage` decimal(5,1) default NULL,
  `normal_percentage` decimal(5,1) default NULL,
  `stroma_percentage` decimal(5,1) default NULL,
  `necrosis_inv_percentage` decimal(5,1) default NULL,
  `necrosis_is_percentage` decimal(5,1) default NULL,
  `inflammation` tinyint(4) default NULL,
  `quality_score` tinyint(4) default NULL,
  `created` datetime default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `review_master_id` (`review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `rd_breast_cancers`
-- 

CREATE TABLE `rd_breast_cancers` (
  `id` int(11) NOT NULL auto_increment,
  `review_master_id` int(11) default NULL,
  `tumour_type_id` int(11) default NULL,
  `invasive_percentage` decimal(5,1) NOT NULL default '0.0',
  `in_situ_percentage` decimal(5,1) NOT NULL default '0.0',
  `normal_percentage` decimal(5,1) NOT NULL default '0.0',
  `stroma_percentage` decimal(5,1) NOT NULL default '0.0',
  `necrosis_inv_percentage` decimal(5,1) NOT NULL default '0.0',
  `necrosis_is_percentage` decimal(5,1) NOT NULL default '0.0',
  `fat_percentage` decimal(5,1) NOT NULL default '0.0',
  `inflammation` tinyint(4) NOT NULL default '0',
  `quality_score` tinyint(4) NOT NULL default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `rd_breast_cancers_revs` (
  `id` int(11) NOT NULL,
  `review_master_id` int(11) default NULL,
  `tumour_type_id` int(11) default NULL,
  `invasive_percentage` decimal(5,1) NOT NULL default '0.0',
  `in_situ_percentage` decimal(5,1) NOT NULL default '0.0',
  `normal_percentage` decimal(5,1) NOT NULL default '0.0',
  `stroma_percentage` decimal(5,1) NOT NULL default '0.0',
  `necrosis_inv_percentage` decimal(5,1) NOT NULL default '0.0',
  `necrosis_is_percentage` decimal(5,1) NOT NULL default '0.0',
  `fat_percentage` decimal(5,1) NOT NULL default '0.0',
  `inflammation` tinyint(4) NOT NULL default '0',
  `quality_score` tinyint(4) NOT NULL default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `rd_coloncancertypes`
-- 

CREATE TABLE `rd_coloncancertypes` (
  `id` int(11) NOT NULL auto_increment,
  `review_master_id` int(11) default NULL,
  `invasive_percentage` decimal(5,1) default NULL,
  `in_situ_percentage` decimal(5,1) default NULL,
  `normal_percentage` decimal(5,1) default NULL,
  `stroma_percentage` decimal(5,1) default NULL,
  `necrosis_percentage` decimal(5,1) default NULL,
  `inflammation` tinyint(4) default NULL,
  `quality_score` tinyint(4) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `review_master_id` (`review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `rd_coloncancertypes_revs` (
  `id` int(11) NOT NULL,
  `review_master_id` int(11) default NULL,
  `invasive_percentage` decimal(5,1) default NULL,
  `in_situ_percentage` decimal(5,1) default NULL,
  `normal_percentage` decimal(5,1) default NULL,
  `stroma_percentage` decimal(5,1) default NULL,
  `necrosis_percentage` decimal(5,1) default NULL,
  `inflammation` tinyint(4) default NULL,
  `quality_score` tinyint(4) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `review_master_id` (`review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `rd_genericcancertypes`
-- 

CREATE TABLE `rd_genericcancertypes` (
  `id` int(11) NOT NULL auto_increment,
  `review_master_id` int(11) default NULL,
  `invasive_percentage` decimal(5,1) default NULL,
  `in_situ_percentage` decimal(5,1) default NULL,
  `normal_percentage` decimal(5,1) default NULL,
  `stroma_percentage` decimal(5,1) default NULL,
  `necrosis_percentage` decimal(5,1) default NULL,
  `inflammation` tinyint(4) default NULL,
  `quality_score` tinyint(4) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `review_master_id` (`review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `rd_genericcancertypes_revs` (
  `id` int(11) NOT NULL,
  `review_master_id` int(11) default NULL,
  `invasive_percentage` decimal(5,1) default NULL,
  `in_situ_percentage` decimal(5,1) default NULL,
  `normal_percentage` decimal(5,1) default NULL,
  `stroma_percentage` decimal(5,1) default NULL,
  `necrosis_percentage` decimal(5,1) default NULL,
  `inflammation` tinyint(4) default NULL,
  `quality_score` tinyint(4) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `review_master_id` (`review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `rd_ovarianuteruscancertypes`
-- 

CREATE TABLE `rd_ovarianuteruscancertypes` (
  `id` int(11) NOT NULL auto_increment,
  `review_master_id` int(11) default NULL,
  `invasive_percentage` decimal(5,1) default NULL,
  `normal_percentage` decimal(5,1) default NULL,
  `stroma_percentage` decimal(5,1) default NULL,
  `necrosis_percentage` decimal(5,1) default NULL,
  `inflammation` tinyint(4) default NULL,
  `quality_score` tinyint(4) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `review_master_id` (`review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `rd_ovarianuteruscancertypes_revs` (
  `id` int(11) NOT NULL,
  `review_master_id` int(11) default NULL,
  `invasive_percentage` decimal(5,1) default NULL,
  `normal_percentage` decimal(5,1) default NULL,
  `stroma_percentage` decimal(5,1) default NULL,
  `necrosis_percentage` decimal(5,1) default NULL,
  `inflammation` tinyint(4) default NULL,
  `quality_score` tinyint(4) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `review_master_id` (`review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `realiquotings`
-- 

CREATE TABLE `realiquotings` (
  `id` int(11) NOT NULL auto_increment,
  `parent_aliquot_master_id` int(11) default NULL,
  `child_aliquot_master_id` int(11) default NULL,
  `aliquot_use_id` int(11) default NULL,
  `realiquoted_by` varchar(20) default NULL,
  `realiquoted_datetime` datetime default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `parent_aliquot_master_id` (`parent_aliquot_master_id`),
  KEY `child_aliquot_master_id` (`child_aliquot_master_id`),
  KEY `aliquot_use_id` (`aliquot_use_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `realiquotings_revs` (
  `id` int(11) NOT NULL,
  `parent_aliquot_master_id` int(11) default NULL,
  `child_aliquot_master_id` int(11) default NULL,
  `aliquot_use_id` int(11) default NULL,
  `realiquoted_by` varchar(20) default NULL,
  `realiquoted_datetime` datetime default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_date` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `parent_aliquot_master_id` (`parent_aliquot_master_id`),
  KEY `child_aliquot_master_id` (`child_aliquot_master_id`),
  KEY `aliquot_use_id` (`aliquot_use_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `reproductive_histories`
-- 

CREATE TABLE `reproductive_histories` (
  `id` int(11) NOT NULL auto_increment,
  `date_captured` date default NULL,
  `menopause_status` varchar(20) default NULL,
  `age_at_menopause` int(11) default NULL,
  `menopause_age_certainty` varchar(50) default NULL,
  `hrt_years_on` int(11) default NULL,
  `hrt_use` varchar(50) default NULL,
  `hysterectomy_age` int(11) default NULL,
  `hysterectomy_age_certainty` varchar(50) default NULL,
  `hysterectomy` varchar(50) default NULL,
  `first_ovary_out_age` int(11) default NULL,
  `first_ovary_certainty` varchar(50) default NULL,
  `second_ovary_out_age` int(11) default NULL,
  `second_ovary_certainty` varchar(50) default NULL,
  `first_ovary_out` varchar(50) default NULL,
  `second_ovary_out` varchar(50) default NULL,
  `gravida` int(11) default NULL,
  `para` int(11) default NULL,
  `age_at_first_parturition` int(11) default NULL,
  `first_parturition_certainty` varchar(50) default NULL,
  `age_at_last_parturition` int(11) default NULL,
  `last_parturition_certainty` varchar(50) default NULL,
  `age_at_menarche` int(11) default NULL,
  `age_at_menarche_certainty` varchar(50) default NULL,
  `oralcontraceptive_use` varchar(50) default NULL,
  `years_on_oralcontraceptives` int(11) default NULL,
  `lnmp_date` date default NULL,
  `lnmp_certainty` varchar(50) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `participant_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  INDEX `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `reproductive_histories_revs` (
  `id` int(11) NOT NULL,
  `date_captured` date default NULL,
  `menopause_status` varchar(20) default NULL,
  `age_at_menopause` int(11) default NULL,
  `menopause_age_certainty` varchar(50) default NULL,
  `hrt_years_on` int(11) default NULL,
  `hrt_use` varchar(50) default NULL,
  `hysterectomy_age` int(11) default NULL,
  `hysterectomy_age_certainty` varchar(50) default NULL,
  `hysterectomy` varchar(50) default NULL,
  `first_ovary_out_age` int(11) default NULL,
  `first_ovary_certainty` varchar(50) default NULL,
  `second_ovary_out_age` int(11) default NULL,
  `second_ovary_certainty` varchar(50) default NULL,
  `first_ovary_out` varchar(50) default NULL,
  `second_ovary_out` varchar(50) default NULL,
  `gravida` int(11) default NULL,
  `para` int(11) default NULL,
  `age_at_first_parturition` int(11) default NULL,
  `first_parturition_certainty` varchar(50) default NULL,
  `age_at_last_parturition` int(11) default NULL,
  `last_parturition_certainty` varchar(50) default NULL,
  `age_at_menarche` int(11) default NULL,
  `age_at_menarche_certainty` varchar(50) default NULL,
  `oralcontraceptive_use` varchar(50) default NULL,
  `years_on_oralcontraceptives` int(11) default NULL,
  `lnmp_date` date default NULL,
  `lnmp_certainty` varchar(50) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `participant_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime NULL,
  PRIMARY KEY  (`version_id`),
  INDEX `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `review_controls`
-- 

CREATE TABLE `review_controls` (
  `id` int(11) NOT NULL auto_increment,
  `review_type` varchar(30) NOT NULL default '',
  `review_sample_group` varchar(30) NOT NULL default '',
  `status` varchar(20) NOT NULL default '',
  `form_alias` varchar(255) NOT NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL default 0,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `review_masters`
-- 

CREATE TABLE `review_masters` (
  `id` int(11) NOT NULL auto_increment,
  `review_control_id` int(11) NOT NULL default 0,
  `collection_id` int(11) default NULL,
  `sample_master_id` int(11) default NULL,
  `review_type` varchar(30) NOT NULL default '',
  `review_sample_group` varchar(30) NOT NULL default '',
  `review_date` date NOT NULL default '0000-00-00',
  `review_status` varchar(20) NOT NULL default '',
  `pathologist` varchar(50) default '',
  `comments` text,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `review_masters_revs` (
  `id` int(11) NOT NULL,
  `review_control_id` int(11) NOT NULL default 0,
  `collection_id` int(11) default NULL,
  `sample_master_id` int(11) default NULL,
  `review_type` varchar(30) NOT NULL default '',
  `review_sample_group` varchar(30) NOT NULL default '',
  `review_date` date NOT NULL default '0000-00-00',
  `review_status` varchar(20) NOT NULL default '',
  `pathologist` varchar(50) default '',
  `comments` text,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  UNIQUE KEY `version_id` (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `rtbforms`
-- 

CREATE TABLE `rtbforms` (
  `id` smallint(5) unsigned NOT NULL auto_increment,
  `frmTitle` varchar(200) default NULL,
  `frmVersion` float NOT NULL default '0',
  `frmCategory` varchar(30) default NULL,
  `frmFileLocation` blob,
  `frmFileType` varchar(40) default NULL,
  `frmFileViewer` blob,
  `frmStatus` varchar(30) default NULL,
  `frmCreated` date default NULL,
  `frmGroup` varchar(50) default NULL,
  `created` datetime default NULL,
  `created_by` int(11) default NULL,
  `modified` datetime default NULL,
  `modified_by` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

CREATE TABLE `rtbforms_revs` (
  `id` smallint(5) unsigned NOT NULL,
  `frmTitle` varchar(200) default NULL,
  `frmVersion` float NOT NULL default '0',
  `frmCategory` varchar(30) default NULL,
  `frmFileLocation` blob,
  `frmFileType` varchar(40) default NULL,
  `frmFileViewer` blob,
  `frmStatus` varchar(30) default NULL,
  `frmCreated` date default NULL,
  `frmGroup` varchar(50) default NULL,
  `created` datetime default NULL,
  `created_by` int(11) default NULL,
  `modified` datetime default NULL,
  `modified_by` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

-- 
-- Table structure for table `derivative_sample_control_id`
-- 

CREATE TABLE IF NOT EXISTS `sample_to_aliquot_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_control_id` int(11) DEFAULT NULL,
  `aliquot_control_id` int(11) DEFAULT NULL,
  `status` enum('inactive','active') DEFAULT 'inactive',
  PRIMARY KEY (`id`),
  KEY `sample_control_id` (`sample_control_id`),
  KEY `aliquot_control_id` (`aliquot_control_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=45 ;

-- 
-- Table structure for table `sample_controls`
-- 

CREATE TABLE `sample_controls` (
  `id` int(11) NOT NULL auto_increment,
  `sample_type` varchar(30) NOT NULL default '',
  `sample_type_code` varchar(10) NOT NULL default '',
  `sample_category` varchar(20) NOT NULL default '',
  `status` varchar(20) default NULL,
  `form_alias` varchar(255) NOT NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL default 0,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `sample_masters`
-- 

CREATE TABLE `sample_masters` (
  `id` int(11) NOT NULL auto_increment,
  `sample_code` varchar(30) NOT NULL default '',
  `sample_category` varchar(30) NOT NULL default '',
  `sample_control_id` int(11) NOT NULL default 0,
  `sample_type` varchar(30) NOT NULL default '',
  `initial_specimen_sample_id` int(11) default NULL,
  `initial_specimen_sample_type` varchar(30) NOT NULL default '',
  `collection_id` int(11) default NULL,
  `parent_id` int(11) default NULL,
  `sop_master_id` int(11) default NULL,
  `product_code` varchar(20) default NULL,
  `is_problematic` varchar(6) default NULL,
  `notes` text,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sample_control_id` (`sample_control_id`),
  KEY `initial_specimen_sample_id` (`initial_specimen_sample_id`),
  KEY `parent_id` (`parent_id`),
  KEY `collection_id` (`collection_id`),
  KEY `sop_master_id` (`sop_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sample_masters_revs` (
  `id` int(11) NOT NULL,
  `sample_code` varchar(30) NOT NULL default '',
  `sample_category` varchar(30) NOT NULL default '',
  `sample_control_id` int(11) NOT NULL default 0,
  `sample_type` varchar(30) NOT NULL default '',
  `initial_specimen_sample_id` int(11) default NULL,
  `initial_specimen_sample_type` varchar(30) NOT NULL default '',
  `collection_id` int(11) default NULL,
  `parent_id` int(11) default NULL,
  `sop_master_id` int(11) default NULL,
  `product_code` varchar(20) default NULL,
  `is_problematic` varchar(6) default NULL,
  `notes` text,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_control_id` (`sample_control_id`),
  KEY `initial_specimen_sample_id` (`initial_specimen_sample_id`),
  KEY `parent_id` (`parent_id`),
  KEY `collection_id` (`collection_id`),
  KEY `sop_master_id` (`sop_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `sd_der_ascite_cells`
-- 

CREATE TABLE `sd_der_ascite_cells` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_ascite_cells_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_ascite_sups`
-- 

CREATE TABLE `sd_der_ascite_sups` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_ascite_sups_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_blood_cells`
-- 

CREATE TABLE `sd_der_blood_cells` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_blood_cells_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_pbmcs`
-- 

CREATE TABLE `sd_der_pbmcs` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_pbmcs_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_dnas`
-- 

CREATE TABLE `sd_der_dnas` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_dnas_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_rnas`
-- 

CREATE TABLE `sd_der_rnas` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_rnas_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_urine_cons`
-- 

CREATE TABLE `sd_der_urine_cons` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_urine_cons_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_urine_cents`
-- 

CREATE TABLE `sd_der_urine_cents` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_urine_cents_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_amp_dnas`
-- 

CREATE TABLE `sd_der_amp_dnas` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_amp_dnas_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_amp_rnas`
-- 

CREATE TABLE `sd_der_amp_rnas` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_amp_rnas_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_b_cells`
-- 

CREATE TABLE `sd_der_b_cells` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_b_cells_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_tiss_lysates`
-- 

CREATE TABLE `sd_der_tiss_lysates` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_tiss_lysates_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_tiss_susps`
-- 

CREATE TABLE `sd_der_tiss_susps` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_tiss_susps_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_pw_cells`
-- 

CREATE TABLE `sd_der_pw_cells` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_pw_cells_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_pw_sups`
-- 

CREATE TABLE `sd_der_pw_sups` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_pw_sups_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_fluid_cells`
-- 

CREATE TABLE `sd_der_fluid_cells` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_fluid_cells_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_fluid_sups`
-- 

CREATE TABLE `sd_der_fluid_sups` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_fluid_sups_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_other_cells`
-- 

CREATE TABLE `sd_der_other_cells` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_other_cells_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_other_sups`
-- 

CREATE TABLE `sd_der_other_sups` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `sd_der_other_sups_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

-- 
-- Table structure for table `sd_der_cell_cultures`
-- 

CREATE TABLE `sd_der_cell_cultures` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `culture_status` varchar(30) default NULL,
  `culture_status_reason` varchar(30) default NULL,
  `cell_passage_number` int(6) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_der_cell_cultures_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `culture_status` varchar(30) default NULL,
  `culture_status_reason` varchar(30) default NULL,
  `cell_passage_number` int(6) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `sd_der_plasmas`
-- 

CREATE TABLE `sd_der_plasmas` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `hemolyze_signs` varchar(10) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_der_plasmas_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `hemolyze_signs` varchar(10) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_date` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `sd_der_serums`
-- 

CREATE TABLE `sd_der_serums` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `hemolyze_signs` varchar(10) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_der_serums_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `hemolyze_signs` varchar(10) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `sd_spe_ascites`
--

CREATE TABLE `sd_spe_ascites` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_spe_ascites_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `sd_spe_bloods`
-- 

CREATE TABLE `sd_spe_bloods` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `blood_type` varchar(30) default NULL,
  `collected_tube_nbr` int(4) default NULL,
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_spe_bloods_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `blood_type` varchar(30) default NULL,
  `collected_tube_nbr` int(4) default NULL,
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `sd_spe_cystic_fluids`
-- 

CREATE TABLE `sd_spe_cystic_fluids` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_spe_cystic_fluids_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `sd_spe_other_fluids`
-- 

CREATE TABLE `sd_spe_other_fluids` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_spe_other_fluids_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `sd_spe_peritoneal_washes`
-- 

CREATE TABLE `sd_spe_peritoneal_washes` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_spe_peritoneal_washes_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `sd_spe_tissues`
--

CREATE TABLE `sd_spe_tissues` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `tissue_source` varchar(20) default NULL,
  `tissue_nature` varchar(15) default NULL,
  `tissue_laterality` varchar(10) default NULL,
  `pathology_reception_datetime` datetime default NULL,
  `tissue_size` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_spe_tissues_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `tissue_source` varchar(20) default NULL,
  `tissue_nature` varchar(15) default NULL,
  `tissue_laterality` varchar(10) default NULL,
  `pathology_reception_datetime` datetime default NULL,
  `tissue_size` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `sd_spe_urines`
-- 

CREATE TABLE `sd_spe_urines` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `urine_aspect` varchar(30) default NULL,
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `received_volume` decimal(10,5) default NULL,
  `received_volume_unit` varchar(20) default NULL,
  `pellet_signs` varchar(10) default NULL,
  `pellet_volume` decimal(10,5) default NULL,
  `pellet_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_spe_urines_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `urine_aspect` varchar(30) default NULL,
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `received_volume` decimal(10,5) default NULL,
  `received_volume_unit` varchar(20) default NULL,
  `pellet_signs` varchar(10) default NULL,
  `pellet_volume` decimal(10,5) default NULL,
  `pellet_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `shelves`
-- 

CREATE TABLE `shelves` (
  `id` int(11) NOT NULL auto_increment,
  `storage_id` int(11) default NULL,
  `description` varchar(50) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `storage_id` (`storage_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `shelves_revs` (
  `id` int(11) NOT NULL,
  `storage_id` int(11) default NULL,
  `description` varchar(50) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_id` (`storage_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `shipments`
-- 

CREATE TABLE `shipments` (
  `id` int(11) NOT NULL auto_increment,
  `shipment_code` varchar(255) NOT NULL default 'No Code',
  `recipient` varchar(60) default NULL,
  `facility` varchar(60) default NULL,
  `delivery_street_address` varchar(255) default NULL,
  `delivery_city` varchar(255) default NULL,
  `delivery_province` varchar(255) default NULL,
  `delivery_postal_code` varchar(255) default NULL,
  `delivery_country` varchar(255) default NULL,
  `shipping_company` varchar(255) default NULL,
  `shipping_account_nbr` varchar(255) default NULL,
  `datetime_shipped` datetime default NULL,
  `datetime_received` datetime default NULL,
  `shipped_by` varchar(255) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(45) default NULL,
  `order_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `shipments_revs` (
  `id` int(11) NOT NULL,
  `shipment_code` varchar(255) NOT NULL default 'No Code',
  `recipient` varchar(60) default NULL,
  `facility` varchar(60) default NULL,
  `delivery_street_address` varchar(255) default NULL,
  `delivery_city` varchar(255) default NULL,
  `delivery_province` varchar(255) default NULL,
  `delivery_postal_code` varchar(255) default NULL,
  `delivery_country` varchar(255) default NULL,
  `shipping_company` varchar(255) default NULL,
  `shipping_account_nbr` varchar(255) default NULL,
  `datetime_shipped` datetime default NULL,
  `datetime_received` datetime default NULL,
  `shipped_by` varchar(255) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(45) default NULL,
  `order_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `sidebars`
-- 

CREATE TABLE `sidebars` (
  `id` int(11) NOT NULL auto_increment,
  `alias` varchar(255) NOT NULL default '',
  `language_title` text NOT NULL,
  `language_body` text NOT NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(255) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `sopd_general_all`
-- 

CREATE TABLE `sopd_general_all` (
  `id` int(11) NOT NULL auto_increment,
  `value` varchar(255) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `sop_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sopd_general_all_revs` (
  `id` int(11) NOT NULL,
  `value` varchar(255) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `sop_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `sopd_inventory_all`
-- 

CREATE TABLE `sopd_inventory_all` (
  `id` int(11) NOT NULL auto_increment,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `sop_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


CREATE TABLE `sopd_inventory_all_revs` (
  `id` int(11) NOT NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `sop_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sope_general_all`
--

CREATE TABLE `sope_general_all` (
  `id` int(11) NOT NULL auto_increment,
  `site_specific` varchar(50) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `sop_master_id` int(11) default NULL,
  `material_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sope_general_all_revs` (
  `id` int(11) NOT NULL,
  `site_specific` varchar(50) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `sop_master_id` int(11) default NULL,
  `material_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `sope_inventory_all`
--

CREATE TABLE `sope_inventory_all` (
  `id` int(11) NOT NULL auto_increment,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `sop_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sope_inventory_all_revs` (
  `id` int(11) NOT NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `sop_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `sop_controls`
-- 

CREATE TABLE `sop_controls` (
  `id` int(11) NOT NULL auto_increment,
  `sop_group` varchar(50) default NULL,
  `type` varchar(50) default NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `form_alias` varchar(255) NOT NULL,
  `extend_tablename` varchar(255) NOT NULL,
  `extend_form_alias` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL default 0,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `sop_masters`
-- 

CREATE TABLE `sop_masters` (
  `id` int(11) NOT NULL auto_increment,
  `sop_control_id` int(11) NOT NULL default 0,
  `title` varchar(255) default NULL,
  `notes` text,
  `code` varchar(50) default NULL,
  `version` varchar(50) default NULL,
  `sop_group` varchar(50) default NULL,
  `type` varchar(50) NOT NULL,
  `status` varchar(50) default NULL,
  `expiry_date` date default NULL,
  `activated_date` date default NULL,
  `scope` text,
  `purpose` text,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `form_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sop_masters_revs` (
  `id` int(11) NOT NULL,
  `sop_control_id` int(11) NOT NULL default 0,
  `title` varchar(255) default NULL,
  `notes` text,
  `code` varchar(50) default NULL,
  `version` varchar(50) default NULL,
  `sop_group` varchar(50) default NULL,
  `type` varchar(50) NOT NULL,
  `status` varchar(50) default NULL,
  `expiry_date` date default NULL,
  `activated_date` date default NULL,
  `scope` text,
  `purpose` text,
  `detail_tablename` varchar(255) NOT NULL,
  `form_alias` varchar(255) NOT NULL,
  `extend_tablename` varchar(255) NOT NULL,
  `extend_form_alias` varchar(255) NOT NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `form_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `source_aliquots`
-- 

CREATE TABLE `source_aliquots` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `aliquot_master_id` int(11) default NULL,
  `aliquot_use_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `aliquot_use_id` (`aliquot_use_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `source_aliquots_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `aliquot_master_id` int(11) default NULL,
  `aliquot_use_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `aliquot_use_id` (`aliquot_use_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `specimen_details`
-- 

CREATE TABLE `specimen_details` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `supplier_dept` varchar(40) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `specimen_details_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `supplier_dept` varchar(40) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `std_cupboards`
-- 

CREATE TABLE `std_cupboards` (
  `id` int(11) NOT NULL auto_increment,
  `storage_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `std_cupboards_revs` (
  `id` int(11) NOT NULL,
  `storage_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `std_nitro_locates`
-- 

CREATE TABLE `std_nitro_locates` (
  `id` int(11) NOT NULL auto_increment,
  `storage_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `std_nitro_locates_revs` (
  `id` int(11) NOT NULL,
  `storage_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `std_fridges`
--

CREATE TABLE `std_fridges` (
  `id` int(11) NOT NULL auto_increment,
  `storage_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `std_fridges_revs` (
  `id` int(11) NOT NULL,
  `storage_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `std_freezers`
--

CREATE TABLE `std_freezers` (
  `id` int(11) NOT NULL auto_increment,
  `storage_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `std_freezers_revs` (
  `id` int(11) NOT NULL,
  `storage_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `std_boxs`
--

CREATE TABLE `std_boxs` (
  `id` int(11) NOT NULL auto_increment,
  `storage_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `std_boxs_revs` (
  `id` int(11) NOT NULL,
  `storage_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `std_racks`
--

CREATE TABLE `std_racks` (
  `id` int(11) NOT NULL auto_increment,
  `storage_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `std_racks_revs` (
  `id` int(11) NOT NULL,
  `storage_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `std_shelfs`
--

CREATE TABLE `std_shelfs` (
  `id` int(11) NOT NULL auto_increment,
  `storage_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `std_shelfs_revs` (
  `id` int(11) NOT NULL,
  `storage_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `std_incubators`
--

CREATE TABLE `std_incubators` (
  `id` int(11) NOT NULL auto_increment,
  `storage_master_id` int(11) default NULL,
  `oxygen_perc` varchar(10) default NULL,
  `carbonic_gaz_perc` varchar(10) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `std_incubators_revs` (
  `id` int(11) NOT NULL,
  `storage_master_id` int(11) default NULL,
  `oxygen_perc` varchar(10) default NULL,
  `carbonic_gaz_perc` varchar(10) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `std_rooms`
-- 

CREATE TABLE `std_rooms` (
  `id` int(11) NOT NULL auto_increment,
  `storage_master_id` int(11) default NULL,
  `laboratory` varchar(50) default NULL,
  `floor` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `std_rooms_revs` (
  `id` int(11) NOT NULL,
  `storage_master_id` int(11) default NULL,
  `laboratory` varchar(50) default NULL,
  `floor` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `std_tma_blocks`
-- 

CREATE TABLE `std_tma_blocks` (
  `id` int(11) NOT NULL auto_increment,
  `storage_master_id` int(11) default NULL,
  `sop_master_id` int(11) default NULL,
  `product_code` varchar(20) default NULL,
  `creation_datetime` datetime default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `storage_master_id` (`storage_master_id`),
  KEY `sop_master_id` (`sop_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `std_tma_blocks_revs` (
  `id` int(11) NOT NULL,
  `storage_master_id` int(11) default NULL,
  `sop_master_id` int(11) default NULL,
  `product_code` varchar(20) default NULL,
  `creation_datetime` datetime default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_master_id` (`storage_master_id`),
  KEY `sop_master_id` (`sop_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `storage_controls`
-- 

CREATE TABLE IF NOT EXISTS `storage_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `storage_type` varchar(30) NOT NULL DEFAULT '',
  `storage_type_code` varchar(10) NOT NULL DEFAULT '',
  `coord_x_title` varchar(30) DEFAULT NULL,
  `coord_x_type` enum('alphabetical','integer','list') DEFAULT NULL,
  `coord_x_size` int(4) DEFAULT NULL,
  `coord_y_title` varchar(30) DEFAULT NULL,
  `coord_y_type` enum('alphabetical','integer','list') DEFAULT NULL,
  `coord_y_size` int(4) DEFAULT NULL,
  `set_temperature` varchar(7) DEFAULT NULL,
  `is_tma_block` varchar(5) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `form_alias` varchar(255) NOT NULL,
  `form_alias_for_children_pos` varchar(50) DEFAULT NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `storage_coordinates`
-- 

CREATE TABLE `storage_coordinates` (
  `id` int(11) NOT NULL auto_increment,
  `storage_master_id` int(11) default NULL,
  `dimension` varchar(4) default '',
  `coordinate_value` varchar(30) default '',
  `order` int(4) default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


CREATE TABLE `storage_coordinates_revs` (
  `id` int(11) NOT NULL,
  `storage_master_id` int(11) default NULL,
  `dimension` varchar(4) default '',
  `coordinate_value` varchar(30) default '',
  `order` int(4) default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `storage_masters`
--

CREATE TABLE IF NOT EXISTS `storage_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(30) NOT NULL DEFAULT '',
  `storage_type` varchar(30) NOT NULL DEFAULT '',
  `storage_control_id` int(11) NOT NULL DEFAULT '0',
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(10) DEFAULT NULL,
  `rght` int(10) DEFAULT NULL,
  `barcode` varchar(60) DEFAULT NULL,
  `short_label` varchar(10) DEFAULT NULL,
  `selection_label` varchar(60) DEFAULT '',
  `storage_status` varchar(20) DEFAULT '',
  `parent_storage_coord_x` varchar(11) DEFAULT NULL,
  `coord_x_order` int(3) DEFAULT NULL,
  `parent_storage_coord_y` varchar(11) DEFAULT NULL,
  `coord_y_order` int(3) DEFAULT NULL,
  `set_temperature` varchar(7) DEFAULT NULL,
  `temperature` decimal(5,2) DEFAULT NULL,
  `temp_unit` varchar(20) DEFAULT NULL,
  `notes` text,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `storage_control_id` (`storage_control_id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `storage_masters_revs` (
  `id` int(11) NOT NULL,
  `code` varchar(30) NOT NULL DEFAULT '',
  `storage_type` varchar(30) NOT NULL DEFAULT '',
  `storage_control_id` int(11) NOT NULL DEFAULT '0',
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(10) DEFAULT NULL,
  `rght` int(10) DEFAULT NULL,
  `barcode` varchar(60) DEFAULT NULL,
  `short_label` varchar(10) DEFAULT NULL,
  `selection_label` varchar(60) DEFAULT '',
  `storage_status` varchar(20) DEFAULT '',
  `parent_storage_coord_x` varchar(11) DEFAULT NULL,
  `coord_x_order` int(3) DEFAULT NULL,
  `parent_storage_coord_y` varchar(11) DEFAULT NULL,
  `coord_y_order` int(3) DEFAULT NULL,
  `set_temperature` varchar(7) DEFAULT NULL,
  `temperature` decimal(5,2) DEFAULT NULL,
  `temp_unit` varchar(20) DEFAULT NULL,
  `notes` text,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `storage_control_id` (`storage_control_id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `structures`
--

CREATE TABLE IF NOT EXISTS `structures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `alias` varchar(255) NOT NULL DEFAULT '',
  `language_title` text NOT NULL,
  `language_help` text NOT NULL,
  `flag_add_columns` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `flag_edit_columns` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `flag_search_columns` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `flag_detail_columns` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(255) NOT NULL DEFAULT '',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `structure_fields`
--

CREATE TABLE IF NOT EXISTS `structure_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `public_identifier` varchar(50) NOT NULL,
  `old_id` varchar(255) NOT NULL,
  `plugin` varchar(255) NOT NULL DEFAULT '',
  `model` varchar(255) NOT NULL DEFAULT '',
  `tablename` varchar(255) NOT NULL DEFAULT '',
  `field` varchar(255) NOT NULL DEFAULT '',
  `language_label` text NOT NULL,
  `language_tag` text NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'input',
  `setting` text NOT NULL,
  `default` varchar(255) NOT NULL,
  `structure_value_domain` int(11) DEFAULT NULL,
  `language_help` text NOT NULL,
  `validation_control` varchar(50) NOT NULL DEFAULT 'open',
  `value_domain_control` varchar(50) NOT NULL DEFAULT 'open',
  `field_control` varchar(50) NOT NULL DEFAULT 'open',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(255) NOT NULL DEFAULT '',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `structure_formats`
--

CREATE TABLE IF NOT EXISTS `structure_formats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `structure_id` int(11) DEFAULT NULL,
  `structure_old_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `structure_field_id` int(11) DEFAULT NULL,
  `structure_field_old_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `display_column` int(11) NOT NULL DEFAULT '1',
  `display_order` int(11) NOT NULL DEFAULT '0',
  `language_heading` varchar(255) NOT NULL DEFAULT '',
  `flag_override_label` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `language_label` text NOT NULL,
  `flag_override_tag` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `language_tag` text NOT NULL,
  `flag_override_help` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `language_help` text NOT NULL,
  `flag_override_type` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `type` varchar(255) NOT NULL DEFAULT '',
  `flag_override_setting` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `setting` varchar(255) NOT NULL DEFAULT '',
  `flag_override_default` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `default` varchar(255) NOT NULL DEFAULT '',
  `flag_add` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `flag_add_readonly` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `flag_edit` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `flag_edit_readonly` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `flag_search` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `flag_search_readonly` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `flag_datagrid` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `flag_datagrid_readonly` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `flag_index` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `flag_detail` set('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(255) NOT NULL DEFAULT '',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `structure_options`
--

CREATE TABLE `structure_options` (
  `id` int(11) NOT NULL auto_increment,
  `alias` varchar(50) character set latin1 default NULL,
  `section` varchar(50) character set latin1 default NULL,
  `subsection` varchar(50) character set latin1 default NULL,
  `value` varchar(100) character set latin1 default NULL,
  `language_choice` varchar(100) character set latin1 default NULL,
  `display_order` int(11) default NULL,
  `active` varchar(50) character set latin1 default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) character set latin1 default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) character set latin1 default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `structure_permissible_values`
-- 

CREATE TABLE `structure_permissible_values` (
  `id` int(11) NOT NULL auto_increment,
  `value` varchar(255) NOT NULL,
  `language_alias` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `structure_validations`
--

CREATE TABLE `structure_validations` (
  `id` int(11) NOT NULL auto_increment,
  `old_id` varchar(255) character set latin1 NOT NULL default '0',
  `structure_field_id` INT(11) NOT NULL default 0,
  `structure_field_old_id` varchar(255) character set latin1 NOT NULL default '0',
  `rule` text character set latin1 NOT NULL,
  `flag_empty` set('0','1') collate utf8_unicode_ci NOT NULL default '0',
  `flag_required` set('0','1') collate utf8_unicode_ci NOT NULL default '0',
  `on_action` varchar(255) collate utf8_unicode_ci NOT NULL,
  `language_message` text character set latin1 NOT NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(255) character set latin1 NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modifed_by` varchar(255) character set latin1 NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci AUTO_INCREMENT=1 ;

--
-- Table structure for table `structure_value_domains`
--

CREATE TABLE `structure_value_domains` (
  `id` int(11) NOT NULL auto_increment,
  `domain_name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `override` set('extend','locked','open') collate utf8_unicode_ci NOT NULL default 'open',
  `category` varchar(255) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci AUTO_INCREMENT=1 ;

--
-- Table structure for table `structure_value_domains_permissible_values`
--

CREATE TABLE IF NOT EXISTS `structure_value_domains_permissible_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structure_value_domain_id` varchar(255) NOT NULL,
  `structure_permissible_value_id` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT '0',
  `active` set('yes','no') NOT NULL DEFAULT 'yes',
  `language_alias` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci AUTO_INCREMENT=1 ;

--
-- Table structure for table `study_contacts`
--

CREATE TABLE `study_contacts` (
  `id` int(11) NOT NULL auto_increment,
  `sort` int(11) default NULL,
  `prefix` int(11) default NULL,
  `first_name` varchar(255) default NULL,
  `middle_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `accreditation` varchar(255) default NULL,
  `occupation` varchar(255) default NULL,
  `department` varchar(255) default NULL,
  `organization` varchar(255) default NULL,
  `organization_type` varchar(255) default NULL,
  `address_street` varchar(255) default NULL,
  `address_city` varchar(255) default NULL,
  `address_province` varchar(255) default NULL,
  `address_country` varchar(255) default NULL,
  `address_postal` varchar(255) default NULL,
  `phone_country` int(11) default NULL,
  `phone_area` int(11) default NULL,
  `phone_number` int(11) default NULL,
  `phone_extension` int(11) default NULL,
  `phone2_country` int(11) default NULL,
  `phone2_area` int(11) default NULL,
  `phone2_number` int(11) default NULL,
  `phone2_extension` int(11) default NULL,
  `fax_country` int(11) default NULL,
  `fax_area` int(11) default NULL,
  `fax_number` int(11) default NULL,
  `fax_extension` int(11) default NULL,
  `email` varchar(255) default NULL,
  `website` varchar(255) default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `study_summary_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `study_contacts_revs` (
  `id` int(11) NOT NULL,
  `sort` int(11) default NULL,
  `prefix` int(11) default NULL,
  `first_name` varchar(255) default NULL,
  `middle_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `accreditation` varchar(255) default NULL,
  `occupation` varchar(255) default NULL,
  `department` varchar(255) default NULL,
  `organization` varchar(255) default NULL,
  `organization_type` varchar(255) default NULL,
  `address_street` varchar(255) default NULL,
  `address_city` varchar(255) default NULL,
  `address_province` varchar(255) default NULL,
  `address_country` varchar(255) default NULL,
  `address_postal` varchar(255) default NULL,
  `phone_country` int(11) default NULL,
  `phone_area` int(11) default NULL,
  `phone_number` int(11) default NULL,
  `phone_extension` int(11) default NULL,
  `phone2_country` int(11) default NULL,
  `phone2_area` int(11) default NULL,
  `phone2_number` int(11) default NULL,
  `phone2_extension` int(11) default NULL,
  `fax_country` int(11) default NULL,
  `fax_area` int(11) default NULL,
  `fax_number` int(11) default NULL,
  `fax_extension` int(11) default NULL,
  `email` varchar(255) default NULL,
  `website` varchar(255) default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `study_summary_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `study_ethicsboards`
--

CREATE TABLE `study_ethics_boards` (
  `id` int(11) NOT NULL auto_increment,
  `ethics_board` varchar(255) default NULL,
  `restrictions` text,
  `contact` varchar(255) default NULL,
  `date` date default NULL,
  `phone_country` varchar(255) default NULL,
  `phone_area` varchar(255) default NULL,
  `phone_number` varchar(255) default NULL,
  `phone_extension` varchar(255) default NULL,
  `fax_country` varchar(255) default NULL,
  `fax_area` varchar(255) default NULL,
  `fax_number` varchar(255) default NULL,
  `fax_extension` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `status` varchar(255) default NULL,
  `approval_number` varchar(255) default NULL,
  `accrediation` varchar(255) default NULL,
  `ohrp_registration_number` varchar(255) default NULL,
  `ohrp_fwa_number` varchar(255) default NULL,
  `path_to_file` varchar(255) default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `study_summary_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `study_ethics_boards_revs` (
  `id` int(11) NOT NULL,
  `ethics_board` varchar(255) default NULL,
  `restrictions` text,
  `contact` varchar(255) default NULL,
  `date` date default NULL,
  `phone_country` varchar(255) default NULL,
  `phone_area` varchar(255) default NULL,
  `phone_number` varchar(255) default NULL,
  `phone_extension` varchar(255) default NULL,
  `fax_country` varchar(255) default NULL,
  `fax_area` varchar(255) default NULL,
  `fax_number` varchar(255) default NULL,
  `fax_extension` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `status` varchar(255) default NULL,
  `approval_number` varchar(255) default NULL,
  `accrediation` varchar(255) default NULL,
  `ohrp_registration_number` varchar(255) default NULL,
  `ohrp_fwa_number` varchar(255) default NULL,
  `path_to_file` varchar(255) default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `study_summary_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `study_fundings`
-- 

CREATE TABLE `study_fundings` (
  `id` int(11) NOT NULL auto_increment,
  `study_sponsor` varchar(255) default NULL,
  `restrictions` text,
  `year_1` int(11) default NULL,
  `amount_year_1` decimal(10,2) default NULL,
  `year_2` int(11) default NULL,
  `amount_year_2` decimal(10,2) default NULL,
  `year_3` int(11) default NULL,
  `amount_year_3` decimal(10,2) default NULL,
  `year_4` int(11) default NULL,
  `amount_year_4` decimal(10,2) default NULL,
  `year_5` int(11) default NULL,
  `amount_year_5` decimal(10,2) default NULL,
  `contact` varchar(255) default NULL,
  `phone_country` varchar(255) default NULL,
  `phone_area` varchar(255) default NULL,
  `phone_number` varchar(255) default NULL,
  `phone_extension` varchar(255) default NULL,
  `fax_country` varchar(255) default NULL,
  `fax_area` varchar(255) default NULL,
  `fax_number` varchar(255) default NULL,
  `fax_extension` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `status` varchar(255) default NULL,
  `date` date default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `rtbform_id` int(11) default NULL,
  `study_summary_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `study_fundings_revs` (
  `id` int(11) NOT NULL,
  `study_sponsor` varchar(255) default NULL,
  `restrictions` text,
  `year_1` int(11) default NULL,
  `amount_year_1` decimal(10,2) default NULL,
  `year_2` int(11) default NULL,
  `amount_year_2` decimal(10,2) default NULL,
  `year_3` int(11) default NULL,
  `amount_year_3` decimal(10,2) default NULL,
  `year_4` int(11) default NULL,
  `amount_year_4` decimal(10,2) default NULL,
  `year_5` int(11) default NULL,
  `amount_year_5` decimal(10,2) default NULL,
  `contact` varchar(255) default NULL,
  `phone_country` varchar(255) default NULL,
  `phone_area` varchar(255) default NULL,
  `phone_number` varchar(255) default NULL,
  `phone_extension` varchar(255) default NULL,
  `fax_country` varchar(255) default NULL,
  `fax_area` varchar(255) default NULL,
  `fax_number` varchar(255) default NULL,
  `fax_extension` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `status` varchar(255) default NULL,
  `date` date default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `rtbform_id` int(11) default NULL,
  `study_summary_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `study_investigators`
-- 

CREATE TABLE `study_investigators` (
  `id` int(11) NOT NULL auto_increment,
  `first_name` varchar(255) default NULL,
  `middle_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `accrediation` varchar(255) default NULL,
  `occupation` varchar(255) default NULL,
  `department` varchar(255) default NULL,
  `organization` varchar(255) default NULL,
  `address_street` varchar(255) default NULL,
  `address_city` varchar(255) default NULL,
  `address_province` varchar(255) default NULL,
  `address_country` varchar(255) default NULL,
  `sort` int(11) default NULL,
  `email` varchar(45) default NULL,
  `role` varchar(255) default NULL,
  `brief` text,
  `participation_start_date` date default NULL,
  `participation_end_date` date default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `path_to_file` text,
  `study_summary_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `study_investigators_revs` (
  `id` int(11) NOT NULL,
  `first_name` varchar(255) default NULL,
  `middle_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `accrediation` varchar(255) default NULL,
  `occupation` varchar(255) default NULL,
  `department` varchar(255) default NULL,
  `organization` varchar(255) default NULL,
  `address_street` varchar(255) default NULL,
  `address_city` varchar(255) default NULL,
  `address_province` varchar(255) default NULL,
  `address_country` varchar(255) default NULL,
  `sort` int(11) default NULL,
  `email` varchar(45) default NULL,
  `role` varchar(255) default NULL,
  `brief` text,
  `participation_start_date` date default NULL,
  `participation_end_date` date default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `path_to_file` text,
  `study_summary_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `study_related`
-- 

CREATE TABLE `study_related` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `principal_investigator` varchar(255) default NULL,
  `journal` varchar(255) default NULL,
  `issue` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `abstract` text,
  `relevance` text,
  `date_posted` date default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `study_summary_id` int(11) default NULL,
  `path_to_file` varchar(255) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `study_related_revs` (
  `id` int(11) NOT NULL,
  `title` varchar(255) default NULL,
  `principal_investigator` varchar(255) default NULL,
  `journal` varchar(255) default NULL,
  `issue` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `abstract` text,
  `relevance` text,
  `date_posted` date default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `study_summary_id` int(11) default NULL,
  `path_to_file` varchar(255) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `study_results`
-- 

CREATE TABLE `study_results` (
  `id` int(11) NOT NULL auto_increment,
  `abstract` text,
  `hypothesis` text,
  `conclusion` text,
  `comparison` text,
  `future` text,
  `result_date` datetime default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `rtbform_id` int(11) default NULL,
  `study_summary_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `study_results_revs` (
  `id` int(11) NOT NULL,
  `abstract` text,
  `hypothesis` text,
  `conclusion` text,
  `comparison` text,
  `future` text,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `rtbform_id` int(11) default NULL,
  `study_summary_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `study_reviews`
-- 

CREATE TABLE `study_reviews` (
  `id` int(11) NOT NULL auto_increment,
  `prefix` int(11) default NULL,
  `first_name` varchar(255) default NULL,
  `middle_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `accreditation` varchar(255) default NULL,
  `committee` varchar(255) default NULL,
  `institution` varchar(255) default NULL,
  `phone_country` varchar(255) default NULL,
  `phone_area` varchar(255) default NULL,
  `phone_number` varchar(255) default NULL,
  `phone_extension` varchar(255) default NULL,
  `status` varchar(255) default NULL,
  `date` date default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `study_summary_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `study_reviews_revs` (
  `id` int(11) NOT NULL,
  `prefix` int(11) default NULL,
  `first_name` varchar(255) default NULL,
  `middle_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `accreditation` varchar(255) default NULL,
  `committee` varchar(255) default NULL,
  `institution` varchar(255) default NULL,
  `phone_country` varchar(255) default NULL,
  `phone_area` varchar(255) default NULL,
  `phone_number` varchar(255) default NULL,
  `phone_extension` varchar(255) default NULL,
  `status` varchar(255) default NULL,
  `date` date default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `study_summary_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `study_summaries`
-- 

CREATE TABLE `study_summaries` (
  `id` int(11) NOT NULL auto_increment,
  `disease_site` varchar(50) default NULL,
  `study_type` varchar(50) default NULL,
  `study_science` varchar(50) default NULL,
  `study_use` varchar(50) default NULL,
  `title` varchar(45) default NULL,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `summary` text,
  `abstract` text,
  `hypothesis` text,
  `approach` text,
  `analysis` text,
  `significance` text,
  `additional_clinical` text,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `path_to_file` varchar(255) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `study_summaries_revs` (
  `id` int(11) NOT NULL,
  `disease_site` varchar(50) default NULL,
  `study_type` varchar(50) default NULL,
  `study_science` varchar(50) default NULL,
  `study_use` varchar(50) default NULL,
  `title` varchar(45) default NULL,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `summary` text,
  `abstract` text,
  `hypothesis` text,
  `approach` text,
  `analysis` text,
  `significance` text,
  `additional_clinical` text,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `path_to_file` varchar(255) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `tma_slides`
-- 

CREATE TABLE IF NOT EXISTS `tma_slides` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `std_tma_block_id` int(11) DEFAULT NULL,
  `barcode` varchar(30) NOT NULL DEFAULT '',
  `product_code` varchar(20) DEFAULT NULL,
  `sop_master_id` int(11) DEFAULT NULL,
  `immunochemistry` varchar(30) DEFAULT NULL,
  `picture_path` varchar(200) DEFAULT NULL,
  `storage_datetime` datetime DEFAULT NULL,
  `storage_master_id` int(11) DEFAULT NULL,
  `storage_coord_x` varchar(11) DEFAULT NULL,
  `coord_x_order` int(3) DEFAULT NULL,
  `storage_coord_y` varchar(11) DEFAULT NULL,
  `coord_y_order` int(3) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `storage_master_id` (`storage_master_id`),
  KEY `sop_master_id` (`sop_master_id`),
  KEY `std_tma_block_id` (`std_tma_block_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `tma_slides_revs` (
  `id` int(11) NOT NULL,
  `std_tma_block_id` int(11) DEFAULT NULL,
  `barcode` varchar(30) NOT NULL DEFAULT '',
  `product_code` varchar(20) DEFAULT NULL,
  `sop_master_id` int(11) DEFAULT NULL,
  `immunochemistry` varchar(30) DEFAULT NULL,
  `picture_path` varchar(200) DEFAULT NULL,
  `storage_datetime` datetime DEFAULT NULL,
  `storage_master_id` int(11) DEFAULT NULL,
  `storage_coord_x` varchar(11) DEFAULT NULL,
  `coord_x_order` int(3) DEFAULT NULL,
  `storage_coord_y` varchar(11) DEFAULT NULL,
  `coord_y_order` int(3) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `storage_master_id` (`storage_master_id`),
  KEY `sop_master_id` (`sop_master_id`),
  KEY `std_tma_block_id` (`std_tma_block_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `towers`
-- 

CREATE TABLE `towers` (
  `id` int(11) NOT NULL auto_increment,
  `storage_id` int(11) default NULL,
  `shelf_id` int(11) default NULL,
  `description` varchar(50) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `shelf_id` (`shelf_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `towers_revs` (
  `id` int(11) NOT NULL,
  `storage_id` int(11) default NULL,
  `shelf_id` int(11) default NULL,
  `description` varchar(50) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `shelf_id` (`shelf_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `txd_chemos`
-- 

CREATE TABLE `txd_chemos` (
  `id` int(11) NOT NULL auto_increment,
  `completed` varchar(50) default NULL,
  `response` varchar(50) default NULL,
  `num_cycles` int(11) default NULL,
  `length_cycles` int(11) default NULL,
  `completed_cycles` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `tx_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `txd_chemos_revs` (
  `id` int(11) NOT NULL,
  `completed` varchar(50) default NULL,
  `response` varchar(50) default NULL,
  `num_cycles` int(11) default NULL,
  `length_cycles` int(11) default NULL,
  `completed_cycles` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `tx_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `txd_radiations`
-- 

CREATE TABLE `txd_radiations` (
  `id` int(11) NOT NULL auto_increment,
  `source` varchar(50) default NULL,
  `mould` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `tx_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `txd_radiations_revs` (
  `id` int(11) NOT NULL,
  `source` varchar(50) default NULL,
  `mould` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `tx_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `txd_surgeries`
-- 

CREATE TABLE `txd_surgeries` (
  `id` int(11) NOT NULL auto_increment,
  `path_num` varchar(50) default NULL,
  `primary` varchar(50) default NULL,
  `surgeon` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `tx_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `txd_surgeries_revs` (
  `id` int(11) NOT NULL,
  `path_num` varchar(50) default NULL,
  `primary` varchar(50) default NULL,
  `surgeon` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `tx_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `txe_chemos`
-- 

CREATE TABLE `txe_chemos` (
  `id` int(11) NOT NULL auto_increment,
  `source` varchar(50) default NULL,
  `frequency` varchar(50) default NULL,
  `dose` varchar(50) default NULL,
  `method` varchar(50) default NULL,
  `reduction` varchar(50) default NULL,
  `cycle_number` int(11) default NULL,
  `completed_cycles` int(11) default NULL,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) default NULL,
  `tx_master_id` int(11) default NULL,
  `drug_id` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `txe_chemos_revs` (
  `id` int(11) NOT NULL,
  `source` varchar(50) default NULL,
  `frequency` varchar(50) default NULL,
  `dose` varchar(50) default NULL,
  `method` varchar(50) default NULL,
  `reduction` varchar(50) default NULL,
  `cycle_number` int(11) default NULL,
  `completed_cycles` int(11) default NULL,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) default NULL,
  `tx_master_id` int(11) default NULL,
  `drug_id` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `txe_radiations`
-- 

CREATE TABLE `txe_radiations` (
  `id` int(11) NOT NULL auto_increment,
  `modaility` varchar(50) default NULL,
  `technique` varchar(50) default NULL,
  `fractions` varchar(50) default NULL,
  `frequency` varchar(50) default NULL,
  `total_time` varchar(50) default NULL,
  `distance_sxd` varchar(50) default NULL,
  `distance_cm` varchar(50) default NULL,
  `dose_xd` varchar(50) default NULL,
  `dose_cgy` varchar(50) default NULL,
  `completed` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) default NULL,
  `tx_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `txe_radiations_revs` (
  `id` int(11) NOT NULL,
  `modaility` varchar(50) default NULL,
  `technique` varchar(50) default NULL,
  `fractions` varchar(50) default NULL,
  `frequency` varchar(50) default NULL,
  `total_time` varchar(50) default NULL,
  `distance_sxd` varchar(50) default NULL,
  `distance_cm` varchar(50) default NULL,
  `dose_xd` varchar(50) default NULL,
  `dose_cgy` varchar(50) default NULL,
  `completed` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) default NULL,
  `tx_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `txe_surgeries`
-- 

CREATE TABLE `txe_surgeries` (
  `id` int(11) NOT NULL auto_increment,
  `surgical_procedure` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) default NULL,
  `tx_master_id` int(11) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `txe_surgeries_revs` (
  `id` int(11) NOT NULL,
  `surgical_procedure` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) default NULL,
  `tx_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `tx_controls`
-- 

CREATE TABLE `tx_controls` (
  `id` int(11) NOT NULL auto_increment,
  `tx_group` varchar(50) default NULL,
  `disease_site` varchar(50) default NULL,
  `status` varchar(50) NOT NULL default '',
  `detail_tablename` varchar(255) NOT NULL,
  `form_alias` varchar(255) NOT NULL,
  `extend_tablename` varchar(255) NOT NULL default '',
  `extend_form_alias` varchar(255) NOT NULL default '',
  `display_order` int(11) NOT NULL default 0,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Table structure for table `tx_masters`
--

CREATE TABLE IF NOT EXISTS `tx_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `treatment_control_id` int(11) NOT NULL DEFAULT '0',
  `tx_group` varchar(50) DEFAULT NULL,
  `disease_site` varchar(50) DEFAULT NULL,
  `tx_intent` varchar(50) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `finish_date` date DEFAULT NULL,
  `source` varchar(50) DEFAULT NULL,
  `facility` varchar(50) DEFAULT NULL,
  `summary` text,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL DEFAULT '',
  `protocol_id` int(11) DEFAULT NULL,
  `participant_id` int(11) DEFAULT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `participant_id` (`participant_id`),
  INDEX `diagnosis_id` (`diagnosis_master_id`),
  INDEX `treatment_control_id` (`treatment_control_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `tx_masters_revs` (
  `id` int(11) NOT NULL,
  `treatment_control_id` int(11) NOT NULL DEFAULT '0',
  `tx_intent` varchar(50) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `finish_date` date DEFAULT NULL,
  `source` varchar(50) DEFAULT NULL,
  `facility` varchar(50) DEFAULT NULL,
  `summary` text,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL DEFAULT '',
  `protocol_id` int(11) DEFAULT NULL,
  `participant_id` int(11) DEFAULT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  INDEX `participant_id` (`participant_id`),
  INDEX `diagnosis_id` (`diagnosis_master_id`),
  INDEX `treatment_control_id` (`treatment_control_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `users`
-- 

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(200) NOT NULL default '',
  `first_name` varchar(50) default NULL,
  `last_name` varchar(50) default NULL,
  `password` varchar(255) NOT NULL default '',
  `email` varchar(200) NOT NULL default '',
  `department` varchar(50) default NULL,
  `job_title` varchar(50) default NULL,
  `institution` varchar(50) default NULL,
  `laboratory` varchar(50) default NULL,
  `help_visible` varchar(50) default NULL,
  `street` varchar(50) default NULL,
  `city` varchar(50) default NULL,
  `region` varchar(50) default NULL,
  `country` varchar(50) default NULL,
  `mail_code` varchar(50) default NULL,
  `phone_work` varchar(50) default NULL,
  `phone_home` varchar(50) default NULL,
  `lang` varchar(255) NOT NULL default 'en',
  `pagination` int(11) NOT NULL default '5',
  `last_visit` datetime NOT NULL default '0000-00-00 00:00:00',
  `group_id` int(11) NOT NULL default '0',
  `active` int(11) NOT NULL default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 
-- Table structure for table `user_logs`
-- 

CREATE TABLE `user_logs` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `url` text NOT NULL,
  `visited` timestamp NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `allowed` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

-- 
-- Table structure for table `versions`
--

CREATE TABLE `versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version_number` VARCHAR(255) NOT NULL,
  `date_installed` TIMESTAMP NOT NULL default CURRENT_TIMESTAMP,
  `status` VARCHAR(45) NOT NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) default NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;


-- Create INDEX for access control object (acos) table.

CREATE INDEX acos_idx1 ON acos (lft, rght);
CREATE INDEX acos_idx2 ON acos (alias);
CREATE INDEX acos_idx3 ON acos (model, foreign_key);

CREATE INDEX aros_idx1 ON aros (lft, rght);
CREATE INDEX aros_idx2 ON aros (alias);
CREATE INDEX aros_idx3 ON aros (model, foreign_key);


-- Clinical Annotation Foreign Keys --

ALTER TABLE `clinical_collection_links`
  ADD CONSTRAINT `FK_clinical_collection_links_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `clinical_collection_links`
  ADD CONSTRAINT `FK_clinical_collection_links_diagnosis_masters`
  FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `clinical_collection_links`
  ADD CONSTRAINT `FK_clinical_collection_links_consent_masters`
  FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `clinical_collection_links`
  ADD CONSTRAINT `FK_clinical_collection_links_collections`
  FOREIGN KEY (`collection_id`) REFERENCES `collections` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `consent_masters`
  ADD CONSTRAINT `FK_consent_masters_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `consent_masters`
  ADD CONSTRAINT `FK_consent_masters_diagnosis_masters`
  FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

-- ALTER TABLE `consent_masters`
--  ADD CONSTRAINT `FK_consent_masters_consent_controls`
--  FOREIGN KEY (`consent_control_id`) REFERENCES `consent_controls` (`id`)
--  ON DELETE RESTRICT
--  ON UPDATE RESTRICT;

ALTER TABLE `diagnosis_masters`
  ADD CONSTRAINT `FK_diagnosis_masters_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

-- ALTER TABLE `diagnosis_masters`
--  ADD CONSTRAINT `FK_diagnosis_masters_diagnosis_controls`
--  FOREIGN KEY (`diagnosis_control_id`) REFERENCES `diagnosis_controls` (`id`)
--  ON DELETE RESTRICT
--  ON UPDATE RESTRICT;

ALTER TABLE `event_masters`
  ADD CONSTRAINT `FK_event_masters_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `event_masters`
  ADD CONSTRAINT `FK_event_masters_diagnosis_masters`
  FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `event_masters`
  ADD CONSTRAINT `FK_event_masters_event_controls`
  FOREIGN KEY (`event_control_id`) REFERENCES `event_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `family_histories`
  ADD CONSTRAINT `FK_family_histories_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `misc_identifiers`
  ADD CONSTRAINT `FK_misc_identifiers_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `participant_contacts`
  ADD CONSTRAINT `FK_participant_contacts_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `participant_messages`
  ADD CONSTRAINT `FK_participant_messages_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `reproductive_histories`
  ADD CONSTRAINT `FK_reproductive_histories_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `tx_masters`
  ADD CONSTRAINT `FK_tx_masters_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `tx_masters`
  ADD CONSTRAINT `FK_tx_masters_diagnosis_masters`
  FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `tx_masters`
  ADD CONSTRAINT `FK_tx_masters_tx_controls`
  FOREIGN KEY (`treatment_control_id`) REFERENCES `tx_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

-- Order Management Foreign Keys --

ALTER TABLE `orders`
  ADD CONSTRAINT `FK_orders_study_summaries`
  FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `order_lines`
  ADD CONSTRAINT `FK_order_lines_orders`
  FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `order_items`
  ADD CONSTRAINT `FK_order_items_orders`
  FOREIGN KEY (`orderline_id`) REFERENCES `order_lines` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `shipments`
  ADD CONSTRAINT `FK_shipments_orders`
  FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;