-- -------------------------------------------------------------------
--
-- SCRIPT to customize ATiM for CUSM Bank
--
-- -------------------------------------------------------------------

UPDATE `configs` SET `config_debug` = '2' WHERE `configs`.`id` =1 ;

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

INSERT INTO `structure_validations` 
(`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-CUSM-000001', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1'), 'CAN-999-999-000-999-1', 'notEmpty', '0', '0', '', 'first name and last name are required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structure_formats`
SET 
`flag_override_label` = '0',
`language_label` = '',
`flag_override_tag` = '1',
`language_tag` = 'last name'
WHERE `old_id` = 'CAN-999-999-000-999-1_CAN-999-999-000-999-2'; 
 
INSERT INTO `structure_validations` 
(`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-CUSM-000002', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-2'), 'CAN-999-999-000-999-2', 'notEmpty', '0', '0', '', 'first name and last name are required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 
DELETE FROM `i18n` WHERE `id` IN ('first name and last name are required');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('first name and last name are required', 'global', 'First name and last name are required!', 'Le nom et pr&eacute;nom sont requis!');

-- Participant race : Hidden
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
WHERE `old_id` IN ('CAN-999-999-000-999-1_CAN-999-999-000-999-7');

-- ... CONSENT ...

CREATE TABLE IF NOT EXISTS `qc_cusm_cd_undetailled` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consent_master_id` int(11) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `consent_master_id` (`consent_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DELETE FROM `consent_controls`;
INSERT INTO `consent_controls` 
(`id`, `controls_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(null, 'cusm prostate bank consent', 'active', 'qc_cusm_prostate_bank_consents', 'qc_cusm_cd_undetailled', 0);

INSERT INTO `structures` 
(`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-CUSM-000001', 'qc_cusm_prostate_bank_consents', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('cusm prostate bank consent');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('cusm prostate bank consent', 'global', 'CONSENT FORM Alliance ProCURE', 'CONSENTEMENT Alliance ProCURE');

SET @consent_structure_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- ConsentMaster.form_version
(null, 'QC-CUSM-000001_CAN-999-999-000-999-53', @consent_structure_id, 'QC-CUSM-000001', 
(SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-53'), 'CAN-999-999-000-999-53', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- ConsentMaster.consent_status
(null, 'QC-CUSM-000001_CAN-999-999-000-999-57', @consent_structure_id, 'QC-CUSM-000001', 
(SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-57'), 'CAN-999-999-000-999-57', 
0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- ConsentMaster.status_date
(null, 'QC-CUSM-000001_CAN-046-003-000-999-1', @consent_structure_id, 'QC-CUSM-000001', 
(SELECT id FROM structure_fields WHERE old_id = 'CAN-046-003-000-999-1'), 'CAN-046-003-000-999-1', 
0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- ConsentMaster.consent_signed_da...
(null, 'QC-CUSM-000001_CAN-999-999-000-999-61', @consent_structure_id, 'QC-CUSM-000001', 
(SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-61'), 'CAN-999-999-000-999-61', 
0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- ConsentMaster.reason_denied
(null, 'QC-CUSM-000001_CAN-999-999-000-999-56', @consent_structure_id, 'QC-CUSM-000001', 
(SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-56'), 'CAN-999-999-000-999-56', 
1, 10, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- ConsentMaster.notes
(null, 'QC-CUSM-000001_CAN-999-999-000-999-65', @consent_structure_id, 'QC-CUSM-000001', 
(SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-65'), 'CAN-999-999-000-999-65', 
1, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'v2006-02-01', 'v2006-02-01'),
(NULL, 'v2006-01-26', 'v2006-01-26');

DELETE FROM `i18n` WHERE `id` IN ('v2006-02-01', 'v2006-01-26');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('v2006-02-01', 'global', 'v2006-02-01', 'v2006-02-01'),
('v2006-01-26', 'global', 'v2006-01-26', 'v2006-01-26');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`) VALUES
(null, 'qc_cusm_consent_version', 'open', '');

SET @domain_id = LAST_INSERT_ID();

INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'v2006-02-01'), '20', 'yes', 'v2006-02-01'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'v2006-01-26'), '30', 'yes', 'v2006-01-26');

DELETE FROM `i18n` WHERE `id` IN ('muhc');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('muhc', 'global', 'MUHC', 'CUSM');

UPDATE `structure_fields`
SET `type` = 'select',
`setting` = '',
`structure_value_domain` = @domain_id
WHERE `old_id` = 'CAN-999-999-000-999-53';

-- ... DIAGNOSTIC ...

-- TODO
UPDATE `menus` SET `active` = 'no' WHERE `id` = 'clin_CAN_5'; -- diagnosis

-- ******** ANNOTATION ******** 

-- TODO
UPDATE `menus` SET `active` = 'no' WHERE `id` = 'clin_CAN_4'; -- annotation

-- ******** TREATMENT ******** 

-- TODO
UPDATE `menus` SET `active` = 'no' WHERE `id` = 'clin_CAN_75'; -- treatment

-- ... IDENTIFICATION ...

DELETE FROM `misc_identifier_controls`;
INSERT INTO `misc_identifier_controls` 
(`id`, `misc_identifier_name`, `misc_identifier_name_abbrev`, `status`, `display_order`, `autoincrement_name`, `misc_identifier_format`) 
VALUES
(null, 'health_insurance_card', 'RAMQ', 'active', 0, '', ''),
(null, 'montreal_general_hospital_card', 'MGH/HGM Id', 'active', 1, '', ''),
(null, 'prostate_bank_participant_id', 'PR-PartID', 'active', 3, 'prostate_bank_participant_id', 'PS3P%%key_increment%%');

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
('prostate_bank_participant_id', 0200);

