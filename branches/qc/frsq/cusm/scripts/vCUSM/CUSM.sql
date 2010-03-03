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

-- Add Prostate Bank Identifier To Collection View

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000002', 'Inventorymanagement', 'ViewCollection', '', 'qc_cusm_prostate_bank_identifier', 'prostate_bank_participant_id', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CANM-00025_QC-CUSM-000002', (SELECT id FROM structures WHERE old_id = 'CANM-00025'), 
'CANM-00025', (SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000002'), 'QC-CUSM-000002', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
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

-- Manage available sample type

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

-- Add Prostate Bank Identifier To Sample View

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000003', 'Inventorymanagement', 'ViewSample', '', 'qc_cusm_prostate_bank_identifier', 'prostate_bank_participant_id', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1094_QC-CUSM-000003', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1094'), 
'CAN-999-999-000-999-1094', (SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000003'), 'QC-CUSM-000003', 
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

-- TODO

-- ******** ALIQUOT ******** 

UPDATE sample_to_aliquot_controls 
SET status = 'inactive'
WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE status = 'inactive');

UPDATE sample_to_aliquot_controls 
SET status = 'inactive'
WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type = 'tissue')
AND aliquot_control_id NOT IN (SELECT id FROM aliquot_controls WHERE aliquot_type = 'block');

UPDATE structure_value_domains_permissible_values
SET active = 'no'
WHERE structure_value_domain_id = (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'aliquot_type')
AND language_alias IN ('cell gel matrix', 'core', 'slide');


