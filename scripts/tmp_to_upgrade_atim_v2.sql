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
UPDATE `structure_fields` SET field='diagnosis_master_id' WHERE field='diagnosis_id';


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
VALUES ('err_missing_param', '1', 'missing_parameter', 'parameter missing', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `i18n` SET en='Missing parameter' WHERE id='parameter missing';
ALTER TABLE `tx_masters` CHANGE `diagnosis_id` `diagnosis_master_id` INT( 11 ) NULL DEFAULT NULL;
ALTER TABLE `tx_masters_revs` CHANGE `diagnosis_id` `diagnosis_master_id` INT( 11 ) NULL DEFAULT NULL;
ALTER TABLE `consents` CHANGE `diagnosis_id` `diagnosis_master_id` INT( 11 ) NULL DEFAULT NULL;
ALTER TABLE `consents_revs` CHANGE `diagnosis_id` `diagnosis_master_id` INT( 11 ) NULL DEFAULT NULL;
ALTER TABLE `clinical_collection_links` CHANGE `diagnosis_id` `diagnosis_master_id` INT( 11 ) NULL DEFAULT NULL;
ALTER TABLE `clinical_collection_links_revs` CHANGE `diagnosis_id` `diagnosis_master_id` INT( 11 ) NULL DEFAULT NULL;
ALTER TABLE `event_masters` CHANGE `diagnosis_id` `diagnosis_master_id` INT( 11 ) NULL DEFAULT NULL;
ALTER TABLE `event_masters_revs` CHANGE `diagnosis_id` `diagnosis_master_id` INT( 11 ) NULL DEFAULT NULL;

COMMIT;

-- --------------------------------------------------------------------------------
-- Description: Updates the database to support the redesigned consents forms
-- Author: FM L'Heureux
-- Date: 2009-10-23
-- --------------------------------------------------------------------------------

RENAME TABLE `consents`  TO `consent_masters` ;

RENAME TABLE `consents_revs`  TO `consent_masters_revs` ;

ALTER TABLE `consent_masters`
ADD COLUMN `consent_control_id` int(11) UNSIGNED NOT NULL,
ADD COLUMN `type` varchar(10) NOT NULL DEFAULT '';

ALTER TABLE `consent_masters_revs`
ADD COLUMN `consents_control_id` int(11) UNSIGNED NOT NULL,
ADD COLUMN `type` varchar(10) NOT NULL DEFAULT '';

CREATE TABLE `consent_controls` (
  `id` tinyint NOT NULL auto_increment,
  `controls_type` varchar(6) NOT NULL,
  `status` varchar(50) NOT NULL default 'active',
  `form_alias` varchar(255) NOT NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL default 0,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `consent_controls_revs` (
  `id` tinyint NOT NULL auto_increment,
  `controls_type` varchar(6) NOT NULL,
  `status` varchar(50) NOT NULL default 'active',
  `form_alias` varchar(255) NOT NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL default 0,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `cd_atypes` (
  `id` int(11) NOT NULL auto_increment,
  `consent_master_id` int(11) NOT NULL,
  `data` varchar(50) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `cd_atypes_revs` (
  `id` int(11) NOT NULL auto_increment,
  `consent_master_id` int(11) NOT NULL,
  `data` varchar(50) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `cd_btypes` (
  `id` int(11) NOT NULL auto_increment,
  `consent_master_id` int(11) NOT NULL,
  `data` varchar(50) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

CREATE TABLE `cd_btypes_revs` (
  `id` int(11) NOT NULL auto_increment,
  `consent_master_id` int(11) NOT NULL,
  `data` varchar(50) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1; 

INSERT INTO `consent_controls` (`controls_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES(
'atype', 'active', 'c_atypes', 'cd_atypes', 0),
('btype', 'active', 'c_btypes', 'cd_btypes', 0);

UPDATE `structures` SET alias='c_atypes' WHERE id=98;

INSERT INTO `structures` (`old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('CANM-00003', 'c_btypes', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @c_btypes_id = LAST_INSERT_ID();

UPDATE `structure_fields` SET model='ConsentMaster' WHERE model='Consent';
UPDATE `structure_fields` SET field='consent_master_id' WHERE field='consent_id';

INSERT INTO `structure_fields` (`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('', 'CANM-00004', 'Clinicalannotation', 'ConsentDetail', '', 'data', 'data', '', 'input', 'size=10', '', 0, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('', 'CANM-00005', 'Clinicalannotation', 'ConsentDetail', '', 'data', 'data', '', 'input', 'size=10', '', 0, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @first_field_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('CANM-00003_CAN-046-003-000-002-29', @c_btypes_id, 'CANM-00003', 116, 'CAN-046-003-000-002-29', 1, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-046-003-000-999-1', @c_btypes_id, 'CANM-00003', 117, 'CAN-046-003-000-999-1', 1, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-046-003-000-999-5', @c_btypes_id, 'CANM-00003', 119, 'CAN-046-003-000-999-5', 1, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-046-003-000-999-6', @c_btypes_id, 'CANM-00003', 120, 'CAN-046-003-000-999-6', 1, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-046-003-000-999-7', @c_btypes_id, 'CANM-00003', 121, 'CAN-046-003-000-999-7', 1, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-046-999-000-999-12', @c_btypes_id, 'CANM-00003', 122, 'CAN-046-999-000-999-12', 2, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-046-999-000-999-13', @c_btypes_id, 'CANM-00003', 123, 'CAN-046-999-000-999-13', 2, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-046-999-000-999-14', @c_btypes_id, 'CANM-00003', 124, 'CAN-046-999-000-999-14', 2, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-999-999-000-999-52', @c_btypes_id, 'CANM-00003', 763, 'CAN-999-999-000-999-52', 1, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-999-999-000-999-53', @c_btypes_id, 'CANM-00003', 775, 'CAN-999-999-000-999-53', 1, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-999-999-000-999-56', @c_btypes_id, 'CANM-00003', 800, 'CAN-999-999-000-999-56', 1, 7, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-999-999-000-999-57', @c_btypes_id, 'CANM-00003', 801, 'CAN-999-999-000-999-57', 1, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-999-999-000-999-60', @c_btypes_id, 'CANM-00003', 804, 'CAN-999-999-000-999-60', 2, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-999-999-000-999-61', @c_btypes_id, 'CANM-00003', 805, 'CAN-999-999-000-999-61', 2, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-999-999-000-999-62', @c_btypes_id, 'CANM-00003', 806, 'CAN-999-999-000-999-62', 2, 7, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-999-999-000-999-63', @c_btypes_id, 'CANM-00003', 807, 'CAN-999-999-000-999-63', 2, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-999-999-000-999-64', @c_btypes_id, 'CANM-00003', 808, 'CAN-999-999-000-999-64', 2, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-999-999-000-999-65', @c_btypes_id, 'CANM-00003', 809, 'CAN-999-999-000-999-65', 1, 50, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CAN-999-999-000-999-66', @c_btypes_id, 'CANM-00003', 810, 'CAN-999-999-000-999-66', 2, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00003_CANM-00005', @c_btypes_id, 'CANM-00003', @first_field_id, 'CANM-00005', 2, 12, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-12_CANM-00004', 98, 'CAN-999-999-000-999-12', @first_field_id + 1, 'CANM-00004', 2, 12, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

ALTER TABLE `clinical_collection_links` CHANGE `consent_id` `consent_master_id` INT( 11 ) NULL DEFAULT NULL;
ALTER TABLE `clinical_collection_links_revs` CHANGE `consent_id` `consent_master_id` INT( 11 ) NULL DEFAULT NULL;
ALTER TABLE `consent_masters` CHANGE `consent_id` `consent_master_id` INT( 11 ) NULL DEFAULT NULL;
ALTER TABLE `consent_masters_revs` CHANGE `consent_id` `consent_master_id` INT( 11 ) NULL DEFAULT NULL;

UPDATE `menus` SET `use_link` = '/clinicalannotation/consent_masters/listall/%%Participant.id%%' WHERE `menus`.`id` = 'clin_CAN_9' LIMIT 1 ;

-- --------------------------------------------------------------------------------
-- Description: Updates the database to support the redesigned qc forms
-- Author: FM L'Heureux
-- Date: 2009-10-23
-- --------------------------------------------------------------------------------

UPDATE `menus` SET use_link='/inventorymanagement/quality_ctrls/listall/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%' WHERE id='inv_CAN_224';
UPDATE `menus` SET use_link='/inventorymanagement/quality_ctrls/listall/%%Collection.id%%/%%SampleMaster.id%%' WHERE id='inv_CAN_2224';

UPDATE `structures` SET `alias` = 'qualityctrls' WHERE `structures`.`id` =65 LIMIT 1 ;

UPDATE `structure_fields` SET model='QualityCtrl' WHERE model='QualityControl';

RENAME TABLE `quality_controls`  TO `quality_ctrls` ;
RENAME TABLE `quality_controls_revs`  TO `quality_ctrls_revs` ;

-- --------------------------------------------------------------------------------
-- Description: Updates the database to 
-- Author: FM L'Heureux
-- Date: 2009-10-23
-- --------------------------------------------------------------------------------

INSERT INTO `structures` (`old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('CANM-00006', 'diagnosis_masters', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @diagnosis_masters_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('CAN-999-999-000-999-6_CAN-999-999-000-002-11', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 139, 'CAN-999-999-000-002-11', 1, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-324', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 585, 'CAN-999-999-000-999-324', 1, 7, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-68', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 812, 'CAN-999-999-000-999-68', 1, 0, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-69', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 813, 'CAN-999-999-000-999-69', 1, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-70', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 815, 'CAN-999-999-000-999-70', 1, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-71', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 816, 'CAN-999-999-000-999-71', 1, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-72', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 817, 'CAN-999-999-000-999-72', 1, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2008-10-01 11:16:32', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-73', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 818, 'CAN-999-999-000-999-73', 1, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-74', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 819, 'CAN-999-999-000-999-74', 1, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-76', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 821, 'CAN-999-999-000-999-76', 1, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-77', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 823, 'CAN-999-999-000-999-77', 2, 13, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-78', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 824, 'CAN-999-999-000-999-78', 2, 14, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-79', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 825, 'CAN-999-999-000-999-79', 2, 15, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-80', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 827, 'CAN-999-999-000-999-80', 2, 16, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-81', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 828, 'CAN-999-999-000-999-81', 2, 17, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-82', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 829, 'CAN-999-999-000-999-82', 2, 18, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-83', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 830, 'CAN-999-999-000-999-83', 2, 19, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-84', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 831, 'CAN-999-999-000-999-84', 2, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-85', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 832, 'CAN-999-999-000-999-85', 2, 21, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-86', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 833, 'CAN-999-999-000-999-86', 2, 22, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-87', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 834, 'CAN-999-999-000-999-87', 2, 23, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-88', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 835, 'CAN-999-999-000-999-88', 2, 24, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-89', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 836, 'CAN-999-999-000-999-89', 2, 24, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-90', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 837, 'CAN-999-999-000-999-90', 2, 25, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CAN-999-999-000-999-6_CAN-999-999-000-999-91', @diagnosis_masters_id, 'CAN-999-999-000-999-6', 838, 'CAN-999-999-000-999-91', 1, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');


INSERT INTO `structures` (`old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('CANM-00006', 'diagnosis_masters', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007', 'consent_masters', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @diagnosis_masters_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('CANM_00006_CAN-999-999-000-002-11', @diagnosis_masters_id, 'CANM_00006', 139, 'CAN-999-999-000-002-11', 1, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-324', @diagnosis_masters_id, 'CANM_00006', 585, 'CAN-999-999-000-999-324', 1, 7, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CANM_000068', @diagnosis_masters_id, 'CANM_00006', 812, 'CANM_000068', 1, 0, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CANM_000069', @diagnosis_masters_id, 'CANM_00006', 813, 'CANM_000069', 1, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-70', @diagnosis_masters_id, 'CANM_00006', 815, 'CAN-999-999-000-999-70', 1, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-71', @diagnosis_masters_id, 'CANM_00006', 816, 'CAN-999-999-000-999-71', 1, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-72', @diagnosis_masters_id, 'CANM_00006', 817, 'CAN-999-999-000-999-72', 1, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2008-10-01 11:16:32', ''),
('CANM_00006_CAN-999-999-000-999-73', @diagnosis_masters_id, 'CANM_00006', 818, 'CAN-999-999-000-999-73', 1, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-74', @diagnosis_masters_id, 'CANM_00006', 819, 'CAN-999-999-000-999-74', 1, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-76', @diagnosis_masters_id, 'CANM_00006', 821, 'CAN-999-999-000-999-76', 1, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-77', @diagnosis_masters_id, 'CANM_00006', 823, 'CAN-999-999-000-999-77', 2, 13, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-78', @diagnosis_masters_id, 'CANM_00006', 824, 'CAN-999-999-000-999-78', 2, 14, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-79', @diagnosis_masters_id, 'CANM_00006', 825, 'CAN-999-999-000-999-79', 2, 15, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-80', @diagnosis_masters_id, 'CANM_00006', 827, 'CAN-999-999-000-999-80', 2, 16, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-81', @diagnosis_masters_id, 'CANM_00006', 828, 'CAN-999-999-000-999-81', 2, 17, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-82', @diagnosis_masters_id, 'CANM_00006', 829, 'CAN-999-999-000-999-82', 2, 18, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-83', @diagnosis_masters_id, 'CANM_00006', 830, 'CAN-999-999-000-999-83', 2, 19, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-84', @diagnosis_masters_id, 'CANM_00006', 831, 'CAN-999-999-000-999-84', 2, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-85', @diagnosis_masters_id, 'CANM_00006', 832, 'CAN-999-999-000-999-85', 2, 21, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-86', @diagnosis_masters_id, 'CANM_00006', 833, 'CAN-999-999-000-999-86', 2, 22, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-87', @diagnosis_masters_id, 'CANM_00006', 834, 'CAN-999-999-000-999-87', 2, 23, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-88', @diagnosis_masters_id, 'CANM_00006', 835, 'CAN-999-999-000-999-88', 2, 24, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-89', @diagnosis_masters_id, 'CANM_00006', 836, 'CAN-999-999-000-999-89', 2, 24, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-90', @diagnosis_masters_id, 'CANM_00006', 837, 'CAN-999-999-000-999-90', 2, 25, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM_00006_CAN-999-999-000-999-91', @diagnosis_masters_id, 'CANM_00006', 838, 'CAN-999-999-000-999-91', 1, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-046-003-000-002-29', @diagnosis_masters_id + 1, 'CANM-00007', 116, 'CAN-046-003-000-002-29', 1, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-046-003-000-999-1', @diagnosis_masters_id + 1, 'CANM-00007', 117, 'CAN-046-003-000-999-1', 1, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-046-003-000-999-5', @diagnosis_masters_id + 1, 'CANM-00007', 119, 'CAN-046-003-000-999-5', 1, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-046-003-000-999-6', @diagnosis_masters_id + 1, 'CANM-00007', 120, 'CAN-046-003-000-999-6', 1, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-046-003-000-999-7', @diagnosis_masters_id + 1, 'CANM-00007', 121, 'CAN-046-003-000-999-7', 1, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-046-999-000-999-12', @diagnosis_masters_id + 1, 'CANM-00007', 122, 'CAN-046-999-000-999-12', 2, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-046-999-000-999-13', @diagnosis_masters_id + 1, 'CANM-00007', 123, 'CAN-046-999-000-999-13', 2, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-046-999-000-999-14', @diagnosis_masters_id + 1, 'CANM-00007', 124, 'CAN-046-999-000-999-14', 2, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-999-999-000-999-52', @diagnosis_masters_id + 1, 'CANM-00007', 763, 'CAN-999-999-000-999-52', 1, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-999-999-000-999-53', @diagnosis_masters_id + 1, 'CANM-00007', 775, 'CAN-999-999-000-999-53', 1, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-999-999-000-999-56', @diagnosis_masters_id + 1, 'CANM-00007', 800, 'CAN-999-999-000-999-56', 1, 7, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-999-999-000-999-57', @diagnosis_masters_id + 1, 'CANM-00007', 801, 'CAN-999-999-000-999-57', 1, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-999-999-000-999-60', @diagnosis_masters_id + 1, 'CANM-00007', 804, 'CAN-999-999-000-999-60', 2, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-999-999-000-999-61', @diagnosis_masters_id + 1, 'CANM-00007', 805, 'CAN-999-999-000-999-61', 2, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-999-999-000-999-62', @diagnosis_masters_id + 1, 'CANM-00007', 806, 'CAN-999-999-000-999-62', 2, 7, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-999-999-000-999-63', @diagnosis_masters_id + 1, 'CANM-00007', 807, 'CAN-999-999-000-999-63', 2, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-999-999-000-999-64', @diagnosis_masters_id + 1, 'CANM-00007', 808, 'CAN-999-999-000-999-64', 2, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-999-999-000-999-65', @diagnosis_masters_id + 1, 'CANM-00007', 809, 'CAN-999-999-000-999-65', 1, 50, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('CANM-00007_CAN-999-999-000-999-66', @diagnosis_masters_id + 1, 'CANM-00007', 810, 'CAN-999-999-000-999-66', 2, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- --------------------------------------------------------------------------------
-- Description: Inventory management - Aliquots cleanup
-- Author: NL
-- Date: 2009-11-01
-- --------------------------------------------------------------------------------


ALTER TABLE `storage_masters` CHANGE `barcode` `barcode` VARCHAR( 60 ) 
CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL;

ALTER TABLE `tma_slides` CHANGE `barcode` `barcode` VARCHAR( 60 ) 
CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ;

ALTER TABLE `storage_masters_revs` CHANGE `barcode` `barcode` VARCHAR( 60 ) 
CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL;

ALTER TABLE `tma_slides_revs` CHANGE `barcode` `barcode` VARCHAR( 60 ) 
CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ;

UPDATE `structure_validations` SET `rule` = 'maxLength,60' WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1183'
AND `rule` LIKE 'maxLength,%';

UPDATE `structure_validations` SET `rule` = 'maxLength,60' WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1232'
AND `rule` LIKE 'maxLength,%';

DELETE FROM menus
WHERE id LIKE 'inv_CAN%';

INSERT INTO `menus` 
(`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_params`, `use_summary`, `active`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
('inv_CAN', 'MAIN_MENU_1', 1, 3, 'inventory management', 'inventory management', '/inventorymanagement/collections/index', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_1', 'inv_CAN', 0, 1, 'collection details', NULL, '/inventorymanagement/collections/detail/%%Collection.id%%', '', 'Inventorymanagement.Collection::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_2', 'inv_CAN', 0, 2, 'listall collection content', NULL, '/inventorymanagement/sample_masters/contentTreeView/%%Collection.id%%', '', 'Inventorymanagement.Collection::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	('inv_CAN_21', 'inv_CAN_2', 0, 1, 'tree view', NULL, '/inventorymanagement/sample_masters/contentTreeView/%%Collection.id%%', '', 'Inventorymanagement.Collection::contentFilterSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	('inv_CAN_22', 'inv_CAN_2', 0, 2, 'listall collection samples', NULL, '/inventorymanagement/sample_masters/listAll/%%Collection.id%%/-1', '', 'Inventorymanagement.Collection::contentFilterSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
		('inv_CAN_221', 'inv_CAN_22', 0, 1, 'details', NULL, '/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%', '', 'Inventorymanagement.SampleMaster::specimenSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
		('inv_CAN_222', 'inv_CAN_22', 0, 2, 'listall derivatives', NULL, '/inventorymanagement/sample_masters/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%', '', 'Inventorymanagement.SampleMaster::specimenSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2221', 'inv_CAN_222', 0, 1, 'details', NULL, '/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.id%%', '', 'Inventorymanagement.SampleMaster::derivativeSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2222', 'inv_CAN_222', 0, 2, 'Parent Aliquots', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2223', 'inv_CAN_222', 0, 3, 'listall aliquots', NULL, '/inventorymanagement/aliquot_masters/listAll/%%Collection.id%%/%%SampleMaster.id%%', '', 'Inventorymanagement.SampleMaster::derivativeSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
				('inv_CAN_22231', 'inv_CAN_2223', 0, 1, 'details', NULL, '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%', '', 'Inventorymanagement.AliquotMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
				('inv_CAN_22232', 'inv_CAN_2223', 0, 2, 'uses', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
				('inv_CAN_22233', 'inv_CAN_2223', 0, 3, 'realiquoted parent', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2224', 'inv_CAN_222', 0, 4, 'quality controls', NULL, '/inventorymanagement/quality_ctrls/listall/%%Collection.id%%/%%SampleMaster.id%%', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
				('inv_CAN_22241', 'inv_CAN_224', 0, 1, 'details', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
				('inv_CAN_22242', 'inv_CAN_224', 0, 2, 'tested aliquots', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
		('inv_CAN_223', 'inv_CAN_22', 0, 3, 'listall aliquots', NULL, '/inventorymanagement/aliquot_masters/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%', '', 'Inventorymanagement.SampleMaster::specimenSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2231', 'inv_CAN_223', 0, 1, 'details', NULL, '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%', '', 'Inventorymanagement.AliquotMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2232', 'inv_CAN_223', 0, 2, 'uses', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2233', 'inv_CAN_223', 0, 3, 'realiquoted parent', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
		('inv_CAN_224', 'inv_CAN_22', 0, 4, 'quality controls', NULL, '/inventorymanagement/quality_ctrls/listall/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2241', 'inv_CAN_224', 0, 1, 'details', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
			('inv_CAN_2242', 'inv_CAN_224', 0, 2, 'tested aliquots', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	('inv_CAN_23', 'inv_CAN_2', 0, 3, 'listall collection aliquots', NULL, '/inventorymanagement/aliquot_masters/listAll/%%Collection.id%%/-1', '', 'Inventorymanagement.Collection::contentFilterSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_3', 'inv_CAN', 0, 3, 'listall collection path reviews', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats` WHERE `old_id` IN (
'CAN-999-999-000-999-1020_CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1020_CAN-999-999-000-999-1000',
'CAN-999-999-000-999-1020_CAN-999-999-000-999-1018');
 
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1020_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1020'), 'CAN-999-999-000-999-1020',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1020_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1020'), 'CAN-999-999-000-999-1020',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1020_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1020'), 'CAN-999-999-000-999-1020',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM sample_to_aliquot_controls;

INSERT INTO `sample_to_aliquot_controls` 
(`id`, `sample_control_id`, `aliquot_control_id`, `status`) VALUES
(1, 1, 2, 'inactive'),
(2, 2, 2, 'active'),
(3, 2, 6, 'active'),
(4, 3, 1001, 'active'),
(5, 3, 1002, 'active'),
(7, 3, 4, 'active'),
(8, 3, 5, 'active'),
(9, 4, 2, 'active'),
(10, 5, 8, 'active'),
(11, 6, 8, 'active'),
(12, 15, 8, 'active'),
(13, 14, 8, 'active'),
(14, 7, 15, 'active'),
(15, 8, 15, 'active'),
(16, 9, 8, 'active'),
(17, 10, 8, 'active'),
(18, 12, 11, 'active'),
(19, 13, 11, 'active'),
(20, 16, 11, 'active'),
(21, 17, 11, 'active'),
(22, 11, 100, 'active'),
(23, 11, 10, 'active'),
(30, 103, 2, 'inactive'),
(31, 104, 2, 'inactive'),
(32, 105, 2, 'inactive'),
(33, 106, 8, 'active'),
(34, 107, 8, 'active'),
(35, 108, 8, 'active'),
(36, 109, 8, 'active'),
(37, 110, 8, 'active'),
(38, 111, 8, 'active'),
(39, 101, 15, 'active'),
(40, 102, 15, 'active'),
(41, 3, 12, 'active'),
(42, 18, 14, 'active'),
(43, 18, 13, 'active'),
(44, 18, 15, 'active');

UPDATE `structure_formats`
SET `flag_add_readonly` = '1',
`flag_edit_readonly` = '1',
`flag_datagrid_readonly` = '1'
WHERE `structure_field_old_id` LIKE 'CAN-999-999-000-999-1131' 
AND `old_id` LIKE '%_CAN-999-999-000-999-1131.2';

DELETE FROM `i18n` WHERE `id` IN 
('listall aliquots');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('listall aliquots', 'global', 'Aliquots', 'Aliquots');

DELETE FROM `structure_formats`
WHERE `structure_field_old_id` LIKE 'CAN-999-999-000-999-1119'
AND `structure_old_id` IN (SELECT old_id from structures where alias like 'ad_der%' or alias like 'ad_%spe%');

DELETE 
FROM `structure_validations`
WHERE `structure_field_old_id` LIKE 'CAN-999-999-000-999-1100';

INSERT INTO `structure_validations` (`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modifed_by`) VALUES
(null, '0', (SELECT id FROM `structure_fields` WHERE `old_id` LIKE 'CAN-999-999-000-999-1100'), 'CAN-999-999-000-999-1100', 'maxLength,60', '1', '0', '', 'barcode size is limited', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '0', (SELECT id FROM `structure_fields` WHERE `old_id` LIKE 'CAN-999-999-000-999-1100'), 'CAN-999-999-000-999-1100', 'notEmpty', '1', '0', '', 'barcode is required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structure_formats` SET `old_id` = 'CAN-999-999-000-999-1033_CAN-999-999-000-999-1131.2'
WHERE `structure_old_id` LIKE 'CAN-999-999-000-999-1033' 
AND `structure_field_old_id` LIKE 'CAN-999-999-000-999-1131' 
AND `old_id` LIKE 'CAN-999-999-000-999-1032_CAN-999-999-000-999-1131.2';

DELETE FROM `structure_formats` WHERE `old_id` = 'CAN-999-999-000-999-1074_CAN-999-999-000-999-1018';

UPDATE `structure_formats` SET display_order = '21' WHERE `old_id` = 'CAN-999-999-000-999-1074_CAN-999-999-000-999-1107';
UPDATE `structure_formats` SET display_order = '22' WHERE `old_id` = 'CAN-999-999-000-999-1074_CAN-999-999-000-999-1108';	

DELETE FROM `structure_formats` WHERE `old_id` = 'CAN-999-999-000-999-1074_CAN-999-999-000-999-1103';

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1074_CAN-999-999-000-999-1103', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1074'), 'CAN-999-999-000-999-1074', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1103'), 'CAN-999-999-000-999-1103', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats` WHERE `old_id` = 'CAN-999-999-000-999-1074_CAN-999-999-000-999-1217';

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1074_CAN-999-999-000-999-1217', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1074'), 'CAN-999-999-000-999-1074', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1217'), 'CAN-999-999-000-999-1217', 0, 20, '', '0', '', '1', 'storage', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structure_formats` SET `flag_override_tag` = '0', `language_tag` ='' WHERE `old_id` = 'CAN-999-999-000-999-1074_CAN-999-999-000-999-1107';

DELETE FROM `structure_formats` WHERE `old_id` = 'CAN-999-999-000-999-1074_CAN-999-999-000-999-1110';

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1074_CAN-999-999-000-999-1110', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1074'), 'CAN-999-999-000-999-1074', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1110'), 'CAN-999-999-000-999-1110', 0, 10, '', '0', '', '1', 'temperature abbreviation', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats` WHERE `old_id` = 'CAN-999-999-000-999-1074_CAN-999-999-000-999-1194';

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1074_CAN-999-999-000-999-1194', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1074'), 'CAN-999-999-000-999-1074', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1194'), 'CAN-999-999-000-999-1194', 0, 11, '', '1', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN 
('temperature abbreviation');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('temperature abbreviation', 'global', 'T&deg;', 'T&deg;');

UPDATE structures SET alias = 'storage_masters_for_storage_tree_view' WHERE alias = 'storage_masters_for_tree_view';
UPDATE structures SET alias = 'tma_slides_for_storage_tree_view' WHERE alias = 'tma_slides_for_tree_view';
UPDATE structures SET alias = 'aliquot_masters_for_collection_tree_view' WHERE alias = 'aliquot_masters_for_tree_view';
UPDATE structures SET alias = 'sample_masters_for_collection_tree_view' WHERE alias = 'sample_masters_for_tree_view';

DELETE FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1076';

INSERT INTO `structures` (`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1076', 'aliquot_masters_for_storage_tree_view', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM structure_formats where structure_old_id = 'CAN-999-999-000-999-1076';

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1076_CAN-999-999-000-999-1102', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1076'), 'CAN-999-999-000-999-1076', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1102'), 'CAN-999-999-000-999-1102', 0, 2, '', '1', '', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1076_CAN-999-999-000-999-1100', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1076'), 'CAN-999-999-000-999-1076', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1100'), 'CAN-999-999-000-999-1100', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1076_CAN-999-999-000-999-1107', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1076'), 'CAN-999-999-000-999-1076', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1107'), 'CAN-999-999-000-999-1107', 0, 21, '', '1', ' ', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1076_CAN-999-999-000-999-1108', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1076'), 'CAN-999-999-000-999-1076', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1108'), 'CAN-999-999-000-999-1108', 0, 22, '', '0', '-', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structure_formats` set 	`old_id` = 'CAN-999-999-000-999-1074_CAN-999-999-000-999-1100'
WHERE `old_id` = 'CAN-999-999-000-999-1074_CAN-999-999-000-999-1101';

UPDATE `structure_fields` 
SET `language_help` = 'aliquot_status_help' 
WHERE `old_id` = 'CAN-999-999-000-999-1103';

UPDATE `structure_fields` 
SET `language_label` = 'initial specimen type' WHERE `old_id` = 'CAN-999-999-000-999-1222';

DELETE FROM `i18n` WHERE `id` IN 
('initial specimen type', 'all content', 'parent sample type');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('initial specimen type', 'global', 'Initial Specimen', 'Sp&eacute;cimen Source'),
('all content', 'global', 'All Content', 'Tout le contenu'),
('parent sample type', 'global', 'Parent Sample', '&eacute;chantillon parent');

DELETE FROM `structure_formats` WHERE `old_id` = 'CAN-999-999-000-999-1002_CAN-999-999-000-999-1222';

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1002_CAN-999-999-000-999-1222', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1002'), 'CAN-999-999-000-999-1002', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1222'), 'CAN-999-999-000-999-1222', 0, 21, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structure_formats` 
SET `display_order` = '20' 
WHERE `old_id` = 'CAN-999-999-000-999-1002_CAN-999-999-000-999-1027';

UPDATE `structure_formats` 
SET `display_order` = '28' 
WHERE `structure_old_id` IN (SELECT old_id FROM structures WHERE alias LIKE 'sd%_der%')
AND `structure_field_old_id` = 'CAN-999-999-000-999-1222';

DELETE FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1276';

INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'CAN-999-999-000-999-1276', '', 'GeneratedParentSample', '', 'sample_type', 'parent sample type', '', 'select', '', '', (SELECT id  FROM `structure_value_domains` WHERE `domain_name` LIKE 'sample_type' LIMIT 0 , 1), 'generated_parent_sample_sample_type_help', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM structure_formats where structure_field_old_id = 'CAN-999-999-000-999-1276';

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1010_CAN-999-999-000-999-1276',  
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1010'), 'CAN-999-999-000-999-1010', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 1, 29, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1011_CAN-999-999-000-999-1276',  
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1011'), 'CAN-999-999-000-999-1011', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 1, 29, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1012_CAN-999-999-000-999-1276',  
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1012'), 'CAN-999-999-000-999-1012', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 1, 29, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1013_CAN-999-999-000-999-1276',  
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1013'), 'CAN-999-999-000-999-1013', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 1, 29, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1014_CAN-999-999-000-999-1276',  
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1014'), 'CAN-999-999-000-999-1014', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 1, 29, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1015_CAN-999-999-000-999-1276',  
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1015'), 'CAN-999-999-000-999-1015', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 1, 29, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1061_CAN-999-999-000-999-1276',  
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1061'), 'CAN-999-999-000-999-1061', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 1, 29, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
	
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1002_CAN-999-999-000-999-1276',  
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1002'), 'CAN-999-999-000-999-1002', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 0, 22, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN 
('aliquot_status_help', 
'generated_parent_sample_sample_type_help',
'add aliquot',
'add',
'add a new collection',
'add collection',
'search',
'add derivative',
'access to all data',
'plugin storagelayout access to storage',
'add to order',
'remove from storage',
'no filter');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('aliquot_status_help', 'global', 'Status of an aliquot: <br> - All ''available'' aliquots should exist physically into the bank (but an available aliquot could be reserved, etc). <br> - All ''Not Available'' aliquots don''t exist anymore because they have been shipped, destroyed, used, etc.', 'Statu d''un aliquot : <br> - Tous les aliquots ''Disponibles'' doivent &ecirc;tre pr&eacute;sent physiquement dans la banque (mais ils peuvent &ecirc;tre r&eacute;serv&eacute;s, etc). <br> - Tous les aliquots ''Non Disponibles'' n''&eacute;xistent plus dans la banque parce qu''ils ont &eacute;t&eacute; utilis&eacute;s, d&eacute;truits, exp&eacute;di&eacute;s, etc.'),
('generated_parent_sample_sample_type_help', 'global', 'Type of the sample used to create the studied derivative sample.', 'Type de l''&eacute;chantillon utilis&eacute; pour cr&eacute;er l''&eacute;chantillon d&eacute;riv&eacute;.'),
('add aliquot', 'global', 'Add Aliquot', 'Cr&eacute;er aliquot'),
('add', 'global', 'Add', 'Cr&eacute;er'),
('add a new collection', 'global', 'Add New Collection', 'Cr&eacute;er collection'),
('add collection', 'global', 'Add Collection', 'Cr&eacute;er collection'),
('search', 'global', 'Search', 'Chercher'),
('add derivative', 'global', 'Add Derivative', 'Cr&eacute;er d&eacute;riv&eacute;'),
('access to all data', 'global', 'Access To Data', 'Acc&eacute;der aux donn&eacute;es'),
('plugin storagelayout access to storage', 'global', 'Access To Storage', 'Acc&eacute;der &agrave; l''entreposage'),
('add to order', 'global', 'Add To Order', 'Ajoutez aux commandes'),
('no filter', 'global', 'No Filter', 'Supprimer Filtre'),
('remove from storage', 'global', 'Remove From Storage', 'Supprimer de l''entreposage');

UPDATE structure_formats
SET flag_detail = '0'
WHERE structure_old_id = 'CAN-999-999-000-999-1002';

DELETE FROM `structure_formats`
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000')
AND `structure_old_id` = 'CAN-999-999-000-999-1012';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1012_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1012'), 'CAN-999-999-000-999-1012', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, -2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1012_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1012'), 'CAN-999-999-000-999-1012', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats`
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000')
AND `structure_old_id` = 'CAN-999-999-000-999-1061';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1061_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1061'), 'CAN-999-999-000-999-1061', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, -2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1061_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1061'), 'CAN-999-999-000-999-1061', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats`
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000')
AND `structure_old_id` = 'CAN-999-999-000-999-1011';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1011_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1011'), 'CAN-999-999-000-999-1011', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, -2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1011_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1011'), 'CAN-999-999-000-999-1011', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats`
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000')
AND `structure_old_id` = 'CAN-999-999-000-999-1013';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1013_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1013'), 'CAN-999-999-000-999-1013', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, -2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1013_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1013'), 'CAN-999-999-000-999-1013', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats`
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000')
AND `structure_old_id` = 'CAN-999-999-000-999-1014';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1014_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1014'), 'CAN-999-999-000-999-1014', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, -2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1014_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1014'), 'CAN-999-999-000-999-1014', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats`
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000')
AND `structure_old_id` = 'CAN-999-999-000-999-1015';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1015_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1015'), 'CAN-999-999-000-999-1015', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, -2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1015_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1015'), 'CAN-999-999-000-999-1015', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats`
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000')
AND `structure_old_id` = 'CAN-999-999-000-999-1007';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1007_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1007'), 'CAN-999-999-000-999-1007', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, -2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1007_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1007'), 'CAN-999-999-000-999-1007', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats`
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000')
AND `structure_old_id` = 'CAN-999-999-000-999-1006';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1006_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1006'), 'CAN-999-999-000-999-1006', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, -2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1006_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1006'), 'CAN-999-999-000-999-1006', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats`
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000')
AND `structure_old_id` = 'CAN-999-999-000-999-1017';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1017_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1017'), 'CAN-999-999-000-999-1017', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, -2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1017_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1017'), 'CAN-999-999-000-999-1017', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats`
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000')
AND `structure_old_id` = 'CAN-999-999-000-999-1018';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1018_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, -2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1018_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats`
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000')
AND `structure_old_id` = 'CAN-999-999-000-999-1016';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1016_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1016'), 'CAN-999-999-000-999-1016', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, -2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1016_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1016'), 'CAN-999-999-000-999-1016', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats`
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000')
AND `structure_old_id` = 'CAN-999-999-000-999-1008';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1008_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1008'), 'CAN-999-999-000-999-1008', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, -2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1008_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1008'), 'CAN-999-999-000-999-1008', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats`
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000')
AND `structure_old_id` = 'CAN-999-999-000-999-1009';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1009_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1009'), 'CAN-999-999-000-999-1009', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, -2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1009_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1009'), 'CAN-999-999-000-999-1009', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats`
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000')
AND `structure_old_id` = 'CAN-999-999-000-999-1010';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1010_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1010'), 'CAN-999-999-000-999-1010', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, -2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1010_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1010'), 'CAN-999-999-000-999-1010', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats`
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000')
AND `structure_old_id` = 'CAN-999-999-000-999-1005';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1005_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1005'), 'CAN-999-999-000-999-1005', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, -2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1005_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1005'), 'CAN-999-999-000-999-1005', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, -1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE structure_formats
SET flag_detail = '0'
WHERE structure_old_id = 'CAN-999-999-000-999-1020';

