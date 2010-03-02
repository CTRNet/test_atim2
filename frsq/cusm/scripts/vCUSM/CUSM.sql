-- -------------------------------------------------------------------
--
-- SCRIPT to customize ATiM for CUSM Bank
--
-- -------------------------------------------------------------------

UPDATE `configs` SET `config_debug` = '2' WHERE `configs`.`id` =1 ;

DELETE FROM `structure_formats` WHERE `structure_old_id` LIKE 'QC-FRSQ-CUSM-%' OR `structure_field_old_id` LIKE 'QC-FRSQ-CUSM-%';

DELETE FROM `structure_validations` WHERE `old_id` LIKE 'QC-FRSQ-CUSM-%';

DELETE FROM `structures` WHERE `old_id` LIKE 'QC-FRSQ-CUSM-%';
DELETE FROM `structure_fields` WHERE `old_id` LIKE 'QC-FRSQ-CUSM-%';

-- General

DELETE FROM `i18n` WHERE `id` IN ('core_appname', 'CTRApp');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('core_appname', 'global', 'ATiM.v2 - MUHC', 'ATiM.v2 - CUSM'),
('CTRApp', 'global', 'ATiM.v2 - MUHC', 'ATiM.v2 - CUSM');

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- CLINICAL ANNOTATION
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- ******** PROFILE ********

-- ... PROFILE ...

-- Participant identifer : Read only & Label changed to 'Participant Code'
UPDATE `structure_formats`
SET `flag_add` = '0',
`flag_add_readonly` = '0',
`flag_edit_readonly` = '1',
`flag_datagrid_readonly` = '1',
`flag_override_label` = '1',
`language_label` = 'participant code'
WHERE `old_id` = 'CAN-999-999-000-999-1_CAN-999-999-000-999-26';

DELETE FROM `i18n` WHERE `id` IN ('participant code');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('participant code', 'global', 'Code', 'Code');

-- Participant title + middle name : Hidden
UPDATE `structure_formats`
SET `flag_add` = '0',
`flag_add_readonly` = '0',
`flag_edit` = '0',
`flag_edit_readonly` = '0',
`flag_search` = '0',
`flag_search_readonly` = '0',
`flag_edit_readonly` = '0',
`flag_datagrid` = '0',
`flag_datagrid_readonly` = '0',
`flag_index` = '0',
`flag_detail` = '0'
WHERE `old_id` IN ('CAN-999-999-000-999-1_CAN-999-999-000-999-295', 'CAN-999-999-000-999-1_CAN-999-999-000-999-4');

-- Participant first name / last name : Required & Add tags
UPDATE `structure_formats`
SET 
`flag_override_label` = '1',
`language_label` = 'name',
`flag_override_tag` = '1',
`language_tag` = 'first name'
WHERE `old_id` = 'CAN-999-999-000-999-1_CAN-999-999-000-999-1';	

