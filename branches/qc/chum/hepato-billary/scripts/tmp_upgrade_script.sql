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
('installation_body', '', 'To view your installed version number open the Administration Tool and select ATiM Version from the first menu. ATiM is built on the CakePHP framework (www.cakephp.org).', '');

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

-- --------------------------------------------------------------------------------------------------------------------------
--
-- SECTION ABOVE HAS ALREADY INCLUDED INTO atim_v2.0.1-DDL.sql and atim_v2.0.1-DML.sql 
--
-- --------------------------------------------------------------------------------------------------------------------------

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

/*
  INVENTORY MANAGEMENT  
*/ 

#SQL View for collections
INSERT INTO `structures` (
`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , 'CANM-00025', 'view_collection', '', '', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO structure_fields (public_identifier,old_id,plugin,model,tablename,field,language_label,language_tag,type,setting,`default`,structure_value_domain,language_help,validation_control,value_domain_control,field_control,created,created_by,modified,modified_by)
SELECT public_identifier, CONCAT(old_id, '-v'),plugin, 'ViewCollection',tablename,field,language_label,language_tag,type,setting,`default`,structure_value_domain,language_help,validation_control,value_domain_control,field_control,created,created_by,modified,modified_by 
FROM structure_fields WHERE old_id IN('CAN-999-999-000-999-1000', 'CAN-999-999-000-999-1003', 'CAN-999-999-000-999-1004', 'CAN-999-999-000-999-1007', 'CAN-999-999-000-999-1008', 'CAN-999-999-000-999-1013', 'CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1285');

INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
SELECT CONCAT('CANM-00025_', structure_field_old_id, '-v'), @last_structure_id, 'CANM-00025', `structure_field_id`, CONCAT(`structure_field_old_id`, '-v'), `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, '0', '0', '0', '0', `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`
FROM structure_formats WHERE structure_old_id='CAN-999-999-000-999-1000' AND (flag_search='1' OR flag_index='1' OR flag_detail='1');

SET @last_id = LAST_INSERT_ID();

UPDATE structure_formats
INNER JOIN structure_fields ON structure_fields.old_id=structure_formats.structure_field_old_id
SET structure_formats.structure_field_id=structure_fields.id
WHERE structure_formats.id >= @last_id;

CREATE VIEW view_collections AS 
SELECT 
collection_id, 
bank_id, 
sop_master_id, 
participant_id, 
diagnosis_master_id, 
consent_master_id, 

acquisition_label, 
collection_site, 
collection_datetime, 
collection_datetime_accuracy, 
collection_property, 
collection_notes, 
collections.deleted, 
collections.deleted_date,

participant_identifier, 

banks.name AS bank_name,

sops.title AS sop_title, 	
sops.code AS sop_code, 	
sops.version AS sop_version, 		
sop_group,
sops.type 	

FROM collections
LEFT JOIN clinical_collection_links AS ccl ON collections.id=ccl.collection_id AND ccl.deleted != 1
LEFT JOIN participants ON ccl.participant_id=participants.id AND participants.deleted != 1
LEFT JOIN banks ON collections.bank_id=banks.id AND banks.deleted != 1
LEFT JOIN sop_masters AS sops ON collections.sop_master_id=sops.id AND sops.deleted != 1;

INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , '', 'CANM-00026', 'Inventorymanagement', 'ViewCollection', '', 'participant_identifier', 'participant identifier', '', 'input', '', '', NULL , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @last_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , 'CANM-00025_CANM-00026', @last_structure_id, 'CANM-00025', @last_id, 'CANM-00026', '0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `menus`
SET `use_summary` = 'Inventorymanagement.ViewCollection::summary'
WHERE `use_summary` LIKE 'Inventorymanagement.Collection::summary';

UPDATE structure_formats
SET display_order = '1'
WHERE old_id = 'CANM-00025_CANM-00026';

UPDATE structure_formats
SET display_order = '0'
WHERE old_id = 'CANM-00025_CAN-999-999-000-999-1000-v'; 

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

-- Remove validation for Family History: Age at Diagnosis 
DELETE FROM `structure_validations` WHERE `structure_validations`.`structure_field_id` = (SELECT id FROM `structure_fields` WHERE `plugin` LIKE 'Clinicalannotation' AND `model` LIKE 'FamilyHistory' AND `field` LIKE 'age_at_dx');