DELETE FROM `structure_formats` WHERE 
`structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000', 'CAN-999-999-000-999-1018')
AND `structure_old_id` IN ('CAN-999-999-000-999-1022', 'CAN-999-999-000-999-1024', 
'CAN-999-999-000-999-1026', 'CAN-999-999-000-999-1028', 'CAN-999-999-000-999-1029', 
'CAN-999-999-000-999-1030', 'CAN-999-999-000-999-1057');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1022_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1022'), 'CAN-999-999-000-999-1022', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1022_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1022'), 'CAN-999-999-000-999-1022',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1022_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1022'), 'CAN-999-999-000-999-1022', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1024_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1024'), 'CAN-999-999-000-999-1024', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1024_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1024'), 'CAN-999-999-000-999-1024',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1024_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1024'), 'CAN-999-999-000-999-1024', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1026_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1026'), 'CAN-999-999-000-999-1026', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1026_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1026'), 'CAN-999-999-000-999-1026',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1026_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1026'), 'CAN-999-999-000-999-1026', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1028_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1028'), 'CAN-999-999-000-999-1028', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1028_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1028'), 'CAN-999-999-000-999-1028',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1028_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1028'), 'CAN-999-999-000-999-1028', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1029_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1029'), 'CAN-999-999-000-999-1029', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1029_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1029'), 'CAN-999-999-000-999-1029',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1029_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1029'), 'CAN-999-999-000-999-1029', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1030_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1030'), 'CAN-999-999-000-999-1030', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1030_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1030'), 'CAN-999-999-000-999-1030',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1030_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1030'), 'CAN-999-999-000-999-1030', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1057_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1057'), 'CAN-999-999-000-999-1057', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1057_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1057'), 'CAN-999-999-000-999-1057',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1057_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1057'), 'CAN-999-999-000-999-1057', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats` WHERE 
`structure_field_old_id` IN ('CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1000', 'CAN-999-999-000-999-1018', 'CAN-999-999-000-999-1222', 'CAN-999-999-000-999-1276')
AND `structure_old_id` IN ('CAN-999-999-000-999-1020', 'CAN-999-999-000-999-1031', 'CAN-999-999-000-999-1032', 
'CAN-999-999-000-999-1033', 'CAN-999-999-000-999-1034', 'CAN-999-999-000-999-1054', 'CAN-999-999-000-999-1063',
'CAN-999-999-000-999-1064', 'CAN-999-999-000-999-1065');
 	
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1020_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1020'), 'CAN-999-999-000-999-1020', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1020_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1020'), 'CAN-999-999-000-999-1020',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1020_CAN-999-999-000-999-1222', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1020'), 'CAN-999-999-000-999-1020',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1222'), 'CAN-999-999-000-999-1222', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1020_CAN-999-999-000-999-1276', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1020'), 'CAN-999-999-000-999-1020',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1020_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1020'), 'CAN-999-999-000-999-1020', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 	
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1031_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1031'), 'CAN-999-999-000-999-1031', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1031_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1031'), 'CAN-999-999-000-999-1031',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1031_CAN-999-999-000-999-1222', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1031'), 'CAN-999-999-000-999-1031',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1222'), 'CAN-999-999-000-999-1222', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1031_CAN-999-999-000-999-1276', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1031'), 'CAN-999-999-000-999-1031',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1031_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1031'), 'CAN-999-999-000-999-1031', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1032_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1032'), 'CAN-999-999-000-999-1032', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1032_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1032'), 'CAN-999-999-000-999-1032',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1032_CAN-999-999-000-999-1222', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1032'), 'CAN-999-999-000-999-1032',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1222'), 'CAN-999-999-000-999-1222', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1032_CAN-999-999-000-999-1276', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1032'), 'CAN-999-999-000-999-1032',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1032_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1032'), 'CAN-999-999-000-999-1032', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1033_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1033'), 'CAN-999-999-000-999-1033', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1033_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1033'), 'CAN-999-999-000-999-1033',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1033_CAN-999-999-000-999-1222', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1033'), 'CAN-999-999-000-999-1033',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1222'), 'CAN-999-999-000-999-1222', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1033_CAN-999-999-000-999-1276', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1033'), 'CAN-999-999-000-999-1033',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1033_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1033'), 'CAN-999-999-000-999-1033', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1034_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1034'), 'CAN-999-999-000-999-1034', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1034_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1034'), 'CAN-999-999-000-999-1034',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1034_CAN-999-999-000-999-1222', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1034'), 'CAN-999-999-000-999-1034',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1222'), 'CAN-999-999-000-999-1222', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1034_CAN-999-999-000-999-1276', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1034'), 'CAN-999-999-000-999-1034',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1034_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1034'), 'CAN-999-999-000-999-1034', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1054_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1054'), 'CAN-999-999-000-999-1054', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1054_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1054'), 'CAN-999-999-000-999-1054',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1054_CAN-999-999-000-999-1222', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1054'), 'CAN-999-999-000-999-1054',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1222'), 'CAN-999-999-000-999-1222', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1054_CAN-999-999-000-999-1276', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1054'), 'CAN-999-999-000-999-1054',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1054_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1054'), 'CAN-999-999-000-999-1054', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1063_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1063'), 'CAN-999-999-000-999-1063', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1063_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1063'), 'CAN-999-999-000-999-1063',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1063_CAN-999-999-000-999-1222', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1063'), 'CAN-999-999-000-999-1063',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1222'), 'CAN-999-999-000-999-1222', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1063_CAN-999-999-000-999-1276', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1063'), 'CAN-999-999-000-999-1063',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1063_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1063'), 'CAN-999-999-000-999-1063', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1064_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1064'), 'CAN-999-999-000-999-1064', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1064_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1064'), 'CAN-999-999-000-999-1064',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1064_CAN-999-999-000-999-1222', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1064'), 'CAN-999-999-000-999-1064',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1222'), 'CAN-999-999-000-999-1222', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1064_CAN-999-999-000-999-1276', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1064'), 'CAN-999-999-000-999-1064',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1064_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1064'), 'CAN-999-999-000-999-1064', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1065_CAN-999-999-000-999-1000', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1065'), 'CAN-999-999-000-999-1065', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1065_CAN-999-999-000-999-1223', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1065'), 'CAN-999-999-000-999-1065',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1065_CAN-999-999-000-999-1222', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1065'), 'CAN-999-999-000-999-1065',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1222'), 'CAN-999-999-000-999-1222', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1065_CAN-999-999-000-999-1276', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1065'), 'CAN-999-999-000-999-1065',
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1065_CAN-999-999-000-999-1018', 
(SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1065'), 'CAN-999-999-000-999-1065', 
(SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structure_formats`
SET `display_order` = '9'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1102'
AND `structure_id` IN (SELECT id FROM `structures` WHERE alias LIKE 'ad_%');

UPDATE `structure_formats`
SET `display_order` = '9'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1102'
AND `structure_id` IN (SELECT id FROM `structures` WHERE alias LIKE 'aliquotmasters');

UPDATE `structure_formats`
SET `flag_index` = '0'
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1180', 'CAN-999-999-000-999-1110', 'CAN-999-999-000-999-1194', 
'CAN-999-999-000-999-1109', 'CAN-999-999-000-999-1132')
AND `structure_id` IN (SELECT id FROM `structures` WHERE alias LIKE 'ad_%');

UPDATE `structure_formats`
SET `flag_index` = '0'
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1180', 'CAN-999-999-000-999-1110', 'CAN-999-999-000-999-1194', 
'CAN-999-999-000-999-1109', 'CAN-999-999-000-999-1132')
AND `structure_id` IN (SELECT id FROM `structures` WHERE alias LIKE 'aliquotmasters');

UPDATE `structure_formats`
SET `flag_index` = '0'
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1131')
AND `display_order` = '74'
AND `structure_id` IN (SELECT id FROM `structures` WHERE alias LIKE 'ad_%');

UPDATE `structure_formats`
SET `flag_index` = '0'
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1131')
AND `display_order` = '74'
AND `structure_id` IN (SELECT id FROM `structures` WHERE alias LIKE 'aliquotmasters');

UPDATE `structure_formats`
SET `flag_index` = '1'
WHERE `old_id` IN ('CAN-999-999-000-999-1063_CAN-999-999-000-999-1239', 'CAN-999-999-000-999-1063_CAN-999-999-000-999-1240');

UPDATE `structure_formats`
SET `flag_index` = '0'
WHERE `old_id` IN ('CAN-999-999-000-999-1028_CAN-999-999-000-999-1166', 'CAN-999-999-000-999-1030_CAN-999-999-000-999-1138', 
'CAN-999-999-000-999-1030_CAN-999-999-000-999-1164');

UPDATE `structure_formats`
SET `flag_search` = '1'
WHERE `old_id` IN ('CAN-999-999-000-999-1020_CAN-999-999-000-999-1000', 'CAN-999-999-000-999-1020_CAN-999-999-000-999-1223',
'CAN-999-999-000-999-1020_CAN-999-999-000-999-1222', 'CAN-999-999-000-999-1020_CAN-999-999-000-999-1018',
'CAN-999-999-000-999-1002_CAN-999-999-000-999-1222');

UPDATE `structure_formats`
SET `display_order` = '1'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1000'
AND `structure_id` IN (SELECT id FROM `structures` WHERE `alias` LIKE 'sd_%' OR `alias` LIKE 'samplemasters');

UPDATE `structure_formats`
SET `display_order` = '2'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1223'
AND `structure_id` IN (SELECT id FROM `structures` WHERE `alias` LIKE 'sd_%' OR `alias` LIKE 'samplemasters');

UPDATE `structure_formats`
SET `display_order` = '3', `display_column` = '0'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1222'
AND `structure_id` IN (SELECT id FROM `structures` WHERE `alias` LIKE 'sd_%' OR `alias` LIKE 'samplemasters');

UPDATE `structure_formats`
SET `display_order` = '4', `display_column` = '0'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1276'
AND `structure_id` IN (SELECT id FROM `structures` WHERE `alias` LIKE 'sd_%' OR `alias` LIKE 'samplemasters');

UPDATE `structure_formats`
SET `display_order` = '5'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1018'
AND `structure_id` IN (SELECT id FROM `structures` WHERE `alias` LIKE 'sd_%' OR `alias` LIKE 'samplemasters');

UPDATE `structure_formats`
SET `display_order` = '6'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1016'
AND `structure_id` IN (SELECT id FROM `structures` WHERE `alias` LIKE 'sd_%' OR `alias` LIKE 'samplemasters');

UPDATE `structure_formats`
SET `display_order` = '7'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1027'
AND `structure_id` IN (SELECT id FROM `structures` WHERE `alias` LIKE 'sd_%' OR `alias` LIKE 'samplemasters');

UPDATE `structure_formats`
SET `display_order` = '8'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1023'
AND `structure_id` IN (SELECT id FROM `structures` WHERE `alias` LIKE 'sd_%' OR `alias` LIKE 'samplemasters');

UPDATE `structure_formats`
SET `display_order` = '8'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1027'
AND `structure_id` IN (SELECT id FROM `structures` WHERE `alias` LIKE 'sd_%' OR `alias` LIKE 'samplemasters');

UPDATE `structure_formats`
SET `display_order` = '9'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1023'
AND `structure_id` IN (SELECT id FROM `structures` WHERE `alias` LIKE 'sd_%' OR `alias` LIKE 'samplemasters');

UPDATE `structure_formats`
SET `display_order` = '7'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1031'
AND `structure_id` IN (SELECT id FROM `structures` WHERE `alias` LIKE 'sd_%' OR `alias` LIKE 'samplemasters');

ALTER TABLE `ad_tissue_slides` CHANGE `ad_block_id` `block_aliquot_master_id` INT( 11 ) NULL DEFAULT NULL;
ALTER TABLE `ad_tissue_slides_revs` CHANGE `ad_block_id` `block_aliquot_master_id` INT( 11 ) NULL DEFAULT NULL;
 
ALTER TABLE `ad_tissue_cores` CHANGE `ad_block_id` `block_aliquot_master_id` INT( 11 ) NULL DEFAULT NULL;
ALTER TABLE `ad_tissue_cores_revs` CHANGE `ad_block_id` `block_aliquot_master_id` INT( 11 ) NULL DEFAULT NULL;
 
ALTER TABLE `ad_cell_cores` CHANGE `ad_gel_matrix_id` `gel_matrix_aliquot_master_id` INT( 11 ) NULL DEFAULT NULL; 
ALTER TABLE `ad_cell_cores_revs` CHANGE `ad_gel_matrix_id` `gel_matrix_aliquot_master_id` INT( 11 ) NULL DEFAULT NULL ;

DELETE FROM `structure_formats`
WHERE `structure_old_id` = 'CAN-999-999-000-999-1001';	

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1001_CAN-999-999-000-999-1000', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1001'), 'CAN-999-999-000-999-1001', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1001_CAN-999-999-000-999-1223', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1001'), 'CAN-999-999-000-999-1001', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1001_CAN-999-999-000-999-1003', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1001'), 'CAN-999-999-000-999-1001', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1003'), 'CAN-999-999-000-999-1003', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1001_CAN-999-999-000-999-1004', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1001'), 'CAN-999-999-000-999-1001', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1004'), 'CAN-999-999-000-999-1004', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1001_CAN-999-999-000-999-1005', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1001'), 'CAN-999-999-000-999-1001', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1005'), 'CAN-999-999-000-999-1005', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1001_CAN-999-999-000-999-1006', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1001'), 'CAN-999-999-000-999-1001', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1006'), 'CAN-999-999-000-999-1006', 0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1001_CAN-999-999-000-999-1007', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1001'), 'CAN-999-999-000-999-1001', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1007'), 'CAN-999-999-000-999-1007', 0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1001_CAN-999-999-000-999-1008', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1001'), 'CAN-999-999-000-999-1001', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1008'), 'CAN-999-999-000-999-1008', 0, 13, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1001_CAN-999-999-000-999-1009', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1001'), 'CAN-999-999-000-999-1001', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1009'), 'CAN-999-999-000-999-1009', 0, 7, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'CAN-999-999-000-999-1001_CAN-999-999-000-999-1013', (SELECT `id` FROM `structures` WHERE `old_id` = 'CAN-999-999-000-999-1001'), 'CAN-999-999-000-999-1001', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1013'), 'CAN-999-999-000-999-1013', 0, 12, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');







