-- ------------------------------------------------------
-- ATiM ... Data Script
-- version: 2.7.2
-- ------------------------------------------------------

-- user_id (To Define)

SET @user_id = (SELECT id FROM users WHERE username LIKE '%' AND id LIKE '1');

-- --------------------------------------------------------------------------------
-- CTRNET BREAST Primary Diagnosis
-- ................................................................................
-- Primary diagnosis forms proposed by CTRNet to capture data of breast primary 
-- cancer.
-- --------------------------------------------------------------------------------

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) 
VALUES
(null, 'primary', 'ctrnet demo - breast', 1, 'ctrnet_demo_dxd_breasts', 'ctrnet_demo_dxd_breasts', 0, 'primary|ctrnet demo - breast', 0);

DROP TABLE IF EXISTS `ctrnet_demo_dxd_breasts`;
CREATE TABLE IF NOT EXISTS `ctrnet_demo_dxd_breasts` (
  `diagnosis_master_id` int(11) NOT NULL,
  `laterality` varchar(50) NOT NULL DEFAULT '',
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `ctrnet_demo_dxd_breasts_revs`;
CREATE TABLE IF NOT EXISTS `ctrnet_demo_dxd_breasts_revs` (
  `diagnosis_master_id` int(11) NOT NULL,
  `laterality` varchar(50) NOT NULL DEFAULT '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `ctrnet_demo_dxd_breasts`
  ADD CONSTRAINT `FK_ctrnet_demo_dxd_breasts_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

ALTER TABLE diagnosis_masters
   MODIFY clinical_tstage varchar(50),
   MODIFY clinical_nstage varchar(50),
   MODIFY clinical_mstage varchar(50),
   MODIFY clinical_stage_summary varchar(50),
   MODIFY path_tstage varchar(50),
   MODIFY path_nstage varchar(50),
   MODIFY path_mstage varchar(50),
   MODIFY path_stage_summary varchar(50);
ALTER TABLE diagnosis_masters_revs
   MODIFY clinical_tstage varchar(50),
   MODIFY clinical_nstage varchar(50),
   MODIFY clinical_mstage varchar(50),
   MODIFY clinical_stage_summary varchar(50),
   MODIFY path_tstage varchar(50),
   MODIFY path_nstage varchar(50),
   MODIFY path_mstage varchar(50),
   MODIFY path_stage_summary varchar(50);

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("bilateral", "bilateral");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="laterality"), 
(SELECT id FROM structure_permissible_values WHERE value="bilateral" AND language_alias="bilateral"), "0", "1"); 

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('ctrnet_demo_breast_dx_nature', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'CTRNet Demo : Breast Diagnosis Nature\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('CTRNet Demo : Breast Diagnosis Nature', 1, 50, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'CTRNet Demo : Breast Diagnosis Nature');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("normal", "Normal", "Normal", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("benign", "Benign", "Bénin", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("malignant", "Malignant", "Malin", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("uncertain", "Uncertain", "Incertain", "7", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("in situ", "In Situ", "In situ", "6", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('ctrnet_demo_breast_tumour_grade', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'CTRNet Demo : Breast Diagnosis Grade\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('CTRNet Demo : Breast Diagnosis Grade', 1, 50, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'CTRNet Demo : Breast Diagnosis Grade');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("1", "1", "", "185", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2", "2", "", "186", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3", "3", "", "187", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("u", "U", "", "188", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('ctrnet_demo_ajcc_edition', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'CTRNet Demo : Ajcc Edition\')');
INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) 
VALUES
('CTRNet Demo : Ajcc Edition', 1, 50, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'CTRNet Demo : Ajcc Edition');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("5th", "5th", "5ème", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("6th", "6th", "6ème", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('ctrnet_demo_breast_ctstage', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'CTRNet Demo : Breast TNM (cT)\')');
INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) 
VALUES
('CTRNet Demo : Breast TNM (cT)', 1, 15, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'CTRNet Demo : Breast TNM (cT)');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("t1", "T1", "", "101", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("t1a", "T1a", "", "103", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("t1b", "T1b", "", "104", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("t1c", "T1c", "", "105", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("t2", "T2", "", "106", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("t3", "T3", "", "107", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("t4", "T4", "", "108", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("tis", "Tis", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("tmi", "Tmi", "", "102", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("tx", "TX", "", "109", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('ctrnet_demo_breast_cnstage', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'CTRNet Demo : Breast TNM (cN)\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('CTRNet Demo : Breast TNM (cN)', 1, 15, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'CTRNet Demo : Breast TNM (cN)');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("n0", "N0", "", "110", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n1", "N1", "", "111", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n2", "N2", "", "112", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n2a", "N2a", "", "113", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n2b", "N2b", "", "114", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n3", "N3", "", "115", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n3a", "N3a", "", "116", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n3b", "N3b", "", "117", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n3c", "N3c", "", "118", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("nx", "NX", "", "119", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source)
VALUES
('ctrnet_demo_breast_cmstage', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'CTRNet Demo : Breast TNM (cM)\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('CTRNet Demo : Breast TNM (cM)', 1, 15, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'CTRNet Demo : Breast TNM (cM)');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("m0", "M0", "", "120", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("m0(i+)", "M0(i+)", "", "121", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("m1", "M1", "", "122", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("mx", "MX", "", "123", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source)
VALUES
('ctrnet_demo_breast_clinical_anatomic_stage', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'CTRNet Demo : Breast Clinical Stage\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category)
VALUES
('CTRNet Demo : Breast Clinical Stage', 1, 15, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'CTRNet Demo : Breast Clinical Stage');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("0", "", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("i", "I", "", "86", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("ia", "IA", "", "87", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("ib", "IB", "", "88", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("ii", "II", "", "89", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("iia", "IIA", "", "90", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("iib", "IIB", "", "91", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("iii", "III", "", "92", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("iiia", "IIIA", "", "93", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("iiib", "IIIB", "", "94", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("iiic", "IIIC", "", "95", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("iv", "IV", "", "96", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("mx", "MX", "", "100", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("nx", "NX", "", "99", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("tx", "TX", "", "98", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("u", "U", "", "97", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source)
VALUES
('ctrnet_demo_breast_ptstage', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'CTRNet Demo : Breast TNM (pT)\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category)
VALUES
('CTRNet Demo : Breast TNM (pT)', 1, 15, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'CTRNet Demo : Breast TNM (pT)');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("t1", "T1", "", "139", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("t1a", "T1a", "", "141", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("t1b", "T1b", "", "142", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("t1c", "T1c", "", "143", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("t1mi", "T1mi", "T1mi", "140", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("t2", "T2", "", "144", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("t3", "T3", "", "145", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("t4", "T4", "", "146", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("Tis", "", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("tx", "TX", "", "147", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source)
VALUES
('ctrnet_demo_breast_pnstage', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'CTRNet Demo : Breast TNM (pN)\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category)
VALUES
('CTRNet Demo : Breast TNM (pN)', 1, 15, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'CTRNet Demo : Breast TNM (pN)');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("n0", "N0", "", "149", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n0(i+)", "N0(i+)", "", "151", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n0(i-)", "N0(i-)", "", "150", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n0(mol+)", "N0(mol+)", "", "153", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n0(mol-)", "N0(mol-)", "", "152", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n1", "N1", "", "154", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n1a", "N1a", "", "156", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n1b", "N1b", "", "157", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n1c", "N1c", "", "158", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n1mi", "N1mi", "", "155", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n2", "N2", "", "159", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n2a", "N2a", "", "160", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n2b", "N2b", "", "161", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n3", "N3", "", "162", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n3a", "N3a", "", "163", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n3b", "N3b", "", "164", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("n3c", "N3c", "", "165", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("nA", "NA", "", "167", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("nx", "NX", "", "166", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("pn", "pN", "", "148", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source)
VALUES
('ctrnet_demo_breast_pmstage', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'CTRNet Demo : Breast TNM (pM)\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category)
VALUES
('CTRNet Demo : Breast TNM (pM)', 1, 15, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'CTRNet Demo : Breast TNM (pM)');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("m0", "M0", "", "168", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("m0(i+)", "M0(i+)", "", "169", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("m1", "M1", "", "170", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("mx", "MX", "", "171", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source)
VALUES
('ctrnet_demo_breast_pathological_anatomic_stage', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'CTRNet Demo : Breast Pathological Anatomic Stage\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category)
VALUES
('CTRNet Demo : Breast Pathological Anatomic Stage', 1, 15, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'CTRNet Demo : Breast Pathological Anatomic Stage');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("0", "", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("i", "I", "", "124", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("ia", "IA", "", "125", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("ib", "IB", "", "126", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("ii", "II", "", "127", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("iia", "IIA", "", "128", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("iib", "IIB", "", "129", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("iii", "III", "", "130", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("iiia", "IIIA", "", "131", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("iiib", "IIIB", "", "132", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("iiic", "IIIC", "", "133", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("iv", "IV", "", "134", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("mx", "MX", "", "138", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("nx", "NX", "", "137", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("tx", "TX", "", "136", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("u", "U", "", "135", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structures(`alias`) VALUES ('ctrnet_demo_dxd_breasts');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'dx_nature', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_dx_nature') , '0', '', '', 'help_dx nature', 'dx nature', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_tumour_grade') , '0', '', '', 'help_tumour grade', 'tumour grade', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'collaborative_staged', 'yes_no',  NULL , '0', '', '', 'help_collaborative staged', 'collaborative staged', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'ajcc_edition', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_ajcc_edition') , '0', '', '', '', 'ajcc edition', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'clinical_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_ctstage') , '0', 'size=1,maxlength=3', '', '', 'clinical stage', 't stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'clinical_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_cnstage') , '0', 'size=1,maxlength=3', '', '', '', 'n stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'clinical_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_cmstage') , '0', 'size=1,maxlength=3', '', '', '', 'm stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'clinical_stage_summary', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_clinical_anatomic_stage') , '0', 'size=1,maxlength=3', '', 'help_clinical_stage_summary', '', 'summary'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_ptstage') , '0', 'size=1,maxlength=3', '', '', 'pathological stage', 't stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_pnstage') , '0', 'size=1,maxlength=3', '', '', '', 'n stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_pmstage') , '0', 'size=1,maxlength=3', '', '', '', 'm stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_stage_summary', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_pathological_anatomic_stage') , '0', 'size=1, maxlength=3', '', 'help_path_stage_summary', '', 'summary'), 
('ClinicalAnnotation', 'DiagnosisDetail', 'ctrnet_demo_dxd_breasts', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '0', '', '', 'dx_laterality', 'laterality', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ctrnet_demo_dxd_breasts'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), 
'1', '6', '', '0', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_dxd_breasts'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), 
'1', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_dxd_breasts'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_dx_nature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx nature' AND `language_label`='dx nature' AND `language_tag`=''), 
'1', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_dxd_breasts'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_tumour_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tumour grade' AND `language_label`='tumour grade' AND `language_tag`=''), 
'1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_dxd_breasts'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='collaborative_staged' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_collaborative staged' AND `language_label`='collaborative staged' AND `language_tag`=''), 
'2', '14', 'staging', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_dxd_breasts'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ajcc_edition' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_ajcc_edition')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ajcc edition' AND `language_tag`=''), 
'2', '16', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_dxd_breasts'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_ctstage')  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='clinical stage' AND `language_tag`='t stage'), 
'2', '19', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_dxd_breasts'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_cnstage')  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), 
'2', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_dxd_breasts'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_cmstage')  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), 
'2', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_dxd_breasts'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_clinical_anatomic_stage')  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='help_clinical_stage_summary' AND `language_label`='' AND `language_tag`='summary'), 
'2', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_dxd_breasts'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_ptstage')  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='pathological stage' AND `language_tag`='t stage'),
'2', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_dxd_breasts'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_pnstage')  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), 
'2', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_dxd_breasts'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_pmstage')  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), 
'2', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_dxd_breasts'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_demo_breast_pathological_anatomic_stage')  AND `flag_confidential`='0' AND `setting`='size=1, maxlength=3' AND `default`='' AND `language_help`='help_path_stage_summary' AND `language_label`='' AND `language_tag`='summary'), 
'2', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_dxd_breasts'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ctrnet_demo_dxd_breasts' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='dx_laterality' AND `language_label`='laterality' AND `language_tag`=''), 
'1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
("ctrnet demo - breast", "Breast (CTRNet Demo)", "Sein (CTRNet démo)");

-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;