-- ******** REP. HISTORY ******** 

-- TODO
UPDATE `menus` SET `active` = 'no' WHERE `id` = 'clin_CAN_68'; -- reproductive history

-- ******** FAM. HISTORY ******** 

-- TODO
UPDATE `menus` SET `active` = 'no' WHERE `id` = 'clin_CAN_10'; -- family history

-- ******** CONTACT ******** 

-- Other Contact Type : Hidden
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
WHERE `old_id` IN ('CAN-999-999-000-999-10_CAN-999-999-000-999-546');

-- Other Contact Type : text box
UPDATE `structure_fields` SET `type` = 'input', `setting` = 'size=30' WHERE `old_id` = 'CAN-999-999-000-999-39' ;

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

INSERT INTO `structure_validations` 
(`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-CUSM-000003', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1223'), 'CAN-999-999-000-999-1223', 'notEmpty', '0', '0', '', 'bank is required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 
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
WHERE `structure_field_id` IN (SELECT `id` FROM `structure_fields` WHERE `old_id` IN ('CAN-999-999-000-999-1007', 'CAN-999-999-000-999-1007-ColView'));

-- Update custom_collection_site

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'muhc', 'muhc');

SET @domain_id = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` LIKE 'custom_collection_site');

DELETE FROM `structure_value_domains_permissible_values` WHERE  `structure_value_domain_id` IN (@domain_id);
INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'muhc' AND `language_alias` = 'muhc'), '1', 'yes', 'muhc'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'other' AND `language_alias` = 'other'), '2', 'yes', 'other');

DELETE FROM `i18n` WHERE `id` IN ('muhc');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('muhc', 'global', 'MUHC', 'CUSM');

-- Add collection visist
 
