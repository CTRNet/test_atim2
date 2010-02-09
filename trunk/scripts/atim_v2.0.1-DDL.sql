-- All DDL related updates go here

/*
	Module: Core
	Description:
*/




/*
	Module: Clinical Annotation
	Description:
*/

-- Diagnosis - Laterality field was not present. Added to both detail and revision table.
ALTER TABLE `dxd_tissues` CHANGE `text_field` `laterality` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '';
ALTER TABLE `dxd_tissues_revs` CHANGE `text_field` `laterality` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '';

-- Study - Add field for uploading images to the Study form
ALTER TABLE `ed_all_study_research` ADD `file_path` VARCHAR( 255 ) NOT NULL AFTER `event_master_id`  ;

-- Add new table for identifiers control
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `misc_identifier_controls`;

CREATE TABLE `misc_identifier_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `misc_identifier_name` varchar(50) NOT NULL DEFAULT '',
  `misc_identifier_name_abbrev` varchar(50) NOT NULL DEFAULT '',
  `status` varchar(50) NOT NULL DEFAULT 'active',
  `display_order` int(11) NOT NULL DEFAULT '0',
  `autoincrement_name` varchar(50) default NULL,
  `misc_identifier_format` varchar(50) default NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_misc_identifier_name` (`misc_identifier_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

SET FOREIGN_KEY_CHECKS=1;

ALTER TABLE `misc_identifiers` ADD `misc_identifier_control_id`  INT( 11 ) NOT NULL DEFAULT '0' AFTER `identifier_value` ; 
ALTER TABLE `misc_identifiers_revs` ADD `misc_identifier_control_id`  INT( 11 ) NOT NULL DEFAULT '0' AFTER `identifier_value` ; 
ALTER TABLE `misc_identifiers`
  ADD CONSTRAINT `FK_misc_identifiers_misc_identifier_controls`
  FOREIGN KEY (`misc_identifier_control_id`) REFERENCES `misc_identifier_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

/*
	Module: Inventory Management
	Description:
*/