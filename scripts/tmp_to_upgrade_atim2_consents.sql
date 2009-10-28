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