ALTER TABLE `collections` ADD `qc_cusm_visit_label` VARCHAR( 20 ) NULL AFTER `bank_id`; 
ALTER TABLE `collections_revs` ADD `qc_cusm_visit_label` VARCHAR( 20 ) NULL AFTER `bank_id`;

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`) VALUES
(null, 'qc_cusm_collection_visit', 'open', '');

SET @visit_domain_id = LAST_INSERT_ID();

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'V01', 'V01'),
(NULL, 'V02', 'V02'),
(NULL, 'V03', 'V03'),
(NULL, 'V04', 'V04'),
(NULL, 'V05', 'V05');

INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , @visit_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'V01'), '1', 'yes', 'V01'),
(NULL , @visit_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'V02'), '2', 'yes', 'V02'),
(NULL , @visit_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'V03'), '3', 'yes', 'V03'),
(NULL , @visit_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'V04'), '4', 'yes', 'V04'),
(NULL , @visit_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'V05'), '5', 'yes', 'V05');

DELETE FROM `i18n` WHERE `id` IN ('visit', 'V01', 'V02', 'V03', 'V04', 'V05');
INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('V01', 'global', 'V01', 'V01'),
('V02', 'global', 'V02', 'V02'),
('V03', 'global', 'V03', 'V03'),
('V04', 'global', 'V04', 'V04'),
('V05', 'global', 'V05', 'V05'),
('visit', 'global', 'Visit', 'Visite');

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000005', 'Inventorymanagement', 'Collection', 'collections', 'qc_cusm_visit_label', 'visit', '', 'select', '', '', @visit_domain_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1000_QC-CUSM-000005', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1000'), 'CAN-999-999-000-999-1000', 
(SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000005'), 'QC-CUSM-000005', 
0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Add Prostate Bank Identifier + visit To Collection View

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000002', 'Inventorymanagement', 'ViewCollection', '', 'qc_cusm_prostate_bank_identifier', 'prostate_bank_participant_id', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CANM-00025_QC-CUSM-000002', (SELECT id FROM structures WHERE old_id = 'CANM-00025'), 'CANM-00025', 
(SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000002'), 'QC-CUSM-000002', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000005-ColView', 'Inventorymanagement', 'ViewCollection', '', 'qc_cusm_visit_label', 'visit', '', 'select', '', '', @visit_domain_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CANM-00025_QC-CUSM-000005-ColView', (SELECT id FROM structures WHERE old_id = 'CANM-00025'), 'CANM-00025', 
(SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000005-ColView'), 'QC-CUSM-000005-ColView', 
0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DROP VIEW IF EXISTS view_collections;
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
col.qc_cusm_visit_label, 
col.collection_site, 
col.collection_datetime, 
col.collection_datetime_accuracy, 
col.collection_property, 
col.collection_notes, 
col.deleted,

banks.name AS bank_name,

idents.identifier_value AS qc_cusm_prostate_bank_identifier 

FROM collections AS col
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
LEFT JOIN misc_identifiers AS idents ON idents.participant_id=link.participant_id AND idents.deleted != 1 AND idents.identifier_name = 'prostate_bank_participant_id'
WHERE col.deleted != 1;

-- ******** SAMPLE ******** 

-- Define available sample types :
--      'tissue', 'urine', 'blood', 'blood cell', 'plasma', 'serum', 'dna', 'rna', 'centrifuged urine'

UPDATE sample_controls
SET status = 'inactive'
WHERE sample_type NOT IN ('tissue', 'urine', 'blood', 'blood cell', 'plasma', 'serum', 'dna', 'rna', 'centrifuged urine');

UPDATE parent_to_derivative_sample_controls
SET status = 'inactive'
WHERE parent_sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type NOT IN ('tissue', 'urine', 'blood', 'blood cell', 'plasma', 'serum', 'dna', 'rna', 'centrifuged urine'));

UPDATE parent_to_derivative_sample_controls
SET status = 'inactive'
WHERE derivative_sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type NOT IN ('tissue', 'urine', 'blood', 'blood cell', 'plasma', 'serum', 'dna', 'rna', 'centrifuged urine'));

UPDATE parent_to_derivative_sample_controls
SET status = 'inactive'
WHERE parent_sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('tissue'));

UPDATE parent_to_derivative_sample_controls
SET status = 'inactive'
WHERE parent_sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('blood'))
AND derivative_sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('dna'));

UPDATE parent_to_derivative_sample_controls
SET status = 'inactive'
WHERE parent_sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('blood cell'))
AND derivative_sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('rna'));

UPDATE structure_value_domains_permissible_values
SET active = 'no'
WHERE structure_value_domain_id = (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'aliquot_type')
AND language_alias IN ('cell gel matrix', 'core', 'slide');

UPDATE structure_value_domains_permissible_values
SET active = 'no'
WHERE structure_value_domain_id IN (SELECT id FROM `structure_value_domains` WHERE `domain_name` IN ('sample_type', 'specimen_sample_type'))
AND language_alias NOT IN ('tissue', 'urine', 'blood', 'blood cell', 'plasma', 'serum', 'dna', 'rna', 'centrifuged urine');

-- Add sample label to existing structures

ALTER TABLE `sample_masters` ADD `qc_cusm_sample_label` VARCHAR(60) NOT NULL default '' AFTER `sample_code`; 
ALTER TABLE `sample_masters_revs` ADD `qc_cusm_sample_label` VARCHAR(60) NOT NULL default '' AFTER `sample_code`; 

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000007', 'Inventorymanagement', 'SampleMaster', 'sample_masters', 'qc_cusm_sample_label', 'sample label', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @field_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- sample_masters_for_collection_tree_view CAN-999-999-000-999-1004  0|0 0|0 0|0 0|0 1 0
(null, 'CAN-999-999-000-999-1004_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1004'), 'CAN-999-999-000-999-1004', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- sd_spe_bloods CAN-999-999-000-999-1006  0|0 1|1 0|0 0|0 1 1
(null, 'CAN-999-999-000-999-1006_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1006'), 'CAN-999-999-000-999-1006', 
@field_id, 'QC-CUSM-000007', 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- sd_spe_tissues CAN-999-999-000-999-1008  0|0 1|1 0|0 0|0 1 1
(null, 'CAN-999-999-000-999-1008_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1008'), 'CAN-999-999-000-999-1008', 
@field_id, 'QC-CUSM-000007', 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- sd_spe_urines CAN-999-999-000-999-1009  0|0 1|1 0|0 0|0 1 1
(null, 'CAN-999-999-000-999-1009_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1009'), 'CAN-999-999-000-999-1009', 
@field_id, 'QC-CUSM-000007', 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- sd_undetailed_derivatives CAN-999-999-000-999-1010  0|0 1|1 0|0 0|0 1 1
(null, 'CAN-999-999-000-999-1010_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1010'), 'CAN-999-999-000-999-1010', 
@field_id, 'QC-CUSM-000007', 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- sd_der_plasmas CAN-999-999-000-999-1014  0|0 1|1 0|0 0|0 1 1
(null, 'CAN-999-999-000-999-1014_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1014'), 'CAN-999-999-000-999-1014', 
@field_id, 'QC-CUSM-000007', 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- sd_der_serums CAN-999-999-000-999-1015  0|0 1|1 0|0 0|0 1 1
(null, 'CAN-999-999-000-999-1015_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1015'), 'CAN-999-999-000-999-1015', 
@field_id, 'QC-CUSM-000007', 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Add Prostate Bank Identifier To view_sample_joined_to_collection

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000003', 'Inventorymanagement', 'ViewSample', '', 'qc_cusm_prostate_bank_identifier', 'prostate_bank_participant_id', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @field_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- view_sample_joined_to_collection
(null, 'CAN-999-999-000-999-1094_QC-CUSM-000003', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1094'), 'CAN-999-999-000-999-1094', 
@field_id, 'QC-CUSM-000003', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Add sample label to existing views

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000007-SampView', 'Inventorymanagement', 'SampleMaster', 'sample_masters', 'qc_cusm_sample_label', 'sample label', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @field_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- view_sample_joined_to_collection CAN-999-999-000-999-1094 -SampView 0|0 0|0 1|0 0|0 1 0
(null, 'CAN-999-999-000-999-1094_QC-CUSM-000007-SampView', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1094'), 'CAN-999-999-000-999-1094', 
@field_id, 'QC-CUSM-000007-SampView', 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- view_sample_joined_to_parent CAN-999-999-000-999-1093 -SampView 0|0 0|0 0|0 0|0 1 0
(null, 'CAN-999-999-000-999-1093_QC-CUSM-000007-SampView', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1093'), 'CAN-999-999-000-999-1093', 
@field_id, 'QC-CUSM-000007-SampView', 
0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Update Sample View

DROP VIEW IF EXISTS view_samples;
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
samp.qc_cusm_sample_label,
samp.sample_category,
samp.deleted,

idents.identifier_value AS qc_cusm_prostate_bank_identifier 

FROM sample_masters as samp
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN misc_identifiers AS idents ON idents.participant_id=link.participant_id AND idents.deleted != 1 AND idents.identifier_name = 'prostate_bank_participant_id'
WHERE samp.deleted != 1;

-- Update custom_laboratory_staff

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'lucie hamel', 'lucie hamel'),
(NULL, 'eleonora scarlata villegas', 'eleonora scarlata villegas'),
(NULL, 'jinsong chen', 'jinsong chen'),
(NULL, 'chrysoula makris', 'chrysoula makris'),
(NULL, 'simone chevalier', 'simone chevalier'),
(NULL, 'armen aprikian', 'armen aprikian');

SET @domain_id = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` LIKE 'custom_laboratory_staff');

