-- -------------------------------------------------------------------
--
-- SCRIPT to customize ATiM for CUSM Bank
--
-- -------------------------------------------------------------------

UPDATE `configs` SET `config_debug` = '2' WHERE `configs`.`id` =1 ;

DELETE FROM `structure_formats` WHERE `structure_old_id` LIKE 'QC-CUSM-%' OR `structure_field_old_id` LIKE 'QC-CUSM-%';

DELETE FROM `structure_validations` WHERE `old_id` LIKE 'QC-CUSM-%';

DELETE FROM `structures` WHERE `old_id` LIKE 'QC-CUSM-%';
DELETE FROM `structure_fields` WHERE `old_id` LIKE 'QC-CUSM-%';

UPDATE `structure_fields` SET `structure_value_domain` = null WHERE `structure_value_domain` IN (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` LIKE 'qc_cusm_%');
DELETE FROM `structure_value_domains_permissible_values` WHERE  `structure_value_domain_id` IN (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` LIKE 'qc_cusm_%');
DELETE FROM `structure_value_domains` WHERE `domain_name` LIKE 'qc_cusm_%';

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

DELETE FROM `structure_validations` WHERE `old_id` = 'QC-CUSM-000001';
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
 
DELETE FROM `structure_validations` WHERE `old_id` = 'QC-CUSM-000002';
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

DELETE FROM `structure_permissible_values` WHERE `value` IN ('v2006-02-01', 'v2006-01-26');
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

DELETE FROM `structure_value_domains_permissible_values` WHERE  `structure_value_domain_id` IN (@domain_id);
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
UPDATE `menus` SET `use_link` = '/underdevelopment/' WHERE `id` = 'clin_CAN_5'; -- diagnosis

-- ******** ANNOTATION ******** 

-- TODO
UPDATE `menus` SET `use_link` = '/underdevelopment/' WHERE `id` = 'clin_CAN_4'; -- annotation

-- ******** TREATMENT ******** 

-- TODO
UPDATE `menus` SET `use_link` = '/underdevelopment/' WHERE `id` = 'clin_CAN_75'; -- treatment

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
UPDATE `menus` SET `use_link` = '/underdevelopment/' WHERE `id` = 'clin_CAN_68'; -- reproductive history

-- ******** FAM. HISTORY ******** 

-- TODO
UPDATE `menus` SET `use_link` = '/underdevelopment/' WHERE `id` = 'clin_CAN_10'; -- family history

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

DELETE FROM `structure_validations` WHERE `old_id` = 'QC-CUSM-000003';
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

-- Collection site value

DELETE FROM `structure_permissible_values` WHERE `value` = 'muhc';
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
 
