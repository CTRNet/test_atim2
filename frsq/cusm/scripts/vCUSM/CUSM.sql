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
`language_label` = 'first name',
`flag_override_tag` = '1',
`language_tag` = ''
WHERE `old_id` = 'CAN-999-999-000-999-1_CAN-999-999-000-999-1'; 

INSERT INTO `structure_validations` 
(`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-CUSM-000001', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-1'), 'CAN-999-999-000-999-1', 'notEmpty', '0', '0', '', 'first name and last name are required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `structure_formats`
SET 
`flag_override_label` = '1',
`language_label` = 'last name',
`flag_override_tag` = '1',
`language_tag` = ''
WHERE `old_id` = 'CAN-999-999-000-999-1_CAN-999-999-000-999-2'; 
 
INSERT INTO `structure_validations` 
(`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-CUSM-000002', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-2'), 'CAN-999-999-000-999-2', 'notEmpty', '0', '0', '', 'first name and last name are required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 
DELETE FROM `i18n` WHERE `id` IN ('first name and last name are required');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('first name and last name are required', 'global', 'First name and last name are required!', 'Le nom et prénom sont requis!');

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

-- cod_confirmation_source, secondary_cod_icd10_code, cod_icd10_code : Hidden
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
WHERE `old_id` IN ('CAN-999-999-000-999-1_CAN-999-999-000-999-25', 'CAN-999-999-000-999-1_CAN-895', 'CAN-999-999-000-999-1_CAN-999-999-000-999-24');

-- marital_status : Hidden
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
WHERE `old_id` IN ('CAN-999-999-000-999-1_CAN-999-999-000-999-296');

-- ... CONSENT ...

CREATE TABLE IF NOT EXISTS `qc_cusm_cd_undetailled` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consent_master_id` int(11) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `consent_master_id` (`consent_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_cusm_cd_undetailled`
  ADD CONSTRAINT `FK_qc_cusm_cd_undetailled_consent_masters` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`);

CREATE TABLE IF NOT EXISTS `qc_cusm_cd_undetailled_revs` (
  `id` int(11) NOT NULL,
  `consent_master_id` int(11) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DELETE FROM `consent_controls`;
INSERT INTO `consent_controls` 
(`id`, `controls_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(null, 'cusm prostate bank consent', 'active', 'qc_cusm_prostate_bank_consents', 'qc_cusm_cd_undetailled', 0);

DELETE FROM `i18n` WHERE `id` IN ('cusm prostate bank consent');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('cusm prostate bank consent', 'global', 'Consent Form - Alliance Procure', 'Consentement - Alliance ProCURE');

INSERT INTO `structures` 
(`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-CUSM-000001', 'qc_cusm_prostate_bank_consents', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

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

-- clean up consent master

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
WHERE `structure_field_old_id` NOT IN (
'CAN-999-999-000-999-57',	-- consent status
'CAN-046-003-000-999-1',	-- status date
'CAN-999-999-000-999-53')	-- form version
AND `structure_old_id` IN ('GENERATED-188');

-- ... DIAGNOSTIC ...

DELETE FROM `diagnosis_controls`;

INSERT INTO `diagnosis_controls` (`id`, `controls_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(null, 'prostate procure diagnosis', 'active', 'qc_cusm_dxd_procure', 'qc_cusm_dxd_procure', 0);

DELETE FROM `i18n` WHERE `id` IN ('procure');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('prostate procure diagnosis', 'global', 'Prostate - Procure Diagnosis', 'Prostate - Diagnostic Procure');

CREATE TABLE IF NOT EXISTS `qc_cusm_dxd_procure` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  `other_morphology` varchar(50) NULL,
  `ptnm_version` varchar(50) NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_cusm_dxd_procure`
  ADD CONSTRAINT `FK_qc_cusm_dxd_procure_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

CREATE TABLE IF NOT EXISTS `qc_cusm_dxd_procure_revs` (
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,  
  `other_morphology` varchar(50) NULL,
  `ptnm_version` varchar(50) NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- change morphology to histo/morpho + create domains

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`) VALUES
(null, 'qc_cusm_histology_values', 'open', '');

SET @histo_domain_id = LAST_INSERT_ID();

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'adenocarcinoma / well differentiated', 'adenocarcinoma / well differentiated'),
(NULL, 'adenocarcinoma / poorly differentiated', 'adenocarcinoma / poorly differentiated'),
(NULL, 'prostatic duct adenocarcinoma', 'prostatic duct adenocarcinoma'),
(NULL, 'mucinous (colloid) adenocarcinoma', 'mucinous (colloid) adenocarcinoma'),
(NULL, 'signet-ring cell carcinoma', 'signet-ring cell carcinoma'),
(NULL, 'adenosquamous carcinoma', 'adenosquamous carcinoma'),
(NULL, 'small cell carcinoma', 'small cell carcinoma'),
(NULL, 'sarcomatoid carcinoma', 'sarcomatoid carcinoma');

INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , @histo_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'adenocarcinoma / well differentiated'), '1', 'yes', 'adenocarcinoma / well differentiated'),
(NULL , @histo_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'adenocarcinoma / poorly differentiated'), '1', 'yes', 'adenocarcinoma / poorly differentiated'),
(NULL , @histo_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'prostatic duct adenocarcinoma'), '1', 'yes', 'prostatic duct adenocarcinoma'),
(NULL , @histo_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'mucinous (colloid) adenocarcinoma'), '1', 'yes', 'mucinous (colloid) adenocarcinoma'),
(NULL , @histo_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'signet-ring cell carcinoma'), '1', 'yes', 'signet-ring cell carcinoma'),
(NULL , @histo_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'adenosquamous carcinoma'), '1', 'yes', 'adenosquamous carcinoma'),
(NULL , @histo_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'small cell carcinoma'), '1', 'yes', 'small cell carcinoma'),
(NULL , @histo_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'sarcomatoid carcinoma'), '1', 'yes', 'sarcomatoid carcinoma'),
(NULL , @histo_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'other'), '1', 'yes', 'other');

DELETE FROM `i18n` WHERE `id` IN ('adenocarcinoma / well differentiated', 'adenocarcinoma / poorly differentiated',
'prostatic duct adenocarcinoma', 'mucinous (colloid) adenocarcinoma', 'signet-ring cell carcinoma',
'adenosquamous carcinoma', 'small cell carcinoma', 'sarcomatoid carcinoma');
INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('adenocarcinoma / well differentiated', '', 'Adenocarcinoma / well differentiated', 'Adénocarcinome / bien différencié'),
('adenocarcinoma / poorly differentiated', '', 'Adenocarcinoma / poorly differentiated', 'Adénocarcinome / peu différencié'),
('prostatic duct adenocarcinoma', '', 'Prostatic duct adenocarcinoma', 'Adénocarcinome ductal'),
('mucinous (colloid) adenocarcinoma', '', 'Mucinous (colloid) adenocarcinoma', 'Adénocarcinome mucineux'),
('signet-ring cell carcinoma', '', 'Signet-ring cell carcinoma', 'Carcinome à cellules indépendantes (Signet-ring cell)'),
('adenosquamous carcinoma', '', 'Adenosquamous carcinoma', 'Carcinome adénosquameux'),
('small cell carcinoma', '', 'Small cell carcinoma', 'Carcinome à petites cellules'),
('sarcomatoid carcinoma', '', 'Sarcomatoid carcinoma', 'Carcinome sarcomato�de');