DELETE FROM `structure_value_domains_permissible_values` WHERE  `structure_value_domain_id` IN (@domain_id);
INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'armen aprikian' AND `language_alias` = 'armen aprikian'), '10', 'yes', 'armen aprikian'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'chrysoula makris' AND `language_alias` = 'chrysoula makris'), '15', 'yes', 'chrysoula makris'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'eleonora scarlata villegas' AND `language_alias` = 'eleonora scarlata villegas'), '20', 'yes', 'eleonora scarlata villegas'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'jinsong chen' AND `language_alias` = 'jinsong chen'), '25', 'yes', 'jinsong chen'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'lucie hamel' AND `language_alias` = 'lucie hamel'), '30', 'yes', 'lucie hamel'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'simone chevalier' AND `language_alias` = 'simone chevalier'), '35', 'yes', 'simone chevalier'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'other' AND `language_alias` = 'other'), '40', 'yes', 'other');

DELETE FROM `i18n` WHERE `id` IN ('simone chevalier', 'jinsong chen', 'lucie hamel', 'eleonora scarlata villegas', 'chrysoula makris', 'armen aprikian');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('armen aprikian', 'global', 'Armen Aprikian', 'Armen Aprikian'),
('chrysoula makris', 'global', 'Chrysoula Makris', 'Chrysoula Makris'),
('eleonora scarlata villegas', 'global', 'Eleonora Scarlata Villegas', 'Eleonora Scarlata Villegas'),
('jinsong chen', 'global', 'Jinsong Chen', 'Jinsong Chen'),
('lucie hamel', 'global', 'Lucie Hamel', 'Lucie Hamel'),
('simone chevalier', 'global', 'Simone Chevalier', 'Simone Chevalier');

-- Update custom_specimen_supplier_dept

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'urology clinic', 'urology clinic');

SET @domain_id = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` LIKE 'custom_specimen_supplier_dept');

DELETE FROM `structure_value_domains_permissible_values` WHERE  `structure_value_domain_id` IN (@domain_id);
INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'operating room' AND `language_alias` = 'operating room'), '10', 'yes', 'operating room'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'urology clinic' AND `language_alias` = 'urology clinic'), '10', 'yes', 'urology clinic'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'other' AND `language_alias` = 'other'), '40', 'yes', 'other');

DELETE FROM `i18n` WHERE `id` IN ('urology clinic');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('urology clinic', 'global', 'Urology Clinic', 'Clinique d''urologie');

-- Update custom_laboratory_site

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'r1-103', 'r1-103'),
(NULL, 'pathology laboratory', 'pathology laboratory');

SET @domain_id = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` LIKE 'custom_laboratory_site');

DELETE FROM `structure_value_domains_permissible_values` WHERE  `structure_value_domain_id` IN (@domain_id);
INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'r1-103' AND `language_alias` = 'r1-103'), '10', 'yes', 'r1-103'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pathology laboratory' AND `language_alias` = 'pathology laboratory'), '10', 'yes', 'pathology laboratory'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'other' AND `language_alias` = 'other'), '40', 'yes', 'other');

DELETE FROM `i18n` WHERE `id` IN ('pathology laboratory');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('pathology laboratory', 'global', 'Pathology Laboratory', 'Laboratoire de pathologie');

-- sample SOP hidden

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
WHERE `structure_field_id` IN (SELECT `id` FROM `structure_fields` WHERE `old_id` IN ('CAN-999-999-000-999-1030'));

-- Update blood type list

SET @domain_id = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` LIKE 'blood_type');

UPDATE structure_value_domains_permissible_values
SET active = 'no'
WHERE structure_value_domain_id = @domain_id
AND language_alias NOT IN ('gel CSA', 'paxgene', 'unknown', 'EDTA');
   
DELETE FROM `i18n` WHERE `id` IN ('gel CSA');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('gel CSA', 'global', 'Gel CSA/SST', 'Gel de CSA/SST');

-- Update urine aspect 

UPDATE structure_fields
SET language_label = 'aspect at reception'
WHERE old_id = 'CAN-999-999-000-999-1050'; -- SampleDetail.urine_aspect

ALTER TABLE `sd_spe_urines` ADD `qc_cusm_aspect_before_centrifugation` VARCHAR(30) NULL AFTER `urine_aspect`; 
ALTER TABLE `sd_spe_urines_revs` ADD `qc_cusm_aspect_before_centrifugation` VARCHAR(30) NULL AFTER `urine_aspect`; 

INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'QC-CUSM-000010', 'Inventorymanagement', 'SampleDetail', '', 'qc_cusm_aspect_before_centrifugation', 'aspect before centrifugation', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'urine_aspect'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @field_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- sd_spe_urines CAN-999-999-000-999-1009 1|0 1|0 0|0 0|0 1 1
(null, 'CAN-999-999-000-999-1009_QC-CUSM-000010', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1009'), 'CAN-999-999-000-999-1009', 
@field_id, 'QC-CUSM-000010', 
1, 41, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('aspect at reception', 'aspect before centrifugation');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('aspect at reception', 'global', 'Aspect at Reception', 'Aspect &agrave; la r&eacute;ception'),
('aspect before centrifugation', 'global', 'Aspect Before Centrifugation', 'Aspect avant centrifugation');
 
-- Centrifuged urine : add pellet color

UPDATE sample_controls
SET form_alias = 'sd_der_centrifuged_urines'
WHERE sample_type = 'centrifuged urine' ;

INSERT INTO `structures` (`id`, `old_id`, `alias`, `description`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'QC-CUSM-000002', 'sd_der_centrifuged_urines', NULL, '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @structure_id = LAST_INSERT_ID();

ALTER TABLE `sd_der_urine_cents` ADD `qc_cusm_pellet_color` VARCHAR(30) NULL AFTER `sample_master_id`; 
ALTER TABLE `sd_der_urine_cents_revs` ADD `qc_cusm_pellet_color` VARCHAR(30) NULL AFTER `sample_master_id`; 

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'red', 'red'),
(NULL, 'pink', 'pink'),
(NULL, 'white', 'white'),
(NULL, 'yellow', 'yellow');

DELETE FROM `i18n` WHERE `id` IN ('red', 'pink', 'white', 'yellow');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('red', 'global', 'Red', 'Rouge'),
('pink', 'global', 'Pink', 'Rose'),
('yellow', 'global', 'Yellow', 'Jaune'),
('white', 'global', 'White', 'Blanc');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`) VALUES
(null, 'qc_cusm_centrifuged_urine_pellet_color', 'open', '');