DELETE FROM `structure_validations` WHERE `old_id` = 'QC-FRSQ-CUSM-000001';
INSERT INTO `structure_validations` 
(`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-FRSQ-CUSM-000001', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1'), 'CAN-999-999-000-999-1', 'notEmpty', '0', '0', '', 'first name and last name are required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structure_formats`
SET 
`flag_override_label` = '0',
`language_label` = '',
`flag_override_tag` = '1',
`language_tag` = 'last name'
WHERE `old_id` = 'CAN-999-999-000-999-1_CAN-999-999-000-999-2';	
 
DELETE FROM `structure_validations` WHERE `old_id` = 'QC-FRSQ-CUSM-000002';
INSERT INTO `structure_validations` 
(`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-FRSQ-CUSM-000002', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-2'), 'CAN-999-999-000-999-2', 'notEmpty', '0', '0', '', 'first name and last name are required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
	
DELETE FROM `i18n` WHERE `id` IN ('first name and last name are required');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('first name and last name are required', 'global', 'First name and last name are required!', 'Le nom et pr&eacute;nom sont requis!');

-- ... CONSENT ...

-- TODO

-- ... DIAGNOSTIC ...

-- TODO

-- ******** ANNOTATION ******** 

-- TODO

-- ******** TREATMENT ******** 

-- TODO

-- ... IDENTIFICATION ...

DELETE FROM `misc_identifier_controls`;
INSERT INTO `misc_identifier_controls` 
(`id`, `misc_identifier_name`, `misc_identifier_name_abbrev`, `status`, `display_order`, `autoincrement_name`, `misc_identifier_format`) 
VALUES
(null, 'health_insurance_card', 'RAMQ', 'active', 0, '', ''),
(null, 'montreal_general_hospital_card', 'MGH/HGM Id', 'active', 1, '', ''),
(null, 'prostate_bank_participant_id', 'PR-PartID', 'active', 3, 'prostate_bank_participant_id', '%%key_increment%%');

DELETE FROM `i18n` WHERE `id` IN ('health_insurance_card', 'montreal_general_hospital_card', 'prostate_bank_participant_id',
'this identifier has already been created for your participant');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES
('health_insurance_card', 'global', 'Health Insurance Card', 'Carte d''assurance maladie'),
('montreal_general_hospital_card', 'global', 'Montreal General Hospital card', 'carte H&ocirc;pital G&eacute;n&eacute;ral de Montr&eacute;al'),
('prostate_bank_participant_id', 'global', 'Prostate Bank Participant Id', 'Num&eacute;ro participant banque Prostate'),
('this identifier has already been created for your participant', '', 'This identifier has already been created for your participant!', 'Cet identification a d&eacute;j&agrave; &eacute;t&eacute; cr&eacute;&eacute;e pour ce participant!');

DELETE FROM `key_increments`;
INSERT INTO `key_increments` (`key_name`, `key_value`) VALUES
('prostate_bank_participant_id', 200);

-- ******** REP. HISTORY ******** 

-- TODO

-- ******** FAM. HISTORY ******** 

-- TODO

-- ******** CONTACT ******** 

-- TODO

-- ******** MESSAGE ******** 

-- TODO

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- INVENTORY MANAGEMENT
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- ******** COLLECTION ******** 

-- Bank : Prostate and required
UPDATE collections set bank_id = null;
DELETE FROM banks;

INSERT INTO `banks` (`id`, `name`, `description`, `created_by`, `created`, `modified_by`, `modified`, `deleted`, `deleted_date`) 
VALUES 
(NULL, 'Prostate', '', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '0', NULL);

DELETE FROM `structure_validations` WHERE `old_id` = 'QC-FRSQ-CUSM-000003';
INSERT INTO `structure_validations` 
(`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-FRSQ-CUSM-000003', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 'notEmpty', '0', '0', '', 'bank is required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
	
DELETE FROM `i18n` WHERE `id` IN ('bank is required');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('bank is required', 'global', 'Bank is required!', 'La banque est requise!');

-- SOP : Hidden

UPDATE `structure_formats`
SET `flag_add` = '0',
`flag_add_readonly` = '0',
`flag_edit` = '0',
`flag_edit_readonly` = '0',
`flag_search` = '0',
`flag_search_readonly` = '0',
`flag_edit_readonly` = '0',
`flag_datagrid` = '0',
`flag_datagrid_readonly` = '0',
`flag_index` = '0',
`flag_detail` = '0'
WHERE `old_id` IN (
'CAN-999-999-000-999-1000_CAN-999-999-000-999-1007',	-- collections
'CANM-00025_CAN-999-999-000-999-1007-v',				-- view_collection
'CAN-999-999-000-999-1001_CAN-999-999-000-999-1007');	-- linked_collections

-- Collection site value

DELETE FROM `structure_permissible_values` WHERE `value` = 'muhc' AND `language_alias` = 'muhc';
INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'muhc', 'muhc');

DELETE FROM `structure_value_domains_permissible_values` WHERE  `structure_value_domain_id` IN (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` LIKE 'custom_collection_site');
INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` LIKE 'custom_collection_site'), (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'muhc' AND `language_alias` = 'muhc'), '1', 'yes', 'muhc'),
(NULL , (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` LIKE 'custom_collection_site'), (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'other' AND `language_alias` = 'other'), '2', 'yes', 'other');

DELETE FROM `i18n` WHERE `id` IN ('muhc');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('muhc', 'global', 'MUHC', 'CUSM');

-- Prostate Bank Identifier

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-FRSQ-CUSM-000001', 'Inventorymanagement', 'ViewCollection', '', 'prostate_bank_participant_id', 'prostate_bank_participant_id', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CANM-00025_QC-FRSQ-CUSM-000001', (SELECT id FROM structures WHERE old_id = 'CANM-00025'), 'CANM-00025', (SELECT id FROM structure_fields WHERE old_id = 'QC-FRSQ-CUSM-000001'), 'QC-FRSQ-CUSM-000001', 0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DROP VIEW IF EXISTS view_collections;
CREATE VIEW view_collections AS 
SELECT 
collection_id, 
bank_id, 
sop_master_id, 
ccl.participant_id AS participant_id, 
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
sops.type,

idents.identifier_value AS prostate_bank_participant_id	

FROM collections
LEFT JOIN clinical_collection_links AS ccl ON collections.id=ccl.collection_id AND ccl.deleted != 1
LEFT JOIN participants ON ccl.participant_id=participants.id AND participants.deleted != 1
LEFT JOIN banks ON collections.bank_id=banks.id AND banks.deleted != 1
LEFT JOIN sop_masters AS sops ON collections.sop_master_id=sops.id AND sops.deleted != 1
LEFT JOIN misc_identifiers AS idents ON idents.participant_id=ccl.participant_id AND idents.deleted != 1 AND idents.identifier_name = 'prostate_bank_participant_id';











-- ******** ANNOTATION ******** 

DROP TABLE IF EXISTS `qc_chum_hb_ed_hepatobiliary_clinical_presentation`;
DROP TABLE IF EXISTS `qc_chum_hb_ed_hepatobiliary_lifestyle`;
DROP TABLE IF EXISTS `qc_chum_hb_ed_hepatobiliary_medical_past_history`;
DROP TABLE IF EXISTS `qc_chum_hb_ed_hepatobiliary_med_hist_record_summary`;

DROP TABLE IF EXISTS `qc_chum_hb_hepatobiliary_medical_past_history_ctrls`;

DELETE FROM `event_masters`;
DELETE FROM `event_controls` ;

-- ... SCREENING ...

UPDATE `menus` SET `active` = 'no' WHERE `menus`.`id` = 'clin_CAN_27' ;

-- ... STUDY ...

UPDATE `menus` SET `active` =  'no' WHERE `menus`.`id` = 'clin_CAN_33' ;

-- ... CLINIC: presentation ...

DELETE FROM `menus` WHERE `id` IN ('clin_QC_CHUM_HB_31', 'clin_QC_CHUM_HB_32', 'clin_QC_CHUM_HB_33');
INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_params`, `use_summary`, `active`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('clin_QC_CHUM_HB_31', 'clin_CAN_31', 0, 1, 'annotation clinical details', 'annotation clinical details', '/clinicalannotation/event_masters/listall/clinical/%%Participant.id%%//', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_QC_CHUM_HB_33', 'clin_CAN_31', 0, 2, 'annotation clinical reports', 'annotation clinical reports', '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(null, 'hepatobiliary', 'clinical', 'presentation', 'active', 'qc_chum_hb_ed_hepatobiliary_clinical_presentation', 'qc_chum_hb_ed_hepatobiliary_clinical_presentation', 0);

DROP TABLE IF EXISTS `qc_chum_hb_ed_hepatobiliary_clinical_presentation`;
CREATE TABLE `qc_chum_hb_ed_hepatobiliary_clinical_presentation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `weight` decimal(7,3) DEFAULT NULL,
  `height` decimal(7,3) DEFAULT NULL,
  `bmi` decimal(10,3) DEFAULT NULL,
  `referral_hospital` varchar(50) DEFAULT NULL, 
  `referral_physisian` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality` varchar(50) DEFAULT NULL,
  `referral_physisian_2` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality_2` varchar(50) DEFAULT NULL,
  `referral_physisian_3` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality_3` varchar(50) DEFAULT NULL,
  `hbp_surgeon` varchar(50) DEFAULT NULL,
  `created` date DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `modified` date DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_chum_hb_ed_hepatobiliary_clinical_presentation`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

DROP TABLE IF EXISTS `qc_chum_hb_ed_hepatobiliary_clinical_presentation_revs`;
CREATE TABLE `qc_chum_hb_ed_hepatobiliary_clinical_presentation_revs` (
  `id` int(11) NOT NULL,
  `weight` decimal(7,3) DEFAULT NULL,
  `height` decimal(7,3) DEFAULT NULL,
  `bmi` decimal(10,3) DEFAULT NULL,
  `referral_hospital` varchar(50) DEFAULT NULL, 
  `referral_physisian` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality` varchar(50) DEFAULT NULL,
  `referral_physisian_2` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality_2` varchar(50) DEFAULT NULL,
  `referral_physisian_3` varchar(50) DEFAULT NULL,
  `referral_physisian_speciality_3` varchar(50) DEFAULT NULL,
  `hbp_surgeon` varchar(50) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DELETE FROM `structure_validations` WHERE `old_id` LIKE ('QC_CHUM_HB_%');	
DELETE FROM `structure_formats` WHERE `old_id` LIKE ('QC_CHUM_HB_%');	
DELETE FROM `structures` WHERE `old_id` LIKE ('QC_CHUM_HB%');
DELETE FROM `structure_fields` WHERE `old_id` LIKE ('QC_CHUM_HB_%');	

INSERT INTO `structures` 
(`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC_CHUM_HB_000001', 'qc_chum_hb_ed_hepatobiliary_clinical_presentation', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC_CHUM_HB_000001', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_clinical_presentation', 'bmi', 'bmi', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_000002', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_clinical_presentation', 'referral_hospital', 'referral hospital', '', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_000003', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian', 'referral physisian', '', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_000004', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_speciality', '', 'referral physisian speciality', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_000005', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_2', 'referral physisian 2', '', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_000006', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_speciality_2', '', 'referral physisian speciality', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_000007', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_3', 'referral physisian 3', '', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_000008', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_clinical_presentation', 'referral_physisian_speciality_3', '', 'referral physisian speciality', 'input', 'size=20', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_000009', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_clinical_presentation', 'hbp_surgeon', 'hbp surgeron', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- first_consultation_date
(null, 'QC_CHUM_HB_000001_CAN-999-999-000-999-229', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000001'), 'QC_CHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-229'), 'CAN-999-999-000-999-229', 0, 1, '', '1', 'first consultation date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, 'QC_CHUM_HB_000001_CAN-999-999-000-999-227', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000001'), 'QC_CHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-227'), 'CAN-999-999-000-999-227', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, 'QC_CHUM_HB_000001_CAN-999-999-000-999-228', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000001'), 'QC_CHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-228'), 'CAN-999-999-000-999-228', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- hbp_surgeon
(null, 'QC_CHUM_HB_000001_QC_CHUM_HB_000009', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000001'), 'QC_CHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_000009'), 'QC_CHUM_HB_000009', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- weight
(null, 'QC_CHUM_HB_000001_CAN-999-999-000-999-235', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000001'), 'QC_CHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-235'), 'CAN-999-999-000-999-235', 0, 10, '', '1', 'weight (kg)', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- height
(null, 'QC_CHUM_HB_000001_CAN-999-999-000-999-236', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000001'), 'QC_CHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-236'), 'CAN-999-999-000-999-236', 0, 11, '', '1', 'height (cm)', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- bmi
(null, 'QC_CHUM_HB_000001_QC_CHUM_HB_000001', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000001'), 'QC_CHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_000001'), 'QC_CHUM_HB_000001', 0, 12, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- event_summary
(null, 'QC_CHUM_HB_000001_CAN-999-999-000-999-230', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000001'), 'QC_CHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-230'), 'CAN-999-999-000-999-230', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- referral_hospital
(null, 'QC_CHUM_HB_000001_QC_CHUM_HB_000002', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000001'), 'QC_CHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_000002'), 'QC_CHUM_HB_000002', 1, 30, 'referral data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian 
(null, 'QC_CHUM_HB_000001_QC_CHUM_HB_000003', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000001'), 'QC_CHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_000003'), 'QC_CHUM_HB_000003', 1, 31, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian_speciality
(null, 'QC_CHUM_HB_000001_QC_CHUM_HB_000004', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000001'), 'QC_CHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_000004'), 'QC_CHUM_HB_000004', 1, 32, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian 2
(null, 'QC_CHUM_HB_000001_QC_CHUM_HB_000005', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000001'), 'QC_CHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_000005'), 'QC_CHUM_HB_000005', 1, 33, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian_speciality 2
(null, 'QC_CHUM_HB_000001_QC_CHUM_HB_000006', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000001'), 'QC_CHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_000006'), 'QC_CHUM_HB_000006', 1, 34, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian 3 
(null, 'QC_CHUM_HB_000001_QC_CHUM_HB_000007', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000001'), 'QC_CHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_000007'), 'QC_CHUM_HB_000007', 1, 35, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- referral_physisian_speciality 3
(null, 'QC_CHUM_HB_000001_QC_CHUM_HB_000008', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000001'), 'QC_CHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_000008'), 'QC_CHUM_HB_000008', 1, 36, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
  
INSERT INTO `structure_validations` (`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'QC_CHUM_HB_000001', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-235'), 'CAN-999-999-000-999-235', 'custom,/^([0-9]+(\\.[0-9]+)?)?$/', '1', '0', '', 'weight should be a positif decimal', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, 'QC_CHUM_HB_000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-236'), 'CAN-999-999-000-999-236', 'custom,/^([0-9]+(\\.[0-9]+)?)?$/', '1', '0', '', 'height should be a positif decimal', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('first consultation date', 'referral data', 'referral hospital', 
'referral physisian', 'referral physisian 2', 'referral physisian 3', 'referral physisian speciality', 
'weight (kg)', 'height (cm)', 'weight should be a positif decimal', 'height should be a positif decimal', 
'hepatobiliary');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('first consultation date', 'global', 'First Consultation Date', 'Date premi&egrave;re consultation'),
('referral data', 'global', 'Referral', 'R&eacute;f&eacute;rent'),
('referral hospital', 'global', 'Referral Hospital', 'H&ocirc;pital r&eacute;f&eacute;rent'),
('referral physisian', 'global', 'Referral Physisian', 'Medecin r&eacute;f&eacute;rent'),
('referral physisian 2', 'global', '2nd Referral Physisian', '2nd Medecin r&eacute;f&eacute;rent'),
('referral physisian 3', 'global', '3rd Referral Physisian', '3eme Medecin r&eacute;f&eacute;rent'),
('referral physisian speciality', 'global', 'Speciality', 'Sp&eacute;cialit&eacute;'),

('weight (kg)', 'global', 'Weight (kg)', 'Poids (kg)'),
('height (cm)', 'global', 'Height (cm)', 'Taille (cm)'),

('weight should be a positif decimal', 'global', 'Weight should be a positive decimal!', 'Le poids doit &ecirc;tre un d&eacute;cimal positif!'),
('height should be a positif decimal', 'global', 'Height should be a positive decimal!', 'Le taille doit &ecirc;tre un d&eacute;cimal positif!'),
('hepatobiliary', 'global', 'Hepatobiliary', 'H&eacute;pato-biliaire');

DELETE FROM `i18n` WHERE `id` = 'presentation';
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`)
 VALUES
('presentation', 'global', 'Presentation', 'Pr&eacute;sentation');

-- ... CLINIC: lifestyle ...

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(null, 'hepatobiliary', 'lifestyle', 'summary', 'active', 'qc_chum_hb_ed_hepatobiliary_lifestyle', 'qc_chum_hb_ed_hepatobiliary_lifestyle', 0);

DROP TABLE IF EXISTS `qc_chum_hb_ed_hepatobiliary_lifestyle`;
CREATE TABLE `qc_chum_hb_ed_hepatobiliary_lifestyle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `active_tobacco` varchar(10) DEFAULT NULL, 
  `active_alcohol` varchar(10) DEFAULT NULL, 
  `created` date DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `modified` date DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_chum_hb_ed_hepatobiliary_lifestyle`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
DROP TABLE IF EXISTS `qc_chum_hb_ed_hepatobiliary_lifestyle_revs`;
CREATE TABLE `qc_chum_hb_ed_hepatobiliary_lifestyle_revs` (
  `id` int(11) NOT NULL, 
  `active_tobacco` varchar(10) DEFAULT NULL, 
  `active_alcohol` varchar(10) DEFAULT NULL, 
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structures` 
(`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC_CHUM_HB_000002', 'qc_chum_hb_ed_hepatobiliary_lifestyle', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC_CHUM_HB_0000010', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_lifestyle', 'active_tobacco', 'active_tobacco', '', 'select', '', '', @last_domains_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_0000011', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_lifestyle', 'active_alcohol', 'active_alcohol', '', 'select', '', '', @last_domains_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, 'QC_CHUM_HB_000002_CAN-999-999-000-999-229', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000002'), 'QC_CHUM_HB_000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-229'), 'CAN-999-999-000-999-229', 0, 1, '', '1', 'last update date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, 'QC_CHUM_HB_000002_CAN-999-999-000-999-227', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000002'), 'QC_CHUM_HB_000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-227'), 'CAN-999-999-000-999-227', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, 'QC_CHUM_HB_000002_CAN-999-999-000-999-228', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000002'), 'QC_CHUM_HB_000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-228'), 'CAN-999-999-000-999-228', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- active_tobacco
(null, 'QC_CHUM_HB_000002_QC_CHUM_HB_0000010', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000002'), 'QC_CHUM_HB_000002', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_0000010'), 'QC_CHUM_HB_0000010', 0, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- active_alcohol
(null, 'QC_CHUM_HB_000002_QC_CHUM_HB_0000011', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000002'), 'QC_CHUM_HB_000002', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_0000011'), 'QC_CHUM_HB_0000011', 0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_summary
(null, 'QC_CHUM_HB_000002_CAN-999-999-000-999-230', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000002'), 'QC_CHUM_HB_000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-230'), 'CAN-999-999-000-999-230', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('active_tobacco', 'active_alcohol', 'last update date', 'this type of event has already been created for your participant');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('active_tobacco', 'global', 'Active Tobacco', 'Tabagisme actif'),
('active_alcohol', 'global', 'Active Alcohol', 'Alcolisme chronique'),
('last update date', 'global', 'Last Update date', 'Date de mise &agrave; jour'),

('this type of event has already been created for your participant', '', 
  'This type of annotation has already been created for your participant!', 
  'Ce type d''annotation a d&eacute;j&agrave; eacyte;t&eacute; cr&eacute;&eacute;e pour votre participant!');

-- ... CLINIC: medical_past_history ...

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) 
VALUES
(null, 'hepatobiliary', 'clinical', 'asa medical past history', 'active', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'heart disease medical past history', 'active', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'vascular disease medical past history', 'active', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'respiratory disease medical past history', 'active', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'neural vascular disease medical past history', 'active', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'endocrine disease medical past history', 'active', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'urinary disease medical past history', 'active', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'gastro-intestinal disease medical past history', 'active', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'gynecologic disease medical past history', 'active', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 0),
(null, 'hepatobiliary', 'clinical', 'other disease medical past history', 'active', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 0);

DROP TABLE IF EXISTS `qc_chum_hb_hepatobiliary_medical_past_history_ctrls`;
CREATE TABLE `qc_chum_hb_hepatobiliary_medical_past_history_ctrls` (
  `id` int(11) NOT NULL AUTO_INCREMENT, 
  `event_control_id` int(11) NOT NULL, 
  `disease_precision` varchar(250) NOT NULL,
  `display_order` int(2)default '0',  
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_chum_hb_hepatobiliary_medical_past_history_ctrls`
  ADD FOREIGN KEY (`event_control_id`) REFERENCES `event_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
-- TODO Section to delete (for example)
INSERT INTO `qc_chum_hb_hepatobiliary_medical_past_history_ctrls` 
(`id`, `event_control_id`, `disease_precision`, `display_order`)
VALUES 
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'drug ex 1', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'drug ex 2', '2'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'drug ex 3', '3'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'drug ex 4', '4'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'asa medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'other', '5'),

(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'heart disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'high blood pressure', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'heart disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'tachycardia', '2'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'heart disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'heart attack', '3'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'heart disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'other', '4'),

(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'vascular disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'respiratory disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'neural vascular disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'endocrine disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'urinary disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'gastro-intestinal disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'gynecologic disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define', '1'),
(null, (SELECT `id` FROM `event_controls` WHERE `event_type` = 'other disease medical past history' AND `disease_site` = 'hepatobiliary' AND `event_group` = 'clinical'), 'to define', '1');

-- TODO to delete (for example)
DELETE FROM `i18n` WHERE `id` LIKE 'drug ex %';
DELETE FROM `i18n` WHERE `id`IN ('to define','high blood pressure', 'tachycardia', 'heart attack');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('drug ex 1', '', 'Drug 1', 'Mdt 1'),
('drug ex 2', '', 'Drug 2', 'Mdt 2'),
('drug ex 3', '', 'Drug 3', 'Mdt 3'),
('drug ex 4', '', 'Drug 4', 'Mdt 4'),
('drug ex 5', '', 'Drug 5', 'Mdt 5'),

('to define', '', 'To Define', 'A definir'),
('high blood pressure', '', 'High blood pressure', 'HTA'),
('tachycardia', '', 'Tachycardia', 'Tachycardie'),
('heart attack', '', 'Heart attack', 'Crise cardiaque');

-- TODO End section to delete

INSERT INTO `structures` 
(`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC_CHUM_HB_000004', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DROP TABLE IF EXISTS `qc_chum_hb_ed_hepatobiliary_medical_past_history`;
CREATE TABLE `qc_chum_hb_ed_hepatobiliary_medical_past_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `disease_precision` varchar(250) DEFAULT NULL, 
  `created` date DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `modified` date DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_chum_hb_ed_hepatobiliary_medical_past_history`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

DROP TABLE IF EXISTS `qc_chum_hb_ed_hepatobiliary_medical_past_history_revs`;
CREATE TABLE `qc_chum_hb_ed_hepatobiliary_medical_past_history_revs` (
  `id` int(11) NOT NULL, 
  `disease_precision` varchar(250) DEFAULT NULL, 
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC_CHUM_HB_0000022', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_medical_past_history', 'disease_precision', 'medical history precision', '', 'select', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `structure_formats` WHERE `old_id` LIKE 'QC_CHUM_HB_000004_%';
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, 'QC_CHUM_HB_000004_CAN-999-999-000-999-229', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000004'), 'QC_CHUM_HB_000004', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-229'), 'CAN-999-999-000-999-229', 0, 1, '', '1', 'diagnostic date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, 'QC_CHUM_HB_000004_CAN-999-999-000-999-227', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000004'), 'QC_CHUM_HB_000004', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-227'), 'CAN-999-999-000-999-227', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, 'QC_CHUM_HB_000004_CAN-999-999-000-999-228', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000004'), 'QC_CHUM_HB_000004', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-228'), 'CAN-999-999-000-999-228', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- precision
(null, 'QC_CHUM_HB_000004_QC_CHUM_HB_0000022', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000004'), 'QC_CHUM_HB_000004', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_0000022'), 'QC_CHUM_HB_0000022', 0, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- event_summary
(null, 'QC_CHUM_HB_000004_CAN-999-999-000-999-230', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000004'), 'QC_CHUM_HB_000004', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-230'), 'CAN-999-999-000-999-230', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id`IN (
'asa medical past history',
'heart disease medical past history',
'vascular disease medical past history',
'respiratory disease medical past history',
'neural vascular disease medical past history',
'endocrine disease medical past history',
'urinary disease medical past history',
'gastro-intestinal disease medical past history',
'gynecologic disease medical past history',
'other disease medical past history',

'diagnostic date', 
'medical history precision',

'detail exists for the deleted medical past history');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('asa medical past history', '', 'ASA', ''),
('heart disease medical past history', '', 'Heart Disease', 'Maladie du coeur'),
('vascular disease medical past history', '', 'Vascular Disease', 'Maladie vasculaire'),
('respiratory disease medical past history', '', 'Respiratory Disease', 'Maladie respiratoire'),
('neural vascular disease medical past history', '', 'Neural Vascular Disease', 'Maladie vasculaire cerebrale'),
('endocrine disease medical past history', '', 'Endocrine Disease', 'Maladie endocrine'),
('urinary disease medical past history', '', 'Urinary Disease', 'Maladie urinaire'),
('gastro-intestinal disease medical past history', '', 'Gastro-Intestinal Disease', 'Maladie gastro-intestinal'),
('gynecologic disease medical past history', '', 'Gynecologic Disease', 'Maladie gynecologique'),
('other disease medical past history', '', 'Other Disease', 'Autre maladie'),

('diagnostic date', '', 'Diagnostic Date', 'Date de diagnostic'),
('medical history precision', '', 'Precision', 'Pr&eacute;cision'),

('detail exists for the deleted medical past history', '', 
'Your data cannot be deleted! <br>Detail exist for the deleted medical past history.', 
'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des d&eacute;tails existent pour votre historique clinique.');

DELETE FROM `i18n` WHERE `id`IN ('annotation clinical details', 'add other clinical event', 'add medical history', 'add medical imaging');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('annotation clinical details', '', 'Details', 'D&eacute;tails'),
('add other clinical event', '', 'Add Other Data', 'Ajouter autres données'),
('add medical history', '', 'Add Medical History', 'Ajouter &eacute;venement clinique'),
('add medical imaging', '', 'Add Medical Imaging', 'Ajouter image m&eacute;dicale');

-- ... CLINIC: medical_past_history revision control...

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) 
VALUES
(null, 'hepatobiliary', 'clinical', 'medical past history record summary', 'active', 'qc_chum_hb_ed_hepatobiliary_med_hist_record_summary', 'qc_chum_hb_ed_hepatobiliary_med_hist_record_summary', 0);

INSERT INTO `structures` 
(`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC_CHUM_HB_000003', 'qc_chum_hb_ed_hepatobiliary_med_hist_record_summary', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DROP TABLE IF EXISTS `qc_chum_hb_ed_hepatobiliary_med_hist_record_summary`;
CREATE TABLE `qc_chum_hb_ed_hepatobiliary_med_hist_record_summary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asa_value` varchar(10) DEFAULT NULL, 
  `heart_disease` varchar(10) DEFAULT NULL, 
  `respiratory_disease` varchar(10) DEFAULT NULL, 
  `vascular_disease` varchar(10) DEFAULT NULL, 
  `neural_vascular_disease` varchar(10) DEFAULT NULL, 
  `endocrine_disease` varchar(10) DEFAULT NULL, 
  `urinary_disease` varchar(10) DEFAULT NULL, 
  `gastro_intestinal_disease` varchar(10) DEFAULT NULL, 
  `gynecologic_disease` varchar(10) DEFAULT NULL, 
  `other_disease` varchar(10) DEFAULT NULL, 
  `created` date DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `modified` date DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_chum_hb_ed_hepatobiliary_med_hist_record_summary`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

DROP TABLE IF EXISTS `qc_chum_hb_ed_hepatobiliary_med_hist_record_summary_revs`;
CREATE TABLE `qc_chum_hb_ed_hepatobiliary_med_hist_record_summary_revs` (
  `id` int(11) NOT NULL, 
  `asa_value` varchar(10) DEFAULT NULL, 
  `heart_disease` varchar(10) DEFAULT NULL, 
  `respiratory_disease` varchar(10) DEFAULT NULL, 
  `vascular_disease` varchar(10) DEFAULT NULL, 
  `neural_vascular_disease` varchar(10) DEFAULT NULL, 
  `endocrine_disease` varchar(10) DEFAULT NULL, 
  `urinary_disease` varchar(10) DEFAULT NULL, 
  `gastro_intestinal_disease` varchar(10) DEFAULT NULL, 
  `gynecologic_disease` varchar(10) DEFAULT NULL, 
  `other_disease` varchar(10) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC_CHUM_HB_0000012', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_med_hist_record_summary', 'asa_value', 'asa medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_0000013', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_med_hist_record_summary', 'heart_disease', 'heart disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_0000014', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_med_hist_record_summary', 'respiratory_disease', 'respiratory disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_0000015', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_med_hist_record_summary', 'vascular_disease', 'vascular disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_0000016', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_med_hist_record_summary', 'neural_vascular_disease', 'neural vascular disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_0000017', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_med_hist_record_summary', 'endocrine_disease', 'endocrine disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_0000018', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_med_hist_record_summary', 'urinary_disease', 'urinary disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_0000019', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_med_hist_record_summary', 'gastro_intestinal_disease', 'gastro-intestinal disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_0000020', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_med_hist_record_summary', 'gynecologic_disease', 'gynecologic disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC_CHUM_HB_0000021', 'Clinicalannotation', 'EventDetail', 'qc_chum_hb_ed_hepatobiliary_med_hist_record_summary', 'other_disease', 'other disease medical past history', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 
INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- date
(null, 'QC_CHUM_HB_000003_CAN-999-999-000-999-229', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000003'), 'QC_CHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-229'), 'CAN-999-999-000-999-229', 0, 1, '', '1', 'last update date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- disease_site
(null, 'QC_CHUM_HB_000003_CAN-999-999-000-999-227', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000003'), 'QC_CHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-227'), 'CAN-999-999-000-999-227', 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, 'QC_CHUM_HB_000003_CAN-999-999-000-999-228', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000003'), 'QC_CHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-228'), 'CAN-999-999-000-999-228', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
	
-- 
(null, 'QC_CHUM_HB_000003_QC_CHUM_HB_0000012', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000003'), 'QC_CHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_0000012'), 'QC_CHUM_HB_0000012', 1, 40, 'reviewed diseases', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CHUM_HB_000003_QC_CHUM_HB_0000013', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000003'), 'QC_CHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_0000013'), 'QC_CHUM_HB_0000013', 1, 41, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CHUM_HB_000003_QC_CHUM_HB_0000014', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000003'), 'QC_CHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_0000014'), 'QC_CHUM_HB_0000014', 1, 42, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CHUM_HB_000003_QC_CHUM_HB_0000015', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000003'), 'QC_CHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_0000015'), 'QC_CHUM_HB_0000015', 1, 43, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CHUM_HB_000003_QC_CHUM_HB_0000016', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000003'), 'QC_CHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_0000016'), 'QC_CHUM_HB_0000016', 1, 44, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CHUM_HB_000003_QC_CHUM_HB_0000017', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000003'), 'QC_CHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_0000017'), 'QC_CHUM_HB_0000017', 1, 45, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CHUM_HB_000003_QC_CHUM_HB_0000018', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000003'), 'QC_CHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_0000018'), 'QC_CHUM_HB_0000018', 1, 46, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CHUM_HB_000003_QC_CHUM_HB_0000019', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000003'), 'QC_CHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_0000019'), 'QC_CHUM_HB_0000019', 1, 47, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CHUM_HB_000003_QC_CHUM_HB_0000020', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000003'), 'QC_CHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_0000020'), 'QC_CHUM_HB_0000020', 1, 48, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- 
(null, 'QC_CHUM_HB_000003_QC_CHUM_HB_0000021', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000003'), 'QC_CHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'QC_CHUM_HB_0000021'), 'QC_CHUM_HB_0000021', 1, 49, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- event_summary
(null, 'QC_CHUM_HB_000003_CAN-999-999-000-999-230', (SELECT id FROM structures WHERE old_id = 'QC_CHUM_HB_000003'), 'QC_CHUM_HB_000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-230'), 'CAN-999-999-000-999-230', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id`IN ('reviewed diseases', 'medical past history record summary');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('reviewed diseases', '', 'Reviewed Diseases/Events', 'Pathologies/&Eacute;venements r&eacute;visionn&eacute;s'),
('medical past history record summary', '', 'Medcial Review Summary', 'R&eacute;sum&eacute; des r&eacute;visions m&eacute;dicales');
