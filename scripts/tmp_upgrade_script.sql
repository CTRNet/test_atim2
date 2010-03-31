-- --------------------------------------------------------------------------------------------------------------------------
-- DDL ------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------

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
ALTER TABLE `ed_all_study_research_revs` ADD `file_path` VARCHAR( 255 ) NOT NULL AFTER `event_master_id`  ;

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

-- Drop tables for unused annotation reports
DROP TABLE IF EXISTS `ed_allsolid_lab_pathology`;
DROP TABLE IF EXISTS `ed_allsolid_lab_pathology_revs`;

-- Fix created/modified fields. Redefine as DATETIME
ALTER TABLE `ed_all_clinical_followup` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL; 
ALTER TABLE `ed_all_clinical_followup_revs` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL; 

ALTER TABLE `ed_all_clinical_presentation` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL; 
ALTER TABLE `ed_all_clinical_presentation_revs` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL;

ALTER TABLE `ed_breast_lab_pathology` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL; 
ALTER TABLE `ed_breast_lab_pathology_revs` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL;

ALTER TABLE `order_items` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL; 
ALTER TABLE `order_items_revs` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL;

ALTER TABLE `pd_chemos` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL; 
ALTER TABLE `pd_chemos_revs` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL;

ALTER TABLE `protocol_controls` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL; 

ALTER TABLE `protocol_masters` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL; 
ALTER TABLE `protocol_masters_revs` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL;

-- Fix lifestyle table for smoking only
ALTER TABLE `ed_all_lifestyle_base`
  DROP `alcohol_history`,
  DROP `weight_loss`;

ALTER TABLE `ed_all_lifestyle_base_revs`
  DROP `alcohol_history`,
  DROP `weight_loss`;

RENAME TABLE `ed_all_lifestyle_base`  TO `ed_all_lifestyle_smoking`  ;
RENAME TABLE `ed_all_lifestyle_base_revs`  TO `ed_all_lifestyle_smoking_revs`  ;

ALTER TABLE `ed_all_lifestyle_smoking` CHANGE `pack_years` `pack_years` INT NULL DEFAULT NULL;
ALTER TABLE `ed_all_lifestyle_smoking_revs` CHANGE `pack_years` `pack_years` INT NULL DEFAULT NULL;


/*
	Module: Inventory Management
	Description:
*/


-- --------------------------------------------------------------------------------------------------------------------------
-- DML ------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------

-- All DML related updates go here

/*
	Module: Core
	Description: 
*/

-- Add text to the footer links present on each page (Credits, About, Installation)
UPDATE `pages` SET `language_title` = 'about_title', `language_body` = 'about_body' WHERE `pages`.`id` = 'about';
UPDATE `pages` SET `language_title` = 'installation_title', `language_body` = 'installation_body' WHERE `pages`.`id` = 'installation';

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('about_title', '', 'About', ''),
('about_body', '', 'The Canadian Tumour Repository Network (CTRNet) is a translational cancer research resource, funded by Canadian Institutes of Health Research, that furthers Canadian health research by linking cancer researchers with provincial tumour banks.', ''),
('credits_title', '', 'Credits', ''),
('credits_body', '', 'ATiM is an open-source project development by leading tumour banks across Canada. For more information on our development team, questions, comments or suggestions please visit our website at http://www.ctrnet.ca', ''),
('installation_title', '', 'Installation', ''),
('installation_body', '', 'To view your installed version number open the Administration Tool and select ATiM Version from the first menu. ATiM is built on the CakePHP framework (www.cakephp.org).', ''),
('no data was retrieved for the specified parameters', 'global', 'No data was retrieved for the specified parameters', 'Aucune donn&eacute;e n''a pu &ecitc;tre r&eacute;cup&eacute;r&eacute;e de la base de donn&eacute;es pour les param&ecirc;tres sp&eacute;cifi&eacute;s.'),
('chronology', '', 'Chronology', 'Chronologie');

-- Update version information
UPDATE `versions` 
SET `version_number` = 'v2.0.1', `date_installed` = '2010-02-09 12:13:43', `build_number` = '954'
WHERE `versions`.`id` =1;

/*
	Module: Clinical
	Description: 
*/

-- Add Clinical Annotation System Error Page

INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('err_clin_system_error', 1, 'system error', 'a system error has been detected', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Add image upload field to the research Study form
INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`,
`type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`,
`created`, `created_by`, `modified`, `modified_by`) VALUES
(NULL , '', 'CANM-00024', 'Clinicalannotation', 'EventDetail', '', 'file_name', 'Picture', '', 'file', '', '', NULL , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`,
`display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`,
`flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`,
`flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`,
`created_by`, `modified`, `modified_by`) VALUES 
(NULL , 'CAN-999-999-000-999-65_CANM-00024', (SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-65'), 'CAN-999-999-000-999-65', '908', 'CANM-00024', '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Updated clinical menu order to better match user workflow.
UPDATE `menus` SET `display_order` = '4' WHERE `menus`.`id` = 'clin_CAN_4';
UPDATE `menus` SET `display_order` = '3' WHERE `menus`.`id` = 'clin_CAN_5';
UPDATE `menus` SET `display_order` = '1' WHERE `menus`.`id` = 'clin_CAN_6';
UPDATE `menus` SET `display_order` = '5' WHERE `menus`.`id` = 'clin_CAN_75';
UPDATE `menus` SET `display_order` = '7' WHERE `menus`.`id` = 'clin_CAN_10';
UPDATE `menus` SET `display_order` = '10' WHERE `menus`.`id` = 'clin_CAN_25';
UPDATE `menus` SET `display_order` = '9' WHERE `menus`.`id` = 'clin_CAN_26';
UPDATE `menus` SET `display_order` = '8' WHERE `menus`.`id` = 'clin_CAN_68';
UPDATE `menus` SET `display_order` = '12' WHERE `menus`.`id` = 'clin_CAN_67';
UPDATE `menus` SET `display_order` = '1' WHERE `menus`.`id` = 'clin_CAN_31';
UPDATE `menus` SET `display_order` = '2' WHERE `menus`.`id` = 'clin_CAN_28';
UPDATE `menus` SET `display_order` = '3' WHERE `menus`.`id` = 'clin_CAN_30';
UPDATE `menus` SET `display_order` = '4' WHERE `menus`.`id` = 'clin_CAN_33';
UPDATE `menus` SET `display_order` = '5' WHERE `menus`.`id` = 'clin_CAN_27';
UPDATE `menus` SET `display_order` = '6' WHERE `menus`.`id` = 'clin_CAN_69';
UPDATE `menus` SET `display_order` = '7' WHERE `menus`.`id` = 'clin_CAN_32';
UPDATE `menus` SET `use_link` = '/clinicalannotation/event_masters/listall/clinical/%%Participant.id%%'  WHERE `menus`.`id` = 'clin_CAN_4';

-- Hide Adverse Events and Protocol menu option from Annotation (unused)
UPDATE `menus` SET `active` = 'no' WHERE `menus`.`id` = 'clin_CAN_32';
UPDATE `menus` SET `active` = 'no' WHERE `menus`.`id` = 'clin_CAN_69';


-- Updates to the misc identifiers section
DELETE FROM `misc_identifiers`;
DELETE FROM `misc_identifiers_revs`;
 
INSERT INTO `misc_identifier_controls` 
(`id`, `misc_identifier_name`, `misc_identifier_name_abbrev`, `status`, `display_order`, `autoincrement_name`, `misc_identifier_format`) 
VALUES
(null, 'custom_identifier_hospital_nbr', 'CIHN', 'active', 0, '', ''),
(null, 'custom_identifier_insurance_nbr', 'CIIN', 'active', 1, '', ''),
(null, 'custom_identifier_breat_bank_nbr', 'CIBB', 'active', 2, 'part_ident_breat_bank_nbr', 'BR - PART [%%key_increment%%]'),
(null, 'custom_identifier_ovary_bank_nbr', 'CIOB', 'active', 3, 'part_ident_ovary_bank_nbr', 'OV_PCODE_%%key_increment%%');

DELETE FROM `key_increments`;
INSERT INTO `key_increments` (`key_name`, `key_value`) VALUES
('part_ident_breat_bank_nbr', 1340),
('part_ident_ovary_bank_nbr', 1232411);

DELETE FROM structure_formats WHERE structure_old_id LIKE 'CAN-999-999-000-999-8';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-8_CAN-999-999-000-999-34', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-8'), 'CAN-999-999-000-999-8', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-34'), 'CAN-999-999-000-999-34', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-8_CAN-999-999-000-999-38', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-8'), 'CAN-999-999-000-999-8', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-38'), 'CAN-999-999-000-999-38', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-8_CAN-999-999-000-999-35', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-8'), 'CAN-999-999-000-999-8', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-35'), 'CAN-999-999-000-999-35', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-8_CAN-999-999-000-999-36', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-8'), 'CAN-999-999-000-999-8', (SELECT id FROM structure_fields WHERE old_id = 'CAN-102'), 'CAN-102', 1, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-8_CAN-999-999-000-999-37', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-8'), 'CAN-999-999-000-999-8', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-37'), 'CAN-999-999-000-999-37', 1, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-8_CAN-999-999-000-999-36', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-8'), 'CAN-999-999-000-999-8', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-36'), 'CAN-999-999-000-999-36', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structures` WHERE old_id = 'CAN-999-999-000-999-1091';
INSERT INTO `structures` (`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1091', 'incrementedmiscidentifiers', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM structure_formats WHERE structure_old_id LIKE 'CAN-999-999-000-999-1091';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1091_CAN-999-999-000-999-34', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1091'), 'CAN-999-999-000-999-1091', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-34'), 'CAN-999-999-000-999-34', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1091_CAN-999-999-000-999-38', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1091'), 'CAN-999-999-000-999-1091', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-38'), 'CAN-999-999-000-999-38', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1091_CAN-999-999-000-999-35', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1091'), 'CAN-999-999-000-999-1091', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-35'), 'CAN-999-999-000-999-35', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1091_CAN-999-999-000-999-36', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1091'), 'CAN-999-999-000-999-1091', (SELECT id FROM structure_fields WHERE old_id = 'CAN-102'), 'CAN-102', 1, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1091_CAN-999-999-000-999-37', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1091'), 'CAN-999-999-000-999-1091', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-37'), 'CAN-999-999-000-999-37', 1, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1091_CAN-999-999-000-999-36', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1091'), 'CAN-999-999-000-999-1091', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-36'), 'CAN-999-999-000-999-36', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structure_fields` 
SET `structure_value_domain` = '0',
type = 'select',
setting = null
WHERE old_id IN ('CAN-999-999-000-999-34');

DELETE FROM `structure_validations`  WHERE `structure_field_old_id` = 'CAN-999-999-000-999-35' AND `rule` = 'notEmpty';
INSERT INTO `structure_validations` 
(`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '0', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-35'), 'CAN-999-999-000-999-35', 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structures` WHERE old_id = 'CAN-999-999-000-999-1092';
INSERT INTO `structures` (`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1092', 'miscidentifierssummary', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM structure_formats WHERE structure_old_id LIKE 'CAN-999-999-000-999-1092';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1092_CAN-999-999-000-999-4', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1092'), 'CAN-999-999-000-999-1092', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-4'), 'CAN-999-999-000-999-4', 0, 1, '', '1', 'participant', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1092_CAN-999-999-000-999-1', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1092'), 'CAN-999-999-000-999-1092', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1'), 'CAN-999-999-000-999-1', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1092_CAN-999-999-000-999-295', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1092'), 'CAN-999-999-000-999-1092', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-295'), 'CAN-999-999-000-999-295', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1092_CAN-999-999-000-999-2', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1092'), 'CAN-999-999-000-999-1092', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-2'), 'CAN-999-999-000-999-2', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

(null, 'CAN-999-999-000-999-1092_CAN-999-999-000-999-34', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1092'), 'CAN-999-999-000-999-1092', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-34'), 'CAN-999-999-000-999-34', 0, 10, '', '1', 'participant identifier', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1092_CAN-999-999-000-999-38', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1092'), 'CAN-999-999-000-999-1092', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-38'), 'CAN-999-999-000-999-38', 0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1092_CAN-999-999-000-999-35', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1092'), 'CAN-999-999-000-999-1092', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-35'), 'CAN-999-999-000-999-35', 0, 12, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM  `i18n` WHERE `id` LIKE 'misc identifiers';
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('misc identifiers', 'global', 'Identifiers', 'Identifiants');

DELETE FROM  `i18n` WHERE `id` LIKE 'custom_identifier_%';
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('custom_identifier_hospital_nbr', 'global', 'Hospital #', 'Hopital #'),
('custom_identifier_insurance_nbr', 'global', 'Insurance #', 'Assurance #'),
('custom_identifier_breat_bank_nbr', 'global', 'Breast Bank ID', 'Banque Sein #'),
('custom_identifier_ovary_bank_nbr', 'global', 'Ovary Bank ID', 'Banque Ovaire #');

DELETE FROM  `i18n` WHERE `id` LIKE 'value is required';
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('value is required', 'global', 'The value is required!', 'La valeur est requise!');

/*
  STRUCTURE TABLES  
*/ 

-- DELETE DUPLICATED structurest.old_id

UPDATE `structures`
SET `old_id` = CONCAT('GENERATED-',id),
`modified_by` = 'NL',
`modified` = '20100212'
WHERE `old_id` IN (
  SELECT res.old_id
  FROM (SELECT count( * ) AS nbr, old_id FROM `structures` GROUP BY old_id) AS res 
  WHERE res.nbr >1
);

ALTER TABLE `structures` 
CHANGE `old_id` `old_id` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;

ALTER TABLE `structures` ADD UNIQUE (`old_id`);

-- DELETE DUPLICATED structure_fieldst.old_id

UPDATE `structure_fields`
SET `old_id` = CONCAT('GENERATED-',id),
`modified_by` = 'NL',
`modified` = '20100212'
WHERE `old_id` IN (
  SELECT res.old_id
  FROM (SELECT count( * ) AS nbr, old_id FROM `structure_fields` GROUP BY old_id) AS res 
  WHERE res.nbr >1
);

ALTER TABLE `structure_fields` ADD UNIQUE (`old_id`);

-- DELETE DUPLICATED structure_fieldst.old_id

UPDATE structure_formats AS st_fo
INNER JOIN structures AS st ON st_fo.structure_id = st.id
INNER JOIN structure_fields AS st_fi ON st_fo.structure_field_id = st_fi.id
SET st_fo.old_id = CONCAT(st.old_id, '_', st_fi.old_id), 
st_fo.structure_old_id = st.old_id, 
st_fo.structure_field_old_id=st_fi.old_id,
st_fo.modified_by = 'NL',
st_fo.modified = '20100212';

UPDATE `structure_formats`
SET `old_id` =  CONCAT(CONCAT(old_id,'_'),id),
`modified_by` = 'NL',
`modified` = '20100212'
WHERE `old_id` IN (
  SELECT res.old_id
  FROM (SELECT count( * ) AS nbr, old_id FROM `structure_formats` GROUP BY old_id) AS res 
  WHERE res.nbr >1
);

ALTER TABLE `structure_formats` ADD UNIQUE (`old_id`);

ALTER TABLE `structure_formats` 
CHANGE `structure_id` `structure_id` INT( 11 ) NOT NULL ,
CHANGE `structure_field_id` `structure_field_id` INT( 11 ) NOT NULL;

-- DELETE DUPLICATED structure_validations.old_id

UPDATE structure_validations AS sv
INNER JOIN structure_fields AS st_fi ON sv.structure_field_id = st_fi.id
SET sv.old_id = CONCAT('GENERATED-', sv.id),
sv.structure_field_old_id = st_fi.old_id,
sv.modified_by = 'NL',
sv.modified = '20100212';

-- ADD STRUCTURE TABLES FK

DELETE FROM structure_validations WHERE structure_field_id NOT IN (SELECT id FROM structure_fields);
DELETE FROM structure_formats WHERE structure_field_id NOT IN (SELECT id FROM structure_fields);
DELETE FROM structure_formats WHERE structure_id NOT IN (SELECT id FROM structures);

ALTER TABLE `structure_validations`
  ADD CONSTRAINT `FK_structure_validations_structure_fields`
  FOREIGN KEY (`structure_field_id`) REFERENCES `structure_fields` (`id`);
  
ALTER TABLE `structure_formats`
  ADD CONSTRAINT `FK_structure_formats_structures`
  FOREIGN KEY (`structure_id`) REFERENCES `structures` (`id`); 
  
ALTER TABLE `structure_formats`
  ADD CONSTRAINT `FK_structure_formats_structure_fields`
  FOREIGN KEY (`structure_field_id`) REFERENCES `structure_fields` (`id`); 

UPDATE structure_fields
SET structure_value_domain = NULL
WHERE structure_value_domain = '0';

ALTER TABLE `structure_fields`
  ADD CONSTRAINT `FK_structure_fields_structure_value_domains`
  FOREIGN KEY (`structure_value_domain`) REFERENCES `structure_value_domains` (`id`); 
  
ALTER TABLE `structure_validations` 
CHANGE `old_id` `old_id` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ,
CHANGE `structure_field_id` `structure_field_id` INT( 11 ) NOT NULL ,
CHANGE `structure_field_old_id` `structure_field_old_id` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ;

ALTER TABLE `structures` 
CHANGE `alias` `alias` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ;

ALTER TABLE `structure_validations` ADD UNIQUE (`old_id`);

-- DROP structure_options

DROP TABLE `structure_options`;

-- Add any new SQL changes to this file which will then be merged with the master
-- upgrade scripts for v2.0.1

/*
  CLINCIAL ANNOTATION  
*/ 

DELETE FROM `i18n`
WHERE `id` IN ('event_group','event_type','mail','in person',
'surgery specific','disease site form', 'annotation', 'event_group',
'event_form_type','summary','clinical','lab', 'lifestyle','clin_study','screening', 
'treatment', 'filter', 'reproductive history', 'link to collection',
'diagnostic' ,'reproductive history','contact', 'diagnosis');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('event_type', '', 'Form Type', 'Type de formulaire'),
('mail', '', 'Mail', 'Courriel'),
('in person', '', 'In Person', 'En personne'),
('annotation', '', 'Annotation', 'Annotation'),
('event_group', '', 'Annotation Group', 'Groupe d''annotation'),
('event_form_type', '', 'Form Type', 'Type de formulaire'),
('summary', '', 'Summary', 'R&eacute;sum&eacute;'),

('clinical', 'global', 'Clinical', 'Clinique'),
('clin_study', 'global', 'Study', '&Eacute;tude'),
('disease site form', '', 'Disease Site Form', ''),
('lab', 'global', 'Lab', 'Lab'),
('lifestyle', 'global', 'Lifestyle', 'Habitude de vie'),
('screening', 'global', 'Screening', 'D&eacute;pistage'),
('surgery specific', '', 'Surgery Specific', ''),
('filter', 'global', 'Filter', 'Filtre'),
('treatment', '', 'Treatment', 'traitement'),

('link to collection', '', 'Participant Collection', 'Collection du participant'), 
('diagnosis' ,'', 'Diagnostic', 'Diagnostique'),
('diagnostic' ,'', 'Diagnostic', 'Diagnostique'),
('reproductive history', '', 'Reproductive History', 'Gyn&eacute;cologie'),
('contact', '', 'Contact', 'Contact');

-- Remove validation for Family History: Age at Diagnosis 
DELETE FROM `structure_validations` WHERE `structure_validations`.`structure_field_id` = (SELECT id FROM `structure_fields` WHERE `plugin` LIKE 'Clinicalannotation' AND `model` LIKE 'FamilyHistory' AND `field` LIKE 'age_at_dx');
 	 
-- Fixed field display for topography
UPDATE `structure_formats` SET `flag_add` = '1',
`flag_edit` = '1' WHERE `structure_formats`.`old_id` = 'CANM-00001_CAN-823';
UPDATE `structure_formats` SET `flag_add` = '1',
`flag_detail` = '1' WHERE `structure_formats`.`old_id` = 'CANM-00010_CAN-823';

-- Improved order of fields on family history form
UPDATE `structure_formats` SET `display_order` = '5' WHERE `structure_formats`.`old_id` = 'CAN-999-999-000-999-3_CAN-999-999-000-999-29';
UPDATE `structure_formats` SET `display_order` = '4' WHERE `structure_formats`.`old_id` = 'CAN-999-999-000-999-3_CAN-999-999-000-999-30';
UPDATE `structure_formats` SET `display_order` = '3' WHERE `structure_formats`.`old_id` = 'CAN-999-999-000-999-3_CAN-999-999-000-999-31';

-- Remove validation for Family History: Age at Diagnosis 
DELETE FROM `structure_validations` WHERE `structure_validations`.`structure_field_id` = (SELECT id FROM `structure_fields` WHERE `plugin` LIKE 'Clinicalannotation' AND `model` LIKE 'FamilyHistory' AND `field` LIKE 'age_at_dx');

-- Manage event language label

UPDATE `structure_fields` SET `language_label` = 'event_form_type' WHERE `old_id` = 'CAN-999-999-000-999-227';
UPDATE `structure_fields` SET `language_label` = '', `language_tag` = '-' WHERE `old_id` = 'CAN-999-999-000-999-228';

-- Manage event type and site display

UPDATE `structure_formats`
SET `language_heading` = null,
`flag_add` = '0',
`flag_add_readonly` = '0',
`flag_edit` = '0',
`flag_edit_readonly` = '0',
`flag_search` = '0',
`flag_search_readonly` = '0',
`flag_datagrid` = '0',
`flag_datagrid_readonly` = '0',
`flag_index` = '1',
`flag_detail` = '0'
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-227', 'CAN-999-999-000-999-228')
AND `structure_old_id` NOT LIKE 'QRY%';

-- Fixes to Breast Screening form
UPDATE `structure_fields` SET `tablename` = 'ed_breast_screening_mammogram' WHERE `structure_fields`.`id` =140;

UPDATE `structure_formats` SET `display_column` = '1', `display_order` = '99', `flag_datagrid` = '0', `flag_index` = '0', `modified_by` = ''
WHERE `structure_formats`.`id` =132;

UPDATE `structure_formats` SET `flag_edit` = '1', `flag_edit_readonly` = '1', `flag_index` = '0', `flag_detail` = '1' 
WHERE `structure_formats`.`id` =129;

UPDATE `structure_formats` SET `flag_edit` = '1', `flag_edit_readonly` = '1', `flag_index` = '0', `flag_detail` = '1', `modified_by` = '0'
WHERE `structure_formats`.`id` =130;

-- Fix tablename for all event master fields
UPDATE `structure_fields` SET `tablename` = 'event_masters' WHERE `structure_fields`.`id` =491;
UPDATE `structure_fields` SET `tablename` = 'event_masters' WHERE `structure_fields`.`id` =490;
UPDATE `structure_fields` SET `tablename` = 'event_masters' WHERE `structure_fields`.`id` =492;
UPDATE `structure_fields` SET `tablename` = 'event_masters' WHERE `structure_fields`.`id` =494;


-- Update smoking form
UPDATE `structures` SET `alias` =  'ed_all_lifestyle_smoking',
`flag_add_columns` = '1',
`flag_edit_columns` = '1' WHERE `structures`.`id` =126;

UPDATE `event_controls` SET `event_type` = 'smoking',
`form_alias` = 'ed_all_lifestyle_smoking',
`detail_tablename` = 'ed_all_lifestyle_smoking' WHERE `event_controls`.`id` =30;

UPDATE `structure_fields` SET `tablename` = 'ed_all_lifestyle_smoking' WHERE `structure_fields`.`id` =579;
UPDATE `structure_fields` SET `tablename` = 'ed_all_lifestyle_smoking' WHERE `structure_fields`.`id` =580;
UPDATE `structure_fields` SET `tablename` = 'ed_all_lifestyle_smoking' WHERE `structure_fields`.`id` =582;
UPDATE `structure_fields` SET `tablename` = 'ed_all_lifestyle_smoking' WHERE `structure_fields`.`id` =583;
UPDATE `structure_fields` SET `tablename` = 'ed_all_lifestyle_smoking' WHERE `structure_fields`.`id` =584;

UPDATE `structure_formats` SET `display_order` = '-10',
`flag_edit` = '1',
`flag_edit_readonly` = '1',
`flag_index` = '0',
`flag_detail` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =1500;

UPDATE `structure_formats` SET `display_order` = '-9',
`flag_edit` = '1',
`flag_edit_readonly` = '1',
`flag_index` = '0',
`flag_detail` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =1501;

UPDATE `structure_formats` SET `flag_datagrid` = '0',
`flag_index` = '0',
`modified_by` = '' WHERE `structure_formats`.`id` =1502;

UPDATE `structure_formats` SET `display_column` = '1',
`display_order` = '99',
`flag_datagrid` = '0',
`flag_index` = '0',
`modified_by` = '' WHERE `structure_formats`.`id` =1503;

UPDATE `structure_formats` SET `display_column` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =1504;

UPDATE `structure_formats` SET `display_column` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =1505;

UPDATE `structure_formats` SET `display_column` = '1',
`flag_datagrid` = '0',
`flag_index` = '0',
`modified_by` = '' WHERE `structure_formats`.`id` =1506;

UPDATE `structure_formats` SET `display_column` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =1507;

UPDATE `structure_formats` SET `display_column` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =1508;

-- Update research form
UPDATE `structure_fields` SET `tablename` = 'ed_all_study_research' WHERE `structure_fields`.`id` =770;

UPDATE `structure_fields` SET `tablename` = 'ed_all_study_research' WHERE `structure_fields`.`id` =772;

UPDATE `structure_fields` SET `tablename` = 'ed_all_study_research' WHERE `structure_fields`.`id` =771;

UPDATE `structure_fields` SET `tablename` = 'ed_all_study_research',
`language_label` = 'picture' WHERE `structure_fields`.`id` =908;

UPDATE `structure_formats` SET `display_order` = '-10',
`flag_edit` = '1',
`flag_edit_readonly` = '1',
`flag_index` = '0',
`flag_detail` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =1715;

UPDATE `structure_formats` SET `display_order` = '-9',
`flag_edit` = '1',
`flag_edit_readonly` = '1',
`flag_index` = '0',
`flag_detail` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =1716;

UPDATE `structure_formats` SET `flag_datagrid` = '0',
`flag_index` = '0',
`modified_by` = '' WHERE `structure_formats`.`id` =1717;

UPDATE `structure_formats` SET `display_column` = '1',
`display_order` = '99',
`flag_datagrid` = '0',
`flag_index` = '0',
`modified_by` = '' WHERE `structure_formats`.`id` =1718;

UPDATE `structure_formats` SET `flag_edit` = '1',
`flag_detail` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =2469;

-- Update followup form
UPDATE `structure_fields` SET `tablename` = 'ed_all_clinical_followup' WHERE `structure_fields`.`id` =503;
UPDATE `structure_fields` SET `tablename` = 'ed_all_clinical_followup' WHERE `structure_fields`.`id` =502;
UPDATE `structure_fields` SET `tablename` = 'ed_all_clinical_followup' WHERE `structure_fields`.`id` =593;
UPDATE `structure_fields` SET `tablename` = 'ed_all_clinical_followup' WHERE `structure_fields`.`id` =499;

UPDATE `structure_formats` SET `display_order` = '-10',
`flag_edit` = '1',
`flag_edit_readonly` = '1',
`flag_index` = '0',
`flag_detail` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =1391;

UPDATE `structure_formats` SET `display_order` = '-9',
`flag_edit` = '1',
`flag_edit_readonly` = '1',
`flag_index` = '0',
`flag_detail` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =1392;

UPDATE `structure_formats` SET `display_order` = '-1',
`flag_datagrid` = '0',
`flag_index` = '0',
`modified_by` = '' WHERE `structure_formats`.`id` =1393;

UPDATE `structure_formats` SET `display_column` = '1',
`display_order` = '99',
`flag_datagrid` = '0',
`flag_index` = '0',
`modified_by` = '' WHERE `structure_formats`.`id` =1394;

UPDATE `structure_formats` SET `display_column` = '1',
`display_order` = '4',
`modified_by` = '' WHERE `structure_formats`.`id` =1395;

UPDATE `structure_formats` SET `display_column` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =1396;

UPDATE `structure_formats` SET `display_column` = '1',
`display_order` = '2',
`modified_by` = '' WHERE `structure_formats`.`id` =1397;

UPDATE `structure_formats` SET `display_column` = '1',
`display_order` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =1398;

-- Update presentation form
ALTER TABLE `ed_all_clinical_presentation` CHANGE `height` `height` DECIMAL( 10, 2 ) NULL DEFAULT NULL,
CHANGE `weight` `weight` DECIMAL( 10, 2 ) NULL DEFAULT NULL;
ALTER TABLE `ed_all_clinical_presentation_revs` CHANGE `height` `height` DECIMAL( 10, 2 ) NULL DEFAULT NULL,
CHANGE `weight` `weight` DECIMAL( 10, 2 ) NULL DEFAULT NULL;

UPDATE `structure_fields` SET `tablename` = 'ed_all_clinical_presentation' WHERE `structure_fields`.`id` =500;

INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`,
`field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`,
`language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`,
`modified`, `modified_by`) VALUES
(NULL , '', '', 'Clinicalannotation', 'EventDetail', 'ed_all_clinical_presentation', 'weight', 'weight', '', 'input', 'size=4', '', NULL , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @field = LAST_INSERT_ID();

UPDATE `structure_formats` SET `structure_field_id` = @field,
`display_column` = '1',
`display_order` = '2',
`flag_index` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =1388;

UPDATE `structure_formats` SET `display_order` = '-10',
`flag_edit` = '1',
`flag_edit_readonly` = '1',
`flag_index` = '0',
`flag_detail` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =1384;

UPDATE `structure_formats` SET `display_order` = '-9',
`flag_edit` = '1',
`flag_edit_readonly` = '1',
`flag_index` = '0',
`flag_detail` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =1385;

UPDATE `structure_formats` SET `display_order` = '-1',
`flag_datagrid` = '0',
`flag_index` = '0',
`modified_by` = '' WHERE `structure_formats`.`id` =1386;

UPDATE `structure_formats` SET `display_column` = '1',
`display_order` = '99',
`flag_datagrid` = '0',
`flag_index` = '0',
`modified_by` = '' WHERE `structure_formats`.`id` =1387;

UPDATE `structure_formats` SET `display_column` = '1',
`display_order` = '3',
`flag_index` = '1',
`modified_by` = '' WHERE `structure_formats`.`id` =1389;

/*
  INVENTORY MANAGEMENT  
*/ 

#SQL View for collections

-- 'view_collection' will be used to search/index/detail collection
INSERT INTO `structures` (
`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , 'CANM-00025', 'view_collection', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @view_collection_structure_id = LAST_INSERT_ID();

INSERT INTO structure_fields (public_identifier,old_id,plugin,model,tablename,field,language_label,language_tag,type,setting,`default`,structure_value_domain,language_help,validation_control,value_domain_control,field_control,created,created_by,modified,modified_by)
SELECT public_identifier,CONCAT(old_id, '-ColView'),plugin,'ViewCollection',tablename,field,language_label,language_tag,type,setting,`default`,structure_value_domain,language_help,validation_control,value_domain_control,field_control,created,created_by,modified,modified_by 
FROM structure_fields 
WHERE old_id IN(
'CAN-999-999-000-999-1000',		-- acquisition_label 
'CAN-999-999-000-999-1223', 	-- bank_id
'CAN-999-999-000-999-1003', 	-- collection_site
'CAN-999-999-000-999-1004', 	-- collection_datetime
'CAN-999-999-000-999-1285', 	-- collection_datetime accuracy
'CAN-999-999-000-999-1007', 	-- sop_master_id
'CAN-999-999-000-999-1013', 	-- collection_property
'CAN-999-999-000-999-1008'); 	-- collection_notes

INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
SELECT CONCAT('CANM-00025_', structure_field_old_id, '-ColView'), @view_collection_structure_id, 'CANM-00025', `structure_field_id`, CONCAT(`structure_field_old_id`, '-ColView'), `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, '0', '0', '0', '0', `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`
FROM structure_formats WHERE structure_old_id='CAN-999-999-000-999-1000' AND (flag_search='1' OR flag_index='1' OR flag_detail='1');

SET @last_id = LAST_INSERT_ID();

UPDATE structure_formats
INNER JOIN structure_fields ON structure_fields.old_id=structure_formats.structure_field_old_id
SET structure_formats.structure_field_id=structure_fields.id
WHERE structure_formats.id >= @last_id;

UPDATE structure_formats
SET display_order = '0'
WHERE old_id = 'CANM-00025_CAN-999-999-000-999-1000-ColView'; 

-- 'collections' will be used to Add/Edit collection: Clean up structures based on previous definitions
UPDATE structure_formats 
SET flag_search = '0', flag_search_readonly = '0', 
flag_datagrid = '0', flag_datagrid_readonly = '0', 
flag_index = '0', flag_detail = '0'
WHERE structure_old_id = 'CAN-999-999-000-999-1000';

UPDATE structure_formats 
SET flag_index = '1'
WHERE structure_old_id = 'CAN-999-999-000-999-1000'
AND structure_field_old_id IN ('CAN-999-999-000-999-1000', 'CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1004', 'CAN-999-999-000-999-1003');

-- Add fields to collection_view
INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , '', 'CANM-00026', 'Inventorymanagement', 'ViewCollection', '', 'participant_identifier', 'participant identifier', '', 'input', 'size=30', '', NULL , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @last_structure_filed_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , 'CANM-00025_CANM-00026', @view_collection_structure_id, 'CANM-00025', @last_structure_filed_id, 'CANM-00026', '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Update summary
UPDATE `menus`
SET `use_summary` = 'Inventorymanagement.ViewCollection::summary'
WHERE `use_summary` LIKE 'Inventorymanagement.Collection::summary';

-- Build View

CREATE VIEW view_collections AS 
SELECT 
col.id AS collection_id, 
col.bank_id, 
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id, 

part.participant_identifier, 

col.acquisition_label, 
col.collection_site, 
col.collection_datetime, 
col.collection_datetime_accuracy, 
col.collection_property, 
col.collection_notes, 
col.deleted,

banks.name AS bank_name

FROM collections AS col
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
WHERE col.deleted != 1;

#end SQL view for collections

#cell lysate

CREATE TABLE `sd_der_cell_lysates` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ; 

CREATE TABLE `sd_der_cell_lysates_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ; 

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('cell lysate', 'cell lysate');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='sample_type'),  (SELECT id FROM structure_permissible_values WHERE value='cell lysate' AND language_alias='cell lysate'), '0', 'yes');

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_type_code`, `sample_category`, `status`, `form_alias`, `detail_tablename`, `display_order`)
VALUES (NULL , 'cell lysate', 'C-LYSATE', 'derivative', 'active', 'sd_undetailed_derivatives', 'sd_der_cell_lysates', '0');


SET @last_id = LAST_INSERT_ID();

INSERT INTO `parent_to_derivative_sample_controls` (`id` ,`parent_sample_control_id` ,`derivative_sample_control_id` ,`status`) VALUES 
(NULL , '3', @last_id, 'active'),#tissue
(NULL , '11', @last_id, 'active'),#cell culture
(NULL , '8', @last_id, 'active');#pbmc
#end cell lysate

#clean up
UPDATE structure_value_domains_permissible_values AS tu
INNER JOIN (SELECT spv.id AS spv_id, doubles.id AS d_id, c FROM structure_permissible_values AS spv INNER JOIN
(select *, count(*) AS c from structure_permissible_values group by value, language_alias HAVING c > 1) AS doubles ON spv.language_alias=doubles.language_alias AND spv.value=doubles.value) as m on tu.structure_permissible_value_id=m.spv_id
SET tu.structure_permissible_value_id=m.d_id;

CREATE TEMPORARY TABLE tmp_id(
id int(11) unsigned not null
);

INSERT INTO tmp_id (SELECT spv.id FROM structure_permissible_values AS spv INNER JOIN
(select *, count(*) AS c from structure_permissible_values group by value, language_alias HAVING c > 1) AS doubles ON spv.language_alias=doubles.language_alias AND spv.value=doubles.value WHERE spv.id!=doubles.id);

DELETE FROM structure_permissible_values WHERE id IN
(SELECT * FROM tmp_id);

DROP TABLE tmp_id;

ALTER TABLE structure_permissible_values ADD UNIQUE KEY(value, language_alias);

#yes no for checkboxes
INSERT INTO structure_permissible_values(value, language_alias) VALUES
('0', 'no'),
('1', 'yes');

SET @last_id = LAST_INSERT_ID();

INSERT INTO structure_value_domains(domain_name) VALUES('yes_no_checkbox');

SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO structure_value_domains_permissible_values(structure_value_domain_id, structure_permissible_value_id) VALUES
(@last_structure_id, @last_id),
(@last_structure_id, @last_id + 1);

#repair accentuated chars
UPDATE `i18n` SET fr='Août' WHERE id='aug';
UPDATE `i18n` SET fr='Déc' WHERE id='dec';
UPDATE `i18n` SET fr='Décembre' WHERE id='December';
UPDATE `i18n` SET fr='Fév' WHERE id='feb';
UPDATE `i18n` SET fr='Février' WHERE id='February';
UPDATE `i18n` SET fr='Cliquez pour supprimer ces éléments' WHERE id='click to remove these elements';
UPDATE `i18n` SET fr='Reçu par' WHERE id='Received By';
UPDATE `i18n` SET fr='Date et heure de Réception' WHERE id='Received DateTime';

#structure_value_domains cleanup
UPDATE structure_fields SET structure_value_domain=6 WHERE structure_value_domain IN(4, 7, 8);
UPDATE structure_fields SET structure_value_domain=32 WHERE structure_value_domain=60;
UPDATE structure_fields SET structure_value_domain=101 WHERE structure_value_domain=162;
UPDATE structure_fields SET structure_value_domain=42 WHERE structure_value_domain=41;
UPDATE structure_fields SET structure_value_domain=36 WHERE structure_value_domain IN(161, 165);
UPDATE structure_fields SET structure_value_domain=130 WHERE structure_value_domain IN(137, 138);
UPDATE structure_fields SET structure_value_domain=77 WHERE structure_value_domain IN(148, 149, 151);
UPDATE structure_fields SET structure_value_domain=69 WHERE structure_value_domain IN(71, 73, 74);
UPDATE structure_fields SET structure_value_domain=70 WHERE structure_value_domain=72;
UPDATE structure_fields SET structure_value_domain=22 WHERE structure_value_domain IN(25, 26, 28, 29, 31, 46, 51, 120, 133, 136, 142, 158, 168);
UPDATE structure_fields SET structure_value_domain=64 WHERE structure_value_domain IN(65, 66, 67, 68);
UPDATE structure_fields SET structure_value_domain=76 WHERE structure_value_domain=167; 
DELETE FROM structure_value_domains WHERE id IN(4, 7, 8, 9, 10, 11, 17, 41, 60, 71, 72, 73, 74, 162, 137, 138, 148, 149, 151, 25, 26, 28, 29, 31, 46, 51, 120, 133, 136, 142, 158, 168, 65, 66, 67, 68, 161, 165, 167);
UPDATE structure_value_domains SET domain_name='disease site 1' WHERE id=80;
UPDATE structure_value_domains SET domain_name='disease site 2' WHERE id=101;
UPDATE structure_value_domains SET domain_name='disease site 3' WHERE id=152;
UPDATE structure_value_domains SET domain_name='method 1' WHERE id=100;
UPDATE structure_value_domains SET domain_name='method 2' WHERE id=160;
UPDATE structure_value_domains SET domain_name='status 1' WHERE id=77;
UPDATE structure_value_domains SET domain_name='status 2' WHERE id=78;
UPDATE structure_value_domains SET domain_name='status 3' WHERE id=83;
UPDATE structure_value_domains SET domain_name='tumor type 1' WHERE id=55;
UPDATE structure_value_domains SET domain_name='tumor type 2' WHERE id=98;
UPDATE structure_value_domains SET domain_name='yesno locked' WHERE id=14;
UPDATE structure_value_domains SET domain_name='yes' WHERE id=64;
ALTER TABLE structure_value_domains ADD UNIQUE KEY(`domain_name`);

-- Add descritpion to structures to add information about a structure
ALTER TABLE `structures` ADD `description` VARCHAR( 250 ) NULL AFTER `alias` ;

-- Delete structure collection_search_type
DELETE FROM structure_formats WHERE old_id = 'CAN-999-999-000-999-1075_CAN-999-999-000-999-1275';
DELETE FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1275';
DELETE FROM structures WHERE old_id = 'CAN-999-999-000-999-1075';

-- Add dscription to '%collection%' structures
UPDATE structures SET description = 'Used to both create (add) and update (edit) a collection being not linked to a participant plus to display collection data in radiolist view to link a collection to a participant.' WHERE alias LIKE 'collections';
UPDATE structures SET description = 'Used to update (edit) a collection linked to a participant (collection property in read only).' WHERE alias LIKE 'linked_collections';
UPDATE structures SET description = 'Used to include participant identifier data into following views: collection search, collection index and collection detail.' WHERE alias LIKE 'view_collection';
UPDATE structures SET description = 'Used to display data into collection tree view (collection data + sample data + aliquot data).' WHERE alias LIKE '%collection_tree_view';
UPDATE structures SET description = 'Used to display data attached to the participant collection link (collection, diagnosis, consent).' WHERE alias LIKE 'clinicalcollectionlinks';

#SQL create sample views for 
#  - collection samples listall ('view_sample_joined_to_parent')
#  - samples search ('view_sample_joined_to_collection')

-- Create Sample View Fields
INSERT INTO structure_fields (public_identifier,old_id,plugin,model,tablename,field,language_label,language_tag,type,setting,`default`,structure_value_domain,language_help,validation_control,value_domain_control,field_control,created,created_by,modified,modified_by)
SELECT public_identifier,CONCAT(old_id, '-SampView'),plugin,'ViewSample',tablename,field,language_label,language_tag,type,setting,`default`,structure_value_domain,language_help,validation_control,value_domain_control,field_control,created,created_by,modified,modified_by 
FROM structure_fields 
WHERE old_id IN(
'CAN-999-999-000-999-1000',		-- acquisition_label 
'CAN-999-999-000-999-1223', 	-- bank_id
'CAN-999-999-000-999-1222', 	-- initial_specimen_sample_type
'CAN-999-999-000-999-1276', 	-- parent_sample_type
'CAN-999-999-000-999-1018', 	-- sample_type
'CAN-999-999-000-999-1016', 	-- sample_code
'CAN-999-999-000-999-1027'); 	-- sample_category

UPDATE structure_fields SET field = 'parent_sample_type' WHERE old_id LIKE 'CAN-999-999-000-999-1276-SampView';

-- 'view_sample_joined_to_parent' will be used to list all master data of samples linked to one collection
INSERT INTO `structures` (
`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , 'CAN-999-999-000-999-1093', 'view_sample_joined_to_parent', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @view_collection_samples_structure_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
SELECT CONCAT('CAN-999-999-000-999-1093_', structure_field_old_id, '-SampView'), @view_collection_samples_structure_id, 'CAN-999-999-000-999-1093', `structure_field_id`, CONCAT(`structure_field_old_id`, '-SampView'), `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, '0', '0', '0', '0', `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`
FROM structure_formats 
WHERE structure_old_id='CAN-999-999-000-999-1002' 
AND structure_field_old_id IN(
'CAN-999-999-000-999-1222', 	-- initial_specimen_sample_type
'CAN-999-999-000-999-1276', 	-- parent_sample_type
'CAN-999-999-000-999-1018', 	-- sample_type
'CAN-999-999-000-999-1016', 	-- sample_code
'CAN-999-999-000-999-1027'); 	-- sample_category

SET @last_id = LAST_INSERT_ID();

UPDATE structure_formats
INNER JOIN structure_fields ON structure_fields.old_id=structure_formats.structure_field_old_id
SET structure_formats.structure_field_id=structure_fields.id
WHERE structure_formats.id >= @last_id;

UPDATE structure_formats 
SET 
flag_add = '0', flag_add_readonly = '0', 
flag_edit = '0', flag_edit_readonly = '0', 
flag_search = '0', flag_search_readonly = '0', 
flag_datagrid = '0', flag_datagrid_readonly = '0', 
flag_index = '1', flag_detail = '0'
WHERE structure_old_id = 'CAN-999-999-000-999-1093';

-- 'view_sample_joined_to_collection' will be used to search samples and list all master data of samples returned by query
INSERT INTO `structures` (
`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , 'CAN-999-999-000-999-1094', 'view_sample_joined_to_collection', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @view_samples_structure_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
SELECT CONCAT('CAN-999-999-000-999-1094_', structure_field_old_id, '-SampView'), @view_samples_structure_id, 'CAN-999-999-000-999-1094', `structure_field_id`, CONCAT(`structure_field_old_id`, '-SampView'), `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, '0', '0', '0', '0', `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`
FROM structure_formats 
WHERE structure_old_id='CAN-999-999-000-999-1002' 
AND structure_field_old_id IN(
'CAN-999-999-000-999-1000',		-- acquisition_label 
'CAN-999-999-000-999-1223', 	-- bank_id
'CAN-999-999-000-999-1222', 	-- initial_specimen_sample_type
'CAN-999-999-000-999-1276', 	-- parent_sample_type
'CAN-999-999-000-999-1018', 	-- sample_type
'CAN-999-999-000-999-1016', 	-- sample_code
'CAN-999-999-000-999-1027'); 	-- sample_category

SET @last_id = LAST_INSERT_ID();

UPDATE structure_formats
INNER JOIN structure_fields ON structure_fields.old_id=structure_formats.structure_field_old_id
SET structure_formats.structure_field_id=structure_fields.id
WHERE structure_formats.id >= @last_id;

UPDATE structure_formats 
SET 
flag_add = '0', flag_add_readonly = '0', 
flag_edit = '0', flag_edit_readonly = '0', 
flag_search = '1', flag_search_readonly = '0', 
flag_datagrid = '0', flag_datagrid_readonly = '0', 
flag_index = '1', flag_detail = '0'
WHERE structure_old_id = 'CAN-999-999-000-999-1094';

-- Add fields to sample_view
INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , '', 'CAN-999-999-000-999-1290', 'Inventorymanagement', 'ViewSample', '', 'participant_identifier', 'participant identifier', '', 'input', 'size=30', '', NULL , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @last_structure_filed_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , 'CAN-999-999-000-999-1094_CAN-999-999-000-999-1290', @view_samples_structure_id, 'CAN-999-999-000-999-1094', @last_structure_filed_id, 'CAN-999-999-000-999-1290', '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Delete sample masters view
DELETE FROM structure_formats WHERE structure_old_id = 'CAN-999-999-000-999-1002';
DELETE FROM structures WHERE old_id = 'CAN-999-999-000-999-1002';

-- Build View

CREATE VIEW view_samples AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id,
col.id AS collection_id, 
col.bank_id, 
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

samp.initial_specimen_sample_type, 	
parent_samp.sample_type AS parent_sample_type,
samp.sample_type,
samp.sample_code,
samp.sample_category,
samp.deleted

FROM sample_masters as samp
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
WHERE samp.deleted != 1;

-- DELETE FROM acquisition_label and bank_id from sample details structure

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'sd_%')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1000' OR old_id = 'CAN-999-999-000-999-1223');

#end SQL view for samples

-- Delete participant_sample_list structure
DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'participant_sample_list');
DELETE FROM structures WHERE alias = 'participant_sample_list';

-- Add dscription to '%sample%' structures
UPDATE structures SET description = 'Used to include participant identifier and collection data into following views: sample search and sample index.' WHERE alias LIKE 'view_sample_joined_to_collection';
UPDATE structures SET description = 'Used to include initial and parent sample data into collection samples list and derivative samples list.' WHERE alias LIKE 'view_sample_joined_to_parent';

#End SQL create sample views

#protein

CREATE TABLE `sd_der_proteins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_sd_der_amp_rnas_sample_masters` (`sample_master_id`),
  FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `sd_der_proteins_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_type_code`, `sample_category`, `status`, `form_alias`, `detail_tablename`, `display_order`)
VALUES (NULL , 'protein', 'PROT', 'derivative', 'active', 'sd_undetailed_derivatives', 'sd_der_proteins', '0');

INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`, `derivative_sample_control_id`, `status`) VALUES
((SELECT id FROM sample_controls WHERE sample_type='cell lysate'), (SELECT id FROM sample_controls WHERE sample_type='dna'), 'active'),
((SELECT id FROM sample_controls WHERE sample_type='cell lysate'), (SELECT id FROM sample_controls WHERE sample_type='rna'), 'active'),
((SELECT id FROM sample_controls WHERE sample_type='cell lysate'), (SELECT id FROM sample_controls WHERE sample_type='protein'), 'active');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES('protein', 'protein');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name='sample_type'),  (SELECT id FROM structure_permissible_values WHERE value='protein' AND language_alias='protein'), '0', 'yes');

INSERT INTO sample_to_aliquot_controls (`sample_control_id`, `aliquot_control_id`, `status`) VALUES
((SELECT id FROM sample_controls WHERE sample_type='cell lysate'), (SELECT id FROM aliquot_controls WHERE aliquot_type='tube' AND form_alias='ad_spec_tubes'), 'active'),
((SELECT id FROM sample_controls WHERE sample_type='protein'), (SELECT id FROM aliquot_controls WHERE aliquot_type='tube' AND form_alias='ad_spec_tubes'), 'active');

#End protein

#SQL 
# . create aliquot views 
#     - for aliquot search ('view_aliquot_joined_to_collection')
#     - for sample aliquots listall ('view_aliquot_joined_to_sample')
# . create aliquotmasters for aliquot list displayed into sample detail form
-- Create Aliquot View Fields
INSERT INTO structure_fields (public_identifier,old_id,plugin,model,tablename,field,language_label,language_tag,type,setting,`default`,structure_value_domain,language_help,validation_control,value_domain_control,field_control,created,created_by,modified,modified_by)
SELECT public_identifier,CONCAT(old_id, '-AliqView'),plugin,'ViewAliquot',tablename,field,language_label,language_tag,type,setting,`default`,structure_value_domain,language_help,validation_control,value_domain_control,field_control,created,created_by,modified,modified_by 
FROM structure_fields 
WHERE old_id IN(
'CAN-999-999-000-999-1000', 	-- Inventorymanagement.Collection.acquisition_label
'CAN-999-999-000-999-1223', 	-- Inventorymanagement.Collection.bank_id
'CAN-999-999-000-999-1222', 	-- Inventorymanagement.SampleMaster.initial_specimen_sample_type
'CAN-999-999-000-999-1276', 	-- Inventorymanagement.GeneratedParentSample.sample_type
'CAN-999-999-000-999-1018', 	-- Inventorymanagement.SampleMaster.sample_type
'CAN-999-999-000-999-1102', 	-- Inventorymanagement.AliquotMaster.aliquot_type
'CAN-999-999-000-999-1100', 	-- Inventorymanagement.AliquotMaster.barcode
'CAN-999-999-000-999-1103', 	-- Inventorymanagement.AliquotMaster.in_stock
'CAN-999-999-000-999-1105', 	-- Inventorymanagement.Generated.aliquot_use_counter
'CAN-999-999-000-999-1217', 	-- Storagelayout.StorageMaster.selection_label
'CAN-999-999-000-999-1107', 	-- Inventorymanagement.AliquotMaster.storage_coord_x
'CAN-999-999-000-999-1108'); 	-- Inventorymanagement.AliquotMaster.storage_coord_y

-- 'view_aliquot_joined_to_collection' will be used to search aliquots and list all master data of aliquots returned by query
INSERT INTO `structures` (
`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , 'CAN-999-999-000-999-1095', 'view_aliquot_joined_to_collection', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @view_aliquots_structure_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
SELECT CONCAT('CAN-999-999-000-999-1095_', structure_field_old_id, '-AliqView'), @view_aliquots_structure_id, 'CAN-999-999-000-999-1095', `structure_field_id`, CONCAT(`structure_field_old_id`, '-AliqView'), `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, '0', '0', '0', '0', `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`
FROM structure_formats 
WHERE structure_old_id='CAN-999-999-000-999-1020' 
AND structure_field_old_id IN(
'CAN-999-999-000-999-1000', 	-- Inventorymanagement.Collection.acquisition_label
'CAN-999-999-000-999-1223', 	-- Inventorymanagement.Collection.bank_id
'CAN-999-999-000-999-1222', 	-- Inventorymanagement.SampleMaster.initial_specimen_sample_type
'CAN-999-999-000-999-1276', 	-- Inventorymanagement.GeneratedParentSample.sample_type
'CAN-999-999-000-999-1018', 	-- Inventorymanagement.SampleMaster.sample_type
'CAN-999-999-000-999-1102', 	-- Inventorymanagement.AliquotMaster.aliquot_type
'CAN-999-999-000-999-1100', 	-- Inventorymanagement.AliquotMaster.barcode
'CAN-999-999-000-999-1103', 	-- Inventorymanagement.AliquotMaster.in_stock
'CAN-999-999-000-999-1105', 	-- Inventorymanagement.Generated.aliquot_use_counter
'CAN-999-999-000-999-1217', 	-- Storagelayout.StorageMaster.selection_label
'CAN-999-999-000-999-1107', 	-- Inventorymanagement.AliquotMaster.storage_coord_x
'CAN-999-999-000-999-1108'); 	-- Inventorymanagement.AliquotMaster.storage_coord_y

SET @last_id = LAST_INSERT_ID();

UPDATE structure_formats
INNER JOIN structure_fields ON structure_fields.old_id=structure_formats.structure_field_old_id
SET structure_formats.structure_field_id=structure_fields.id
WHERE structure_formats.id >= @last_id;

-- Add fields to aliquot_view
INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , '', 'CAN-999-999-000-999-1291', 'Inventorymanagement', 'ViewAliquot', '', 'participant_identifier', 'participant identifier', '', 'input', 'size=30', '', NULL , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @last_structure_filed_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , 'CAN-999-999-000-999-1095_CAN-999-999-000-999-1291', @view_aliquots_structure_id, 'CAN-999-999-000-999-1095', @last_structure_filed_id, 'CAN-999-999-000-999-1291', '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE structure_fields SET field = 'parent_sample_type' WHERE old_id LIKE 'CAN-999-999-000-999-1276-AliqView';

UPDATE structure_formats 
SET flag_search = '1'
WHERE structure_old_id = 'CAN-999-999-000-999-1095'
AND structure_field_old_id IN('CAN-999-999-000-999-1276-AliqView', 'CAN-999-999-000-999-1217-AliqView') ;

-- Build View

CREATE VIEW view_aliquots AS 
SELECT 
al.id AS aliquot_master_id,
samp.id AS sample_master_id,
col.id AS collection_id, 
col.bank_id, 
stor.id AS storage_master_id,
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

samp.initial_specimen_sample_type, 	
parent_samp.sample_type AS parent_sample_type,
samp.sample_type,

al.barcode,
al.aliquot_type,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

COUNT(al_use.id) as aliquot_use_counter,

al.deleted

FROM aliquot_masters as al
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN aliquot_uses AS al_use ON al_use.aliquot_master_id = al.id AND al_use.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
WHERE al.deleted != 1
GROUP BY al.id;

-- Create view_aliquot

UPDATE structures SET alias = 'view_aliquot_joined_to_sample' WHERE old_id = 'CAN-999-999-000-999-1020';
DELETE FROM structure_formats WHERE structure_old_id = 'CAN-999-999-000-999-1020';

SET @view_collection_aliquots_structure_id = (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1020');

INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
SELECT CONCAT('CAN-999-999-000-999-1020_', structure_field_old_id), @view_collection_aliquots_structure_id, 'CAN-999-999-000-999-1020', `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, '0', '0', '0', '0', `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`
FROM structure_formats 
WHERE structure_old_id='CAN-999-999-000-999-1095' 
AND structure_field_old_id IN(
'CAN-999-999-000-999-1222-AliqView', 	-- Inventorymanagement.ViewAliquot.initial_specimen_sample_type
'CAN-999-999-000-999-1276-AliqView', 	-- Inventorymanagement.ViewAliquot.parent_sample_type
'CAN-999-999-000-999-1018-AliqView', 	-- Inventorymanagement.ViewAliquot.sample_type
'CAN-999-999-000-999-1102-AliqView', 	-- Inventorymanagement.ViewAliquot.aliquot_type
'CAN-999-999-000-999-1100-AliqView', 	-- Inventorymanagement.ViewAliquot.barcode
'CAN-999-999-000-999-1103-AliqView', 	-- Inventorymanagement.ViewAliquot.in_stock
'CAN-999-999-000-999-1105-AliqView', 	-- Inventorymanagement.ViewAliquot.aliquot_use_counter
'CAN-999-999-000-999-1217-AliqView', 	-- Storagelayout.ViewAliquot.selection_label
'CAN-999-999-000-999-1107-AliqView', 	-- Inventorymanagement.ViewAliquot.storage_coord_x
'CAN-999-999-000-999-1108-AliqView'); 	-- Inventorymanagement.ViewAliquot.storage_coord_y

UPDATE structure_formats 
SET 
flag_add = '0', flag_add_readonly = '0', 
flag_edit = '0', flag_edit_readonly = '0', 
flag_search = '0', flag_search_readonly = '0', 
flag_datagrid = '0', flag_datagrid_readonly = '0', 
flag_index = '1', flag_detail = '0'
WHERE structure_old_id = 'CAN-999-999-000-999-1020';

-- Create aliquotmasters

UPDATE structures SET alias = 'aliquotmasters' WHERE old_id = 'CAN-999-999-000-999-1079';

UPDATE structure_formats 
SET 
flag_add = '0', flag_add_readonly = '0', 
flag_edit = '0', flag_edit_readonly = '0', 
flag_search = '0', flag_search_readonly = '0', 
flag_datagrid = '0', flag_datagrid_readonly = '0', 
flag_index = '1', flag_detail = '0'
WHERE structure_old_id = 'CAN-999-999-000-999-1079';

-- Drop structure 'aliquotmasters_summary'
DELETE FROM structure_formats WHERE structure_old_id = 'CAN-999-999-000-999-1090';
DELETE FROM structures WHERE old_id = 'CAN-999-999-000-999-1090';

-- Delete collection.acquisition_label and collection.bank_id from aliquot details structures
DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'ad_der_%' OR alias LIKE 'ad_spec_%')
AND structure_field_old_id IN(
'CAN-999-999-000-999-1000', 	-- Inventorymanagement.Collection.acquisition_label;
'CAN-999-999-000-999-1223');	-- Inventorymanagement.Collection.bank_id;

-- Add dscription to '%aliquot%' structures
UPDATE structures SET description = 'Used to include participant identifier and collection data into following views: aliquot search and aliquot index.' 
WHERE alias LIKE 'view_aliquot_joined_to_collection';
UPDATE structures SET description = 'Used to include sample data plus initial and parent sample data into collection aliquots list and sample aliquots list.' 
WHERE alias LIKE 'view_aliquot_joined_to_sample';
UPDATE structures SET description = 'Used to list aliquots data excluding linked sample data into sample detail view.' 
WHERE alias LIKE 'aliquotmasters';

UPDATE structures SET description = 'Used to list and display detail of aliquot uses plus create and edit all uses not created by the system.' 
WHERE alias LIKE 'aliquotuses';
UPDATE structures SET description = 'Used to edit all uses created by the system (as ''realiquoted aliquot'', ''shipped aliquot'', etc).' 
WHERE alias LIKE 'aliquotuses_system_dependent';

UPDATE structures SET description = 'Used to display aliquot data into storage tree view.' 
WHERE alias LIKE 'aliquot_masters_for_storage_tree_view';

UPDATE structures SET description = 'Used to select children aliquots created from a parent aliquot (children and parent being both linked to the same sample).' 
WHERE alias LIKE 'children_aliquots_selection';
UPDATE structures SET description = 'Used to display realiquoted parent aliquots used to create a children aliquot (children and parent being both linked to the same sample).' 
WHERE alias LIKE 'realiquotedparent';

UPDATE structures SET description = 'Used to select and list aliquots of a parent sample used to create a derivative sample.' 
WHERE alias LIKE 'sourcealiquots';

UPDATE structures SET description = 'Used to define and display aliquots of a parent sample used to create a derivative sample.' 
WHERE alias LIKE 'qctestedaliquots';

#End SQL create sample view for collection samples listall and samples search

-- DELETE unused structure
DELETE FROM structure_formats WHERE structure_old_id IN (SELECT old_id FROM structures WHERE alias IN ('manage_storage_aliquots_without_position', 'std_1_dim_position_selection_for_aliquot', 'std_2_dim_position_selection_for_aliquot'));
DELETE FROM structures WHERE alias IN ('manage_storage_aliquots_without_position', 'std_1_dim_position_selection_for_aliquot', 'std_2_dim_position_selection_for_aliquot');

-- Add/modify structure description

ALTER TABLE `structures` CHANGE `description` `description` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL; 

UPDATE `structures` SET `description` =  'Used to include sample data plus both initial and parent sample data into collection aliquots list and sample aliquots list.' 
WHERE `alias` = 'view_aliquot_joined_to_sample' ;

UPDATE `structures` SET `description` =  'Used to include both initial and parent sample data into collection samples list and derivative samples list.' 
WHERE `alias` = 'view_sample_joined_to_parent' ;

UPDATE `structures` SET `description` =  'Used to select and display aliquots of a sample used to realize a sample quality control test.' 
WHERE `alias` = 'qctestedaliquots' ;

UPDATE `structures` SET `description` =  'Used to list all aliquots of sample into sample detail view (displaying aliquot without linked sample data).' 
WHERE `alias` = 'aliquotmasters' ;

UPDATE `structures` SET `description` =  'USed to set data of the created order items when a user adds many aliquots to an order line in batch.'
WHERE `alias` = 'orderitems_to_addAliquotsInBatch' ;

ALTER TABLE storage_controls
	ADD display_x_size tinyint unsigned not null default 0 AFTER coord_y_size,
	ADD display_y_size tinyint unsigned not null default 0 AFTER display_x_size,
	ADD reverse_x_numbering boolean not null default false AFTER display_y_size,
	ADD reverse_y_numbering boolean not null default false AFTER reverse_x_numbering;

UPDATE storage_controls SET display_x_size=sqrt(IFNULL(coord_x_size, 1)), display_y_size=sqrt(IFNULL(coord_x_size, 1)) WHERE square_box=1;

ALTER TABLE storage_controls
	DROP square_box,
	DROP horizontal_display;

ALTER TABLE i18n
	MODIFY id varchar(255) NOT NULL,
	MODIFY en varchar(255) NOT NULL,
	MODIFY fr varchar(255) NOT NULL;
INSERT IGNORE INTO i18n (`id`, `page_id`, `en`, `fr`) VALUES
#("lang head", "global", "lang head", ""), 
#("new head", "global", "new head", ""), 
("tissue core", "global", "Tissue core", "Carotte de tissus"), 
#("-", "global", "-", ""), 
("define as shipped", "global", "Define as shipped", "Définir comme expédié"), 
("new label", "global", "New label", "Nouvel étiquette"), 
("new tag", "global", "New tag", "Nouveau tag"), 
("new help", "global", "New help", "Nouvel aide"), 
("blood lymph", "global", "Blood lymph", "Sang lympathique"), 
("use by", "global", "Use by", "Utilisation par"), 
("use date", "global", "Use date", "Date d'utilisation"), 
("date_effective", "global", "Effective date", "Date d'entrée en vigueur"), 
("date_expiry", "global", "Expiration date", "Date d'expiration"), 
("number of participants", "global", "Number of participants", "Nombre de participants"), 
("aquisition_label", "global", "Aquisition label", "Étiquette d'acquisition"), 
("data", "global", "Data", "Données"), 
("surgical procedure", "global", "Surgical procedure", "Procédure chirurgicale"), 
("picture", "global", "Picture", "Image"), 
#("lang labq", "global", "lang labq", ""), 
("date/time", "global", "date/time", "date/heure"), 
#("lang tag", "global", "lang tag", ""), 
("0", "global", "0", "0"), 
("20", "global", "20", "20"), 
("50", "global", "50", "50"), 
("5th", "global", "5th", "5è"), 
("6th", "global", "6th", "6è"), 
("base", "global", "Base", "Base"), 
#("custom_tool_2", "global", "custom_tool_2", ""), 
("cell lysate", "global", "cell lysate", "Lysat cellulaire"), 
#("collection_site_1", "global", "collection_site_1", ""), 
#("collection_site_2", "global", "collection_site_2", ""), 
#("collection_site_etc", "global", "collection_site_etc", ""), 
#("custom_laboratory_site_1", "global", "custom_laboratory_site_1", ""), 
#("custom_laboratory_site_2", "global", "custom_laboratory_site_2", ""), 
#("custom_laboratory_site_etc", "global", "custom_laboratory_site_etc", ""), 
#("custom_laboratory_staff_1", "global", "custom_laboratory_staff_1", ""), 
#("custom_laboratory_staff_2", "global", "custom_laboratory_staff_2", ""), 
#("custom_laboratory_staff_etc", "global", "custom_laboratory_staff_etc", ""), 
#("custom_supplier_dept_1", "global", "custom_supplier_dept_1", ""), 
#("custom_supplier_dept_2", "global", "custom_supplier_dept_2", ""), 
#("custom_supplier_dept_etc", "global", "custom_supplier_dept_etc", ""), 
#("custom_tool_1", "global", "custom_tool_1", ""), 
#("custom_tool_etc", "global", "custom_tool_etc", ""), 
#("d l mix", "global", "d l mix", ""), 
("DMY", "global", "DMY", "JMA"), 
("Dr. Carl Spencer", "global", "Dr. Carl Spencer", ""), 
("Dr. Francois Dionne", "global", "Dr. Francois Dionne", ""), 
("Dr. James Kelly", "global", "Dr. James Kelly", ""), 
("Dr. Pete Stevens", "global", "Dr. Pete Stevens", ""), 
("IM: intramuscular injection", "global", "IM: intramuscular injection", ""), 
("IV: Intravenous", "global", "IV: Intravenous", ""), 
("MDY", "global", "MDY", "MJA"), 
#("p.o.: by mouth", "global", "p.o.: by mouth", "p.o.:Par la bouche"), 
("PR: per rectum", "global", "PR: per rectum", "PR: Par le rectum"), 
("protein", "global", "Protein", "Protéine"), 
("research", "global", "Research", "Recherche"), 
("SC: subcutaneous injection", "global", "SC: subcutaneous injection", "SC: Injection sous-cuatnée"), 
("surgical/clinical", "global", "surgical/clinical", "chirurgical/clinique"), 
("used", "global", "Used", "Utilisé"), 
("YMD", "global", "YMD", "AMJ"), 
("A valid username is required, between 5 to 15, and a mix of alphabetical and numeric characters only.", "global", "A valid username is required, between 5 to 15, and a mix of alphabetical and numeric characters only.", "Un nom d'utilisateur composé exclusivement de 5 à 15 caractères alphanumériques est requis."), 
("Preference setting is required.", "global", "Preference setting is required.", "La paramètre de préférence est requis."), 
("Consent status field is required.", "global", "Consent status field is required.", "Le champ statut de consentement est requis."), 
("Estrogen amount is required.", "global", "Estrogen amount is required.", "La quantité d'estrogènes est requise."), 
("product type is required.", "global", "product type is required.", "Le type de produit est requis.");

-- Add tissue weight

ALTER TABLE `sd_spe_tissues` 
	ADD `tissue_weight` VARCHAR( 10 ) NULL AFTER `tissue_size_unit`,
	ADD `tissue_weight_unit` VARCHAR( 10 ) NULL AFTER `tissue_weight`  ;

ALTER TABLE `sd_spe_tissues_revs` 
	ADD `tissue_weight` VARCHAR( 10 ) NULL AFTER `tissue_size_unit`,
	ADD `tissue_weight_unit` VARCHAR( 10 ) NULL AFTER `tissue_weight`  ;
	
DELETE FROM `structure_value_domains_permissible_values` 
WHERE `structure_value_domain_id` = (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'tissue_size_unit') 
AND language_alias = 'gr';

INSERT INTO structure_value_domains(domain_name) VALUES('tissue_weight_unit');
SET @structure_value_domain_id = LAST_INSERT_ID();

SET @value_id = (SELECT id FROM `structure_permissible_values` WHERE `value` LIKE 'gr' AND `language_alias` LIKE 'gr');

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`, `language_alias`) 
VALUES(@structure_value_domain_id,  @value_id, '0', 'yes', 'gr');

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'CAN-999-999-000-999-1045.2', 'Inventorymanagement', 'SampleDetail', '', 'tissue_weight', 'received tissue weight', '', 'input', 'size=20', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
SET @weight_field_id = LAST_INSERT_ID();
INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'CAN-999-999-000-999-1288.2', 'Inventorymanagement', 'SampleDetail', '', 'tissue_weight_unit', '', 'unit', 'select', '', '', @structure_value_domain_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
SET @weight_unit_field_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1008_CAN-999-999-000-999-1045.2', (SELECT id FROM `structures` WHERE `old_id` LIKE 'CAN-999-999-000-999-1008'), 'CAN-999-999-000-999-1008', @weight_field_id, 'CAN-999-999-000-999-1045.2', 1, 48, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
(null, 'CAN-999-999-000-999-1008_CAN-999-999-000-999-1288.2', (SELECT id FROM `structures` WHERE `old_id` LIKE 'CAN-999-999-000-999-1008'), 'CAN-999-999-000-999-1008', @weight_unit_field_id, 'CAN-999-999-000-999-1288.2', 1, 49, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('received tissue weight', 'global', 'Received Tissue Weight', 'Poids du tissu re&ccedil;u');

-- Form updates for administration of permissions
INSERT INTO `structure_fields` (`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('', 'AAA-000-000-000-000-54.1', 'Administrate', 'Aco', '', 'state', 'state', '', 'select', '', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
SET @FIELD_ID = LAST_INSERT_ID();
INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('AAA-000-000-000-000-14_AAA-000-000-000-000-54.1', 6, 'AAA-000-000-000-000-14', @FIELD_ID, 'AAA-000-000-000-000-54', 0, 0, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_fields` (`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('', 'AAA-000-000-000-000-54.2', 'Administrate', 'Aco', 'acos', 'alias', 'level', '', 'display', '', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
SET @FIELD_ID = LAST_INSERT_ID();
INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('AAA-000-000-000-000-54.2', 6, 'AAA-000-000-000-000-54.2', @FIELD_ID, 'AAA-000-000-000-000-54.2', 1, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_fields` (`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('', 'AAA-000-000-000-000-54.3', 'Administrate', 'Aco', 'acos', 'id', '', '', 'hidden', '', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
SET @FIELD_ID = LAST_INSERT_ID();
INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('AAA-000-000-000-000-54.3', 6, 'AAA-000-000-000-000-54.3', @FIELD_ID, 'AAA-000-000-000-000-54.3', 1, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES ('', 'CANM-00027', ' ', 'Generated', ' ', 'field1', '', '', 'input', '', '', NULL, '', '', '', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES (NULL, 'CAN-999-999-000-999-1000_CANM-00027', '31', 'CAN-999-999-000-999-1000', (SELECT id FROM structure_fields WHERE old_id='CANM-00027'), 'CANM-00027', '0', '1', '', '1', 'participant identifier', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Change diagnosis_controls.controls_type size
ALTER TABLE `diagnosis_controls` CHANGE `controls_type` `controls_type` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ;

UPDATE structure_formats SET flag_add='1' WHERE old_id='AAA-000-000-000-000-11_AAA-000-000-000-000-2';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES (NULL, 'AAA-000-000-000-000-11_CANM-00027', '3', 'AAA-000-000-000-000-11', (SELECT id FROM structure_fields WHERE old_id='CANM-00027'), 'CANM-00027', '1', '2', '', '1', 'password verification', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
UPDATE `structure_formats` SET `display_order`=3, `flag_add_readonly` = '0',`flag_edit` = '0', `flag_override_type` = '1', `type` = 'password' WHERE `structure_formats`.`old_id` ='AAA-000-000-000-000-11_CANM-00027';
UPDATE `structure_fields` SET `language_label` = 'last name' WHERE `structure_fields`.`id` =59;
UPDATE `structure_fields` SET `language_label` = 'first name' WHERE `structure_fields`.`id` =58;
UPDATE `structure_formats` SET `flag_edit_readonly` = '1' WHERE `structure_formats`.`id` =5;

UPDATE `structure_validations` SET `rule` = 'notEmpty,alphaNumeric', `flag_empty` = '0' WHERE `structure_validations`.`id` =4;

ALTER TABLE users 
	ADD UNIQUE unique_username (username);
	
INSERT INTO `pages` (`id` ,`error_flag` ,`language_title` ,`language_body` ,`created` ,`created_by` ,`modified` ,`modified_by`)VALUES ('err_no_data', '0', 'error', 'no data was retrieved for the specified parameters', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');	

-- Hidde disease_site and event_type from event forms

UPDATE structure_formats 
SET 
flag_add = '0', flag_add_readonly = '0', 
flag_edit = '0', flag_edit_readonly = '0', 
flag_search = '0', flag_search_readonly = '0', 
flag_datagrid = '0', flag_datagrid_readonly = '0', 
flag_index = '0', flag_detail = '0'
WHERE structure_field_old_id IN ('CAN-999-999-000-999-227', 'CAN-999-999-000-999-228')
AND structure_id IN (SELECT id FROM structures WHERE alias LIKE 'ed_%');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('related diagnosis', 'global', 'Related Diagnosis', 'Diagnostic connexe');

DELETE FROM `i18n` WHERE `id` = 'n/a';
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('n/a', '', 'N/A', 'N/A');

-- Hidde tx_method from trt forms

UPDATE structure_formats 
SET 
flag_add = '0', flag_add_readonly = '0', 
flag_edit = '0', flag_edit_readonly = '0', 
flag_search = '0', flag_search_readonly = '0', 
flag_datagrid = '0', flag_datagrid_readonly = '0', 
flag_index = '0', flag_detail = '0'
WHERE structure_field_old_id IN ('CAN-999-999-000-999-276')
AND structure_id IN (SELECT id FROM structures WHERE alias LIKE 'txd_%'); 	

-- Change diagnosis primary number management system

UPDATE `diagnosis_masters`
SET primary_number = NULL
WHERE primary_number = '0';

UPDATE `i18n` 
SET 
`en` = 'Diagnoses Group Nbr',
`fr` = 'No du Groupe de diagnostics'
WHERE `id` IN ('primary number', 'primary_number');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('new group', '', 'New Group', 'Nouveau groupe');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('related diagnoses group', '', 'Related Diagnoses Group', 'Groupe de diagnostics connexes');

-- hidde dx identifier

UPDATE structure_formats 
SET 
flag_add = '0', flag_add_readonly = '0', 
flag_edit = '0', flag_edit_readonly = '0', 
flag_search = '0', flag_search_readonly = '0', 
flag_datagrid = '0', flag_datagrid_readonly = '0', 
flag_index = '0', flag_detail = '0'
WHERE structure_field_old_id IN ('CAN-812');

-- Update Acos Table Content
TRUNCATE `acos`;
INSERT INTO `acos` (`id`, `parent_id`, `model`, `foreign_key`, `alias`, `lft`, `rght`) VALUES
(1, NULL, NULL, NULL, 'controllers', 1, 930),
(2, 1, NULL, NULL, 'Administrate', 2, 111),
(3, 2, NULL, NULL, 'Announcements', 3, 14),
(4, 3, NULL, NULL, 'add', 4, 5),
(5, 3, NULL, NULL, 'index', 6, 7),
(6, 3, NULL, NULL, 'detail', 8, 9),
(7, 3, NULL, NULL, 'edit', 10, 11),
(8, 3, NULL, NULL, 'delete', 12, 13),
(9, 2, NULL, NULL, 'Banks', 15, 26),
(10, 9, NULL, NULL, 'add', 16, 17),
(11, 9, NULL, NULL, 'index', 18, 19),
(12, 9, NULL, NULL, 'detail', 20, 21),
(13, 9, NULL, NULL, 'edit', 22, 23),
(14, 9, NULL, NULL, 'delete', 24, 25),
(15, 2, NULL, NULL, 'Groups', 27, 38),
(16, 15, NULL, NULL, 'index', 28, 29),
(17, 15, NULL, NULL, 'detail', 30, 31),
(18, 15, NULL, NULL, 'add', 32, 33),
(19, 15, NULL, NULL, 'edit', 34, 35),
(20, 15, NULL, NULL, 'delete', 36, 37),
(21, 2, NULL, NULL, 'Menus', 39, 48),
(22, 21, NULL, NULL, 'index', 40, 41),
(23, 21, NULL, NULL, 'detail', 42, 43),
(24, 21, NULL, NULL, 'edit', 44, 45),
(25, 21, NULL, NULL, 'add', 46, 47),
(26, 2, NULL, NULL, 'Passwords', 49, 52),
(27, 26, NULL, NULL, 'index', 50, 51),
(28, 2, NULL, NULL, 'Permissions', 53, 66),
(29, 28, NULL, NULL, 'index', 54, 55),
(30, 28, NULL, NULL, 'regenerate', 56, 57),
(31, 28, NULL, NULL, 'update', 58, 59),
(32, 28, NULL, NULL, 'updatePermission', 60, 61),
(33, 28, NULL, NULL, 'tree', 62, 63),
(34, 28, NULL, NULL, 'addPermissionStateToThreadedData', 64, 65),
(35, 2, NULL, NULL, 'Preferences', 67, 72),
(36, 35, NULL, NULL, 'index', 68, 69),
(37, 35, NULL, NULL, 'edit', 70, 71),
(38, 2, NULL, NULL, 'StructureFormats', 73, 82),
(39, 38, NULL, NULL, 'listall', 74, 75),
(40, 38, NULL, NULL, 'detail', 76, 77),
(41, 38, NULL, NULL, 'edit', 78, 79),
(42, 38, NULL, NULL, 'add', 80, 81),
(43, 2, NULL, NULL, 'Structures', 83, 92),
(44, 43, NULL, NULL, 'index', 84, 85),
(45, 43, NULL, NULL, 'detail', 86, 87),
(46, 43, NULL, NULL, 'edit', 88, 89),
(47, 43, NULL, NULL, 'add', 90, 91),
(48, 2, NULL, NULL, 'UserLogs', 93, 96),
(49, 48, NULL, NULL, 'index', 94, 95),
(50, 2, NULL, NULL, 'Users', 97, 106),
(51, 50, NULL, NULL, 'listall', 98, 99),
(52, 50, NULL, NULL, 'detail', 100, 101),
(53, 50, NULL, NULL, 'add', 102, 103),
(54, 50, NULL, NULL, 'edit', 104, 105),
(55, 2, NULL, NULL, 'Versions', 107, 110),
(56, 55, NULL, NULL, 'detail', 108, 109),
(57, 1, NULL, NULL, 'App', 112, 153),
(58, 57, NULL, NULL, 'Groups', 113, 124),
(59, 58, NULL, NULL, 'index', 114, 115),
(60, 58, NULL, NULL, 'view', 116, 117),
(61, 58, NULL, NULL, 'add', 118, 119),
(62, 58, NULL, NULL, 'edit', 120, 121),
(63, 58, NULL, NULL, 'delete', 122, 123),
(64, 57, NULL, NULL, 'Menus', 125, 130),
(65, 64, NULL, NULL, 'index', 126, 127),
(66, 64, NULL, NULL, 'update', 128, 129),
(67, 57, NULL, NULL, 'Pages', 131, 134),
(68, 67, NULL, NULL, 'display', 132, 133),
(69, 57, NULL, NULL, 'Posts', 135, 146),
(70, 69, NULL, NULL, 'index', 136, 137),
(71, 69, NULL, NULL, 'view', 138, 139),
(72, 69, NULL, NULL, 'add', 140, 141),
(73, 69, NULL, NULL, 'edit', 142, 143),
(74, 69, NULL, NULL, 'delete', 144, 145),
(75, 57, NULL, NULL, 'Users', 147, 152),
(76, 75, NULL, NULL, 'login', 148, 149),
(77, 75, NULL, NULL, 'logout', 150, 151),
(78, 1, NULL, NULL, 'Clinicalannotation', 154, 333),
(79, 78, NULL, NULL, 'ClinicalCollectionLinks', 155, 168),
(80, 79, NULL, NULL, 'listall', 156, 157),
(81, 79, NULL, NULL, 'detail', 158, 159),
(82, 79, NULL, NULL, 'add', 160, 161),
(83, 79, NULL, NULL, 'edit', 162, 163),
(84, 79, NULL, NULL, 'delete', 164, 165),
(85, 79, NULL, NULL, 'allowClinicalCollectionLinkDeletion', 166, 167),
(86, 78, NULL, NULL, 'ConsentMasters', 169, 182),
(87, 86, NULL, NULL, 'listall', 170, 171),
(88, 86, NULL, NULL, 'detail', 172, 173),
(89, 86, NULL, NULL, 'add', 174, 175),
(90, 86, NULL, NULL, 'edit', 176, 177),
(91, 86, NULL, NULL, 'delete', 178, 179),
(92, 86, NULL, NULL, 'allowConsentDeletion', 180, 181),
(93, 78, NULL, NULL, 'DiagnosisMasters', 183, 198),
(94, 93, NULL, NULL, 'listall', 184, 185),
(95, 93, NULL, NULL, 'detail', 186, 187),
(96, 93, NULL, NULL, 'add', 188, 189),
(97, 93, NULL, NULL, 'edit', 190, 191),
(98, 93, NULL, NULL, 'delete', 192, 193),
(99, 93, NULL, NULL, 'allowDiagnosisDeletion', 194, 195),
(100, 93, NULL, NULL, 'buildAndSetExistingDx', 196, 197),
(101, 78, NULL, NULL, 'EventMasters', 199, 212),
(102, 101, NULL, NULL, 'listall', 200, 201),
(103, 101, NULL, NULL, 'detail', 202, 203),
(104, 101, NULL, NULL, 'add', 204, 205),
(105, 101, NULL, NULL, 'edit', 206, 207),
(106, 101, NULL, NULL, 'delete', 208, 209),
(107, 101, NULL, NULL, 'allowEventDeletion', 210, 211),
(108, 78, NULL, NULL, 'FamilyHistories', 213, 226),
(109, 108, NULL, NULL, 'listall', 214, 215),
(110, 108, NULL, NULL, 'detail', 216, 217),
(111, 108, NULL, NULL, 'add', 218, 219),
(112, 108, NULL, NULL, 'edit', 220, 221),
(113, 108, NULL, NULL, 'delete', 222, 223),
(114, 108, NULL, NULL, 'allowFamilyHistoryDeletion', 224, 225),
(115, 78, NULL, NULL, 'MiscIdentifiers', 227, 244),
(116, 115, NULL, NULL, 'index', 228, 229),
(117, 115, NULL, NULL, 'search', 230, 231),
(118, 115, NULL, NULL, 'listall', 232, 233),
(119, 115, NULL, NULL, 'detail', 234, 235),
(120, 115, NULL, NULL, 'add', 236, 237),
(121, 115, NULL, NULL, 'edit', 238, 239),
(122, 115, NULL, NULL, 'delete', 240, 241),
(123, 115, NULL, NULL, 'allowMiscIdentifierDeletion', 242, 243),
(124, 78, NULL, NULL, 'ParticipantContacts', 245, 258),
(125, 124, NULL, NULL, 'listall', 246, 247),
(126, 124, NULL, NULL, 'detail', 248, 249),
(127, 124, NULL, NULL, 'add', 250, 251),
(128, 124, NULL, NULL, 'edit', 252, 253),
(129, 124, NULL, NULL, 'delete', 254, 255),
(130, 124, NULL, NULL, 'allowParticipantContactDeletion', 256, 257),
(131, 78, NULL, NULL, 'ParticipantMessages', 259, 272),
(132, 131, NULL, NULL, 'listall', 260, 261),
(133, 131, NULL, NULL, 'detail', 262, 263),
(134, 131, NULL, NULL, 'add', 264, 265),
(135, 131, NULL, NULL, 'edit', 266, 267),
(136, 131, NULL, NULL, 'delete', 268, 269),
(137, 131, NULL, NULL, 'allowParticipantMessageDeletion', 270, 271),
(138, 78, NULL, NULL, 'Participants', 273, 290),
(139, 138, NULL, NULL, 'index', 274, 275),
(140, 138, NULL, NULL, 'search', 276, 277),
(141, 138, NULL, NULL, 'profile', 278, 279),
(142, 138, NULL, NULL, 'add', 280, 281),
(143, 138, NULL, NULL, 'edit', 282, 283),
(144, 138, NULL, NULL, 'delete', 284, 285),
(145, 138, NULL, NULL, 'allowParticipantDeletion', 286, 287),
(146, 138, NULL, NULL, 'chronology', 288, 289),
(147, 78, NULL, NULL, 'ProductMasters', 291, 294),
(148, 147, NULL, NULL, 'productsTreeView', 292, 293),
(149, 78, NULL, NULL, 'ReproductiveHistories', 295, 308),
(150, 149, NULL, NULL, 'listall', 296, 297),
(151, 149, NULL, NULL, 'detail', 298, 299),
(152, 149, NULL, NULL, 'add', 300, 301),
(153, 149, NULL, NULL, 'edit', 302, 303),
(154, 149, NULL, NULL, 'delete', 304, 305),
(155, 149, NULL, NULL, 'allowReproductiveHistoryDeletion', 306, 307),
(156, 78, NULL, NULL, 'TreatmentExtends', 309, 320),
(157, 156, NULL, NULL, 'listall', 310, 311),
(158, 156, NULL, NULL, 'detail', 312, 313),
(159, 156, NULL, NULL, 'add', 314, 315),
(160, 156, NULL, NULL, 'edit', 316, 317),
(161, 156, NULL, NULL, 'delete', 318, 319),
(162, 78, NULL, NULL, 'TreatmentMasters', 321, 332),
(163, 162, NULL, NULL, 'listall', 322, 323),
(164, 162, NULL, NULL, 'detail', 324, 325),
(165, 162, NULL, NULL, 'edit', 326, 327),
(166, 162, NULL, NULL, 'add', 328, 329),
(167, 162, NULL, NULL, 'delete', 330, 331),
(168, 1, NULL, NULL, 'Codingicd10', 334, 341),
(169, 168, NULL, NULL, 'CodingIcd10s', 335, 340),
(170, 169, NULL, NULL, 'tool', 336, 337),
(171, 169, NULL, NULL, 'autoComplete', 338, 339),
(172, 1, NULL, NULL, 'Customize', 342, 365),
(173, 172, NULL, NULL, 'Announcements', 343, 348),
(174, 173, NULL, NULL, 'index', 344, 345),
(175, 173, NULL, NULL, 'detail', 346, 347),
(176, 172, NULL, NULL, 'Passwords', 349, 352),
(177, 176, NULL, NULL, 'index', 350, 351),
(178, 172, NULL, NULL, 'Preferences', 353, 358),
(179, 178, NULL, NULL, 'index', 354, 355),
(180, 178, NULL, NULL, 'edit', 356, 357),
(181, 172, NULL, NULL, 'Profiles', 359, 364),
(182, 181, NULL, NULL, 'index', 360, 361),
(183, 181, NULL, NULL, 'edit', 362, 363),
(184, 1, NULL, NULL, 'Datamart', 366, 415),
(185, 184, NULL, NULL, 'AdhocSaved', 367, 380),
(186, 185, NULL, NULL, 'index', 368, 369),
(187, 185, NULL, NULL, 'add', 370, 371),
(188, 185, NULL, NULL, 'search', 372, 373),
(189, 185, NULL, NULL, 'results', 374, 375),
(190, 185, NULL, NULL, 'edit', 376, 377),
(191, 185, NULL, NULL, 'delete', 378, 379),
(192, 184, NULL, NULL, 'Adhocs', 381, 396),
(193, 192, NULL, NULL, 'index', 382, 383),
(194, 192, NULL, NULL, 'favourite', 384, 385),
(195, 192, NULL, NULL, 'unfavourite', 386, 387),
(196, 192, NULL, NULL, 'search', 388, 389),
(197, 192, NULL, NULL, 'results', 390, 391),
(198, 192, NULL, NULL, 'process', 392, 393),
(199, 192, NULL, NULL, 'csv', 394, 395),
(200, 184, NULL, NULL, 'BatchSets', 397, 414),
(201, 200, NULL, NULL, 'index', 398, 399),
(202, 200, NULL, NULL, 'listall', 400, 401),
(203, 200, NULL, NULL, 'add', 402, 403),
(204, 200, NULL, NULL, 'edit', 404, 405),
(205, 200, NULL, NULL, 'delete', 406, 407),
(206, 200, NULL, NULL, 'process', 408, 409),
(207, 200, NULL, NULL, 'remove', 410, 411),
(208, 200, NULL, NULL, 'csv', 412, 413),
(209, 1, NULL, NULL, 'Drug', 416, 433),
(210, 209, NULL, NULL, 'Drugs', 417, 432),
(211, 210, NULL, NULL, 'index', 418, 419),
(212, 210, NULL, NULL, 'search', 420, 421),
(213, 210, NULL, NULL, 'listall', 422, 423),
(214, 210, NULL, NULL, 'add', 424, 425),
(215, 210, NULL, NULL, 'edit', 426, 427),
(216, 210, NULL, NULL, 'detail', 428, 429),
(217, 210, NULL, NULL, 'delete', 430, 431),
(218, 1, NULL, NULL, 'Inventorymanagement', 434, 559),
(219, 218, NULL, NULL, 'AliquotMasters', 435, 490),
(220, 219, NULL, NULL, 'index', 436, 437),
(221, 219, NULL, NULL, 'search', 438, 439),
(222, 219, NULL, NULL, 'listAll', 440, 441),
(223, 219, NULL, NULL, 'add', 442, 443),
(224, 219, NULL, NULL, 'detail', 444, 445),
(225, 219, NULL, NULL, 'edit', 446, 447),
(226, 219, NULL, NULL, 'removeAliquotFromStorage', 448, 449),
(227, 219, NULL, NULL, 'delete', 450, 451),
(228, 219, NULL, NULL, 'addAliquotUse', 452, 453),
(229, 219, NULL, NULL, 'editAliquotUse', 454, 455),
(230, 219, NULL, NULL, 'deleteAliquotUse', 456, 457),
(231, 219, NULL, NULL, 'addSourceAliquots', 458, 459),
(232, 219, NULL, NULL, 'listAllSourceAliquots', 460, 461),
(233, 219, NULL, NULL, 'defineRealiquotedChildren', 462, 463),
(234, 219, NULL, NULL, 'listAllRealiquotedParents', 464, 465),
(235, 219, NULL, NULL, 'getStudiesList', 466, 467),
(236, 219, NULL, NULL, 'getSampleBlocksList', 468, 469),
(237, 219, NULL, NULL, 'getSampleGelMatricesList', 470, 471),
(238, 219, NULL, NULL, 'getDefaultAliquotStorageDate', 472, 473),
(239, 219, NULL, NULL, 'isDuplicatedAliquotBarcode', 474, 475),
(240, 219, NULL, NULL, 'formatAliquotFieldDecimalData', 476, 477),
(241, 219, NULL, NULL, 'validateAliquotStorageData', 478, 479),
(242, 219, NULL, NULL, 'allowAliquotDeletion', 480, 481),
(243, 219, NULL, NULL, 'getDefaultRealiquotingDate', 482, 483),
(244, 219, NULL, NULL, 'formatPreselectedStoragesForDisplay', 484, 485),
(245, 219, NULL, NULL, 'formatBlocksForDisplay', 486, 487),
(246, 219, NULL, NULL, 'formatGelMatricesForDisplay', 488, 489),
(247, 218, NULL, NULL, 'Collections', 491, 506),
(248, 247, NULL, NULL, 'index', 492, 493),
(249, 247, NULL, NULL, 'search', 494, 495),
(250, 247, NULL, NULL, 'detail', 496, 497),
(251, 247, NULL, NULL, 'add', 498, 499),
(252, 247, NULL, NULL, 'edit', 500, 501),
(253, 247, NULL, NULL, 'delete', 502, 503),
(254, 247, NULL, NULL, 'allowCollectionDeletion', 504, 505),
(255, 218, NULL, NULL, 'PathCollectionReviews', 507, 508),
(256, 218, NULL, NULL, 'QualityCtrls', 509, 528),
(257, 256, NULL, NULL, 'listAll', 510, 511),
(258, 256, NULL, NULL, 'add', 512, 513),
(259, 256, NULL, NULL, 'detail', 514, 515),
(260, 256, NULL, NULL, 'edit', 516, 517),
(261, 256, NULL, NULL, 'if', 518, 519),
(262, 256, NULL, NULL, 'delete', 520, 521),
(263, 256, NULL, NULL, 'addTestedAliquots', 522, 523),
(264, 256, NULL, NULL, 'allowQcDeletion', 524, 525),
(265, 256, NULL, NULL, 'createQcCode', 526, 527),
(266, 218, NULL, NULL, 'ReviewMasters', 529, 530),
(267, 218, NULL, NULL, 'SampleMasters', 531, 558),
(268, 267, NULL, NULL, 'index', 532, 533),
(269, 267, NULL, NULL, 'search', 534, 535),
(270, 267, NULL, NULL, 'contentTreeView', 536, 537),
(271, 267, NULL, NULL, 'listAll', 538, 539),
(272, 267, NULL, NULL, 'detail', 540, 541),
(273, 267, NULL, NULL, 'add', 542, 543),
(274, 267, NULL, NULL, 'edit', 544, 545),
(275, 267, NULL, NULL, 'delete', 546, 547),
(276, 267, NULL, NULL, 'createSampleCode', 548, 549),
(277, 267, NULL, NULL, 'allowSampleDeletion', 550, 551),
(278, 267, NULL, NULL, 'getTissueSourceList', 552, 553),
(279, 267, NULL, NULL, 'formatSampleFieldDecimalData', 554, 555),
(280, 267, NULL, NULL, 'formatParentSampleDataForDisplay', 556, 557),
(281, 1, NULL, NULL, 'Material', 560, 577),
(282, 281, NULL, NULL, 'Materials', 561, 576),
(283, 282, NULL, NULL, 'index', 562, 563),
(284, 282, NULL, NULL, 'search', 564, 565),
(285, 282, NULL, NULL, 'listall', 566, 567),
(286, 282, NULL, NULL, 'add', 568, 569),
(287, 282, NULL, NULL, 'edit', 570, 571),
(288, 282, NULL, NULL, 'detail', 572, 573),
(289, 282, NULL, NULL, 'delete', 574, 575),
(290, 1, NULL, NULL, 'Order', 578, 649),
(291, 290, NULL, NULL, 'OrderItems', 579, 592),
(292, 291, NULL, NULL, 'listall', 580, 581),
(293, 291, NULL, NULL, 'add', 582, 583),
(294, 291, NULL, NULL, 'addAliquotsInBatch', 584, 585),
(295, 291, NULL, NULL, 'edit', 586, 587),
(296, 291, NULL, NULL, 'delete', 588, 589),
(297, 291, NULL, NULL, 'allowOrderItemDeletion', 590, 591),
(298, 290, NULL, NULL, 'OrderLines', 593, 608),
(299, 298, NULL, NULL, 'listall', 594, 595),
(300, 298, NULL, NULL, 'add', 596, 597),
(301, 298, NULL, NULL, 'edit', 598, 599),
(302, 298, NULL, NULL, 'detail', 600, 601),
(303, 298, NULL, NULL, 'delete', 602, 603),
(304, 298, NULL, NULL, 'generateSampleAliquotControlList', 604, 605),
(305, 298, NULL, NULL, 'allowOrderLineDeletion', 606, 607),
(306, 290, NULL, NULL, 'Orders', 609, 626),
(307, 306, NULL, NULL, 'index', 610, 611),
(308, 306, NULL, NULL, 'search', 612, 613),
(309, 306, NULL, NULL, 'add', 614, 615),
(310, 306, NULL, NULL, 'detail', 616, 617),
(311, 306, NULL, NULL, 'edit', 618, 619),
(312, 306, NULL, NULL, 'delete', 620, 621),
(313, 306, NULL, NULL, 'getStudiesList', 622, 623),
(314, 306, NULL, NULL, 'allowOrderDeletion', 624, 625),
(315, 290, NULL, NULL, 'Shipments', 627, 648),
(316, 315, NULL, NULL, 'listall', 628, 629),
(317, 315, NULL, NULL, 'add', 630, 631),
(318, 315, NULL, NULL, 'edit', 632, 633),
(319, 315, NULL, NULL, 'if', 634, 635),
(320, 315, NULL, NULL, 'detail', 636, 637),
(321, 315, NULL, NULL, 'delete', 638, 639),
(322, 315, NULL, NULL, 'addToShipment', 640, 641),
(323, 315, NULL, NULL, 'deleteFromShipment', 642, 643),
(324, 315, NULL, NULL, 'allowShipmentDeletion', 644, 645),
(325, 315, NULL, NULL, 'allowItemRemoveFromShipment', 646, 647),
(326, 1, NULL, NULL, 'Protocol', 650, 679),
(327, 326, NULL, NULL, 'ProtocolExtends', 651, 662),
(328, 327, NULL, NULL, 'listall', 652, 653),
(329, 327, NULL, NULL, 'detail', 654, 655),
(330, 327, NULL, NULL, 'add', 656, 657),
(331, 327, NULL, NULL, 'edit', 658, 659),
(332, 327, NULL, NULL, 'delete', 660, 661),
(333, 326, NULL, NULL, 'ProtocolMasters', 663, 678),
(334, 333, NULL, NULL, 'index', 664, 665),
(335, 333, NULL, NULL, 'search', 666, 667),
(336, 333, NULL, NULL, 'listall', 668, 669),
(337, 333, NULL, NULL, 'add', 670, 671),
(338, 333, NULL, NULL, 'detail', 672, 673),
(339, 333, NULL, NULL, 'edit', 674, 675),
(340, 333, NULL, NULL, 'delete', 676, 677),
(341, 1, NULL, NULL, 'Provider', 680, 697),
(342, 341, NULL, NULL, 'Providers', 681, 696),
(343, 342, NULL, NULL, 'index', 682, 683),
(344, 342, NULL, NULL, 'search', 684, 685),
(345, 342, NULL, NULL, 'listall', 686, 687),
(346, 342, NULL, NULL, 'add', 688, 689),
(347, 342, NULL, NULL, 'detail', 690, 691),
(348, 342, NULL, NULL, 'edit', 692, 693),
(349, 342, NULL, NULL, 'delete', 694, 695),
(350, 1, NULL, NULL, 'Rtbform', 698, 713),
(351, 350, NULL, NULL, 'Rtbforms', 699, 712),
(352, 351, NULL, NULL, 'index', 700, 701),
(353, 351, NULL, NULL, 'search', 702, 703),
(354, 351, NULL, NULL, 'profile', 704, 705),
(355, 351, NULL, NULL, 'add', 706, 707),
(356, 351, NULL, NULL, 'edit', 708, 709),
(357, 351, NULL, NULL, 'delete', 710, 711),
(358, 1, NULL, NULL, 'Sop', 714, 739),
(359, 358, NULL, NULL, 'SopExtends', 715, 726),
(360, 359, NULL, NULL, 'listall', 716, 717),
(361, 359, NULL, NULL, 'detail', 718, 719),
(362, 359, NULL, NULL, 'add', 720, 721),
(363, 359, NULL, NULL, 'edit', 722, 723),
(364, 359, NULL, NULL, 'delete', 724, 725),
(365, 358, NULL, NULL, 'SopMasters', 727, 738),
(366, 365, NULL, NULL, 'listall', 728, 729),
(367, 365, NULL, NULL, 'add', 730, 731),
(368, 365, NULL, NULL, 'detail', 732, 733),
(369, 365, NULL, NULL, 'edit', 734, 735),
(370, 365, NULL, NULL, 'delete', 736, 737),
(371, 1, NULL, NULL, 'Storagelayout', 740, 815),
(372, 371, NULL, NULL, 'StorageCoordinates', 741, 754),
(373, 372, NULL, NULL, 'listAll', 742, 743),
(374, 372, NULL, NULL, 'add', 744, 745),
(375, 372, NULL, NULL, 'delete', 746, 747),
(376, 372, NULL, NULL, 'allowStorageCoordinateDeletion', 748, 749),
(377, 372, NULL, NULL, 'isDuplicatedValue', 750, 751),
(378, 372, NULL, NULL, 'isDuplicatedOrder', 752, 753),
(379, 371, NULL, NULL, 'StorageMasters', 755, 796),
(380, 379, NULL, NULL, 'index', 756, 757),
(381, 379, NULL, NULL, 'search', 758, 759),
(382, 379, NULL, NULL, 'detail', 760, 761),
(383, 379, NULL, NULL, 'add', 762, 763),
(384, 379, NULL, NULL, 'edit', 764, 765),
(385, 379, NULL, NULL, 'editStoragePosition', 766, 767),
(386, 379, NULL, NULL, 'delete', 768, 769),
(387, 379, NULL, NULL, 'contentTreeView', 770, 771),
(388, 379, NULL, NULL, 'completeStorageContent', 772, 773),
(389, 379, NULL, NULL, 'storageLayout', 774, 775),
(390, 379, NULL, NULL, 'setStorageCoordinateValues', 776, 777),
(391, 379, NULL, NULL, 'allowStorageDeletion', 778, 779),
(392, 379, NULL, NULL, 'getStorageSelectionLabel', 780, 781),
(393, 379, NULL, NULL, 'updateChildrenStorageSelectionLabel', 782, 783),
(394, 379, NULL, NULL, 'createSelectionLabel', 784, 785),
(395, 379, NULL, NULL, 'IsDuplicatedStorageBarCode', 786, 787),
(396, 379, NULL, NULL, 'createStorageCode', 788, 789),
(397, 379, NULL, NULL, 'updateChildrenSurroundingTemperature', 790, 791),
(398, 379, NULL, NULL, 'updateAndSaveDataArray', 792, 793),
(399, 379, NULL, NULL, 'buildChildrenArray', 794, 795),
(400, 371, NULL, NULL, 'TmaSlides', 797, 814),
(401, 400, NULL, NULL, 'listAll', 798, 799),
(402, 400, NULL, NULL, 'add', 800, 801),
(403, 400, NULL, NULL, 'detail', 802, 803),
(404, 400, NULL, NULL, 'edit', 804, 805),
(405, 400, NULL, NULL, 'delete', 806, 807),
(406, 400, NULL, NULL, 'isDuplicatedTmaSlideBarcode', 808, 809),
(407, 400, NULL, NULL, 'allowTMASlideDeletion', 810, 811),
(408, 400, NULL, NULL, 'formatPreselectedStoragesForDisplay', 812, 813),
(409, 1, NULL, NULL, 'Study', 816, 929),
(410, 409, NULL, NULL, 'StudyContacts', 817, 830),
(411, 410, NULL, NULL, 'listall', 818, 819),
(412, 410, NULL, NULL, 'detail', 820, 821),
(413, 410, NULL, NULL, 'add', 822, 823),
(414, 410, NULL, NULL, 'edit', 824, 825),
(415, 410, NULL, NULL, 'delete', 826, 827),
(416, 410, NULL, NULL, 'allowStudyContactDeletion', 828, 829),
(417, 409, NULL, NULL, 'StudyEthicsBoards', 831, 844),
(418, 417, NULL, NULL, 'listall', 832, 833),
(419, 417, NULL, NULL, 'detail', 834, 835),
(420, 417, NULL, NULL, 'add', 836, 837),
(421, 417, NULL, NULL, 'edit', 838, 839),
(422, 417, NULL, NULL, 'delete', 840, 841),
(423, 417, NULL, NULL, 'allowStudyEthicsBoardDeletion', 842, 843),
(424, 409, NULL, NULL, 'StudyFundings', 845, 858),
(425, 424, NULL, NULL, 'listall', 846, 847),
(426, 424, NULL, NULL, 'detail', 848, 849),
(427, 424, NULL, NULL, 'add', 850, 851),
(428, 424, NULL, NULL, 'edit', 852, 853),
(429, 424, NULL, NULL, 'delete', 854, 855),
(430, 424, NULL, NULL, 'allowStudyFundingDeletion', 856, 857),
(431, 409, NULL, NULL, 'StudyInvestigators', 859, 872),
(432, 431, NULL, NULL, 'listall', 860, 861),
(433, 431, NULL, NULL, 'detail', 862, 863),
(434, 431, NULL, NULL, 'add', 864, 865),
(435, 431, NULL, NULL, 'edit', 866, 867),
(436, 431, NULL, NULL, 'delete', 868, 869),
(437, 431, NULL, NULL, 'allowStudyInvestigatorDeletion', 870, 871),
(438, 409, NULL, NULL, 'StudyRelated', 873, 886),
(439, 438, NULL, NULL, 'listall', 874, 875),
(440, 438, NULL, NULL, 'detail', 876, 877),
(441, 438, NULL, NULL, 'add', 878, 879),
(442, 438, NULL, NULL, 'edit', 880, 881),
(443, 438, NULL, NULL, 'delete', 882, 883),
(444, 438, NULL, NULL, 'allowStudyRelatedDeletion', 884, 885),
(445, 409, NULL, NULL, 'StudyResults', 887, 900),
(446, 445, NULL, NULL, 'listall', 888, 889),
(447, 445, NULL, NULL, 'detail', 890, 891),
(448, 445, NULL, NULL, 'add', 892, 893),
(449, 445, NULL, NULL, 'edit', 894, 895),
(450, 445, NULL, NULL, 'delete', 896, 897),
(451, 445, NULL, NULL, 'allowStudyResultDeletion', 898, 899),
(452, 409, NULL, NULL, 'StudyReviews', 901, 914),
(453, 452, NULL, NULL, 'listall', 902, 903),
(454, 452, NULL, NULL, 'detail', 904, 905),
(455, 452, NULL, NULL, 'add', 906, 907),
(456, 452, NULL, NULL, 'edit', 908, 909),
(457, 452, NULL, NULL, 'delete', 910, 911),
(458, 452, NULL, NULL, 'allowStudyReviewDeletion', 912, 913),
(459, 409, NULL, NULL, 'StudySummaries', 915, 928),
(460, 459, NULL, NULL, 'listall', 916, 917),
(461, 459, NULL, NULL, 'detail', 918, 919),
(462, 459, NULL, NULL, 'add', 920, 921),
(463, 459, NULL, NULL, 'edit', 922, 923),
(464, 459, NULL, NULL, 'delete', 924, 925),
(465, 459, NULL, NULL, 'allowStudySummaryDeletion', 926, 927);

-- Update inventroy menu and filter data

UPDATE menus SET parent_id = 'inv_CAN' WHERE parent_id = 'inv_CAN_2';
DELETE FROM menus WHERE id = 'inv_CAN_2';	-- listall collection content
UPDATE menus SET language_title = 'collection products' WHERE id = 'inv_CAN_21';	-- tree view
UPDATE menus SET parent_id = 'inv_CAN_21' WHERE parent_id = 'inv_CAN_22';
UPDATE menus SET use_summary = 'Inventorymanagement.ViewCollection::summary' WHERE use_summary = 'Inventorymanagement.Collection::contentFilterSummary';
UPDATE menus SET active = 'no' WHERE id = 'inv_CAN_3';	-- listall collection path reviews

DELETE FROM `i18n` WHERE `id` IN ('listall collection samples', 'listall collection aliquots', 'collection products');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('listall collection samples', '', 'Samples List', 'Liste des &eacute;chantillons'),
('listall collection aliquots', '', 'Aliquots List', 'Liste des aliquots'),
('collection products', '', 'Products', 'Produits');

UPDATE menus SET active = 'no' WHERE parent_id = 'clin_CAN_57' AND use_link = '/underdevelopment/';	-- participant sample and aliquots
UPDATE menus SET use_summary = '' WHERE id = 'clin_CAN_571'; -- participant tree view

-- Update participants form display
UPDATE structure_formats SET display_column='0', display_order='46', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='1', `flag_search_readonly`='0', `flag_datagrid`='1', `flag_datagrid_readonly`='0', `flag_index`='0', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-1008_qc-lady-00024' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1008') AND structure_old_id='CAN-999-999-000-999-1008' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00024') AND structure_field_old_id='qc-lady-00024';
UPDATE structure_formats SET display_column='0', display_order='47', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='1', `flag_search_readonly`='0', `flag_datagrid`='1', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`=''  WHERE old_id='CAN-999-999-000-999-1008_qc-lady-00006' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1008') AND structure_old_id='CAN-999-999-000-999-1008' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='qc-lady-00006') AND structure_field_old_id='qc-lady-00006';
UPDATE structure_formats SET display_column='1', display_order='1', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='1', `flag_search_readonly`='0', `flag_datagrid`='1', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='1', `language_label`='first name', `flag_override_tag`='1', `language_tag`='', `flag_override_help`='1', `language_help`='', `flag_override_type`='1', `type`='input', `flag_override_setting`='1', `setting`='size=20', `flag_override_default`='1', `default`=''  WHERE old_id='CAN-999-999-000-999-1_CAN-999-999-000-999-1' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1') AND structure_old_id='CAN-999-999-000-999-1' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-1') AND structure_field_old_id='CAN-999-999-000-999-1';
UPDATE structure_formats SET display_column='1', display_order='0', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='1', `flag_search_readonly`='0', `flag_datagrid`='1', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='1', `language_label`='title', `flag_override_tag`='1', `language_tag`='', `flag_override_help`='1', `language_help`='help_name', `flag_override_type`='1', `type`='select', `flag_override_setting`='1', `setting`='', `flag_override_default`='1', `default`=''  WHERE old_id='CAN-999-999-000-999-1_CAN-999-999-000-999-4' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1') AND structure_old_id='CAN-999-999-000-999-1' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-4') AND structure_field_old_id='CAN-999-999-000-999-4';
UPDATE structure_formats SET display_column='1', display_order='2', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_datagrid`='1', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='1', `language_label`='middle name', `flag_override_tag`='1', `language_tag`='', `flag_override_help`='1', `language_help`='', `flag_override_type`='1', `type`='input', `flag_override_setting`='1', `setting`='size=15', `flag_override_default`='1', `default`=''  WHERE old_id='CAN-999-999-000-999-1_CAN-999-999-000-999-295' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1') AND structure_old_id='CAN-999-999-000-999-1' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-295') AND structure_field_old_id='CAN-999-999-000-999-295';
UPDATE structure_formats SET display_column='1', display_order='3', language_heading='', `flag_add`='1', `flag_add_readonly`='0', `flag_edit`='1', `flag_edit_readonly`='0', `flag_search`='1', `flag_search_readonly`='0', `flag_datagrid`='1', `flag_datagrid_readonly`='0', `flag_index`='1', `flag_detail`='1', `flag_override_label`='1', `language_label`='last name', `flag_override_tag`='1', `language_tag`='', `flag_override_help`='1', `language_help`='', `flag_override_type`='1', `type`='input', `flag_override_setting`='1', `setting`='size=30', `flag_override_default`='1', `default`=''  WHERE old_id='CAN-999-999-000-999-1_CAN-999-999-000-999-2' AND structure_id=(SELECT id FROM structures WHERE old_id='CAN-999-999-000-999-1') AND structure_old_id='CAN-999-999-000-999-1' AND structure_field_id=(SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-2') AND structure_field_old_id='CAN-999-999-000-999-2';

-- Chronolgy
INSERT INTO `menus` (`id` ,`parent_id` ,`is_root` ,`display_order` ,`language_title` ,`language_description` ,`use_link` ,`use_params` ,`use_summary` ,`active` ,`created` ,`created_by` ,`modified` ,`modified_by`)VALUES ('clin_CAN_1_13', 'clin_CAN_1', '0', '13', 'chronology', '', '/clinicalannotation/participants/chronology/%%Participant.id%%', '', 'Clinicalannotation.Participant::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO structures(`old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('CANM-00029', 'chronology', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES('', 'CANM-00030', 'Clinicalannotation', 'Generated', 'generated', 'date', 'date', '', 'datetime', '', '', NULL, '', 'open', 'open', 'open'), ('', 'CANM-00031', 'Clinicalannotation', 'Generated', 'generated', 'event', 'event', '', 'input', '', '', NULL, '', 'open', 'open', 'open');
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CANM-00029_CANM-00030', (SELECT id FROM structures WHERE old_id='CANM-00029'), 'CANM-00029', (SELECT id FROM structure_fields WHERE old_id='CANM-00030'), 'CANM-00030', '0', '1', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0') ;
INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES ('CANM-00029_CANM-00031', (SELECT id FROM structures WHERE old_id='CANM-00029'), 'CANM-00029', (SELECT id FROM structure_fields WHERE old_id='CANM-00031'), 'CANM-00031', '0', '2', '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0') ;

-- add "source" field to value domains, as place to put Model::function call to pulldown data, instead of permissible values
ALTER TABLE  `structure_value_domains` ADD  `source` VARCHAR( 255 ) NULL;

-- New SOURCE functionality using ICD10 field in PARTICIPANT model
INSERT INTO  `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(NULL ,  'icd10',  'locked',  '',  'Clinicalannotation.Icd10::permissibleValues');

SET @value_domain_id = LAST_INSERT_ID();

UPDATE  `structure_fields` SET  `type` =  'select', `setting` =  '', `structure_value_domain` =  @value_domain_id WHERE `structure_fields`.`id` = 501;

-- Enable permissions link under Administration and hide field
UPDATE  `menus` SET  `use_link` =  '/administrate/permissions/tree/%%Bank.id%%/%%Group.id%%' WHERE  `menus`.`id` =  'core_CAN_88';
UPDATE  `structure_fields` SET  `type` =  'hidden', `setting` =  '' WHERE  `structure_fields`.`id` =80;

-- Cleanup pages error

DELETE FROM pages WHERE error_flag = '1';
DELETE FROM pages WHERE id = 'err_no_data';
DELETE FROM pages WHERE id = 'err_clin_no_data';

INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('err_admin_no_data', 1, 'data not found', 'no data exists for the specified id', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_clin_funct_param_missing', 1, 'parameter missing', 'a paramater used by the executed function has not been set', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_clin_no_data', 1, 'data not found', 'no data exists for the specified id', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_clin_system_error', 1, 'system error', 'a system error has been detected', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_drug_funct_param_missing', 1, 'parameter missing', 'a paramater used by the executed function has not been set', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_inv_funct_param_missing', 1, 'parameter missing', 'a paramater used by the executed function has not been set', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_inv_no_data', 1, 'data not found', 'no data exists for the specified id', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_inv_record_err', 1, 'data creation - update error', 'an error occured during the creation or the update of the data', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_inv_system_error', 1, 'system error', 'a system error has been detected', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_mat_funct_param_missing', 1, 'parameter missing', 'a paramater used by the executed function has not been set', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_no_data', 1, 'data not found', 'no data exists for the specified id', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_order_funct_param_missing', 1, 'parameter missing', 'a paramater used by the executed function has not been set', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_order_no_data', 1, 'data not found', 'no data exists for the specified id', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_order_record_err', 1, 'data creation - update error', 'an error occured during the creation or the update of the data', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_order_system_error', 1, 'system error', 'a system error has been detected', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_pro_funct_param_missing', 1, 'parameter missing', 'a paramater used by the executed function has not been set', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_prov_funct_param_missing', 1, 'parameter missing', 'a paramater used by the executed function has not been set', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_rtb_funct_param_missing', 1, 'parameter missing', 'a paramater used by the executed function has not been set', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_sop_funct_param_missing', 1, 'parameter missing', 'a paramater used by the executed function has not been set', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_sto_funct_param_missing', 1, 'parameter missing', 'a paramater used by the executed function has not been set', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_sto_no_data', 1, 'data not found', 'no data exists for the specified id', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_sto_system_error', 1, 'system error', 'a system error has been detected', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_study_funct_param_missing', 1, 'parameter missing', 'a paramater used by the executed function has not been set', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_study_no_data', 1, 'data not found', 'no data exists for the specified id', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Update date accuracy codes in Clinical

UPDATE `structure_fields` SET `structure_value_domain`  = '172' WHERE `structure_fields`.`id` =128;
UPDATE `structure_fields` SET `structure_value_domain`  = '172' WHERE `structure_fields`.`id` =803;
UPDATE `structure_fields` SET `structure_value_domain`  = '172' WHERE `structure_fields`.`id` =826;
UPDATE `structure_fields` SET `structure_value_domain`  = '172' WHERE `structure_fields`.`id` =828;
UPDATE `structure_fields` SET `structure_value_domain`  = '172' WHERE `structure_fields`.`id` =904;
UPDATE `structure_fields` SET `structure_value_domain`  = '172' WHERE `structure_fields`.`id` =905;