SET @domain_id = LAST_INSERT_ID();

INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pink'), '10', 'yes', 'pink'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'red'), '20', 'yes', 'red'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'white'), '30', 'yes', 'white'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'yellow'), '40', 'yes', 'yellow'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'other'), '50', 'yes', 'other');

INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'QC-CUSM-000011', 'Inventorymanagement', 'SampleDetail', '', 'qc_cusm_pellet_color', 'pellet color', '', 'select', '', '', @domain_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @field_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- CAN-999-999-000-999-1222 SampleMaster.initial_specimen_sample_type
(null, 'QC-CUSM-000002_CAN-999-999-000-999-1222', @structure_id, 'QC-CUSM-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1222'), 'CAN-999-999-000-999-1222', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1276 GeneratedParentSample.sample_type
(null, 'QC-CUSM-000002_CAN-999-999-000-999-1276', @structure_id, 'QC-CUSM-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1018 SampleMaster.sample_type
(null, 'QC-CUSM-000002_CAN-999-999-000-999-1018', @structure_id, 'QC-CUSM-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- QC-CUSM-000007 SampleMaster.qc_cusm_sample_label
(null, 'QC-CUSM-000002_QC-CUSM-000007', @structure_id, 'QC-CUSM-000002', (SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000007'), 'QC-CUSM-000007', 0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- CAN-999-999-000-999-1016 SampleMaster.sample_code
(null, 'QC-CUSM-000002_CAN-999-999-000-999-1016', @structure_id, 'QC-CUSM-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1016'), 'CAN-999-999-000-999-1016', 0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1027 SampleMaster.sample_category
(null, 'QC-CUSM-000002_CAN-999-999-000-999-1027', @structure_id, 'QC-CUSM-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1027'), 'CAN-999-999-000-999-1027', 0, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1023 SampleMaster.parent_id
(null, 'QC-CUSM-000002_CAN-999-999-000-999-1023', @structure_id, 'QC-CUSM-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1023'), 'CAN-999-999-000-999-1023', 0, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1030 SampleMaster.sop_master_id
(null, 'QC-CUSM-000002_CAN-999-999-000-999-1030', @structure_id, 'QC-CUSM-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1030'), 'CAN-999-999-000-999-1030', 0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1029 SampleMaster.is_problematic
(null, 'QC-CUSM-000002_CAN-999-999-000-999-1029', @structure_id, 'QC-CUSM-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1029'), 'CAN-999-999-000-999-1029', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1022 SampleMaster.notes
(null, 'QC-CUSM-000002_CAN-999-999-000-999-1022', @structure_id, 'QC-CUSM-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1022'), 'CAN-999-999-000-999-1022', 0, 25, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1062 DerivativeDetail.creation_datetime
(null, 'QC-CUSM-000002_CAN-999-999-000-999-1062', @structure_id, 'QC-CUSM-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1062'), 'CAN-999-999-000-999-1062', 1, 30, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1287 DerivativeDetail.creation_datetime_accuracy
(null, 'QC-CUSM-000002_CAN-999-999-000-999-1287', @structure_id, 'QC-CUSM-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1287'), 'CAN-999-999-000-999-1287', 1, 31, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1061 DerivativeDetail.creation_by
(null, 'QC-CUSM-000002_CAN-999-999-000-999-1061', @structure_id, 'QC-CUSM-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1061'), 'CAN-999-999-000-999-1061', 1, 32, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1060 DerivativeDetail.creation_site
(null, 'QC-CUSM-000002_CAN-999-999-000-999-1060', @structure_id, 'QC-CUSM-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1060'), 'CAN-999-999-000-999-1060', 1, 33, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1070 Generated.coll_to_creation_spent_time_msg
(null, 'QC-CUSM-000002_CAN-999-999-000-999-1070', @structure_id, 'QC-CUSM-000002', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1070'), 'CAN-999-999-000-999-1070', 1, 34, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),

-- new field
(null, 'QC-CUSM-000002_QC-CUSM-000011', @structure_id, 'QC-CUSM-000002', @field_id, 'QC-CUSM-000011', 1, 40, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL');

-- Add 'on ice' to tissue

ALTER TABLE `sd_spe_tissues` ADD `qc_cusm_on_ice` VARCHAR(10) NULL AFTER `tissue_size_unit`; 
ALTER TABLE `sd_spe_tissues_revs` ADD `qc_cusm_on_ice` VARCHAR(10) NULL AFTER `tissue_size_unit`; 

INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'QC-CUSM-000012', 'Inventorymanagement', 'SampleDetail', '', 'qc_cusm_on_ice', 'on ice', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yesno'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @field_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1008_QC-CUSM-000012', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1008'), 'CAN-999-999-000-999-1008', 
@field_id, 'QC-CUSM-000012', 
1, 48, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('on ice');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('on ice', 'global', 'On Ice', 'Sur glace');

-- RNA : Add 'is micro RNA'

UPDATE sample_controls
SET form_alias = 'sd_der_rnas'
WHERE sample_type = 'rna' ;

INSERT INTO `structures` (`id`, `old_id`, `alias`, `description`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'QC-CUSM-000003', 'sd_der_rnas', NULL, '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @structure_id = LAST_INSERT_ID();

ALTER TABLE `sd_der_rnas` ADD `qc_cusm_micro_rna` VARCHAR(10) NULL AFTER `sample_master_id`; 
ALTER TABLE `sd_der_rnas_revs` ADD `qc_cusm_micro_rna` VARCHAR(10) NULL AFTER `sample_master_id`; 

INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'QC-CUSM-000013', 'Inventorymanagement', 'SampleDetail', '', 'qc_cusm_micro_rna', 'micro rna', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @field_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- CAN-999-999-000-999-1222 SampleMaster.initial_specimen_sample_type
(null, 'QC-CUSM-000003_CAN-999-999-000-999-1222', @structure_id, 'QC-CUSM-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1222'), 'CAN-999-999-000-999-1222', 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1276 GeneratedParentSample.sample_type
(null, 'QC-CUSM-000003_CAN-999-999-000-999-1276', @structure_id, 'QC-CUSM-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1276'), 'CAN-999-999-000-999-1276', 0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1018 SampleMaster.sample_type
(null, 'QC-CUSM-000003_CAN-999-999-000-999-1018', @structure_id, 'QC-CUSM-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1018'), 'CAN-999-999-000-999-1018', 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- QC-CUSM-000007 SampleMaster.qc_cusm_sample_label
(null, 'QC-CUSM-000003_QC-CUSM-000007', @structure_id, 'QC-CUSM-000003', (SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000007'), 'QC-CUSM-000007', 0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- CAN-999-999-000-999-1016 SampleMaster.sample_code
(null, 'QC-CUSM-000003_CAN-999-999-000-999-1016', @structure_id, 'QC-CUSM-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1016'), 'CAN-999-999-000-999-1016', 0, 6, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1027 SampleMaster.sample_category
(null, 'QC-CUSM-000003_CAN-999-999-000-999-1027', @structure_id, 'QC-CUSM-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1027'), 'CAN-999-999-000-999-1027', 0, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1023 SampleMaster.parent_id
(null, 'QC-CUSM-000003_CAN-999-999-000-999-1023', @structure_id, 'QC-CUSM-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1023'), 'CAN-999-999-000-999-1023', 0, 9, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1030 SampleMaster.sop_master_id
(null, 'QC-CUSM-000003_CAN-999-999-000-999-1030', @structure_id, 'QC-CUSM-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1030'), 'CAN-999-999-000-999-1030', 0, 11, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1029 SampleMaster.is_problematic
(null, 'QC-CUSM-000003_CAN-999-999-000-999-1029', @structure_id, 'QC-CUSM-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1029'), 'CAN-999-999-000-999-1029', 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1022 SampleMaster.notes
(null, 'QC-CUSM-000003_CAN-999-999-000-999-1022', @structure_id, 'QC-CUSM-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1022'), 'CAN-999-999-000-999-1022', 0, 25, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1062 DerivativeDetail.creation_datetime
(null, 'QC-CUSM-000003_CAN-999-999-000-999-1062', @structure_id, 'QC-CUSM-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1062'), 'CAN-999-999-000-999-1062', 1, 30, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1287 DerivativeDetail.creation_datetime_accuracy
(null, 'QC-CUSM-000003_CAN-999-999-000-999-1287', @structure_id, 'QC-CUSM-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1287'), 'CAN-999-999-000-999-1287', 1, 31, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1061 DerivativeDetail.creation_by
(null, 'QC-CUSM-000003_CAN-999-999-000-999-1061', @structure_id, 'QC-CUSM-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1061'), 'CAN-999-999-000-999-1061', 1, 32, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1060 DerivativeDetail.creation_site
(null, 'QC-CUSM-000003_CAN-999-999-000-999-1060', @structure_id, 'QC-CUSM-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1060'), 'CAN-999-999-000-999-1060', 1, 33, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- CAN-999-999-000-999-1070 Generated.coll_to_creation_spent_time_msg
(null, 'QC-CUSM-000003_CAN-999-999-000-999-1070', @structure_id, 'QC-CUSM-000003', (SELECT id FROM structure_fields WHERE old_id = 'CAN-999-999-000-999-1070'), 'CAN-999-999-000-999-1070', 1, 34, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),

-- new field
(null, 'QC-CUSM-000003_QC-CUSM-000013', @structure_id, 'QC-CUSM-000003', @field_id, 'QC-CUSM-000013', 1, 40, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL');

-- Tissu laterality: hidden
-- Tissu pathology_reception_datetime: hidden

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
WHERE `old_id` IN ('CAN-999-999-000-999-1008_CAN-999-999-000-999-1043', 'CAN-999-999-000-999-1008_CAN-999-999-000-999-1044');

-- ******** ALIQUOT ******** 

-- Define available aliquot types

UPDATE sample_to_aliquot_controls 
SET status = 'inactive'
WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE status = 'inactive');

UPDATE sample_to_aliquot_controls 
SET status = 'inactive'
WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type = 'tissue')
AND aliquot_control_id NOT IN (SELECT id FROM aliquot_controls WHERE aliquot_type = 'block');

UPDATE aliquot_controls 
SET status = 'inactive'
WHERE id NOT IN (SELECT aliquot_control_id FROM `sample_to_aliquot_controls` WHERE `status` = 'active');

UPDATE structure_value_domains_permissible_values
SET active = 'no'
WHERE structure_value_domain_id = (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'aliquot_type')
AND language_alias IN ('cell gel matrix', 'core', 'slide');

-- Add Prostate Bank Identifier To view_aliquot_joined_to_collection

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000009', 'Inventorymanagement', 'ViewAliquot', '', 'qc_cusm_prostate_bank_identifier', 'prostate_bank_participant_id', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @field_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- view_aliquot_joined_to_collection
(null, 'CAN-999-999-000-999-1095_QC-CUSM-000009', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1095'), 'CAN-999-999-000-999-1095', 
@field_id, 'QC-CUSM-000009', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Update Aliquot View

DROP VIEW IF EXISTS view_aliquots;
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

-- SOP hidden

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
WHERE `structure_field_id` IN (SELECT `id` FROM `structure_fields` WHERE `old_id` IN ('CAN-999-999-000-999-1165'));

-- Add Whatman paper creation date

ALTER TABLE `ad_whatman_papers` ADD `qc_cusm_creation_date` DATETIME NULL AFTER `used_blood_volume_unit` ;
ALTER TABLE `ad_whatman_papers_revs` ADD `qc_cusm_creation_date` DATETIME NULL AFTER `used_blood_volume_unit` ;

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000004', 'Inventorymanagement', 'AliquotDetail', 'ad_whatman_papers', 'qc_cusm_creation_date', 'creation date', '', 'datetime', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1030_QC-CUSM-000004', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1030'), 'CAN-999-999-000-999-1030', 
(SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000004'), 'QC-CUSM-000004', 
1, 72, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Tissue Block: Delete frozen from tissue block type

SET @domain_id = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` LIKE 'block_type');

DELETE FROM `structure_value_domains_permissible_values` WHERE  `structure_value_domain_id` IN (@domain_id)
AND language_alias NOT IN ('oct solution', 'paraffin');

-- Tissue Block: Add tissue position

ALTER TABLE `ad_blocks` 
ADD `qc_cusm_tissue_position_code` varchar(10) default NULL AFTER `block_type`;

ALTER TABLE `ad_blocks_revs` 
ADD `qc_cusm_tissue_position_code` varchar(10) default NULL AFTER `block_type`;

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000014', 'Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'qc_cusm_tissue_position_code', 'tissue position code', '', 'select', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1028_QC-CUSM-000014', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1028'), 'CAN-999-999-000-999-1028', 
(SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000014'), 'QC-CUSM-000014', 
1, 73, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('tissue position code');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('tissue position code', 'global', 'Tissue Position', 'Position du tissue');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'right anterior', 'right anterior'),
(NULL, 'left anterior', 'left anterior'),
(NULL, 'right posterior', 'right posterior'),
(NULL, 'left posterior', 'left posterior');

DELETE FROM `i18n` WHERE `id` IN ('right anterior', 'left anterior', 'right posterior', 'left posterior');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('right anterior', 'global', 'Right Anterior', 'Anterieur droit'),
('left anterior', 'global', 'Left Anterior', 'Anterieur gauche'),
('right posterior', 'global', 'Right Posterior', 'Posterieur droit'),
('left posterior', 'global', 'Left Posterior', 'Posterieur gauche');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`) VALUES
(null, 'qc_cusm_tissue_position', 'open', '');

SET @domain_id = LAST_INSERT_ID();

INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'right anterior'), '20', 'yes', 'right anterior'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'left anterior'), '20', 'yes', 'left anterior'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'right posterior'), '20', 'yes', 'right posterior'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'left posterior'), '20', 'yes', 'left posterior');

-- Tissue Block: Add tissue section

ALTER TABLE `ad_blocks` 
ADD `qc_cusm_tissue_section_code` varchar(10) default NULL AFTER `qc_cusm_tissue_position_code`;

ALTER TABLE `ad_blocks_revs` 
ADD `qc_cusm_tissue_section_code` varchar(10) default NULL AFTER `qc_cusm_tissue_position_code`;

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000015', 'Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'qc_cusm_tissue_section_code', 'tissue section code', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1028_QC-CUSM-000015', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1028'), 'CAN-999-999-000-999-1028', 
(SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000015'), 'QC-CUSM-000015', 
1, 74, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('tissue section code');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('tissue section code', 'global', 'Tissue Section', 'Section du tissue');

INSERT INTO `structure_validations` (`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'QC-CUSM-000004', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'QC-CUSM-000015'), 'QC-CUSM-000015', 'custom,/^([0-9]+)?$/', '1', '0', '', 'section should be a positif integer', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL');

DELETE FROM `i18n` WHERE `id` IN ('section should be a positif integer');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('section should be a positif integer', 'global', 'Section should be a positif integer!', 'La section doit &ecirc;tre un entier positif!');

-- Tissue Block: Add size

ALTER TABLE `ad_blocks` 
ADD `qc_cusm_block_size` varchar(10) default NULL AFTER `qc_cusm_tissue_section_code`;

ALTER TABLE `ad_blocks_revs` 
ADD `qc_cusm_block_size` varchar(10) default NULL AFTER `qc_cusm_tissue_section_code`;

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000016', 'Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'qc_cusm_block_size', 'size', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1028_QC-CUSM-000016', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1028'), 'CAN-999-999-000-999-1028', 
(SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000016'), 'QC-CUSM-000016', 
1, 75, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Hidde cells count and concentration fro blood cells tubes

SET @sample_control_id = (SELECT id  FROM  `sample_controls` WHERE `sample_type` LIKE 'blood cell' AND `status` LIKE 'active');
SET @new_aliquot_control_id = (SELECT id  FROM `aliquot_controls` WHERE `aliquot_type` LIKE 'tube' AND `form_alias` LIKE 'ad_der_tubes_incl_ml_vol' AND `status` = 'active');
SET @old_aliquot_control_id = (SELECT id FROM `aliquot_controls` WHERE `aliquot_type` LIKE 'tube' AND `status` = 'active' AND `form_alias` LIKE 'ad_der_cell_tubes_incl_ml_vol');

UPDATE `sample_to_aliquot_controls`
SET `aliquot_control_id` = @new_aliquot_control_id
WHERE `sample_control_id` = @sample_control_id
AND `aliquot_control_id` = @old_aliquot_control_id
AND `status` = 'active';

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- STORAGE
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- Hidde unused strorage type

UPDATE `storage_controls` SET  `status` = 'inactive' WHERE `storage_type` NOT IN ('room', 'freezer', 'shelf');

UPDATE structure_value_domains_permissible_values
SET active = 'no'
WHERE structure_value_domain_id = (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'storage_type')
AND language_alias NOT IN ('room', 'freezer', 'shelf');

-- Creatre new strorage type

INSERT INTO `storage_controls` (`id`, `storage_type`, `storage_type_code`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `set_temperature`, `is_tma_block`, `status`, `form_alias`, `form_alias_for_children_pos`, `detail_tablename`) VALUES
(null , 'rack16 A1-D4', 'RACK', 'column', 'alphabetical', 4, 'row', 'integer', 4, 0, 0, 0, 1, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_2_dim_position_selection', 'std_racks'),
(null, 'box100', 'B100', 'position', 'integer', 100, null, null, null, 10, 10, 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', 'std_boxs'),
(null, 'drawers box', 'DR-BX', 'position', 'integer', 8, null, null, null, 4, 2, 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', 'std_boxs'),
(null, 'blocks drawer', 'DR', 'position', 'integer', 2, null, null, null, 0, 0, 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', 'std_boxs');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'rack16 A1-D4', 'rack16 A1-D4'),
(NULL, 'box100', 'box100'),
(NULL, 'drawers box', 'drawers box'),
(NULL, 'blocks drawer', 'blocks drawer');

SET @domain_id = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` LIKE 'storage_type');

INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'rack16 A1-D4' AND `language_alias` = 'rack16 A1-D4'), '110', 'yes', 'rack16 A1-D4'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'box100' AND `language_alias` = 'box100'), '120', 'yes', 'box100'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'drawers box' AND `language_alias` = 'drawers box'), '130', 'yes', 'drawers box'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'blocks drawer' AND `language_alias` = 'blocks drawer'), '140', 'yes', 'blocks drawer');