UPDATE structure_fields
SET type  = 'select',
setting = '',
structure_value_domain = @histo_domain_id,
language_label = 'morphology (histology)'
WHERE old_id LIKE 'CAN-999-999-000-999-324';

DELETE FROM `i18n` WHERE `id` IN ('morphology (histology)');
INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('morphology (histology)', '', 'Morphology (Histology)', 'Morphologie (Histologie)');

-- histology other precision

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000024', 'Clinicalannotation', 'DiagnosisDetail', 'qc_cusm_dxd_procure', 'other_morphology', 'other morphology data', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('other morphology data');
INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('other morphology data', '', 'Other (details)', 'Autre (détails)');

-- ptnm version

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000025', 'Clinicalannotation', 'DiagnosisDetail', 'qc_cusm_dxd_procure', 'ptnm_version', 'version', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
INSERT IGNORE INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES ('version', '', 'Version', 'Version');

-- change pTNM to select fields

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`) VALUES
(null, 'qc_cusm_ptnm_pt', 'open', '');

SET @pt_domain_id = LAST_INSERT_ID();

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'pTx', 'pTx'),
(NULL, 'pT2', 'pT2'),
(NULL, 'pT2a', 'pT2a'),
(NULL, 'pT2b', 'pT2b'),
(NULL, 'pT2c', 'pT2c'),
(NULL, 'pT3b', 'pT3b'),
(NULL, 'pT4', 'pT4');

INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , @pt_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pTx'), '1', 'yes', 'pTx'),
(NULL , @pt_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pT2'), '1', 'yes', 'pT2'),
(NULL , @pt_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pT2a'), '1', 'yes', 'pT2a'),
(NULL , @pt_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pT2b'), '1', 'yes', 'pT2b'),
(NULL , @pt_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pT2c'), '1', 'yes', 'pT2c'),
(NULL , @pt_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pT3a'), '1', 'yes', 'pT3a'),
(NULL , @pt_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pT3b'), '1', 'yes', 'pT3b'),
(NULL , @pt_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pT4'), '1', 'yes', 'pT4');

DELETE FROM `i18n` WHERE `id` IN ('pTx', 'pT2', 'pT2a', 'pT2b', 'pT2c', 'pT3a', 'pT3b', 'pT4');
INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('pTx', '', 'pTx: Insufficient data', 'pTx : Renseignements insuffisants'),
('pT2', '', 'pT2: Organ confined', 'pT2: Confinée à la prostate'),
('pT2a', '', 'pT2a: Unilateral, involving one-half of one side (''lobe'') or less', 'pT2a: Unilatérale, envahissant la moitié ou moins d''un lobe'),
('pT2b', '', 'pT2b: Unilateral, involving more than one-half of one side (''lobe'') but not both', 'pT2b: Unilatérale, envahissant plus de la moitié d''un lobe mais pas les deux'),
('pT2c', '', 'pT2c: Bilateral disease', 'pT2c: Bilatérale'),
('pT3a', '', 'pT3a: Extracapsular extension (uni-or bi-lateral)', 'pT3a: Extension extracapsulaire (uni- ou bi-latérale)'),
('pT3b', '', 'pT3b: Seminal vesicle invasion', 'pT3b: Envahissant les vésicules séminales'),
('pT4', '', 'pT4: Fixed or invading other adjacent structures such as bladder and/or rectum', 'pT4: Fixe ou envahissant d''autres structures adjacentes telles le rectum et/ou la vessie');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`) VALUES
(null, 'qc_cusm_ptnm_pn', 'open', '');

SET @pn_domain_id = LAST_INSERT_ID();

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'pNx', 'pNx'),
(NULL, 'pN0', 'pN0'),
(NULL, 'pN1', 'pN1');

INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , @pn_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pNx'), '1', 'yes', 'pNx'),
(NULL , @pn_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pN0'), '2', 'yes', 'pN0'),
(NULL , @pn_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pN1'), '3', 'yes', 'pN1');

DELETE FROM `i18n` WHERE `id` IN ('pNx', 'pN0', 'pN1');
INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('pNx', '', 'pNx: Insufficient data', 'pNx: Renseignements insuffisants'),
('pN0', '', 'pN0: No regional lymph node metastasis', 'pN0: Pas d''atteinte des ganglions lymphatiques régionaux'),
('pN1', '', 'pN1: Metastasis in regional lymph node(s)', 'pN1: Atteinte des ganglions lymphatiques régionaux');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`) VALUES
(null, 'qc_cusm_ptnm_pm', 'open', '');

SET @pm_domain_id = LAST_INSERT_ID();

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'pMx', 'pMx'),
(NULL, 'pM0', 'pM0'),
(NULL, 'pM1', 'pM1'),
(NULL, 'pM1a', 'pM1a'),
(NULL, 'pM1b', 'pM1b'),
(NULL, 'pM1c', 'pM1c');

INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , @pm_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pMx'), '1', 'yes', 'pMx'),
(NULL , @pm_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pM0'), '2', 'yes', 'pM0'),
(NULL , @pm_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pM1'), '3', 'yes', 'pM1'),
(NULL , @pm_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pM1a'), '4', 'yes', 'pM1a'),
(NULL , @pm_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pM1b'), '5', 'yes', 'pM1b'),
(NULL , @pm_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'pM1c'), '6', 'yes', 'pM1c');

DELETE FROM `i18n` WHERE `id` IN ('', '', '', '', '', '');
INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('pMx', '', 'pMx: Insufficient data', 'pMx: Renseignements insuffisants'),
('pM0', '', 'pM0: None', 'pM0: Aucune'),
('pM1', '', 'pM1: Distant metastasis', 'pM1: Métastases à distance'),
('pM1a', '', 'pM1a: Non-regional lymph node(s)', 'pM1a: Ganglions lymphatiques (adénopathies) non régionaux'),
('pM1b', '', 'pM1b: Bone', 'pM1b: Os'),
('pM1c', '', 'pM1c: Other site(s)', 'pM1c: Autre(s) site(s)');

UPDATE structure_fields
SET type  = 'select',
setting = '',
structure_value_domain = @pt_domain_id,
language_label = 't stage',
language_tag = ''
WHERE old_id LIKE 'CAN-999-999-000-999-87';

UPDATE structure_fields
SET type  = 'select',
setting = '',
structure_value_domain = @pn_domain_id,
language_label = 'n stage',
language_tag = ''
WHERE old_id LIKE 'CAN-999-999-000-999-88';

UPDATE structure_fields
SET type  = 'select',
setting = '',
structure_value_domain = @pm_domain_id,
language_label = 'm stage',
language_tag = ''
WHERE old_id LIKE 'CAN-999-999-000-999-89';

UPDATE structure_fields
SET 
language_label = 'summary',
language_tag = ''
WHERE old_id LIKE 'CAN-999-999-000-999-90';

-- build structure

INSERT INTO `structures` 
(`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-CUSM-000005', 'qc_cusm_dxd_procure', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @dx_structure_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- DiagnosisMaster.dx_identifier	CAN-812
-- (null, 'QC-CUSM-000005_CAN-812', @dx_structure_id, 'QC-CUSM-000005', 
-- (SELECT id FROM structure_fields WHERE old_id LIKE 'CAN-812'), 'CAN-812', 1, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- DiagnosisMaster.primary_number	CAN-999-999-000-999-76
(null, 'QC-CUSM-000005_CAN-999-999-000-999-76', @dx_structure_id, 'QC-CUSM-000005', 
(SELECT id FROM structure_fields WHERE old_id LIKE 'CAN-999-999-000-999-76'), 'CAN-999-999-000-999-76', 1, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- DiagnosisMaster.dx_origin	CAN-999-999-000-999-91
(null, 'QC-CUSM-000005_CAN-999-999-000-999-91', @dx_structure_id, 'QC-CUSM-000005', 
(SELECT id FROM structure_fields WHERE old_id LIKE 'CAN-999-999-000-999-91'), 'CAN-999-999-000-999-91', 1, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- DiagnosisMaster.dx_date	CAN-999-999-000-999-71
(null, 'QC-CUSM-000005_CAN-999-999-000-999-71', @dx_structure_id, 'QC-CUSM-000005', 
(SELECT id FROM structure_fields WHERE old_id LIKE 'CAN-999-999-000-999-71'), 'CAN-999-999-000-999-71', 1, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- DiagnosisMaster.dx_date_accuracy	CAN-828
(null, 'QC-CUSM-000005_CAN-828', @dx_structure_id, 'QC-CUSM-000005', 
(SELECT id FROM structure_fields WHERE old_id LIKE 'CAN-828'), 'CAN-828', 1, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- DiagnosisMaster.dx_nature	CAN-999-999-000-999-70
(null, 'QC-CUSM-000005_CAN-999-999-000-999-70', @dx_structure_id, 'QC-CUSM-000005', 
(SELECT id FROM structure_fields WHERE old_id LIKE 'CAN-999-999-000-999-70'), 'CAN-999-999-000-999-70', 1, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- DiagnosisMaster.notes	CAN-896
(null, 'QC-CUSM-000005_CAN-896', @dx_structure_id, 'QC-CUSM-000005', 
(SELECT id FROM structure_fields WHERE old_id LIKE 'CAN-896'), 'CAN-896', 1, 13, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),

-- DiagnosisMaster.morphology	CAN-999-999-000-999-324
(null, 'QC-CUSM-000005_CAN-999-999-000-999-324', @dx_structure_id, 'QC-CUSM-000005', 
(SELECT id FROM structure_fields WHERE old_id LIKE 'CAN-999-999-000-999-324'), 'CAN-999-999-000-999-324', 2, 7, 'coding', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- DiagnosisDetail.other_morphology	QC-CUSM-000024
(null, 'QC-CUSM-000005_QC-CUSM-000024', @dx_structure_id, 'QC-CUSM-000005', 
(SELECT id FROM structure_fields WHERE old_id LIKE 'QC-CUSM-000024'), 'QC-CUSM-000024', 2, 8, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),

-- DiagnosisMaster.path_tstage	CAN-999-999-000-999-87
(null, 'QC-CUSM-000005_CAN-999-999-000-999-87', @dx_structure_id, 'QC-CUSM-000005', 
(SELECT id FROM structure_fields WHERE old_id LIKE 'CAN-999-999-000-999-87'), 'CAN-999-999-000-999-87', 2, 23, 'pathological stage', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- DiagnosisMaster.path_nstage	CAN-999-999-000-999-88
(null, 'QC-CUSM-000005_CAN-999-999-000-999-88', @dx_structure_id, 'QC-CUSM-000005', 
(SELECT id FROM structure_fields WHERE old_id LIKE 'CAN-999-999-000-999-88'), 'CAN-999-999-000-999-88', 2, 24, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- DiagnosisMaster.path_mstage	CAN-999-999-000-999-89
(null, 'QC-CUSM-000005_CAN-999-999-000-999-89', @dx_structure_id, 'QC-CUSM-000005', 
(SELECT id FROM structure_fields WHERE old_id LIKE 'CAN-999-999-000-999-89'), 'CAN-999-999-000-999-89', 2, 24, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- DiagnosisMaster.path_stage_summary	CAN-999-999-000-999-90
(null, 'QC-CUSM-000005_CAN-999-999-000-999-90', @dx_structure_id, 'QC-CUSM-000005', 
(SELECT id FROM structure_fields WHERE old_id LIKE 'CAN-999-999-000-999-90'), 'CAN-999-999-000-999-90', 2, 25, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL'),
-- DiagnosisDetail.ptnm_version	QC-CUSM-000025
(null, 'QC-CUSM-000005_QC-CUSM-000025', @dx_structure_id, 'QC-CUSM-000005', 
(SELECT id FROM structure_fields WHERE old_id LIKE 'QC-CUSM-000025'), 'QC-CUSM-000025', 2, 26, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', 'NL');

-- clean up diagnosis master

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
WHERE `structure_field_old_id` NOT IN (
'CAN-999-999-000-999-76',	-- Clinicalannotation.DiagnosisMaster.primary_number
'CAN-999-999-000-999-91',	-- Clinicalannotation.DiagnosisMaster.dx_origin
'CAN-999-999-000-999-71',	-- Clinicalannotation.DiagnosisMaster.dx_date
'CAN-999-999-000-999-70',	-- Clinicalannotation.DiagnosisMaster.dx_nature
'CAN-999-999-000-999-324')	-- Clinicalannotation.DiagnosisMaster.morphology
AND `structure_old_id` IN ('CANM-00010');

-- ******** ANNOTATION ******** 

UPDATE `menus` SET `active` = 'no' WHERE `parent_id` LIKE 'clin_CAN_4' AND language_title NOT IN ('lab', 'lifestyle');
UPDATE `menus` SET `use_link` = '/clinicalannotation/event_masters/listall/lab/%%Participant.id%%'  WHERE `id` LIKE 'clin_CAN_4';

DELETE FROM `event_controls`;

-- Life style

CREATE TABLE IF NOT EXISTS `qc_cusm_ed_procure_lifestyle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `form_version` varchar(30) NULL,
  `delivery_date` date NULL,
  `reception_date` date NULL,
  `completed` varchar(10) NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_cusm_ed_procure_lifestyle`
  ADD CONSTRAINT `FK_qc_cusm_ed_procure_lifestyle_event_masters` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `qc_cusm_ed_procure_lifestyle_revs` (
  `id` int(11) NOT NULL,
  `form_version` varchar(30) NULL,
  `delivery_date` date NULL,
  `reception_date` date NULL,
  `completed` varchar(10) NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(null, 'prostate', 'lifestyle', 'procure lifestyle form', 'active', 'qc_cusm_ed_procure_lifestyle', 'qc_cusm_ed_procure_lifestyle', 0);
INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES ('procure lifestyle form', '', 'Procure Lifestyle Form', 'Formulaire habitude de vie Procure');

INSERT INTO `structures` (`id`, `old_id`, `alias`, `description`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'QC-CUSM-000004', 'qc_cusm_ed_procure_lifestyle', NULL, '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @structure_id = LAST_INSERT_ID();

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`) VALUES
(null, 'qc_cusm_lifestyle_form_version', 'open', '');

SET @version_domain_id = LAST_INSERT_ID();

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'fr october 2006', 'fr october 2006'),
(NULL, 'en october 2006', 'en october 2006');

INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , @version_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'fr october 2006'), '20', 'yes', 'fr october 2006'),
(NULL , @version_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'en october 2006'), '21', 'yes', 'en october 2006'),
(NULL , @version_domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'other'), '50', 'yes', 'other');

DELETE FROM `i18n` WHERE `id` IN ('fr october 2006', 'en october 2006');
INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('fr october 2006', 'global', 'FR - October 2006', 'FR - Octobre 2006'),
('en october 2006', 'global', 'ENG - October 2006', 'ANG - Octobre 2006');

SET @yesno_domain_id = (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yesno');

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000020', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_lifestyle', 'form_version', 'form version', '', 'select', '', '', @version_domain_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-CUSM-000021', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_lifestyle', 'delivery_date', 'delivery date', '', 'date', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-CUSM-000022', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_lifestyle', 'reception_date', 'reception date', '', 'date', '', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, '', 'QC-CUSM-000023', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_lifestyle', 'completed', 'completed', '', 'select', '', '', @yesno_domain_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('form version', 'delivery date', 'completion date');
INSERT INTO `i18n` ( `id` , `page_id` , `en` , `fr` )
VALUES
('form version', '', 'Form Version', 'Version du formulaire'),
('delivery date', '', 'Delivery Date', 'Date de délivrance'),
('completion date', '', 'Completion Date', 'Date de complétion');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- disease_site
(null, 'QC-CUSM-000004_CAN-999-999-000-999-227', 
@structure_id, 'QC-CUSM-000004', 
(SELECT id FROM `structure_fields` WHERE `old_id` LIKE 'CAN-999-999-000-999-227'), 'CAN-999-999-000-999-227', 
0, 1, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', ''),
-- event_type
(null, 'QC-CUSM-000004_CAN-999-999-000-999-228', 
@structure_id, 'QC-CUSM-000004', 
(SELECT id FROM `structure_fields` WHERE `old_id` LIKE 'CAN-999-999-000-999-228'), 'CAN-999-999-000-999-228', 
0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', ''),
-- completed
(null, 'QC-CUSM-000004_QC-CUSM-000023', 
@structure_id, 'QC-CUSM-000004', 
(SELECT id FROM `structure_fields` WHERE `old_id` LIKE 'QC-CUSM-000023'), 'QC-CUSM-000023', 
0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', ''),
-- event_date
(null, 'QC-CUSM-000004_CAN-999-999-000-999-229', 
@structure_id, 'QC-CUSM-000004', 
(SELECT id FROM `structure_fields` WHERE `old_id` LIKE 'CAN-999-999-000-999-229'), 'CAN-999-999-000-999-229', 
0, 6, '', '1', 'completion date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', ''),
-- form_version
(null, 'QC-CUSM-000004_QC-CUSM-000020', 
@structure_id, 'QC-CUSM-000004', 
(SELECT id FROM `structure_fields` WHERE `old_id` LIKE 'QC-CUSM-000020'), 'QC-CUSM-000020', 
0, 4, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', ''),
-- delivery_date
(null, 'QC-CUSM-000004_QC-CUSM-000021', 
@structure_id, 'QC-CUSM-000004', 
(SELECT id FROM `structure_fields` WHERE `old_id` LIKE 'QC-CUSM-000021'), 'QC-CUSM-000021', 
1, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', ''),
-- reception_date
(null, 'QC-CUSM-000004_QC-CUSM-000022', 
@structure_id, 'QC-CUSM-000004', 
(SELECT id FROM `structure_fields` WHERE `old_id` LIKE 'QC-CUSM-000022'), 'QC-CUSM-000022', 
1, 21, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', ''),
-- event_summary
(null, 'QC-CUSM-000004_CAN-999-999-000-999-230', 
@structure_id, 'QC-CUSM-000004', 
(SELECT id FROM `structure_fields` WHERE `old_id` LIKE 'CAN-999-999-000-999-230'), 'CAN-999-999-000-999-230', 
1, 99, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '2010-02-12 00:00:00', '');

-- Life style

CREATE TABLE IF NOT EXISTS `qc_cusm_ed_procure_prostate_path_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,

  `report_number` varchar(50) NULL,
  `pathologist_name` varchar(50) NULL,

  `prostate_weight` decimal(10,3) default NULL COMMENT 'unit (gr)',
  `prostate_lenght` decimal(10,3) default NULL COMMENT 'unit (cm)',
  `prostate_width` decimal(10,3) default NULL COMMENT 'unit (cm)',
  `prostate_height` decimal(10,3) default NULL COMMENT 'unit (cm)',
    
  `rgt_seminal_vesicles_lenght` decimal(10,3) default NULL COMMENT 'unit (cm)',
  `rgt_seminal_vesicles_width` decimal(10,3) default NULL COMMENT 'unit (cm)',
  `rgt_seminal_vesicles_height` decimal(10,3) default NULL COMMENT 'unit (cm)',

  `lft_seminal_vesicles_lenght` decimal(10,3) default NULL COMMENT 'unit (cm)',
  `lft_seminal_vesicles_width` decimal(10,3) default NULL COMMENT 'unit (cm)',
  `lft_seminal_vesicles_height` decimal(10,3) default NULL COMMENT 'unit (cm)',
   
  `tumour_location_rgt_anterior` varchar(50) NULL,
  `tumour_location_rgt_posterior` varchar(50) NULL,
  `tumour_location_lft_anterior` varchar(50) NULL,
  `tumour_location_lft_posterior` varchar(50) NULL,
  `tumour_location_apex` varchar(50) NULL,
  `tumour_location_base` varchar(50) NULL,
  `tumour_location_bladder_neck` varchar(50) NULL,

  `primary_grade` varchar(20) NULL,
  `secondary_grade` varchar(20) NULL,
  `tertiary_grade` varchar(20) NULL,
  `gleason_score` varchar(20) NULL,
   
  `margin_status` varchar(20) NULL,
  `margin_focal` varchar(20) NULL,
  `margin_position_apical` varchar(10) NULL,
  `margin_position_bladder_neck` varchar(10) NULL,
  `margin_position_lft_anterior` varchar(10) NULL,
  `margin_position_rgt_anterior` varchar(10) NULL,
  `margin_position_lft_posterior` varchar(10) NULL,
  `margin_position_rgt_posterior` varchar(10) NULL,
   
  `extracapsular_invasion_status` varchar(10) NULL,
  `focal_extracapsular_invasion` varchar(10) NULL,
  `established_extracapsular_invasion` varchar(10) NULL,
  
  `rgt_ant_quadrant_extracapsular_invasion` varchar(10) NULL,
  `rgt_post_quadrant_extracapsular_invasion` varchar(10) NULL,
  `lft_ant_quadrant_extracapsular_invasion` varchar(10) NULL,
  `lft_post_quadrant_extracapsular_invasion` varchar(10) NULL,
  `seminal_vesicles_extracapsular_invasion` varchar(10) NULL,

  `lymph_nodes_collected` varchar(10) NULL,
  `examined_lymph_nodes_nbr` int(5) NULL,
  `involved_lymph_nodes_nbr` int(5) NULL,

  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_cusm_ed_procure_prostate_path_report`
  ADD CONSTRAINT `FK_qc_cusm_ed_procure_prostate_path_report_event_masters` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `qc_cusm_ed_procure_prostate_path_report_revs` (
  `id` int(11) NOT NULL,

  `report_number` varchar(50) NULL,
  `pathologist_name` varchar(50) NULL,

  `prostate_weight` decimal(10,3) default NULL COMMENT 'unit (gr)',
  `prostate_lenght` decimal(10,3) default NULL COMMENT 'unit (cm)',
  `prostate_width` decimal(10,3) default NULL COMMENT 'unit (cm)',
  `prostate_height` decimal(10,3) default NULL COMMENT 'unit (cm)',
    
  `rgt_seminal_vesicles_lenght` decimal(10,3) default NULL COMMENT 'unit (cm)',
  `rgt_seminal_vesicles_width` decimal(10,3) default NULL COMMENT 'unit (cm)',
  `rgt_seminal_vesicles_height` decimal(10,3) default NULL COMMENT 'unit (cm)',

  `lft_seminal_vesicles_lenght` decimal(10,3) default NULL COMMENT 'unit (cm)',
  `lft_seminal_vesicles_width` decimal(10,3) default NULL COMMENT 'unit (cm)',
  `lft_seminal_vesicles_height` decimal(10,3) default NULL COMMENT 'unit (cm)',
   
  `tumour_location_rgt_anterior` varchar(50) NULL,
  `tumour_location_rgt_posterior` varchar(50) NULL,
  `tumour_location_lft_anterior` varchar(50) NULL,
  `tumour_location_lft_posterior` varchar(50) NULL,
  `tumour_location_apex` varchar(50) NULL,
  `tumour_location_base` varchar(50) NULL,
  `tumour_location_bladder_neck` varchar(50) NULL,

  `primary_grade` varchar(20) NULL,
  `secondary_grade` varchar(20) NULL,
  `tertiary_grade` varchar(20) NULL,
  `gleason_score` varchar(20) NULL,
   
  `margin_status` varchar(20) NULL,
  `margin_focal` varchar(20) NULL,
  `margin_position_apical` varchar(10) NULL,
  `margin_position_bladder_neck` varchar(10) NULL,
  `margin_position_lft_anterior` varchar(10) NULL,
  `margin_position_rgt_anterior` varchar(10) NULL,
  `margin_position_lft_posterior` varchar(10) NULL,
  `margin_position_rgt_posterior` varchar(10) NULL,
   
  `extracapsular_invasion_status` varchar(10) NULL,
  `focal_extracapsular_invasion` varchar(10) NULL,
  `established_extracapsular_invasion` varchar(10) NULL,
  
  `rgt_ant_quadrant_extracapsular_invasion` varchar(10) NULL,
  `rgt_post_quadrant_extracapsular_invasion` varchar(10) NULL,
  `lft_ant_quadrant_extracapsular_invasion` varchar(10) NULL,
  `lft_post_quadrant_extracapsular_invasion` varchar(10) NULL,
  `seminal_vesicles_extracapsular_invasion` varchar(10) NULL,

  `lymph_nodes_collected` varchar(10) NULL,
  `examined_lymph_nodes_nbr` int(5) NULL,
  `involved_lymph_nodes_nbr` int(5) NULL,

  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(null, 'prostate', 'lab', 'procure path report', 'active', 'qc_cusm_ed_procure_prostate_path_report', 'qc_cusm_ed_procure_prostate_path_report', 0);
INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES ('procure path report', '', 'Procure Path Report', 'Rapport Pathologie Procure');

INSERT INTO `structures` 
(`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-CUSM-000006', 'qc_cusm_ed_procure_prostate_path_report', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`)
 VALUES 
 ('qc_cusm_grade', '', '');
 
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('grade 1', 'grade 1'),
('grade 2', 'grade 2'),
('grade 3', 'grade 3'),
('grade 4', 'grade 4'),
('grade 5', 'grade 5');

DELETE FROM `i18n` WHERE `id` IN ('grade 1', 'grade 2', 'grade 3', 'grade 4', 'grade 5');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('grade 1', 'global', '1', '1'),
('grade 2', 'global', '2', '2'),
('grade 3', 'global', '3', '3'),
('grade 4', 'global', '4', '4'),
('grade 5', 'global', '5', '5');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name='qc_cusm_grade'),  
(SELECT id FROM structure_permissible_values WHERE `value`='grade 1' AND language_alias='grade 1'), '1', 'yes'),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_cusm_grade'),  
(SELECT id FROM structure_permissible_values WHERE `value`='grade 2' AND language_alias='grade 2'), '2', 'yes'),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_cusm_grade'),  
(SELECT id FROM structure_permissible_values WHERE `value`='grade 3' AND language_alias='grade 3'), '3', 'yes'),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_cusm_grade'),  
(SELECT id FROM structure_permissible_values WHERE `value`='grade 4' AND language_alias='grade 4'), '4', 'yes'),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_cusm_grade'),  
(SELECT id FROM structure_permissible_values WHERE `value`='grade 5' AND language_alias='grade 5'), '5', 'yes');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`)
 VALUES 
 ('margin_status', '', '');
 
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('cannot be assessed', 'cannot be assessed'),
('negative', 'negative'),
('positive', 'positive');

DELETE FROM `i18n` WHERE `id` IN ('cannot be assessed', 'negative', 'positive');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('cannot be assessed', 'global', 'Cannot Be Assessed', 'Ne peuvent être évaluées'),
('negative', 'global', 'Negative', 'Négative'),
('positive', 'global', 'Positive', 'Positive');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name='margin_status'),  
(SELECT id FROM structure_permissible_values WHERE `value`='cannot be assessed' AND language_alias='cannot be assessed'), '1', 'yes'),
((SELECT id FROM structure_value_domains WHERE domain_name='margin_status'),  
(SELECT id FROM structure_permissible_values WHERE `value`='negative' AND language_alias='negative'), '2', 'yes'),
((SELECT id FROM structure_value_domains WHERE domain_name='margin_status'),  
(SELECT id FROM structure_permissible_values WHERE `value`='positive' AND language_alias='positive'), '3', 'yes');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`)
 VALUES 
 ('margin_focal', '', '');
 
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('unifocal', 'unifocal'),
('multifocal', 'multifocal');

DELETE FROM `i18n` WHERE `id` IN ('unifocal', 'multifocal');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('unifocal', 'global', 'UniFocal', 'UniFocale'),
('multifocal', 'global', 'MultiFocal', 'MultiFocale');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name='margin_focal'),  
(SELECT id FROM structure_permissible_values WHERE `value`='unifocal' AND language_alias='unifocal'), '1', 'yes'),
((SELECT id FROM structure_value_domains WHERE domain_name='margin_focal'),  
(SELECT id FROM structure_permissible_values WHERE `value`='multifocal' AND language_alias='multifocal'), '2', 'yes');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`)
 VALUES 
 ('qc_cusm_absent_present', '', '');
 
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('absent', 'absent'),
('present', 'present');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name='qc_cusm_absent_present'),  
(SELECT id FROM structure_permissible_values WHERE `value`='absent' AND language_alias='absent'), '1', 'yes'),
((SELECT id FROM structure_value_domains WHERE domain_name='qc_cusm_absent_present'),  
(SELECT id FROM structure_permissible_values WHERE `value`='present' AND language_alias='present'), '2', 'yes');

INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'QC-CUSM-000027', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'report_number', 'report number', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000028', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'pathologist_name', 'pathologist name', '', 'input', 'size=30', '', null, '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000029', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'prostate_weight', 'weight', '', 'input', 'size=7', '', null, '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000030', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'prostate_lenght', 'lenght', '', 'input', 'size=7', '', null, '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000031', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'prostate_width', 'width', '', 'input', 'size=7', '', null, '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000032', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'rgt_seminal_vesicles_lenght', 'lenght', '', 'input', 'size=7', '', null, '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000033', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'rgt_seminal_vesicles_width', 'width', '', 'input', 'size=7', '', null, '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000034', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'rgt_seminal_vesicles_height', 'height', '', 'input', 'size=7', '', null, '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000035', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'lft_seminal_vesicles_lenght', 'lenght', '', 'input', 'size=7', '', null, '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000036', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'lft_seminal_vesicles_width', 'width', '', 'input', 'size=7', '', null, '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000037', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'lft_seminal_vesicles_height', 'height', '', 'input', 'size=7', '', null, '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000038', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'primary_grade', 'primary grade', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_cusm_grade'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000039', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'secondary_grade', 'secondary grade', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_cusm_grade'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000040', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'tertiary_grade', 'tertiary grade', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_cusm_grade'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000041', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'gleason_score', 'gleason score', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000042', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'margin_status', 'margin status', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'margin_status'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000043', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'margin_focal', 'margin focal', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'margin_focal'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000044', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'margin_position_apical', 'apical', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000045', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'margin_position_bladder_neck', 'bladder neck', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000046', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'margin_position_lft_anterior', 'left anterior', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000047', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'margin_position_rgt_anterior', 'right anterior', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000048', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'margin_position_lft_posterior', 'left posterior', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000049', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'margin_position_rgt_posterior', 'right posterior', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000050', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'extracapsular_invasion_status', 'extracapsular invasion status', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'qc_cusm_absent_present'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000051', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'established_extracapsular_invasion', 'established extracapsular invasion', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000052', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'focal_extracapsular_invasion', 'focal extracapsular invasion', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000053', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'rgt_ant_quadrant_extracapsular_invasion', 'right anterior', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000054', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'rgt_post_quadrant_extracapsular_invasion', 'right posterior', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000055', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'lft_ant_quadrant_extracapsular_invasion', 'left anterior', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000056', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'lft_post_quadrant_extracapsular_invasion', 'left posterior', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000057', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'seminal_vesicles_extracapsular_invasion', 'seminal vesicles extracapsular invasion', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'qc_cusm_absent_present'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000058', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'examined_lymph_nodes_nbr', 'examined lymph nodes nbr', '', 'number', 'size=7', '', null, '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000059', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'involved_lymph_nodes_nbr', 'involved lymph nodes nbr', '', 'number', 'size=7', '', null, '', 'open', 'open', 'open'),

('', 'QC-CUSM-000060', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'prostate_height', 'prostate height', '', 'number', 'size=7', '', null, '', 'open', 'open', 'open'),
('', 'QC-CUSM-000061', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'lymph_nodes_collected', 'lymph nodes collected', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yesno'), '', 'open', 'open', 'open');

INSERT INTO structure_fields(`public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'QC-CUSM-000062', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'tumour_location_rgt_anterior', 'right anterior', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000063', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'tumour_location_rgt_posterior', 'right posterior', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000064', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'tumour_location_lft_anterior', 'left anterior', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000065', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'tumour_location_lft_posterior', 'left posterior', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000066', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'tumour_location_apex', 'apex', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000067', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'tumour_location_base', 'base', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'), 
('', 'QC-CUSM-000068', 'Clinicalannotation', 'EventDetail', 'qc_cusm_ed_procure_prostate_path_report', 'tumour_location_bladder_neck', 'bladder neck', '', 'checkbox', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'yes_no_checkbox'), '', 'open', 'open', 'open'); 

INSERT INTO structure_formats(`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
-- disease site
('QC-CUSM-000006_CAN-999-999-000-999-227', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-227'), 'CAN-999-999-000-999-227', 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0') ,
-- event_type
('QC-CUSM-000006_CAN-999-999-000-999-228', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-228'), 'CAN-999-999-000-999-228', 
'0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0') ,
-- event_date
('QC-CUSM-000006_CAN-999-999-000-999-229', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-229'), 'CAN-999-999-000-999-229', 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ,
-- report_number
('QC-CUSM-000006_QC-CUSM-000027', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000027'), 'QC-CUSM-000027', 
'0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ,
-- pathologist_name
('QC-CUSM-000006_QC-CUSM-000028', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000028'), 'QC-CUSM-000028', 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1') ,
-- summary
('QC-CUSM-000006_CAN-999-999-000-999-230', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='CAN-999-999-000-999-230'), 'CAN-999-999-000-999-230', 
'0', '7', '', '0', '', '0', '', '0', '', '0', 'input', '1', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),

-- prostate_lenght
('QC-CUSM-000006_QC-CUSM-000030', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000030'), 'QC-CUSM-000030', 
'0', '12', 'measurements', '1', 'prostate', '1', 'lenght (cm)', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- prostate_width
('QC-CUSM-000006_QC-CUSM-000031', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000031'), 'QC-CUSM-000031', 
'0', '13', '', '1', '', '1', 'width (cm)', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- prostate_height
('QC-CUSM-000006_QC-CUSM-000060', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000060'), 'QC-CUSM-000060', 
'0', '14', '', '1', '', '1', 'height (cm)', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- prostate_weight
('QC-CUSM-000006_QC-CUSM-000029', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000029'), 'QC-CUSM-000029', 
'0', '15', '', '1', '', '1', 'weight (gr)', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- rgt_seminal_vesicles_lenght
('QC-CUSM-000006_QC-CUSM-000032', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000032'), 'QC-CUSM-000032', 
'0', '16', '', '1', 'right seminal vesicles', '1', 'lenght (cm)', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- rgt_seminal_vesicles_width
('QC-CUSM-000006_QC-CUSM-000033', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000033'), 'QC-CUSM-000033', 
'0', '17', '', '1', '', '1', 'width (cm)', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- rgt_seminal_vesicles_height
('QC-CUSM-000006_QC-CUSM-000034', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000034'), 'QC-CUSM-000034', 
'0', '18', '', '1', '', '1', 'height (cm)', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- lft_seminal_vesicles_lenght
('QC-CUSM-000006_QC-CUSM-000035', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000035'), 'QC-CUSM-000035', 
'0', '19', '', '1', 'left seminal vesicles ', '1', 'lenght (cm)', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- lft_seminal_vesicles_width
('QC-CUSM-000006_QC-CUSM-000036', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000036'), 'QC-CUSM-000036', 
'0', '20', '','1', '', '1', 'width (cm)', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- lft_seminal_vesicles_height
('QC-CUSM-000006_QC-CUSM-000037', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000037'), 'QC-CUSM-000037', 
'0', '21', '','1', '', '1', 'height (cm)', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,

-- tumour_location_rgt_anterior
('QC-CUSM-000006_QC-CUSM-000062', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000062'), 'QC-CUSM-000062', 
'0', '30', 'tumour location','0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- tumour_location_rgt_posterior
('QC-CUSM-000006_QC-CUSM-000063', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000063'), 'QC-CUSM-000063', 
'0', '31', '','0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- tumour_location_lft_anterior
('QC-CUSM-000006_QC-CUSM-000064', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000064'), 'QC-CUSM-000064', 
'0', '32', '','0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- tumour_location_lft_posterior
('QC-CUSM-000006_QC-CUSM-000065', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000065'), 'QC-CUSM-000065', 
'0', '33', '','0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- tumour_location_apex
('QC-CUSM-000006_QC-CUSM-000066', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000066'), 'QC-CUSM-000066', 
'0', '34', '','0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- tumour_location_base
('QC-CUSM-000006_QC-CUSM-000067', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000067'), 'QC-CUSM-000067', 
'0', '35', '','0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- tumour_location_bladder_neck
('QC-CUSM-000006_QC-CUSM-000068', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000068'), 'QC-CUSM-000068', 
'0', '36', '','0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,

-- primary_grade
('QC-CUSM-000006_QC-CUSM-000038', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000038'), 'QC-CUSM-000038', 
'1', '40', 'histologic grade', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- secondary_grade
('QC-CUSM-000006_QC-CUSM-000039', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000039'), 'QC-CUSM-000039', 
'1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- tertiary_grade
('QC-CUSM-000006_QC-CUSM-000040', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000040'), 'QC-CUSM-000040', 
'1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- gleason_score
('QC-CUSM-000006_QC-CUSM-000041', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000041'), 'QC-CUSM-000041', 
'1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,

-- margin_status
('QC-CUSM-000006_QC-CUSM-000042', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000042'), 'QC-CUSM-000042',
'1', '50', 'margins', '1', 'status', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- margin_focal
('QC-CUSM-000006_QC-CUSM-000043', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000043'), 'QC-CUSM-000043', 
'1', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- margin_position_apical
('QC-CUSM-000006_QC-CUSM-000044', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000044'), 'QC-CUSM-000044', 
'1', '52', '', '1', 'positions', '1', 'apical', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- margin_position_bladder_neck
('QC-CUSM-000006_QC-CUSM-000045', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000045'), 'QC-CUSM-000045', 
'1', '53', '', '1', '', '1', 'bladder neck', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- margin_position_lft_anterior
('QC-CUSM-000006_QC-CUSM-000046', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000046'), 'QC-CUSM-000046', 
'1', '54', '', '1', '', '1', 'left anterior', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- margin_position_rgt_anterior
('QC-CUSM-000006_QC-CUSM-000047', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000047'), 'QC-CUSM-000047', 
'1', '55', '', '1', '', '1', 'right anterior', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- margin_position_lft_posterior
('QC-CUSM-000006_QC-CUSM-000048', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000048'), 'QC-CUSM-000048', 
'1', '56', '', '1', '', '1', 'left posterior', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- margin_position_rgt_posterior
('QC-CUSM-000006_QC-CUSM-000049', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000049'), 'QC-CUSM-000049', 
'1', '57', '', '1', '', '1', 'right posterior', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,

-- extracapsular_invasion_status
('QC-CUSM-000006_QC-CUSM-000050', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000050'), 'QC-CUSM-000050', 
'1', '70', 'extracapsular invasion', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1')  ,
-- established_extracapsular_invasion
('QC-CUSM-000006_QC-CUSM-000051', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000051'), 'QC-CUSM-000051', 
'1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- focal_extracapsular_invasion
('QC-CUSM-000006_QC-CUSM-000052', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000052'), 'QC-CUSM-000052', 
'1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,

-- rgt_ant_quadrant_extracapsular_invasion
('QC-CUSM-000006_QC-CUSM-000053', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000053'), 'QC-CUSM-000053', 
'1', '80', 'extracapsular invasion location', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- rgt_post_quadrant_extracapsular_invasion
('QC-CUSM-000006_QC-CUSM-000054', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000054'), 'QC-CUSM-000054', 
'1', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- lft_ant_quadrant_extracapsular_invasion
('QC-CUSM-000006_QC-CUSM-000055', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000055'), 'QC-CUSM-000055', 
'1', '82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- lft_post_quadrant_extracapsular_invasion
('QC-CUSM-000006_QC-CUSM-000056', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000056'), 'QC-CUSM-000056', 
'1', '83', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- seminal_vesicles_extracapsular_invasion
('QC-CUSM-000006_QC-CUSM-000057', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000057'), 'QC-CUSM-000057', 
'1', '84', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,

-- lymph_nodes_collected
('QC-CUSM-000006_QC-CUSM-000061', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000061'), 'QC-CUSM-000061', 
'1', '90', 'regional lymph nodes', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
-- examined_lymph_nodes_nbr
('QC-CUSM-000006_QC-CUSM-000058', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000058'), 'QC-CUSM-000058', 
'1', '91', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ,
-- involved_lymph_nodes_nbr
('QC-CUSM-000006_QC-CUSM-000059', (SELECT id FROM structures WHERE old_id='QC-CUSM-000006'), 'QC-CUSM-000006', 
(SELECT id FROM structure_fields WHERE old_id='QC-CUSM-000059'), 'QC-CUSM-000059',
 '1', '92', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1') ;

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('report number', 'global', 'Report Number', 'Numéro du rapport'),
('pathologist name', 'global', 'Pathologist Name', 'Nom du pathologiste'),
('lenght (cm)', 'global', 'Lenght (cm)', 'Longueur (cm)'),
('width (cm)', 'global', 'Width (cm)', 'Largeur (cm)'),
('height (cm)', 'global', 'Height (cm)', 'Hauteur (cm)'),
('weight (gr)', 'global', 'Weight (gr)', 'Poids (cm)'),
('apex', 'global', 'Apex', 'Apex'),
('bladder neck', 'global', 'Bladder Neck', 'Col Vésical'),
('involved lymph nodes nbr', 'global', 'Involved Number', 'Nombre atteint(s)'),
('examined lymph nodes nbr', 'global', 'Examined Number', 'Nombre examiné(s)'),
('lymph nodes collected', 'global', 'Collected', 'Récoltés'),
('absent', 'global', 'Absent', 'Absent(e)'),
('present', 'global', 'Present', 'Présent(e)'),
('established extracapsular invasion', 'global', 'Established', 'établie'),
('focal extracapsular invasion', 'global', 'Focal', 'Focale'),
('seminal vesicles extracapsular invasion', 'global', 'Seminal Vesicles', 'Vésicules séminales'),
('extracapsular invasion status', 'global', 'Status', 'Statut'),
('margin focal', 'global', 'Focal', 'Focale'),
('tertiary grade', 'global', 'Tertiary Grade', '');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('measurements', 'global', 'Measurements', 'Dimensions'),
('tumour location', 'global', 'Tumour Location', 'Localisation de la tumeur'),
('histologic grade', 'global', 'Histologic Grade', 'Grade Histologique'),
('margins', 'global', 'Margins', 'Marges'),
('extracapsular invasion', 'global', 'Extracapsular Invasion', 'Invasion extracapsulaire'),
('extracapsular invasion location', 'global', 'Extracapsular Invasion Location', 'Localisation de l''invasion extracapsulaire'),
('regional lymph nodes', 'global', 'Regional Lymph Nodes', 'Adénopathies régionales / ganglions');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('positions', 'global', 'Positions', 'Positions');

-- ******** TREATMENT ******** 

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
('montreal_general_hospital_card', 'global', 'Montreal General Hospital card', 'carte Hôpital Général de Montréal'),
('prostate_bank_participant_id', 'global', 'Prostate Bank Participant Id', 'Numéro participant banque Prostate'),
('this identifier has already been created for your participant', '', 'This identifier has already been created for your participant!', 'Cet identification a déjà été créée pour ce participant!');

DELETE FROM `key_increments`;
INSERT INTO `key_increments` (`key_name`, `key_value`) VALUES
('prostate_bank_participant_id', 0200);

-- ******** REP. HISTORY ******** 

UPDATE `menus` SET `active` = 'no' WHERE `id` = 'clin_CAN_68'; -- reproductive history

-- ******** FAM. HISTORY ******** 

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

-- Change author to select

UPDATE `structure_fields`
SET `type` = 'select',
`setting` = '',
`structure_value_domain` = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` LIKE 'custom_laboratory_staff')
WHERE `old_id` = 'CAN-999-999-000-999-1256';

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
('aspect at reception', 'global', 'Aspect at Reception', 'Aspect à la réception'),
('aspect before centrifugation', 'global', 'Aspect Before Centrifugation', 'Aspect avant centrifugation');
 
-- Centrifuged urine : add pellet color

UPDATE sample_controls
SET form_alias = 'qc_cusm_sd_der_centrifuged_urines'
WHERE sample_type = 'centrifuged urine' ;

INSERT INTO `structures` (`id`, `old_id`, `alias`, `description`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'QC-CUSM-000002', 'qc_cusm_sd_der_centrifuged_urines', NULL, '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

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
1, 60, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('on ice');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('on ice', 'global', 'On Ice', 'Sur glace');

-- RNA : Add 'is micro RNA'

UPDATE sample_controls
SET form_alias = 'qc_cusm_sd_der_rnas'
WHERE sample_type = 'rna' ;

INSERT INTO `structures` (`id`, `old_id`, `alias`, `description`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'QC-CUSM-000003', 'qc_cusm_sd_der_rnas', NULL, '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

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

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000014', 'Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'qc_cusm_tissue_position_code', 'tissue position code', '', 'select', '', '',  @domain_id , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1028_QC-CUSM-000014', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1028'), 'CAN-999-999-000-999-1028', 
(SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000014'), 'QC-CUSM-000014', 
1, 73, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('tissue position code');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('tissue position code', 'global', 'Tissue Position', 'Position du tissue');

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
('section should be a positif integer', 'global', 'Section should be a positif integer!', 'La section doit être un entier positif!');

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

ALTER TABLE `ad_blocks` 
ADD `qc_cusm_block_size_unit` varchar(10) default NULL AFTER `qc_cusm_block_size`;

ALTER TABLE `ad_blocks_revs` 
ADD `qc_cusm_block_size_unit` varchar(10) default NULL AFTER `qc_cusm_block_size`;

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) 
VALUES 
(NULL, 'mm', 'mm');

DELETE FROM `i18n` WHERE `id` IN ('mm');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('mm', 'global', 'mm', 'mm');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`) VALUES
(null, 'qc_cusm_block_size_unit', 'open', '');

SET @domain_id = LAST_INSERT_ID();

INSERT INTO `structure_value_domains_permissible_values`  
(`id` , `structure_value_domain_id` , `structure_permissible_value_id` , `display_order` , `active` , `language_alias` )
VALUES 
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'cm'), '20', 'yes', 'cm'),
(NULL , @domain_id, (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'mm'), '20', 'yes', 'mm');

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000017', 'Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'qc_cusm_block_size_unit', '', 'unit', 'select', '', '', @domain_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1028_QC-CUSM-000017', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1028'), 'CAN-999-999-000-999-1028', 
(SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000017'), 'QC-CUSM-000017', 
1, 76, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Tissue Block: Add collection to freezing spent time (mn)

ALTER TABLE `ad_blocks` 
ADD `qc_cusm_coll_to_freezing_spent_time` int(15) default NULL AFTER `qc_cusm_block_size_unit`;

ALTER TABLE `ad_blocks_revs` 
ADD `qc_cusm_coll_to_freezing_spent_time` int(15) default NULL AFTER `qc_cusm_block_size_unit`;

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000018', 'Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'qc_cusm_coll_to_freezing_spent_time', 'collection to freezing spent time (mn)', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_validations` 
(`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-CUSM-000005', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'QC-CUSM-000018'), 'QC-CUSM-000018', 
'custom,/^([0-9]+)?$/', '1', '0', '', 'spent time should be a positif integer', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1028_QC-CUSM-000018', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1028'), 'CAN-999-999-000-999-1028', 
(SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000018'), 'QC-CUSM-000018', 
1, 76, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('collection to freezing spent time (mn)', 'spent time should be a positif integer');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('spent time should be a positif integer', 'global', 'Spent time should be a positif integer!', 'Temps écoulé doit être un entier positif!'),
('collection to freezing spent time (mn)', 'global', 'Collection to Freezing Spent Time(mn)', 'Temps écoulé entre collection et congélation (mn)');

-- Tissue Block: Add fixation process duration

ALTER TABLE `ad_blocks` 
ADD `qc_cusm_fixation_process_duration` int(15) default NULL AFTER `qc_cusm_coll_to_freezing_spent_time`;

ALTER TABLE `ad_blocks_revs` 
ADD `qc_cusm_fixation_process_duration` int(15) default NULL AFTER `qc_cusm_coll_to_freezing_spent_time`;

INSERT INTO `structure_fields` 
(`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, '', 'QC-CUSM-000019', 'Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'qc_cusm_fixation_process_duration', 'fixation process duration (hr)', '', 'input', 'size=10', '', null, '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_validations` 
(`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'QC-CUSM-000006', (SELECT `id` FROM `structure_fields` WHERE `old_id` = 'QC-CUSM-000019'), 'QC-CUSM-000019', 
'custom,/^([0-9]+)?$/', '1', '0', '', 'fixation duration should be a positif integer', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'CAN-999-999-000-999-1028_QC-CUSM-000019', (SELECT id FROM structures WHERE old_id = 'CAN-999-999-000-999-1028'), 'CAN-999-999-000-999-1028', 
(SELECT id FROM structure_fields WHERE old_id = 'QC-CUSM-000019'), 'QC-CUSM-000019', 
1, 77, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '1', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('fixation process duration (hr)', 'fixation duration should be a positif integer');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('fixation duration should be a positif integer', 'global', 'Spent time should be a positif integer!', 'Durée du processus de fixation doit être un entier positif!'),
('fixation process duration (hr)', 'global', 'Fixation Process Duration (hr)', 'Durée du processus de fixation (hr)');

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
('box100', 'global', 'Box 100', 'Boîte 100'),
('drawers box', 'global', 'Drawers Box', 'Boîte à tiroirs'),
('blocks drawer', 'global', 'Blocks Drawer', 'Tiroir à blocs');

-- Storage Barcode : hidden

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
WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1183');

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