ALTER TABLE `collections` ADD `visit_label` VARCHAR( 20 ) NULL AFTER `bank_id`; 
ALTER TABLE `collections_revs` ADD `visit_label` VARCHAR( 20 ) NULL AFTER `bank_id`;

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`) VALUES
(null, 'qc_cusm_collection_visit', 'open', '');

SET @visit_domain_id = LAST_INSERT_ID();

DELETE FROM `structure_permissible_values` WHERE `value` IN ('V01', 'V02', 'V03', 'V04', 'V05');
INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'V01', 'V01'),
(NULL, 'V02', 'V02'),
(NULL, 'V03', 'V03'),
(NULL, 'V04', 'V04'),
(NULL, 'V05', 'V05');

DELETE FROM `structure_value_domains_permissible_values` WHERE  `structure_value_domain_id` IN (@visit_domain_id);
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
(null, '', 'QC-CUSM-000005', 'Inventorymanagement', 'Collection', 'collections', 'visit_label', 'visit', '', 'select', '', @visit_domain_id, null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CANM-00025_QC-CUSM-000005', (SELECT id FROM structures WHERE old_id = 'CANM-00025'), 'CANM-00025', 
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
(null, '', 'QC-CUSM-000006', 'Inventorymanagement', 'ViewCollection', '', 'visit_label', 'visit', '', 'select', '', @visit_domain_id, null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CANM-00025_QC-CUSM-000006', (SELECT id FROM structures WHERE old_id = 'CANM-00025'), 'CANM-00025', 
(SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000006'), 'QC-CUSM-000006', 
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
col.visit_label, 
col.collection_site, 
col.collection_datetime, 
col.collection_datetime_accuracy, 
col.collection_property, 
col.collection_notes, 
col.deleted,

banks.name AS bank_name,

idents.identifier_value AS prostate_bank_participant_id	

FROM collections AS col
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
LEFT JOIN misc_identifiers AS idents ON idents.participant_id=link.participant_id AND idents.deleted != 1 AND idents.identifier_name = 'prostate_bank_participant_id'
WHERE col.deleted != 1;

-- ******** SAMPLE ******** 

-- Define available sample types

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

-- Add sample label

ALTER TABLE `sample_masters` ADD `sample_label` VARCHAR(60) NOT NULL default '' AFTER `sample_code`; 
ALTER TABLE `sample_masters_revs` ADD `sample_label` VARCHAR(60) NOT NULL default '' AFTER `sample_code`; 

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000007', 'Inventorymanagement', 'SampleMaster', 'sample_masters', 'sample_label', 'sample label', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @field_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- sample_masters_for_collection_tree_view	CAN-999-999-000-999-1004		0|0	0|0	0|0	0|0	1	0
(null, 'CAN-999-999-000-999-1004_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1004'), 'CAN-999-999-000-999-1004', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- view_sample_joined_to_collection	CAN-999-999-000-999-1094	-SampView	0|0	0|0	1|0	0|0	1	0
(null, 'CAN-999-999-000-999-1094_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1094'), 'CAN-999-999-000-999-1094', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- view_sample_joined_to_parent	CAN-999-999-000-999-1093	-SampView	0|0	0|0	0|0	0|0	1	0
(null, 'CAN-999-999-000-999-1093_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1093'), 'CAN-999-999-000-999-1093', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- sd_spe_bloods	CAN-999-999-000-999-1006		0|0	1|1	0|0	0|0	1	1
(null, 'CAN-999-999-000-999-1006_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1006'), 'CAN-999-999-000-999-1006', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- sd_spe_tissues	CAN-999-999-000-999-1008		0|0	1|1	0|0	0|0	1	1
(null, 'CAN-999-999-000-999-1008_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1008'), 'CAN-999-999-000-999-1008', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- sd_spe_urines	CAN-999-999-000-999-1009		0|0	1|1	0|0	0|0	1	1
(null, 'CAN-999-999-000-999-1009_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1009'), 'CAN-999-999-000-999-1009', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- sd_der_cell_cultures	CAN-999-999-000-999-1011		0|0	1|1	0|0	0|0	1	1
(null, 'CAN-999-999-000-999-1011_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1011'), 'CAN-999-999-000-999-1011', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- sd_der_plasmas	CAN-999-999-000-999-1014		0|0	1|1	0|0	0|0	1	1
(null, 'CAN-999-999-000-999-1014_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1014'), 'CAN-999-999-000-999-1014', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- sd_der_serums	CAN-999-999-000-999-1015		0|0	1|1	0|0	0|0	1	1
(null, 'CAN-999-999-000-999-1015_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1015'), 'CAN-999-999-000-999-1015', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- sd_undetailed_derivatives	CAN-999-999-000-999-1010		0|0	1|1	0|0	0|0	1	1
(null, 'CAN-999-999-000-999-1010_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1010'), 'CAN-999-999-000-999-1010', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Add Prostate Bank Identifier and sample label To Sample View

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000003', 'Inventorymanagement', 'ViewSample', '', 'qc_cusm_prostate_bank_identifier', 'prostate_bank_participant_id', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- view_sample_joined_to_collection
(null, 'CAN-999-999-000-999-1094_QC-CUSM-000003', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1094'), 'CAN-999-999-000-999-1094', 
(SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000003'), 'QC-CUSM-000003', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

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
samp.sample_label,
samp.sample_category,
samp.deleted,

idents.identifier_value AS prostate_bank_participant_id	

FROM sample_masters as samp
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN misc_identifiers AS idents ON idents.participant_id=link.participant_id AND idents.deleted != 1 AND idents.identifier_name = 'prostate_bank_participant_id'
WHERE samp.deleted != 1;

-- Update laboratory staff

DELETE FROM `structure_permissible_values` WHERE `value` IN ('lucie hamel', 'eleonora scarlata villegas');
INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'lucie hamel', 'lucie hamel'),
(NULL, 'eleonora scarlata villegas', 'eleonora scarlata villegas');

SET @domain_id = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` LIKE 'custom_laboratory_staff');

DELETE FROM `structure_value_domains_permissible_values` WHERE  `structure_value_domain_id` IN (@domain_id);
INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'lucie hamel' AND `language_alias` = 'lucie hamel'), '20', 'yes', 'lucie hamel'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'eleonora scarlata villegas' AND `language_alias` = 'eleonora scarlata villegas'), '10', 'yes', 'eleonora scarlata villegas'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'other' AND `language_alias` = 'other'), '40', 'yes', 'other');

DELETE FROM `i18n` WHERE `id` IN ('lucie hamel', 'eleonora scarlata villegas');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('lucie hamel', 'global', 'Lucie Hamel', 'Lucie Hamel'),
('eleonora scarlata villegas', 'global', 'Eleonora Scarlata Villegas', 'Eleonora Scarlata Villegas');

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
WHERE `structure_field_id` IN (SELECT `id` FROM `structure_fields` WHERE `old_id` IN ('CAN-999-999-000-999-1030'));

-- Update blood type list