DELETE FROM `i18n` WHERE `id` IN ('blocks drawer', 'drawers box', 'box100', 'rack16 A1-D4');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('rack16 A1-D4', 'global', 'Rack ', 'Ratelier'),
('box100', 'global', 'Box 100', 'Bo&icirc;te 100'),
('drawers box', 'global', 'Drawers Box', 'Bo&icirc;te &agrave; tiroirs'),
('blocks drawer', 'global', 'Blocks Drawer', 'Tiroir &agrave; blocs');

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- SOP
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

UPDATE `menus` SET `active` = 'no' WHERE `id` LIKE 'sop_CAN_%';

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- MATERIAL
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

UPDATE `menus` SET `active` = 'no' WHERE `id` LIKE 'mat_CAN_%';

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- DRUG
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

UPDATE `menus` SET `active` = 'no' WHERE `id` LIKE 'drug_CAN_%';

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- PROTOCOL
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

UPDATE `menus` SET `active` = 'no' WHERE `id` LIKE 'proto_CAN_%';

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- FORM
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

UPDATE `menus` SET `active` = 'no' WHERE `id` LIKE 'rtbf_CAN_%';

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- STUDY
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

UPDATE `menus` SET `active` = 'no' WHERE `id` IN (
'tool_CAN_107',		--	tool_reviews
'tool_CAN_108',		--	tool_ethics
'tool_CAN_109',		--	tool_funding
'tool_CAN_110',		--	tool_result
'tool_CAN_112');	--	tool_related studies

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
'CAN-999-999-000-999-52_CAN-999-999-000-999-365',	-- StudySummary.study_type
'CAN-999-999-000-999-52_CAN-999-999-000-999-366',	-- StudySummary.study_science
'CAN-999-999-000-999-52_CAN-999-999-000-999-52-3',	-- StudySummary.path_to_file
'CAN-999-999-000-999-52_CAN-999-999-000-999-370',	-- StudySummary.abstract
'CAN-999-999-000-999-52_CAN-999-999-000-999-371',	-- StudySummary.hypothesis
'CAN-999-999-000-999-52_CAN-999-999-000-999-372',	-- StudySummary.approach
'CAN-999-999-000-999-52_CAN-999-999-000-999-373',	-- StudySummary.analysis
'CAN-999-999-000-999-52_CAN-999-999-000-999-374',	-- StudySummary.significance
'CAN-999-999-000-999-52_CAN-999-999-000-999-375');	-- StudySummary.additional_clinical

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- ADMINISTRATION
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


