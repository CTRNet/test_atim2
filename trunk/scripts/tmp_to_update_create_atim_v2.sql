-- --------------------------------------------------------------------------------
-- Description: Updates the database to support the redesigned diagnosis forms
-- Author: FM L'Heureux
-- Date: 2009-10-23
-- --------------------------------------------------------------------------------
SET autocommit = 0;
START TRANSACTION;

UPDATE `menus` SET use_link='/clinicalannotation/diagnosis_masters/listall/%%Participant.id%%' WHERE id='clin_CAN_5';
INSERT INTO `menus` VALUES
('clin_CAN_5_1', 'clin_CAN_5', 0, 1, 'Details', 'Details', '/clinicalannotation/diagnosis_masters/detail/%%Participant.id%%/%%DiagnosisMaster.id%%/%%DiagnosisMaster.diagnosis_control_id%%', '', 'Clinicalannotation.DiagnosisMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_5_2', 'clin_CAN_5', 0, 2, 'Comorbidity', 'Comorbidity', 'dev', '', '', 'no', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');


CREATE TABLE `diagnosis_controls` (
  `id` tinyint NOT NULL auto_increment,
  `controls_type` varchar(6) NOT NULL,
  `status` varchar(50) NOT NULL default 'active',
  `form_alias` varchar(255) NOT NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL default 0,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `diagnosis_controls_revs` (
  `id` tinyint NOT NULL auto_increment,
  `controls_type` varchar(6) NOT NULL,
  `status` varchar(50) NOT NULL default 'active',
  `form_alias` varchar(255) NOT NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL default 0,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `diagnosis_controls` (`controls_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES(
'Blood', 'active', 'dx_bloods', 'dxd_bloods', 0),
('Tissue', 'active', 'dx_tissues', 'dxd_tissues', 0);

RENAME TABLE `diagnoses`  TO `diagnosis_masters` ;
ALTER TABLE `diagnosis_masters` 
	ADD `diagnosis_control_id` tinyint unsigned NOT NULL default 0,
	ADD `type` varchar(6) NOT NULL default '';

RENAME TABLE `diagnoses_revs`  TO `diagnosis_masters_revs` ;
ALTER TABLE `diagnosis_masters_revs` 
	ADD `diagnosis_control_id` tinyint unsigned NOT NULL default 0,
	ADD `type`varchar(6) NOT NULL default '';

CREATE TABLE `dxd_bloods` (
  `id` int unsigned NOT NULL auto_increment,
  `diagnosis_master_id` int(11) unsigned default NULL,
  `text_field` varchar(10) not null default '',
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `dxd_bloods_revs` (
  `id` int unsigned NOT NULL auto_increment,
  `diagnosis_master_id` int(11) unsigned default NULL,
  `text_field` varchar(10) not null default '',
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `dxd_tissues` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `diagnosis_master_id` int(11) unsigned default NULL,
  `text_field` varchar(10) not null default '',
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `dxd_tissues_revs` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `diagnosis_master_id` int(11) unsigned default NULL,
  `text_field` varchar(10) not null default '',
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

UPDATE `structures` SET alias='dx_bloods' WHERE id=138;

INSERT INTO `structures` (`old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('CANM-00001', 'dx_tissues', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @dx_tissues_id = LAST_INSERT_ID();

UPDATE `structure_fields` SET model='DiagnosisMaster' WHERE model='Diagnosis';

INSERT INTO `structure_fields` (`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('', 'CANM-00001', 'Clinicalannotation', 'DiagnosisDetail', '', 'text_field', 'text_field', '', 'input', 'size=10', '', 0, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('', 'CANM-00002', 'Clinicalannotation', 'DiagnosisDetail', '', 'text_field', 'text_field', '', 'input', 'size=10', '', 0, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @first_field_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('CAN-999-999-000-999-6_CANM-00001', 138, 'CAN-999-999-000-999-6', @first_field_id, 'CANM-00001', 2, 26, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CANM-00002', @dx_tissues_id, 'CAN-999-999-000-999-6', @first_field_id + 1, 'CANM-00002', 2, 26, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-002-11', @dx_tissues_id, 'CAN-999-999-000-999-6', 139, 'CAN-999-999-000-002-11', 1, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-324', @dx_tissues_id, 'CAN-999-999-000-999-6', 585, 'CAN-999-999-000-999-324', 1, 7, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-68', @dx_tissues_id, 'CAN-999-999-000-999-6', 812, 'CAN-999-999-000-999-68', 1, 0, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-69', @dx_tissues_id, 'CAN-999-999-000-999-6', 813, 'CAN-999-999-000-999-69', 1, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-70', @dx_tissues_id, 'CAN-999-999-000-999-6', 815, 'CAN-999-999-000-999-70', 1, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-71', @dx_tissues_id, 'CAN-999-999-000-999-6', 816, 'CAN-999-999-000-999-71', 1, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-72', @dx_tissues_id, 'CAN-999-999-000-999-6', 817, 'CAN-999-999-000-999-72', 1, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2008-10-01 11:16:32', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-73', @dx_tissues_id, 'CAN-999-999-000-999-6', 818, 'CAN-999-999-000-999-73', 1, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-74', @dx_tissues_id, 'CAN-999-999-000-999-6', 819, 'CAN-999-999-000-999-74', 1, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-76', @dx_tissues_id, 'CAN-999-999-000-999-6', 821, 'CAN-999-999-000-999-76', 1, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-77', @dx_tissues_id, 'CAN-999-999-000-999-6', 823, 'CAN-999-999-000-999-77', 2, 13, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-78', @dx_tissues_id, 'CAN-999-999-000-999-6', 824, 'CAN-999-999-000-999-78', 2, 14, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-79', @dx_tissues_id, 'CAN-999-999-000-999-6', 825, 'CAN-999-999-000-999-79', 2, 15, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-80', @dx_tissues_id, 'CAN-999-999-000-999-6', 827, 'CAN-999-999-000-999-80', 2, 16, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-81', @dx_tissues_id, 'CAN-999-999-000-999-6', 828, 'CAN-999-999-000-999-81', 2, 17, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-82', @dx_tissues_id, 'CAN-999-999-000-999-6', 829, 'CAN-999-999-000-999-82', 2, 18, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-83', @dx_tissues_id, 'CAN-999-999-000-999-6', 830, 'CAN-999-999-000-999-83', 2, 19, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-84', @dx_tissues_id, 'CAN-999-999-000-999-6', 831, 'CAN-999-999-000-999-84', 2, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-85', @dx_tissues_id, 'CAN-999-999-000-999-6', 832, 'CAN-999-999-000-999-85', 2, 21, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-86', @dx_tissues_id, 'CAN-999-999-000-999-6', 833, 'CAN-999-999-000-999-86', 2, 22, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-87', @dx_tissues_id, 'CAN-999-999-000-999-6', 834, 'CAN-999-999-000-999-87', 2, 23, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-88', @dx_tissues_id, 'CAN-999-999-000-999-6', 835, 'CAN-999-999-000-999-88', 2, 24, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-89', @dx_tissues_id, 'CAN-999-999-000-999-6', 836, 'CAN-999-999-000-999-89', 2, 24, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-90', @dx_tissues_id, 'CAN-999-999-000-999-6', 837, 'CAN-999-999-000-999-90', 2, 25, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-91', @dx_tissues_id, 'CAN-999-999-000-999-6', 838, 'CAN-999-999-000-999-91', 1, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `pages` (`id` ,`error_flag` ,`language_title` ,`language_body` ,`created` ,`created_by` ,`modified` ,`modified_by`)
VALUES ('err_missing_param', '1', 'missing_parameter', 'Missing parameter', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `atim_3`.`i18n` (`id` ,`page_id` ,`en` ,`fr`)
VALUES ('', 'err_missing_param', 'Missing parameter:', 'Paramètre manquant:');


COMMIT;