SET @domain_id = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` LIKE 'blood_type');

UPDATE structure_value_domains_permissible_values
SET active = 'no'
WHERE structure_value_domain_id = @domain_id
AND language_alias NOT IN ('gel CSA', 'heparine', 'unknown', 'EDTA');
   
DELETE FROM `i18n` WHERE `id` IN ('gel CSA');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('gel CSA', 'global', 'Gel CSA/SST', 'Gel de CSA/SST');



-- Add is micro RNA to RNA

-- TODO









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

-- Add aliquot label

ALTER TABLE `aliquot_masters` ADD `aliquot_label` VARCHAR(60) NOT NULL default '' AFTER `barcode`; 
ALTER TABLE `aliquot_masters_revs` ADD `aliquot_label` VARCHAR(60) NOT NULL default '' AFTER `barcode`; 

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000008', 'Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'aliquot_label', 'aliquot label', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @field_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- ad_spec_tubes_incl_ml_vol	CAN-999-999-000-999-1024		1|1	1|1	0|0	1|1	1	1
(null, 'CAN-999-999-000-999-1024_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1024'), 'CAN-999-999-000-999-1024', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- ad_spec_tiss_blocks	CAN-999-999-000-999-1028		1|1	1|1	0|0	1|1	1	1
(null, 'CAN-999-999-000-999-1028_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1028'), 'CAN-999-999-000-999-1028', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- ad_spec_whatman_papers	CAN-999-999-000-999-1030		1|1	1|1	0|0	1|1	1	1
(null, 'CAN-999-999-000-999-1030_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1030'), 'CAN-999-999-000-999-1030', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- ad_der_tubes_incl_ml_vol	CAN-999-999-000-999-1032		1|1	1|1	0|0	1|1	1	1
(null, 'CAN-999-999-000-999-1032_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1032'), 'CAN-999-999-000-999-1032', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- ad_der_tubes_incl_ul_vol_and_conc	CAN-999-999-000-999-1054		1|1	1|1	0|0	1|1	1	1
(null, 'CAN-999-999-000-999-1054_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1054'), 'CAN-999-999-000-999-1054', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- ad_der_cell_tubes_incl_ml_vol	CAN-999-999-000-999-1065		1|1	1|1	0|0	1|1	1	1
(null, 'CAN-999-999-000-999-1065_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1065'), 'CAN-999-999-000-999-1065', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- aliquotmasters	CAN-999-999-000-999-1079		0|0	0|0	0|0	0|0	1	0
(null, 'CAN-999-999-000-999-1079_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1079'), 'CAN-999-999-000-999-1079', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- aliquot_masters_for_collection_tree_view	CAN-999-999-000-999-1074		0|0	0|0	0|0	0|0	1	0
(null, 'CAN-999-999-000-999-1074_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1074'), 'CAN-999-999-000-999-1074', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- aliquot_masters_for_storage_tree_view	CAN-999-999-000-999-1076		0|0	0|0	0|0	0|0	1	0
(null, 'CAN-999-999-000-999-1076_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1076'), 'CAN-999-999-000-999-1076', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- realiquotedparent	CANM-00016		0|0	0|0	0|0	0|0	1	0
(null, 'CANM-00016_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CANM-00016'), 'CANM-00016', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- view_aliquot_joined_to_sample	CAN-999-999-000-999-1020	-AliqView	0|0	0|0	0|0	0|0	1	0
(null, 'CAN-999-999-000-999-1020_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1020'), 'CAN-999-999-000-999-1020', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- children_aliquots_selection	CANM-00011		0|0	0|0	0|0	1|1	0	0
(null, 'CANM-00011_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CANM-00011'), 'CANM-00011', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- qctestedaliquots	CAN-999-999-000-999-1071		0|0	0|0	0|0	1|1	1	0
(null, 'CAN-999-999-000-999-1071_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1071'), 'CAN-999-999-000-999-1071', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '1', '1', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- sourcealiquots	CAN-999-999-000-999-1036		0|0	0|0	0|0	1|1	1	0
(null, 'CAN-999-999-000-999-1036_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1036'), 'CAN-999-999-000-999-1036', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '1', '1', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- view_aliquot_joined_to_collection	CAN-999-999-000-999-1095	-AliqView	0|0	0|0	1|0	0|0	1	0
(null, 'CAN-999-999-000-999-1095_QC-CUSM-000007', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1095'), 'CAN-999-999-000-999-1095', 
@field_id, 'QC-CUSM-000007', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Add Prostate Bank Identifier and aliquot label To Aliquot View

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000009', 'Inventorymanagement', 'ViewAliquot', '', 'qc_cusm_prostate_bank_identifier', 'prostate_bank_participant_id', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- view_aliquot_joined_to_collection
(null, 'CAN-999-999-000-999-1095_QC-CUSM-000009', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1095'), 'CAN-999-999-000-999-1095', 
(SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000009'), 'QC-CUSM-000009', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

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
al.aliquot_label,
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

ALTER TABLE `ad_whatman_papers` ADD `creation_date` DATETIME NULL AFTER `used_blood_volume_unit` ;
ALTER TABLE `ad_whatman_papers_revs` ADD `creation_date` DATETIME NULL AFTER `used_blood_volume_unit` ;

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000004', 'Inventorymanagement', 'AliquotDetail', 'ad_whatman_papers', 'creation_date', 'creation date', '', 'datetime', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1030_QC-CUSM-000004', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1030'), 'CAN-999-999-000-999-1030', 
(SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000004'), 'QC-CUSM-000004', 
1, 72, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');




