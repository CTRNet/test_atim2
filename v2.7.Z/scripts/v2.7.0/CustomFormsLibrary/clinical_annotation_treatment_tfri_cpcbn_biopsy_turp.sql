-- ------------------------------------------------------
-- ATiM ... Data Script
-- version: 2.7.2
-- ------------------------------------------------------

-- user_id (To Define)

SET @user_id = (SELECT id FROM users WHERE username LIKE '%' AND id LIKE '1');

-- --------------------------------------------------------------------------------
-- TFRI CPCBN Biopsy/TURP
-- ................................................................................
-- Biopsy/TURP forms developped to capture data of prostate cancer 
-- for the central ATiM of the Canadian Prostate Cancer Biomarker Network (CPCBN).
-- Project of the Terry Fox Research Institute (TFRI).
-- --------------------------------------------------------------------------------

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`, `use_addgrid`, `use_detail_form_for_index`) 
VALUES
(null, 'tfri cpcbn - biopsy and turp', 'prostate', 1, 'tfri_cpcbn_txd_biopsy_turps', 'tfri_cpcbn_txd_biopsy_turps', 0, NULL, NULL, 'prostate|tfri cpcbn - biopsy and turp', 0, NULL, 0, 1);

DROP TABLE IF EXISTS `tfri_cpcbn_txd_biopsy_turps`;
CREATE TABLE IF NOT EXISTS `tfri_cpcbn_txd_biopsy_turps` (
  `total_number_taken` int(4) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `gleason_score` varchar(10) DEFAULT '',
  `total_positive` int(6) DEFAULT NULL,
  `greatest_percent_of_cancer` int(6) DEFAULT NULL,
  `gleason_grade` varchar(10) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `ctnm` varchar(10) NOT NULL DEFAULT '',
  `perineural_invasion` char(1) DEFAULT '',
  `type_specification` varchar(100) DEFAULT NULL,
  KEY `treatment_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `tfri_cpcbn_txd_biopsy_turps_revs`;
CREATE TABLE IF NOT EXISTS `tfri_cpcbn_txd_biopsy_turps_revs` (
  `total_number_taken` int(4) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `gleason_score` varchar(10) DEFAULT '',
  `total_positive` int(6) DEFAULT NULL,
  `greatest_percent_of_cancer` int(6) DEFAULT NULL,
  `gleason_grade` varchar(10) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `ctnm` varchar(10) NOT NULL DEFAULT '',
  `perineural_invasion` char(1) DEFAULT '',
  `type_specification` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `tfri_cpcbn_txd_biopsy_turps`
  ADD CONSTRAINT `tfri_cpcbn_txd_biopsy_turps_ibfk_2` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);

