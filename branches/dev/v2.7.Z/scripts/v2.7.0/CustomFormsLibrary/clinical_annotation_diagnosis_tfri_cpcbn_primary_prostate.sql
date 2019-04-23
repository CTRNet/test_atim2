-- ------------------------------------------------------
-- ATiM ... Data Script
-- version: 2.7.2
-- ------------------------------------------------------

-- user_id (To Define)

SET @user_id = (SELECT id FROM users WHERE username LIKE '%' AND id LIKE '1');

-- --------------------------------------------------------------------------------
-- TFRI CPCBN Prostate Primary Diagnosis
-- ................................................................................
-- Primary diagnosis forms developped to capture data of prostate primary cancer 
-- for the central ATiM of the Canadian Prostate Cancer Biomarker Network (CPCBN).
-- Project of the Terry Fox Research Institute (TFRI).
-- --------------------------------------------------------------------------------

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) 
VALUES
(null, 'primary', 'tfri cpcbn - prostate', 1, 'tfri_cpcbn_dxd_prostates', 'tfri_cpcbn_dxd_prostates', 0, 'primary|tfri cpcbn - prostate', 0);

DROP TABLE IF EXISTS `tfri_cpcbn_dxd_prostates`;
CREATE TABLE IF NOT EXISTS `tfri_cpcbn_dxd_prostates` (
  `diagnosis_master_id` int(11) NOT NULL,
  `tool` varchar(50) NOT NULL DEFAULT '',
  `gleason_score_biopsy_turp` varchar(10) NOT NULL DEFAULT '',
  `ptnm` varchar(10) NOT NULL DEFAULT '',
  `ctnm` varchar(10) NOT NULL DEFAULT '',
  `gleason_score_rp` varchar(10) NOT NULL DEFAULT '',
  `hormonorefractory_status` varchar(50) NOT NULL DEFAULT '',
  `survival_in_months` int(5) DEFAULT NULL,
  `bcr_in_months` int(5) DEFAULT NULL,
  `active_surveillance` varchar(50) DEFAULT NULL,
  KEY `FK_tfri_cpcbn_dxd_prostates_diagnosis_masters` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `tfri_cpcbn_dxd_prostates_revs`;
CREATE TABLE IF NOT EXISTS `tfri_cpcbn_dxd_prostates_revs` (
  `diagnosis_master_id` int(11) NOT NULL,
  `gleason_score_biopsy_turp` varchar(10) NOT NULL DEFAULT '',
  `gleason_score_rp` varchar(10) NOT NULL DEFAULT '',
  `hormonorefractory_status` varchar(50) NOT NULL DEFAULT '',
  `bcr_in_months` int(5) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `tfri_cpcbn_dxd_prostates`
  ADD CONSTRAINT `FK_tfri_cpcbn_dxd_prostates_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('tfri_cpcbn_dx_tools', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI CPCBN: Diagnosis Tools\')');
INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) 
VALUES
('TFRI CPCBN: Diagnosis Tools', 1, 20, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI CPCBN: Diagnosis Tools');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("biopsy", "Biopsy", "Biopsie", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("RP", "RP", "RP", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("PSA+DRE", "", "", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("unknown", "Unknown", "Inconnu", "6", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("TRUS-guided biopsy", "TRUS-Guided Biopsy", "", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("TURP", "TURP", "TURP", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('tfri_cpcbn_gleason_values', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI CPCBN: Gleason Values\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('TFRI CPCBN: Gleason Values', 1, 10, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI CPCBN: Gleason Values');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("1", "1", "1", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2", "", "", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3", "", "", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4", "", "", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("5", "", "", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("6", "", "", "6", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("7", "", "", "7", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("8", "", "", "8", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("9", "", "", "9", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("10", "", "", "10", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("unknown", "Unknown", "Inconnu", "11", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('tfri_cpcbn_ctnm', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI CPCBN: cTNM\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('TFRI CPCBN: cTNM', 1, 5, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI CPCBN: cTNM');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("2", "", "", "10", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2a", "", "", "11", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2b", "", "", "12", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2c", "", "", "13", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3", "", "", "14", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3a", "", "", "15", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3b", "", "", "16", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3c", "", "", "17", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4", "", "", "18", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1a", "", "", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1c", "", "", "6", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1b", "", "", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1", "1", "1", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('tfri_cpcbn_ptnm', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI CPCBN: pTNM\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('TFRI CPCBN: pTNM', 1, 5, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI CPCBN: pTNM');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("2", "", "", "10", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2a", "", "", "11", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2b", "", "", "12", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2c", "", "", "13", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3", "", "", "14", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3a", "", "", "15", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3b", "", "", "16", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3c", "", "", "17", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4", "", "", "18", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4a", "", "", "19", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4b", "", "", "20", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('tfri_cpcbn_hormonorefractory_status', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI CPCBN: Hormonorefractory Status\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('TFRI CPCBN: Hormonorefractory Status', 1, 50, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI CPCBN: Hormonorefractory Status');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("HR", "HR", "HR", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("not HR", "Not HR", "Pas HR", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("unknown", "Unknown", "Inconnu", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structures(`alias`) VALUES ('tfri_cpcbn_dxd_prostates');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'tfri_cpcbn_dxd_prostates', 'gleason_score_biopsy_turp', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_gleason_values') , '0', '', '', '', 'gleason score biopsy and turp', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'tfri_cpcbn_dxd_prostates', 'gleason_score_rp', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_gleason_values') , '0', '', '', '', 'gleason sum rp', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'tfri_cpcbn_dxd_prostates', 'bcr_in_months', 'integer',  NULL , '0', '', '', '', 'bcr in months', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'tfri_cpcbn_dxd_prostates', 'hormonorefractory_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_hormonorefractory_status') , '0', '', '', '', 'hormonorefractory status', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'dx_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_dx_tools') , '0', '', '', '', 'diagnosis method', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'clinical_stage_summary', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_ctnm') , '0', '', '', '', 'ctnm', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_stage_summary', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_ptnm') , '0', '', '', '', 'ptnm', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_dxd_prostates'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), 
'1', '4', '', '0', '0', '', '0', '', '1', '', '0', '', '1', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_dxd_prostates'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='tfri_cpcbn_dxd_prostates' AND `field`='gleason_score_biopsy_turp' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_gleason_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason score biopsy and turp' AND `language_tag`=''), 
'2', '7', 'score', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_dxd_prostates'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='tfri_cpcbn_dxd_prostates' AND `field`='gleason_score_rp' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_gleason_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason sum rp' AND `language_tag`=''), 
'2', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_dxd_prostates'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='tfri_cpcbn_dxd_prostates' AND `field`='bcr_in_months' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bcr in months' AND `language_tag`=''), 
'1', '14', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_dxd_prostates'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='tfri_cpcbn_dxd_prostates' AND `field`='hormonorefractory_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_hormonorefractory_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hormonorefractory status' AND `language_tag`=''), 
'3', '17', 'hormonorefractory', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_dxd_prostates'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_dx_tools')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='diagnosis method' AND `language_tag`=''), 
'1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_dxd_prostates'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_ctnm')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ctnm' AND `language_tag`=''), 
'2', '6', 'staging', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_dxd_prostates'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_ptnm')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ptnm' AND `language_tag`=''), 
'2', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_dxd_prostates'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), 
'1', '13', 'survival and bcr', '0', '0', '', '0', '', '1', '', '0', '', '1', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
("tfri cpcbn - prostate", "Prostate (TFRI CPCBN)", "Prostate (TFRI CPCBN)"),
("diagnosis method", "Diagnosis Method", "Méthode de diagnostic"),
("survival and bcr", "Survival & Biochemical Recurrence", "Survie et récidive biochimique"),
("bcr in months", "BCR (Months)", "BCR (mois)"),
("ctnm", "cTNM", "cTNM"),
("ptnm", "pTNM", "pTNM"),
("gleason score biopsy and turp", "Gleason Score (Biopsy and TURP)", "Score de Gleason (Biopsie and TURP)"),
("gleason sum rp", "Gleason Sum (RP)", "Score de Gleason (PR)"),
("hormonorefractory", "Hormono Refractory", "Résistance hormonale"),
("hormonorefractory status", "Status", "Statut");
 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;