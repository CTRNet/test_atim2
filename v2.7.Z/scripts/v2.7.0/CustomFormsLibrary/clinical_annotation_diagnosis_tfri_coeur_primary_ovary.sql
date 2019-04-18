-- ------------------------------------------------------
-- ATiM ... Data Script
-- version: 2.7.2
-- ------------------------------------------------------

-- user id to define

SET @user_id = (SELECT id FROM users WHERE username LIKE '%' AND id LIKE '1');

-- --------------------------------------------------------------------------------
-- TFRI COEUR Ovary Primary Diagnosis
-- ................................................................................
-- Primary diagnosis forms developped to capture data of ovary primary cancer 
-- for the central ATiM of the Canadian Ovarian Experimental Unified Resource 
-- (COEUR). Project of the Terry Fox Research Institute (TFRI).
-- --------------------------------------------------------------------------------

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) 
VALUES
(null, 'primary', 'tfri coeur - ovary', 1, 'tfri_coeur_dxd_ovaries', 'tfri_coeur_dxd_ovaries', 0, 'primary|tfri coeur - ovary', 0);

DROP TABLE IF EXISTS `tfri_coeur_dxd_ovaries`;
CREATE TABLE IF NOT EXISTS `tfri_coeur_dxd_ovaries` (
  `diagnosis_master_id` int(11) NOT NULL,
  `laterality` varchar(50) NOT NULL DEFAULT '',
  `fallopian_tube_lesion` varchar(50) NOT NULL DEFAULT '',
  `presence_of_precursor_of_benign_lesions` varchar(50) NOT NULL DEFAULT '',
  `histopathology` varchar(50) NOT NULL DEFAULT '',
  `reviewed_histopathology` varchar(50) DEFAULT NULL,
  `figo` varchar(50) NOT NULL DEFAULT '',
  `residual_disease` varchar(50) NOT NULL DEFAULT '',
  `progression_status` varchar(50) NOT NULL DEFAULT '',
  `progression_time_in_months` int(10) DEFAULT NULL,
  `ca125_progression_time_in_months` int(10) DEFAULT NULL,
  `follow_up_from_ovarectomy_in_months` int(10) DEFAULT NULL,
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `tfri_coeur_dxd_ovaries_revs`;
CREATE TABLE IF NOT EXISTS `tfri_coeur_dxd_ovaries_revs` (
  `diagnosis_master_id` int(11) NOT NULL,
  `laterality` varchar(50) NOT NULL DEFAULT '',
  `fallopian_tube_lesion` varchar(50) NOT NULL DEFAULT '',
  `presence_of_precursor_of_benign_lesions` varchar(50) NOT NULL DEFAULT '',
  `histopathology` varchar(50) NOT NULL DEFAULT '',
  `reviewed_histopathology` varchar(50) DEFAULT NULL,
  `figo` varchar(50) NOT NULL DEFAULT '',
  `residual_disease` varchar(50) NOT NULL DEFAULT '',
  `progression_status` varchar(50) NOT NULL DEFAULT '',
  `progression_time_in_months` int(10) DEFAULT NULL,
  `ca125_progression_time_in_months` int(10) DEFAULT NULL,
  `follow_up_from_ovarectomy_in_months` int(10) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `tfri_coeur_dxd_ovaries`
  ADD CONSTRAINT `FK_tfri_coeur_dxd_ovaries_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);
 
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("bilateral", "bilateral");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="laterality"), 
(SELECT id FROM structure_permissible_values WHERE value="bilateral" AND language_alias="bilateral"), "0", "1"); 
  
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('tfri_coeur_fallopian_tube_lesions', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI COEUR : Fallopian Tube Lesions\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('TFRI COEUR : Fallopian Tube Lesions', 1, 50, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI COEUR : Fallopian Tube Lesions');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("benign tumors", "Benign Tumors", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("malignant tumors", "Malignant Tumors", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("no", "No", "Non", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("salpingitis", "Salpingitis", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("unknown", "Unknown", "Inconnu", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("yes", "Yes", "Oui", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('tfri_coeur_presence_of_precursor_of_benign_lesions', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI COEUR : Presence Precursor of Benign Lesions\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('TFRI COEUR : Presence Precursor of Benign Lesions', 1, 50, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI COEUR : Presence Precursor of Benign Lesions');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("benign or borderline tumours", "Benign or Borderline Tumours", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("endometriosis", "Endometriosis", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("endosalpingiosis", "Endosalpingiosis", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("no", "No", "Non", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("ovarian cysts", "Ovarian Cysts", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("unknown", "Unknown", "Inconnu", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('tfri_coeur_histopathology', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI COEUR : Histopathology\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('TFRI COEUR : Histopathology', 1, 50, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI COEUR : Histopathology');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("benign or borderline tumours", "Benign or Borderline Tumours", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("endometriosis", "Endometriosis", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("endosalpingiosis", "Endosalpingiosis", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("no", "No", "Non", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("ovarian cysts", "Ovarian Cysts", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("unknown", "Unknown", "Inconnu", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('tfri_coeur_grades', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI COEUR : Grades\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('TFRI COEUR : Grades', 1, 150, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI COEUR : Grades');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1", "", "", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2", "", "", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3", "", "", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("unknown", "Unknown", "Inconnu", "6", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4", "", "", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('tfri_coeur_figo', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI COEUR : Figo\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('TFRI COEUR : Figo', 1, 50, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI COEUR : Figo');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("Ia", "Ia", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("Ib", "Ib", "", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("Ic", "Ic", "", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("IIa", "IIa", "", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("IIb", "IIb", "", "6", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("IIc", "IIc", "", "7", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("IIIa", "IIIa", "", "9", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("IIIb", "IIIb", "", "10", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("IIIc", "IIIc", "", "11", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("IV", "IV", "", "12", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("unknown", "Unknown", "Inconnu", "99", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("I", "I", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("II", "II", "", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("III", "III", "", "8", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('tfri_coeur_residual_diseases', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI COEUR : Residual Diseases\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('TFRI COEUR : Residual Diseases', 1, 50, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI COEUR : Residual Diseases');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("1-2cm", "", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("<1cm", "", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
(">2cm", "", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("miliary", "Miliary", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("none", "None", "Aucun", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("unknown", "Unknown", "Inconnu", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("suboptimal", "Suboptimal", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("yes unknown", "Yes Unknown", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("microscopic", "Microscopic", "Microscopique", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('tfri_coeur_progression_status', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'TFRI COEUR : Progression Status\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category)
VALUES
('TFRI COEUR : Progression Status', 1, 0, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TFRI COEUR : Progression Status');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("no", "No", "Non", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("yes", "Yes", "Oui", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("progressive disease", "Progressive Disease", "Maladie progressive", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("bouncer", "Bouncer", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("unknown", "Unknown", "Inconnu", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
 
INSERT INTO structures(`alias`) VALUES ('tfri_coeur_dxd_ovaries');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'tfri_coeur_dxd_ovaries', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '0', '', '', '', 'laterality', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'tfri_coeur_dxd_ovaries', 'fallopian_tube_lesion', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_coeur_fallopian_tube_lesions') , '0', '', '', '', 'fallopian tube lesion', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'tfri_coeur_dxd_ovaries', 'presence_of_precursor_of_benign_lesions', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_coeur_presence_of_precursor_of_benign_lesions') , '0', '', '', '', 'presence of precursor of benign lesions', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'tfri_coeur_dxd_ovaries', 'histopathology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_coeur_histopathology') , '0', '', '', '', 'histopathology', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'tfri_coeur_dxd_ovaries', 'reviewed_histopathology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_coeur_histopathology') , '0', '', '', '', '', 'reviewed histopathology'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_coeur_grades') , '0', '', '', '', 'tumour grade', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'tfri_coeur_dxd_ovaries', 'figo', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_coeur_figo') , '0', '', '', '', 'figo', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'tfri_coeur_dxd_ovaries', 'residual_disease', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_coeur_residual_diseases') , '0', '', '', '', 'residual disease', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'tfri_coeur_dxd_ovaries', 'progression_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_coeur_progression_status') , '0', '', '', '', 'progression status', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'tfri_coeur_dxd_ovaries', 'progression_time_in_months', 'integer_positive',  NULL , '0', 'size=3', '', '', 'progression time (months)', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'tfri_coeur_dxd_ovaries', 'ca125_progression_time_in_months', 'integer_positive', (SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') , '0', '', '', '', 'ca125 progression time in months', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'tfri_coeur_dxd_ovaries', 'follow_up_from_ovarectomy_in_months', 'integer_positive',  NULL , '0', 'size=3', '', '', 'follow up from ovarectomy (months)', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tfri_coeur_dxd_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='help_age at dx' AND `language_label`='age_at_dx' AND `language_tag`=''), 
'1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_coeur_dxd_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='tfri_coeur_dxd_ovaries' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), 
'1', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='tfri_coeur_dxd_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='tfri_coeur_dxd_ovaries' AND `field`='fallopian_tube_lesion' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_coeur_fallopian_tube_lesions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='fallopian tube lesion' AND `language_tag`=''), 
'1', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_coeur_dxd_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='tfri_coeur_dxd_ovaries' AND `field`='presence_of_precursor_of_benign_lesions' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_coeur_presence_of_precursor_of_benign_lesions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='presence of precursor of benign lesions' AND `language_tag`=''), 
'1', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_coeur_dxd_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='tfri_coeur_dxd_ovaries' AND `field`='histopathology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_coeur_histopathology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histopathology' AND `language_tag`=''), 
'1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_coeur_dxd_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='tfri_coeur_dxd_ovaries' AND `field`='reviewed_histopathology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_coeur_histopathology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='reviewed histopathology'), 
'1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_coeur_dxd_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_coeur_grades')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumour grade' AND `language_tag`=''), 
'1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_coeur_dxd_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='tfri_coeur_dxd_ovaries' AND `field`='figo' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_coeur_figo')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='figo' AND `language_tag`=''), 
'1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_coeur_dxd_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='tfri_coeur_dxd_ovaries' AND `field`='residual_disease' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_coeur_residual_diseases')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='residual disease' AND `language_tag`=''), 
'1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_coeur_dxd_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='tfri_coeur_dxd_ovaries' AND `field`='progression_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_coeur_progression_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='progression status' AND `language_tag`=''), 
'2', '20', 'progression', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_coeur_dxd_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='tfri_coeur_dxd_ovaries' AND `field`='progression_time_in_months' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='progression time (months)' AND `language_tag`=''), 
'2', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_coeur_dxd_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='tfri_coeur_dxd_ovaries' AND `field`='ca125_progression_time_in_months' AND `type`='integer_positive' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ca125 progression time in months' AND `language_tag`=''), 
'2', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_coeur_dxd_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='tfri_coeur_dxd_ovaries' AND `field`='follow_up_from_ovarectomy_in_months' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='follow up from ovarectomy (months)' AND `language_tag`=''), 
'2', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tfri_coeur_dxd_ovaries'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), 
'2', '24', '', '0', '1', 'survival from ovarectomy (months)', '0', '', '1', '', '0', '', '1', 'size=3', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
("tfri coeur - ovary", "Ovary (TFRI COEUR)", "Ovaire (TFRI COEUR)"),
("bilateral", "Bilateral", "Bilatéral(e)"),
("ca125 progression time in months", "CA125 progression (Months)", "Progression CA125 (mois)"),
("fallopian tube lesion", "Fallopian Tube Lesion", "Lésion de la trompe de Fallope"),
("figo", "Figo", "Figo"),
("follow up from ovarectomy (months)", "Follow up from Ovarectomy (months)", "Suivi depuis ovarectomie (mois)"),
("histopathology", "Histopathology", "Histopathologie"),
("presence of precursor of benign lesions", "Presence of precursor of benign lesions", "Présence de lésions bénignes précurseures"),
("progression status", "Progression Status", "Statut de progression"),
("progression time (months)", "Progression (months)", "Progression (mois)"),
("residual disease", "Residual disease", "Maladie résiduelle"),
("reviewed histopathology", "Reviewed", "Révisé"),
("survival from ovarectomy (months)", "Survival from Ovarectomy (months)", "Suivi depuis ovarectomie (mois)");
 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;