INSERT INTO structure_value_domains (domain_name, override, category, source)
VALUES
('tfri_cpcbn_biopsy_turp_types', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI CPCBN: Biopsy TURP Types\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category)
VALUES
('TFRI CPCBN: Biopsy TURP Types', 1, 50, 'clinical - treatment');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI CPCBN: Biopsy TURP Types');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("Bx", "Bx", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("Bx Dx", "Bx Dx", "", "2", "0", @control_id, NOW(), NOW(), @user_id, @user_id), 
("Bx prior to Tx", "Bx prior to Tx", "", "2", "0", @control_id, NOW(), NOW(), @user_id, @user_id), 
("Bx TRUS-Guided", "Bx TRUS-Guided", "", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("Bx Dx TRUS-Guided", "Bx Dx TRUS-Guided", "", "2", "0", @control_id, NOW(), NOW(), @user_id, @user_id), 
("TURP", "TURP", "TURP", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("TURP Dx", "TURP Dx", "", "2", "0", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source)
VALUES
('tfri_cpcbn_biopsy_type_specifications', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI CPCBN: Biopsy TURP Types Details\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category)
VALUES
('TFRI CPCBN: Biopsy TURP Types Details', 1, 100, 'clinical - treatment');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI CPCBN: Biopsy TURP Types Details');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("Dx", "Dx", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("follow-up", "Follow-up", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("prior to Tx", "Prior to Tx", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

-- INSERT INTO structure_value_domains (domain_name, override, category, source) 
-- values
-- ('tfri_cpcbn_ctnm', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI CPCBN: cTNM\')');
-- INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
-- VALUES
-- ('TFRI CPCBN: cTNM', 1, 5, 'clinical - diagnosis');
-- SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI CPCBN: cTNM');
-- INSERT INTO structure_permissible_values_customs 
-- (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
-- ("2", "", "", "10", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("2a", "", "", "11", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("2b", "", "", "12", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("2c", "", "", "13", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("3", "", "", "14", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("3a", "", "", "15", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("3b", "", "", "16", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("3c", "", "", "17", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("4", "", "", "18", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("1a", "", "", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("1c", "", "", "6", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("1b", "", "", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("1", "1", "1", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source)
VALUES
('tfri_cpcbn_biop_gleason_grades', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI CPCBN: Biopsy Gleason Grades\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category)
VALUES
('TFRI CPCBN: Biopsy Gleason Grades', 1, 10, 'clinical - treatment');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI CPCBN: Biopsy Gleason Grades');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("3+3", "3+3", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3+4", "3+4", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4+3", "4+3", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4+4", "4+4", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4+5", "4+5", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("5+4", "5+4", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("5+5", "5+5", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2+2", "2+2", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2+3", "2+3", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1+2", "1+2", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3+2", "3+2", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3+5", "3+5", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3+1", "3+1", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4+2", "4+2", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("5+3", "5+3", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2+1", "2+1", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2+4", "2+4", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1+1", "1+1", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

-- INSERT INTO structure_value_domains (domain_name, override, category, source) 
-- VALUES
-- ('tfri_cpcbn_gleason_values', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI CPCBN: Gleason Values\')');
-- INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
-- VALUES
-- ('TFRI CPCBN: Gleason Values', 1, 10, 'clinical - diagnosis');
-- SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI CPCBN: Gleason Values');
-- INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
-- VALUES
-- ("1", "1", "1", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("2", "", "", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("3", "", "", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("4", "", "", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("5", "", "", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("6", "", "", "6", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("7", "", "", "7", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("8", "", "", "8", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("9", "", "", "9", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("10", "", "", "10", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
-- ("unknown", "Unknown", "Inconnu", "11", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structures(`alias`) VALUES ('tfri_cpcbn_txd_biopsy_turps');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'tfri_cpcbn_txd_biopsy_turps', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_biopsy_turp_types') , '0', '', '', '', 'type', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'tfri_cpcbn_txd_biopsy_turps', 'type_specification', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_biopsy_type_specifications') , '0', '', '', '', '', 'specification'), 
('ClinicalAnnotation', 'TreatmentDetail', 'tfri_cpcbn_txd_biopsy_turps', 'total_number_taken', 'integer_positive',  NULL , '0', 'size=3', '', '', 'total number taken', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'tfri_cpcbn_txd_biopsy_turps', 'total_positive', 'integer_positive',  NULL , '0', 'size=3', '', '', 'total positive', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'tfri_cpcbn_txd_biopsy_turps', 'greatest_percent_of_cancer', 'integer_positive',  NULL , '0', 'size=3', '', '', 'greatest percent of cancer', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'tfri_cpcbn_txd_biopsy_turps', 'perineural_invasion', 'yes_no',  NULL , '0', '', '', '', 'perineural invasion', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'tfri_cpcbn_txd_biopsy_turps', 'ctnm', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_ctnm') , '0', '', '', '', 'ctnm', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'tfri_cpcbn_txd_biopsy_turps', 'gleason_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_biop_gleason_grades') , '0', '', '', '', 'gleason grade', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'tfri_cpcbn_txd_biopsy_turps', 'gleason_score', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_gleason_values') , '0', '', '', '', 'gleason score', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
VALUES
((SELECT id FROM structures WHERE alias='tfri_cpcbn_txd_biopsy_turps'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='tfri_cpcbn_txd_biopsy_turps' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_biopsy_turp_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), 
'1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_txd_biopsy_turps'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='tfri_cpcbn_txd_biopsy_turps' AND `field`='type_specification' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_biopsy_type_specifications')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='specification'), 
'1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_txd_biopsy_turps'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='tfri_cpcbn_txd_biopsy_turps' AND `field`='total_number_taken' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='total number taken' AND `language_tag`=''), 
'2', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_txd_biopsy_turps'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='tfri_cpcbn_txd_biopsy_turps' AND `field`='total_positive' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='total positive' AND `language_tag`=''), 
'2', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_txd_biopsy_turps'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='tfri_cpcbn_txd_biopsy_turps' AND `field`='greatest_percent_of_cancer' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='greatest percent of cancer' AND `language_tag`=''), 
'2', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_txd_biopsy_turps'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='tfri_cpcbn_txd_biopsy_turps' AND `field`='perineural_invasion' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='perineural invasion' AND `language_tag`=''), 
'2', '30', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_txd_biopsy_turps'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='tfri_cpcbn_txd_biopsy_turps' AND `field`='ctnm' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_ctnm')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ctnm' AND `language_tag`=''), 
'1', '79', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_txd_biopsy_turps'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='tfri_cpcbn_txd_biopsy_turps' AND `field`='gleason_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_biop_gleason_grades')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason grade' AND `language_tag`=''), 
'1', '80', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_cpcbn_txd_biopsy_turps'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='tfri_cpcbn_txd_biopsy_turps' AND `field`='gleason_score' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_cpcbn_gleason_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason score' AND `language_tag`=''), 
'1', '81', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("tfri cpcbn - biopsy and turp", "Biopsy/TURP (TFRI CPCBN)", "Biopsie/TURP (TFRI CPCBN)"),
("specification", "Specification", "Spécification"),
("gleason score", "Gleason Score ", "Score de Gleason"),
("total number taken", "Total Number Taken", "Nombre total prélevés"),
("total positive", "Total positive", "Total positif"),
("greatest percent of cancer", "Greatest Percent of Cancer", "Plus grand pourcentage de cancer");
 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;