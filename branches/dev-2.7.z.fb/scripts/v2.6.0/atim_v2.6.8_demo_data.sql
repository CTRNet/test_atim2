-- ------------------------------------------------------
-- ATiM Demo Data Script
-- version: 2.6.8
--
-- Note: To run after 
--              atim_v2.6.0_full_installation.sql
--              atim_v2.6.1_upgrade.sql
--              atim_v2.6.2_upgrade.sql
--              atim_v2.6.3_upgrade.sql
--              atim_v2.6.4_upgrade.sql
--              atim_v2.6.5_upgrade.sql
--              atim_v2.6.6_upgrade.sql
--              atim_v2.6.7_upgrade.sql
--              atim_v2.6.8_upgrade.sql
--
-- For more information: 
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- ------------------------------------------------------

SET FOREIGN_KEY_CHECKS=0;

ALTER TABLE structure_permissible_values_customs 
  MODIFY created_by int(10) unsigned DEFAULT '1',
  MODIFY modified_by int(10) unsigned DEFAULT '1';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Custom forms properties and controls
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

update groups set flag_show_confidential = 1 where id = 1;
update users set flag_active = 1 where id = 1;
INSERT INTO i18n (id,en,fr) VALUES ('core_installname', 'CTRNet - Demo', 'CTRNet - Demo');

-- Banks 
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `banks` (`id`, `name`, `description`, `misc_identifier_control_id`, `created_by`, `created`, `modified_by`, `modified`, `deleted`) VALUES
(2, 'Prostate', '', NULL, 1, '2012-07-31 19:00:44', 1, '2012-07-31 19:28:19', 0),
(3, 'Breast', '', NULL, 1, '2012-07-31 19:28:31', 1, '2012-07-31 19:28:31', 0);

-- Profile 
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Identifiers
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Hide dates and note fields

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Create controls

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`) VALUES
(1, 'BR_Nbr', 1, 1, 'br', 'BR%%key_increment%%', 0, 0, 1, 0, '', ''),
(2, 'PR_Nbr', 1, 2, 'pr', 'PR%%key_increment%%', 0, 0, 1, 0, '', ''),
(3, 'hospital number', 1, 4, '', '', 1, 1, 1, 0, '', '');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('BR_Nbr', 'Breast - Bank#', 'Sein - Banque #'),
('PR_Nbr', 'Prostate - Bank#', 'Prostate - Banque #');

-- Add study to identifier forms

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, flag_link_to_study) 
VALUES
('patient study id', 1, '', '', 0, 0, 0, 0, '', '', '1');
INSERT INTO i18n (id,en,fr) 
VALUES 
('patient study id', 'Patient Study ID', 'ID Patient - Étude');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Activate StudySummary to MiscIdentifier databrowser link

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- Consent 
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Hide cd_nationals form fields

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='surgeon' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='operation_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='facility' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='facility_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_person' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='process_status' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Create study consent

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'study consent', 1, 'consent_masters_study', 'cd_nationals', 0, 'study consent');
INSERT INTO i18n (id,en,fr) VALUES ('study consent', 'Sudy Consent', 'Consentement d''étude');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `field`='autocomplete_consent_study_summary_id'), 'notEmpty', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '2', '', '0', '1', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters_study') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Activate StudySummary to ConsentMaster databrowser link

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- Diagnosis 
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Change 'tissue' diagnosis control to 'other tissue'

UPDATE diagnosis_controls SET controls_type = 'other tissue', databrowser_label = REPLACE(databrowser_label, '|tissue', '|other tissue') WHERE controls_type = 'tissue';
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('other tissue', 'Other Tissue', 'Autre tissu');

-- Changed tumor grade to Gx...

UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="tumour grade");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES ("G1", "G1"),("G2", "G2"),("G3", "G3"),("G4", "G4"),("Gx", "Gx");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="tumour grade"), (SELECT id FROM structure_permissible_values WHERE value="G1" AND language_alias="G1"), "0", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="tumour grade"), (SELECT id FROM structure_permissible_values WHERE value="G2" AND language_alias="G2"), "0", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="tumour grade"), (SELECT id FROM structure_permissible_values WHERE value="G3" AND language_alias="G3"), "0", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="tumour grade"), (SELECT id FROM structure_permissible_values WHERE value="G4" AND language_alias="G4"), "0", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="tumour grade"), (SELECT id FROM structure_permissible_values WHERE value="Gx" AND language_alias="Gx"), "0", "1");
INSERT INTO i18n (id,en,fr)
 VALUES 
 ("G1", "G1", "G1"),("G2", "G2", "G2"),("G3", "G3", "G3"),("G4", "G4", "G4"),("Gx", "Gx", "Gx");

-- Create 'breast' diagnosis control

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'primary', 'breast', 1, 'dx_primary,demo_dx_tissues', 'dxd_tissues', 0, 'primary|breast', 1);
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('demo_clinical_anatomic_stage', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Clinical Anatomic Stage')"),
('demo_tnm_ct', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (cT)')"),
('demo_tnm_cn', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (cN)')"),
('demo_tnm_cm', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (cM)')"),
('demo_pathological_anatomic_stage', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Pathological Anatomic Stage')"),
('demo_tnm_pt', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (pT)')"),
('demo_tnm_pn', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (pN)')"),
('demo_tnm_pm', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (pM)')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('DX : Clinical Anatomic Stage', 1, 50, 'clinical - diagnosis'),
('DX : TNM (cT)', 1, 50, 'clinical - diagnosis'),
('DX : TNM (cN)', 1, 50, 'clinical - diagnosis'),
('DX : TNM (cM)', 1, 50, 'clinical - diagnosis'),
('DX : Pathological Anatomic Stage', 1, 50, 'clinical - diagnosis'),
('DX : TNM (pT)', 1, 50, 'clinical - diagnosis'),
('DX : TNM (pN)', 1, 50, 'clinical - diagnosis'),
('DX : TNM (pM)', 1, 50, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Clinical Anatomic Stage');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('i', 'I',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('ia', 'IA',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('ib', 'IB',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('ii', 'II',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iia', 'IIA',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iib', 'IIB',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iii', 'III',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iiia', 'IIIA',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iiib', 'IIIB',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iiic', 'IIIC',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iv', 'IV',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('u', 'U',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('tx', 'TX',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('nx', 'NX',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('mx', 'MX',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (cT)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('t1', 'T1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('mi', 'mi',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('1a', '1a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('1b', '1b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('1c', '1c',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t2', 'T2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t3', 'T3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t4', 'T4',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('tx', 'TX',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (cN)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('n0', 'N0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n1', 'N1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n2', 'N2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('2a', '2a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('2b', '2b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n3', 'N3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('3a', '3a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('3b', '3b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('3c', '3c',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('nx', 'NX',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (cM)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('m0', 'M0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('cm0(i+)', 'cM0(I+)',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('m1', 'M1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('mx', 'MX',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Pathological Anatomic Stage');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('i', 'I',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('ia', 'IA',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('ib', 'IB',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('ii', 'II',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iia', 'IIA',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iib', 'IIB',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iii', 'III',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iiia', 'IIIA',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iiib', 'IIIB',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iiic', 'IIIC',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iv', 'IV',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('u', 'U',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('tx', 'TX',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('nx', 'NX',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('mx', 'MX',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (pT)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('t1', 'T1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('mi', 'mi',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('1a', '1a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('1b', '1b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('1c', '1c',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t2', 'T2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t3', 'T3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t4', 'T4',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('tx', 'TX',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (pN)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('pn', 'pN',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n0', 'N0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n0(i-)', 'N0(i-)',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n0(1+)', 'N0(1+)',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n0(mol-)', 'N0(mol-)',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n0(mol+)', 'N0(mol+)',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n1', 'N1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n1mi', 'N1mi',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n1a', 'N1a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n1b', 'N1b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n1c', 'N1c',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n2', 'N2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n2a', 'N2a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n2b', 'N2b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n3', 'N3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n3a', 'N3a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n3b', 'N3b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n3c', 'N3c',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('nx', 'NX',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('nA', 'NA',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (pM)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('m0', 'M0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('cm0(i+)', 'cM0(I+)',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('m1', 'M1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('mx', 'MX',  '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structures(`alias`) VALUES ('demo_dx_tissues');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'clinical_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='demo_tnm_ct') , '0', '', '', '', 'clinical stage', 't stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'clinical_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='demo_tnm_cn') , '0', '', '', '', '', 'n stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'clinical_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='demo_tnm_cm') , '0', '', '', '', '', 'm stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'clinical_stage_summary', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='demo_clinical_anatomic_stage') , '0', '', '', 'help_clinical_stage_summary', '', 'summary'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='demo_tnm_pt') , '0', '', '', '', 'pathological stage', 't stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='demo_tnm_pn') , '0', '', '', '', '', 'n stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='demo_tnm_pm') , '0', '', '', '', '', 'm stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_stage_summary', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='demo_pathological_anatomic_stage') , '0', '', '', 'help_path_stage_summary', '', 'summary');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='demo_dx_tissues'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tissues' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='dx_laterality' AND `language_label`='laterality' AND `language_tag`=''), '2', '99', 'tissue specific', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='demo_dx_tissues'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx nature' AND `language_label`='dx nature' AND `language_tag`=''), '1', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='demo_dx_tissues'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '6', '', '0', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='demo_dx_tissues'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tumour grade' AND `language_label`='tumour grade' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='demo_dx_tissues'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='demo_tnm_ct')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='clinical stage' AND `language_tag`='t stage'), '2', '19', 'staging', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='demo_dx_tissues'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='demo_tnm_cn')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='demo_dx_tissues'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='demo_tnm_cm')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='demo_dx_tissues'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='demo_clinical_anatomic_stage')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_clinical_stage_summary' AND `language_label`='' AND `language_tag`='summary'), '2', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='demo_dx_tissues'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='demo_tnm_pt')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pathological stage' AND `language_tag`='t stage'), '2', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='demo_dx_tissues'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='demo_tnm_pn')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='demo_dx_tissues'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='demo_tnm_pm')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='demo_dx_tissues'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='demo_pathological_anatomic_stage')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_path_stage_summary' AND `language_label`='' AND `language_tag`='summary'), '2', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='demo_dx_tissues'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Treatment 
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Hide surgery without extension

UPDATE treatment_controls SET flag_active = 0 WHERE tx_method = 'surgery without extension';
SET @id_1 = (SELECT id FROM treatment_controls WHERE tx_method = 'surgery without extension');
SET @id_2 = (SELECT id FROM treatment_controls WHERE tx_method = 'surgery');
UPDATE treatment_masters SET treatment_control_id = @id_2 WHERE treatment_control_id = @id_1;

-- Create surgery site field that uses the 'icd_0_3_topography_categories' structure_Value_domain

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'target_site_icdo', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='icd_0_3_topography_categories') , '0', '', '', 'help_target_site_icdo', 'site', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='target_site_icdo' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='icd_0_3_topography_categories') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='target_site_icdo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='target_site_icdo' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='icd_0_3_topography_categories') AND `flag_confidential`='0');

-- Create radiation site field that uses the 'icd_0_3_topography_categories' structure_Value_domain

UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='target_site_icdo' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='icd_0_3_topography_categories') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='target_site_icdo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='target_site_icdo' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='icd_0_3_topography_categories') AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('site', 'Site', 'Site');

-- Event 
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Add CT-SCan

INSERT INTO event_controls (disease_site,event_group,event_type,flag_active,detail_form_alias,detail_tablename,databrowser_label,flag_use_for_ccl,use_addgrid,use_detail_form_for_index)
VALUES
('general', 'clinical', 'ct-scan', '1', 'demo_ed_all_ct_scan', 'demo_ed_all_ct_scans', 'clinical|general|ct-scan', '0', '1', '1');
INSERT INTO structures(`alias`) VALUES ('demo_ed_all_ct_scan');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'demo_ed_all_ct_scans', 'result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='result') , '0', '', '', '', 'result', ''), 
('ClinicalAnnotation', 'EventDetail', 'demo_ed_all_ct_scans', 'icd_O_3_category', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='icd_0_3_topography_categories') , '0', '', '', '', 'site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='demo_ed_all_ct_scan'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='demo_ed_all_ct_scans' AND `field`='result' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='result')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='result' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='demo_ed_all_ct_scan'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='demo_ed_all_ct_scan'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='demo_ed_all_ct_scans' AND `field`='icd_O_3_category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='icd_0_3_topography_categories')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
CREATE TABLE IF NOT EXISTS `demo_ed_all_ct_scans` (
  `icd_O_3_category` varchar(3) DEFAULT NULL,
  `result` varchar(10) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `demo_ed_all_ct_scans_revs` (
  `icd_O_3_category` varchar(3) DEFAULT NULL,
  `result` varchar(10) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `demo_ed_all_ct_scans`
  ADD CONSTRAINT `demo_ed_all_ct_scans_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT IGNORE INTO i18n (id,en,fr) VALUEs ('ct-scan','CT-Scan','CT-Scan');

-- Study Tool 
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Change the 'studysummaries' form fields list

ALTER TABLE study_summaries 
  ADD COLUMN demo_institution VARCHAR(50) DEFAULT NULL,
  ADD COLUMN demo_ethical_approved char(1) DEFAULT '', 
  ADD COLUMN demo_ethical_approval_file_name varchar(500) DEFAULT null,
  ADD COLUMN demo_mta_data_sharing_approved char(1) DEFAULT '', 
  ADD COLUMN demo_mta_data_sharing_approved_file_name varchar(500) DEFAULT null,
  ADD COLUMN demo_pubmed_ids TEXT DEFAULT NULL;
ALTER TABLE study_summaries_revs 
  ADD COLUMN demo_institution VARCHAR(50) DEFAULT NULL,
  ADD COLUMN demo_ethical_approved char(1) DEFAULT '', 
  ADD COLUMN demo_ethical_approval_file_name varchar(500) DEFAULT null,
  ADD COLUMN demo_mta_data_sharing_approved char(1) DEFAULT '', 
  ADD COLUMN demo_mta_data_sharing_approved_file_name varchar(500) DEFAULT null,
  ADD COLUMN demo_pubmed_ids TEXT DEFAULT NULL;  
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('demo_institutions', "StructurePermissibleValuesCustom::getCustomDropdown('Institutions')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Institutions', 1, 50, 'study / project');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Institutions');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'demo_ethical_approved', 'yes_no',  NULL , '0', '', '', '', 'ethic', ''), 
('Study', 'StudySummary', 'study_summaries', 'demo_ethical_approval_file_name', 'input',  NULL , '0', 'size=50', '', '', '', 'file name'), 
('Study', 'StudySummary', 'study_summaries', 'demo_mta_data_sharing_approved', 'yes_no',  NULL , '0', '', '', '', 'mta data sharing', ''), 
('Study', 'StudySummary', 'study_summaries', 'demo_mta_data_sharing_approved_file_name', 'input',  NULL , '0', 'size=50', '', '', '', 'file name'),
('Study', 'StudySummary', 'study_summaries', 'demo_institution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='demo_institutions') , '0', '', '', '', 'laboratory / institution', ''),
('Study', 'StudySummary', 'study_summaries', 'demo_pubmed_ids', 'textarea',  NULL , '0', 'cols=40,rows=1', '', '', 'pubmed ids', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='demo_ethical_approved' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ethic' AND `language_tag`=''), '2', '1', 'approval', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='demo_ethical_approval_file_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='file name'), '2', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='demo_mta_data_sharing_approved' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mta data sharing' AND `language_tag`=''), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='demo_mta_data_sharing_approved_file_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='file name'), '2', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='demo_institution'), '1', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='demo_pubmed_ids' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=1' AND `default`='' AND `language_help`='' AND `language_label`='pubmed ids' AND `language_tag`=''), '2', '20', 'literature', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='30', `language_heading`='details' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) 
VALUES
('laboratory / institution', 'Laboratory/Institution','Laboratoire/Institution'),
('approval', 'Approval', 'Approbation'),
('ethic', 'Ethic', 'éthique'),
('file name', 'File Name', 'Nom du fichier'),
('mta data sharing', 'MTA Data Sharing', 'Partage de matériels et de données'),
('literature','Literature','Literature'),
('pubmed ids','PubMed IDs','PubMed IDs');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');

-- Change the 'studyinvestigators' form fields list

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='occupation' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='department' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='organization' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='participation_start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='participation_end_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='-1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='role' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='role') AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_label`='study_city',  `language_tag`='' WHERE model='StudyInvestigator' AND tablename='study_investigators' AND field='address_city' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='study_province',  `language_tag`='' WHERE model='StudyInvestigator' AND tablename='study_investigators' AND field='address_province' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='study_country',  `language_tag`='' WHERE model='StudyInvestigator' AND tablename='study_investigators' AND field='address_country' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='study_street',  `language_tag`='' WHERE model='StudyInvestigator' AND tablename='study_investigators' AND field='address_street' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_column`='1', `display_order`='50' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='brief' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='study_address' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='address_street' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='organization' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='email' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyinvestigators') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='role' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='role') AND `flag_confidential`='0');

-- Change the 'studyfundings' form fields list

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyfundings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyFunding' AND `tablename`='study_fundings' AND `field`='restrictions' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyfundings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyFunding' AND `tablename`='study_fundings' AND `field`='amount_year_1' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyfundings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyFunding' AND `tablename`='study_fundings' AND `field`='year_1' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyfundings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyFunding' AND `tablename`='study_fundings' AND `field`='amount_year_2' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyfundings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyFunding' AND `tablename`='study_fundings' AND `field`='year_2' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyfundings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyFunding' AND `tablename`='study_fundings' AND `field`='amount_year_3' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyfundings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyFunding' AND `tablename`='study_fundings' AND `field`='year_3' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyfundings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyFunding' AND `tablename`='study_fundings' AND `field`='amount_year_4' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyfundings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyFunding' AND `tablename`='study_fundings' AND `field`='year_4' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyfundings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyFunding' AND `tablename`='study_fundings' AND `field`='amount_year_5' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studyfundings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyFunding' AND `tablename`='study_fundings' AND `field`='year_5' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Add values to custom list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Institutions');
REPLACE INTO `structure_permissible_values_customs` (`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`) 
VALUES
(@control_id, 'CNRT', '', '', 0, 1),
(@control_id, 'BC Cancer Agency', '', '', 0, 1),
(@control_id, 'CRCHUM', '', '', 0, 1);

-- Inventory
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Use icd_0_3_topography_categories for tissue source

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='icd_0_3_topography_categories')  WHERE model='SampleDetail' AND tablename='sd_spe_tissues' AND field='tissue_source' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list');

-- TMA Slide
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Activate OrderItem to TmaSlide databrowser link

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');

-- Activate TmaSlideUse to other models databrowser link

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- Order Tool 
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Activate StudySummary to OrderLine databrowser link

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'OrderLine'); 
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderLine') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Order');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderLine') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- Populate custom list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Orders Contacts');
REPLACE INTO `structure_permissible_values_customs` (`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`) 
VALUES
(@control_id, 'Michele Obstar', '', '', 0, 1),
(@control_id, 'Jason Miro', '', '', 0, 1),
(@control_id, 'Dr Champlain', '', '', 0, 1),
(@control_id, 'Dr Vanorm', '', '', 0, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Orders Institutions');
REPLACE INTO `structure_permissible_values_customs` (`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`) 
VALUES
(@control_id, 'R.O.R.', '', '', 0, 1),
(@control_id, 'CCRaTy', '', '', 0, 1);

-- Storage
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE storage_controls SET flag_active = 0 WHERE storage_type = 'TMA-blc 23X15';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types');
UPDATE `structure_permissible_values_customs` 
SET en = 'TMA-block',
fr = 'TMA-bloc'
WHERE control_id = @control_id AND value = 'TMA-blc 29X21';

-- Other Custom Drop Down List
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Consent Form Versions');
INSERT INTO `structure_permissible_values_customs` (`id`, `control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`) VALUES
(null, @control_id, 'v1.0', '', '', 0, 1),
(null, @control_id, 'v2.0', '', '', 0, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Specimen Collection Sites');
INSERT INTO `structure_permissible_values_customs` (`id`, `control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`) VALUES
(null, @control_id, 'surg room 1', 'Surgery Room #1', 'Chambre Opératoire #1', 0, 1),
(null, @control_id, 'surg  room 2', 'Surgery Room #2', 'Chambre Opératoire #2', 0, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Laboratory Staff');
INSERT INTO `structure_permissible_values_customs` (`id`, `control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`) VALUES
(null, @control_id, 'res. assist. 1', 'Lise R.', 'Lise R.', 0, 1),
(null, @control_id, 'tech. 2', 'Arnold P.', 'Arnold P.', 0, 1),
(null, @control_id, 'tech. 1', 'Vanessa R.', 'Vanessa R.', 0, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Laboratory Sites');
INSERT INTO `structure_permissible_values_customs` (`id`, `control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`) VALUES
(null, @control_id, 'r523', '', '', 0, 1),
(null, @control_id, 'r644', '', '', 0, 1),
(null, @control_id, 'r645', '', '', 0, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Quality Control Tools');
INSERT INTO `structure_permissible_values_customs` (`id`, `control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`) VALUES
(null, @control_id, 'Spect 99', '', '', 0, 1),
(null, @control_id, 'BioAnalyzer 007', '', '', 0, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Specimen Supplier Departments');
INSERT INTO `structure_permissible_values_customs` (`id`, `control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`) VALUES
(null, @control_id, 'patho dpt', 'Pathology Dept.', '', 0, 1),
(null, @control_id, 'Surgery Room', 'Chambre Opératoir', '', 0, 1);

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE structure_permissible_values_customs
  MODIFY created_by int(10) unsigned NOT NULL,
  MODIFY modified_by int(10) unsigned NOT NULL;
  
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Data
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

INSERT INTO `ad_blocks` (`aliquot_master_id`, `block_type`, `patho_dpt_block_code`) VALUES
(1, 'frozen', ''),
(2, 'frozen', ''),
(3, 'frozen', ''),
(4, 'frozen', ''),
(5, 'frozen', ''),
(6, 'frozen', ''),
(7, 'frozen', ''),
(8, 'frozen', ''),
(9, 'frozen', ''),
(10, 'frozen', ''),
(11, 'frozen', ''),
(12, 'frozen', ''),
(13, 'frozen', ''),
(14, 'frozen', ''),
(40, 'frozen', ''),
(41, 'frozen', ''),
(119, 'frozen', ''),
(120, 'frozen', ''),
(121, 'frozen', ''),
(122, 'frozen', ''),
(123, 'frozen', ''),
(124, 'frozen', '');

INSERT INTO `ad_blocks_revs` (`aliquot_master_id`, `block_type`, `patho_dpt_block_code`, `version_id`, `version_created`) VALUES
(1, 'frozen', '', 1, '2012-07-31 19:34:31'),
(2, 'frozen', '', 2, '2012-07-31 19:34:32'),
(3, 'frozen', '', 3, '2012-07-31 19:34:32'),
(4, 'frozen', '', 4, '2012-07-31 19:34:33'),
(5, 'frozen', '', 5, '2012-07-31 19:34:34'),
(6, 'frozen', '', 6, '2012-07-31 19:34:34'),
(7, 'frozen', '', 7, '2012-07-31 19:34:35'),
(8, 'frozen', '', 8, '2012-07-31 19:34:35'),
(9, 'frozen', '', 9, '2012-07-31 19:34:36'),
(10, 'frozen', '', 10, '2012-07-31 19:34:36'),
(11, 'frozen', '', 11, '2012-07-31 19:34:37'),
(12, 'frozen', '', 12, '2012-07-31 19:42:15'),
(13, 'frozen', '', 13, '2012-07-31 19:42:16'),
(14, 'frozen', '', 14, '2012-07-31 19:42:16'),
(40, 'frozen', '', 15, '2012-07-31 20:46:47'),
(41, 'frozen', '', 16, '2012-07-31 20:46:48'),
(41, 'frozen', '', 17, '2012-08-01 13:08:33'),
(1, 'frozen', '', 18, '2012-08-01 13:32:09'),
(10, 'frozen', '', 19, '2012-08-01 13:32:11'),
(11, 'frozen', '', 20, '2012-08-01 13:32:13'),
(12, 'frozen', '', 21, '2012-08-01 13:32:16'),
(13, 'frozen', '', 22, '2012-08-01 13:32:19'),
(14, 'frozen', '', 23, '2012-08-01 13:32:21'),
(2, 'frozen', '', 24, '2012-08-01 13:32:23'),
(3, 'frozen', '', 25, '2012-08-01 13:32:25'),
(4, 'frozen', '', 26, '2012-08-01 13:32:27'),
(40, 'frozen', '', 27, '2012-08-01 13:32:30'),
(41, 'frozen', '', 28, '2012-08-01 13:32:32'),
(5, 'frozen', '', 29, '2012-08-01 13:32:33'),
(6, 'frozen', '', 30, '2012-08-01 13:32:35'),
(7, 'frozen', '', 31, '2012-08-01 13:32:36'),
(8, 'frozen', '', 32, '2012-08-01 13:32:37'),
(9, 'frozen', '', 33, '2012-08-01 13:32:38'),
(41, 'frozen', '', 34, '2012-08-01 13:43:34'),
(14, 'frozen', '', 35, '2012-08-01 13:43:35'),
(10, 'frozen', '', 36, '2012-08-01 13:43:36'),
(1, 'frozen', '', 37, '2012-08-01 13:45:38'),
(1, 'frozen', '', 38, '2012-08-01 13:45:38'),
(12, 'frozen', '', 39, '2012-08-01 13:45:39'),
(12, 'frozen', '', 40, '2012-08-01 13:45:39'),
(2, 'frozen', '', 41, '2012-08-01 13:45:40'),
(2, 'frozen', '', 42, '2012-08-01 13:45:40'),
(40, 'frozen', '', 43, '2012-08-01 13:45:41'),
(40, 'frozen', '', 44, '2012-08-01 13:45:42'),
(7, 'frozen', '', 45, '2012-08-01 13:45:43'),
(7, 'frozen', '', 46, '2012-08-01 13:45:43'),
(13, 'frozen', '', 47, '2012-08-02 19:45:49'),
(3, 'frozen', '', 48, '2014-02-14 20:19:47'),
(4, 'frozen', '', 49, '2014-02-14 20:19:48'),
(5, 'frozen', '', 50, '2014-02-14 20:19:50'),
(6, 'frozen', '', 51, '2014-02-14 20:19:51'),
(8, 'frozen', '', 52, '2014-02-14 20:19:53'),
(9, 'frozen', '', 53, '2014-02-14 20:19:54'),
(10, 'frozen', '', 54, '2014-02-14 20:19:56'),
(11, 'frozen', '', 55, '2014-02-14 20:19:57'),
(13, 'frozen', '', 56, '2014-02-14 20:19:58'),
(14, 'frozen', '', 57, '2014-02-14 20:20:00'),
(41, 'frozen', '', 58, '2014-02-14 20:20:01'),
(119, 'frozen', '', 59, '2016-08-26 19:40:08'),
(120, 'frozen', '', 60, '2016-08-26 19:40:09'),
(121, 'frozen', '', 61, '2016-08-26 19:40:10'),
(122, 'frozen', '', 62, '2016-08-26 19:40:11'),
(123, 'frozen', '', 63, '2016-08-26 19:40:12'),
(124, 'frozen', '', 64, '2016-08-26 19:40:13'),
(120, 'frozen', '', 65, '2016-08-26 19:45:13'),
(119, 'frozen', '', 66, '2016-08-26 19:50:45'),
(120, 'frozen', '', 67, '2016-08-26 19:50:47'),
(121, 'frozen', '', 68, '2016-08-26 19:50:49'),
(122, 'frozen', '', 69, '2016-08-26 19:50:50'),
(123, 'frozen', '', 70, '2016-08-26 19:50:51'),
(124, 'frozen', '', 71, '2016-08-26 19:50:53'),
(120, 'frozen', '', 72, '2016-08-26 20:02:12'),
(120, 'frozen', '', 73, '2016-08-26 20:04:56');

INSERT INTO `ad_tissue_cores` (`aliquot_master_id`) VALUES
(50),
(51),
(52),
(53),
(54),
(55),
(56),
(57),
(58),
(59),
(60),
(61),
(62),
(63),
(64),
(65),
(66),
(67),
(68),
(69),
(70),
(71),
(72),
(73),
(74),
(75),
(76),
(125),
(126),
(127),
(128),
(129),
(130),
(131),
(132),
(133),
(134),
(135),
(136),
(137),
(138),
(139),
(140);

INSERT INTO `ad_tissue_cores_revs` (`aliquot_master_id`, `version_id`, `version_created`) VALUES
(50, 1, '2012-08-01 13:32:09'),
(51, 2, '2012-08-01 13:32:10'),
(52, 3, '2012-08-01 13:32:12'),
(53, 4, '2012-08-01 13:32:13'),
(54, 5, '2012-08-01 13:32:14'),
(55, 6, '2012-08-01 13:32:15'),
(56, 7, '2012-08-01 13:32:16'),
(57, 8, '2012-08-01 13:32:17'),
(58, 9, '2012-08-01 13:32:19'),
(59, 10, '2012-08-01 13:32:20'),
(60, 11, '2012-08-01 13:32:21'),
(61, 12, '2012-08-01 13:32:22'),
(62, 13, '2012-08-01 13:32:23'),
(63, 14, '2012-08-01 13:32:24'),
(64, 15, '2012-08-01 13:32:26'),
(65, 16, '2012-08-01 13:32:26'),
(66, 17, '2012-08-01 13:32:28'),
(67, 18, '2012-08-01 13:32:29'),
(68, 19, '2012-08-01 13:32:30'),
(69, 20, '2012-08-01 13:32:31'),
(70, 21, '2012-08-01 13:32:32'),
(71, 22, '2012-08-01 13:32:33'),
(72, 23, '2012-08-01 13:32:34'),
(73, 24, '2012-08-01 13:32:35'),
(74, 25, '2012-08-01 13:32:36'),
(75, 26, '2012-08-01 13:32:38'),
(76, 27, '2012-08-01 13:32:39'),
(50, 28, '2012-08-01 13:33:29'),
(51, 29, '2012-08-01 13:33:30'),
(52, 30, '2012-08-01 13:33:30'),
(53, 31, '2012-08-01 13:33:31'),
(54, 32, '2012-08-01 13:33:31'),
(55, 33, '2012-08-01 13:33:32'),
(62, 34, '2012-08-01 13:33:33'),
(63, 35, '2012-08-01 13:33:33'),
(64, 36, '2012-08-01 13:33:34'),
(65, 37, '2012-08-01 13:33:34'),
(66, 38, '2012-08-01 13:33:35'),
(67, 39, '2012-08-01 13:33:35'),
(72, 40, '2012-08-01 13:33:36'),
(73, 41, '2012-08-01 13:33:36'),
(74, 42, '2012-08-01 13:33:37'),
(75, 43, '2012-08-01 13:33:38'),
(76, 44, '2012-08-01 13:33:38'),
(56, 45, '2012-08-01 13:33:39'),
(57, 46, '2012-08-01 13:33:40'),
(58, 47, '2012-08-01 13:33:40'),
(59, 48, '2012-08-01 13:33:41'),
(60, 49, '2012-08-01 13:33:41'),
(61, 50, '2012-08-01 13:33:42'),
(68, 51, '2012-08-01 13:33:43'),
(69, 52, '2012-08-01 13:33:43'),
(70, 53, '2012-08-01 13:33:44'),
(71, 54, '2012-08-01 13:33:44'),
(50, 55, '2012-08-01 13:36:01'),
(51, 56, '2012-08-01 13:36:01'),
(52, 57, '2012-08-01 13:36:01'),
(53, 58, '2012-08-01 13:36:02'),
(54, 59, '2012-08-01 13:36:02'),
(55, 60, '2012-08-01 13:36:03'),
(62, 61, '2012-08-01 13:36:03'),
(63, 62, '2012-08-01 13:36:03'),
(64, 63, '2012-08-01 13:36:04'),
(65, 64, '2012-08-01 13:36:04'),
(66, 65, '2012-08-01 13:36:04'),
(67, 66, '2012-08-01 13:36:05'),
(72, 67, '2012-08-01 13:36:05'),
(73, 68, '2012-08-01 13:36:05'),
(74, 69, '2012-08-01 13:36:06'),
(75, 70, '2012-08-01 13:36:06'),
(76, 71, '2012-08-01 13:36:07'),
(56, 72, '2012-08-01 13:36:07'),
(57, 73, '2012-08-01 13:36:07'),
(58, 74, '2012-08-01 13:36:08'),
(59, 75, '2012-08-01 13:36:08'),
(60, 76, '2012-08-01 13:36:08'),
(61, 77, '2012-08-01 13:36:09'),
(68, 78, '2012-08-01 13:36:09'),
(69, 79, '2012-08-01 13:36:10'),
(70, 80, '2012-08-01 13:36:11'),
(71, 81, '2012-08-01 13:36:11'),
(125, 82, '2016-08-26 19:50:46'),
(126, 83, '2016-08-26 19:50:46'),
(127, 84, '2016-08-26 19:50:46'),
(128, 85, '2016-08-26 19:50:47'),
(129, 86, '2016-08-26 19:50:48'),
(130, 87, '2016-08-26 19:50:48'),
(131, 88, '2016-08-26 19:50:48'),
(132, 89, '2016-08-26 19:50:49'),
(133, 90, '2016-08-26 19:50:50'),
(134, 91, '2016-08-26 19:50:51'),
(135, 92, '2016-08-26 19:50:51'),
(136, 93, '2016-08-26 19:50:52'),
(137, 94, '2016-08-26 19:50:52'),
(138, 95, '2016-08-26 19:50:53'),
(139, 96, '2016-08-26 19:50:53'),
(140, 97, '2016-08-26 19:50:54'),
(125, 98, '2016-08-26 19:58:37'),
(126, 99, '2016-08-26 19:58:37'),
(127, 100, '2016-08-26 19:58:38'),
(128, 101, '2016-08-26 19:58:38'),
(129, 102, '2016-08-26 19:58:38'),
(130, 103, '2016-08-26 19:58:39'),
(131, 104, '2016-08-26 19:58:39'),
(132, 105, '2016-08-26 19:58:39'),
(133, 106, '2016-08-26 19:58:40'),
(134, 107, '2016-08-26 19:58:40'),
(135, 108, '2016-08-26 19:58:41'),
(136, 109, '2016-08-26 19:58:41'),
(137, 110, '2016-08-26 19:58:42'),
(138, 111, '2016-08-26 19:58:42'),
(139, 112, '2016-08-26 19:58:43'),
(140, 113, '2016-08-26 19:58:43');

INSERT INTO `ad_tissue_slides` (`aliquot_master_id`, `immunochemistry`) VALUES
(77, ''),
(78, ''),
(79, '');

INSERT INTO `ad_tissue_slides_revs` (`aliquot_master_id`, `immunochemistry`, `version_id`, `version_created`) VALUES
(77, '', 1, '2012-08-01 13:43:34'),
(78, '', 2, '2012-08-01 13:43:36'),
(79, '', 3, '2012-08-01 13:43:37');

INSERT INTO `ad_tubes` (`aliquot_master_id`, `lot_number`, `concentration`, `concentration_unit`, `cell_count`, `cell_count_unit`, `cell_viability`, `hemolysis_signs`) VALUES
(15, '', NULL, NULL, NULL, NULL, NULL, ''),
(16, '', NULL, NULL, NULL, NULL, NULL, ''),
(17, '', NULL, NULL, NULL, NULL, NULL, ''),
(18, '', NULL, NULL, NULL, NULL, NULL, ''),
(19, '', NULL, NULL, NULL, NULL, NULL, ''),
(20, '', NULL, NULL, NULL, NULL, NULL, ''),
(21, '', NULL, NULL, NULL, NULL, NULL, ''),
(22, '', NULL, NULL, NULL, NULL, NULL, ''),
(23, '', NULL, NULL, NULL, NULL, NULL, ''),
(24, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, ''),
(25, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, ''),
(26, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, ''),
(27, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, ''),
(28, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, ''),
(29, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, ''),
(30, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, ''),
(31, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, ''),
(32, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, ''),
(33, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, ''),
(34, '', NULL, NULL, NULL, NULL, NULL, 'n'),
(35, '', NULL, NULL, NULL, NULL, NULL, 'n'),
(36, '', NULL, NULL, NULL, NULL, NULL, 'n'),
(37, '', NULL, NULL, NULL, NULL, NULL, 'n'),
(38, '', NULL, NULL, NULL, NULL, NULL, 'n'),
(39, '', NULL, NULL, NULL, NULL, NULL, 'n'),
(42, '', NULL, NULL, NULL, NULL, NULL, ''),
(43, '', NULL, NULL, NULL, NULL, NULL, ''),
(44, '', NULL, NULL, NULL, NULL, NULL, ''),
(45, '', NULL, NULL, NULL, NULL, NULL, ''),
(46, '', NULL, NULL, NULL, NULL, NULL, ''),
(47, '', NULL, NULL, NULL, NULL, NULL, ''),
(48, '', NULL, NULL, NULL, NULL, NULL, ''),
(49, '', NULL, NULL, NULL, NULL, NULL, ''),
(80, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(81, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(82, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(83, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(84, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(85, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(86, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(87, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(88, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(89, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(90, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(91, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(92, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(93, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(94, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(95, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(96, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(97, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(98, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(99, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(100, '', '12.00', 'ng/ul', NULL, NULL, NULL, ''),
(101, '', NULL, '', NULL, NULL, NULL, ''),
(102, '', NULL, '', NULL, NULL, NULL, ''),
(103, '', NULL, '', NULL, NULL, NULL, ''),
(104, '', NULL, '', NULL, NULL, NULL, ''),
(105, '', NULL, '', NULL, NULL, NULL, ''),
(106, '', NULL, '', NULL, NULL, NULL, ''),
(107, '', NULL, '', NULL, NULL, NULL, ''),
(108, '', NULL, '', NULL, NULL, NULL, ''),
(109, '', NULL, NULL, NULL, NULL, NULL, ''),
(110, '', NULL, NULL, NULL, NULL, NULL, ''),
(111, '', NULL, NULL, NULL, NULL, NULL, ''),
(112, '', NULL, NULL, NULL, NULL, NULL, ''),
(113, '', NULL, NULL, NULL, NULL, NULL, ''),
(114, '', NULL, NULL, NULL, NULL, NULL, ''),
(115, '', NULL, NULL, NULL, NULL, NULL, ''),
(116, '', NULL, NULL, NULL, NULL, NULL, ''),
(117, '', NULL, NULL, NULL, NULL, NULL, ''),
(118, '', NULL, NULL, NULL, NULL, NULL, '');

INSERT INTO `ad_tubes_revs` (`aliquot_master_id`, `lot_number`, `concentration`, `concentration_unit`, `cell_count`, `cell_count_unit`, `cell_viability`, `hemolysis_signs`, `version_id`, `version_created`) VALUES
(15, '', NULL, NULL, NULL, NULL, NULL, '', 1, '2012-07-31 19:45:05'),
(16, '', NULL, NULL, NULL, NULL, NULL, '', 2, '2012-07-31 19:45:06'),
(17, '', NULL, NULL, NULL, NULL, NULL, '', 3, '2012-07-31 19:45:06'),
(18, '', NULL, NULL, NULL, NULL, NULL, '', 4, '2012-07-31 19:45:07'),
(19, '', NULL, NULL, NULL, NULL, NULL, '', 5, '2012-07-31 19:45:07'),
(20, '', NULL, NULL, NULL, NULL, NULL, '', 6, '2012-07-31 19:45:08'),
(21, '', NULL, NULL, NULL, NULL, NULL, '', 7, '2012-07-31 19:48:12'),
(22, '', NULL, NULL, NULL, NULL, NULL, '', 8, '2012-07-31 19:48:12'),
(23, '', NULL, NULL, NULL, NULL, NULL, '', 9, '2012-07-31 19:48:13'),
(24, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, '', 10, '2012-07-31 19:51:21'),
(25, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, '', 11, '2012-07-31 19:51:21'),
(26, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, '', 12, '2012-07-31 19:51:22'),
(27, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, '', 13, '2012-07-31 19:51:22'),
(28, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, '', 14, '2012-07-31 19:51:23'),
(29, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, '', 15, '2012-07-31 19:51:23'),
(30, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, '', 16, '2012-07-31 19:51:24'),
(31, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, '', 17, '2012-07-31 19:51:24'),
(32, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, '', 18, '2012-07-31 19:51:24'),
(33, '#41222', '12.00', 'ug/ul', NULL, NULL, NULL, '', 19, '2012-07-31 19:51:25'),
(34, '', NULL, NULL, NULL, NULL, NULL, 'n', 20, '2012-07-31 19:52:37'),
(35, '', NULL, NULL, NULL, NULL, NULL, 'n', 21, '2012-07-31 19:52:37'),
(36, '', NULL, NULL, NULL, NULL, NULL, 'n', 22, '2012-07-31 19:52:38'),
(37, '', NULL, NULL, NULL, NULL, NULL, 'n', 23, '2012-07-31 19:52:39'),
(38, '', NULL, NULL, NULL, NULL, NULL, 'n', 24, '2012-07-31 19:52:39'),
(39, '', NULL, NULL, NULL, NULL, NULL, 'n', 25, '2012-07-31 19:52:39'),
(21, '', NULL, NULL, NULL, NULL, NULL, '', 26, '2012-07-31 19:54:46'),
(22, '', NULL, NULL, NULL, NULL, NULL, '', 27, '2012-07-31 19:54:46'),
(42, '', NULL, NULL, NULL, NULL, NULL, '', 28, '2012-07-31 20:47:50'),
(43, '', NULL, NULL, NULL, NULL, NULL, '', 29, '2012-07-31 20:47:50'),
(44, '', NULL, NULL, NULL, NULL, NULL, '', 30, '2012-07-31 20:47:51'),
(45, '', NULL, NULL, NULL, NULL, NULL, '', 31, '2012-07-31 20:50:35'),
(46, '', NULL, NULL, NULL, NULL, NULL, '', 32, '2012-07-31 20:53:49'),
(47, '', NULL, NULL, NULL, NULL, NULL, '', 33, '2012-08-01 13:11:21'),
(48, '', NULL, NULL, NULL, NULL, NULL, '', 34, '2012-08-01 13:11:21'),
(49, '', NULL, NULL, NULL, NULL, NULL, '', 35, '2012-08-01 13:11:22'),
(47, '', NULL, NULL, NULL, NULL, NULL, '', 36, '2012-08-01 13:14:22'),
(48, '', NULL, NULL, NULL, NULL, NULL, '', 37, '2012-08-01 13:14:22'),
(49, '', NULL, NULL, NULL, NULL, NULL, '', 38, '2012-08-01 13:14:23'),
(45, '', NULL, NULL, NULL, NULL, NULL, '', 39, '2012-08-01 13:14:23'),
(80, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 40, '2012-08-01 13:49:07'),
(81, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 41, '2012-08-01 13:49:07'),
(82, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 42, '2012-08-01 13:49:07'),
(83, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 43, '2012-08-01 13:49:08'),
(84, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 44, '2012-08-01 13:49:08'),
(85, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 45, '2012-08-01 13:49:09'),
(86, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 46, '2012-08-01 13:49:09'),
(87, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 47, '2012-08-01 13:49:10'),
(88, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 48, '2012-08-01 13:49:10'),
(89, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 49, '2012-08-01 13:49:11'),
(90, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 50, '2012-08-01 13:49:11'),
(91, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 51, '2012-08-01 13:49:12'),
(92, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 52, '2012-08-01 13:49:13'),
(93, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 53, '2012-08-01 13:49:13'),
(94, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 54, '2012-08-01 13:49:13'),
(95, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 55, '2012-08-01 13:49:14'),
(96, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 56, '2012-08-01 13:49:14'),
(97, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 57, '2012-08-01 13:49:15'),
(98, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 58, '2012-08-01 13:49:16'),
(99, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 59, '2012-08-01 13:49:17'),
(100, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 60, '2012-08-01 13:49:17'),
(80, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 61, '2012-08-01 13:53:59'),
(87, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 62, '2012-08-01 13:53:59'),
(91, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 63, '2012-08-01 13:53:59'),
(96, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 64, '2012-08-01 13:53:59'),
(99, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 65, '2012-08-01 13:53:59'),
(80, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 66, '2012-08-01 13:54:00'),
(87, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 67, '2012-08-01 13:54:00'),
(91, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 68, '2012-08-01 13:54:01'),
(96, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 69, '2012-08-01 13:54:01'),
(99, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 70, '2012-08-01 13:54:02'),
(80, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 71, '2012-08-01 13:55:57'),
(101, '', NULL, '', NULL, NULL, NULL, '', 72, '2012-08-01 13:55:58'),
(80, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 73, '2012-08-01 13:55:59'),
(87, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 74, '2012-08-01 13:55:59'),
(102, '', NULL, '', NULL, NULL, NULL, '', 75, '2012-08-01 13:55:59'),
(87, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 76, '2012-08-01 13:56:00'),
(91, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 77, '2012-08-01 13:56:00'),
(103, '', NULL, '', NULL, NULL, NULL, '', 78, '2012-08-01 13:56:01'),
(91, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 79, '2012-08-01 13:56:02'),
(96, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 80, '2012-08-01 13:56:02'),
(104, '', NULL, '', NULL, NULL, NULL, '', 81, '2012-08-01 13:56:02'),
(96, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 82, '2012-08-01 13:56:03'),
(99, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 83, '2012-08-01 13:56:03'),
(105, '', NULL, '', NULL, NULL, NULL, '', 84, '2012-08-01 13:56:04'),
(99, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 85, '2012-08-01 13:56:05'),
(101, '', NULL, '', NULL, NULL, NULL, '', 86, '2012-08-01 13:58:05'),
(102, '', NULL, '', NULL, NULL, NULL, '', 87, '2012-08-01 13:58:06'),
(103, '', NULL, '', NULL, NULL, NULL, '', 88, '2012-08-01 13:58:07'),
(104, '', NULL, '', NULL, NULL, NULL, '', 89, '2012-08-01 13:58:08'),
(105, '', NULL, '', NULL, NULL, NULL, '', 90, '2012-08-01 13:58:09'),
(101, '', NULL, '', NULL, NULL, NULL, '', 91, '2012-08-01 13:59:42'),
(101, '', NULL, '', NULL, NULL, NULL, '', 92, '2012-08-01 13:59:43'),
(102, '', NULL, '', NULL, NULL, NULL, '', 93, '2012-08-01 13:59:44'),
(102, '', NULL, '', NULL, NULL, NULL, '', 94, '2012-08-01 13:59:44'),
(103, '', NULL, '', NULL, NULL, NULL, '', 95, '2012-08-01 13:59:45'),
(103, '', NULL, '', NULL, NULL, NULL, '', 96, '2012-08-01 13:59:45'),
(104, '', NULL, '', NULL, NULL, NULL, '', 97, '2012-08-01 13:59:46'),
(104, '', NULL, '', NULL, NULL, NULL, '', 98, '2012-08-01 13:59:46'),
(105, '', NULL, '', NULL, NULL, NULL, '', 99, '2012-08-01 13:59:46'),
(105, '', NULL, '', NULL, NULL, NULL, '', 100, '2012-08-01 13:59:48'),
(104, '', NULL, '', NULL, NULL, NULL, '', 101, '2012-08-02 19:47:51'),
(80, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 102, '2012-08-02 19:54:25'),
(81, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 103, '2012-08-02 19:54:25'),
(82, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 104, '2012-08-02 19:54:25'),
(83, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 105, '2012-08-02 19:54:26'),
(84, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 106, '2012-08-02 19:54:26'),
(85, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 107, '2012-08-02 19:54:27'),
(86, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 108, '2012-08-02 19:54:27'),
(87, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 109, '2012-08-02 19:54:27'),
(88, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 110, '2012-08-02 19:54:28'),
(89, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 111, '2012-08-02 19:54:28'),
(90, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 112, '2012-08-02 19:54:28'),
(91, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 113, '2012-08-02 19:54:29'),
(92, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 114, '2012-08-02 19:54:29'),
(93, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 115, '2012-08-02 19:54:29'),
(94, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 116, '2012-08-02 19:54:30'),
(95, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 117, '2012-08-02 19:54:30'),
(96, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 118, '2012-08-02 19:54:31'),
(97, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 119, '2012-08-02 19:54:31'),
(98, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 120, '2012-08-02 19:54:31'),
(99, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 121, '2012-08-02 19:54:32'),
(100, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 122, '2012-08-02 19:54:32'),
(97, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 123, '2012-08-02 19:55:29'),
(97, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 124, '2012-08-02 19:55:30'),
(104, '', NULL, '', NULL, NULL, NULL, '', 125, '2014-02-14 20:20:03'),
(96, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 126, '2016-08-26 16:07:17'),
(106, '', NULL, '', NULL, NULL, NULL, '', 127, '2016-08-26 16:07:17'),
(96, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 128, '2016-08-26 16:07:18'),
(97, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 129, '2016-08-26 16:07:19'),
(107, '', NULL, '', NULL, NULL, NULL, '', 130, '2016-08-26 16:07:19'),
(97, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 131, '2016-08-26 16:07:20'),
(98, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 132, '2016-08-26 16:07:20'),
(108, '', NULL, '', NULL, NULL, NULL, '', 133, '2016-08-26 16:07:20'),
(98, '', '12.00', 'ng/ul', NULL, NULL, NULL, '', 134, '2016-08-26 16:07:21'),
(106, '', NULL, '', NULL, NULL, NULL, '', 135, '2016-08-26 16:58:40'),
(107, '', NULL, '', NULL, NULL, NULL, '', 136, '2016-08-26 16:58:50'),
(108, '', NULL, '', NULL, NULL, NULL, '', 137, '2016-08-26 16:59:07'),
(106, '', NULL, '', NULL, NULL, NULL, '', 138, '2016-08-26 16:59:51'),
(107, '', NULL, '', NULL, NULL, NULL, '', 139, '2016-08-26 16:59:51'),
(108, '', NULL, '', NULL, NULL, NULL, '', 140, '2016-08-26 16:59:51'),
(109, '', NULL, NULL, NULL, NULL, NULL, '', 141, '2016-08-26 19:19:08'),
(110, '', NULL, NULL, NULL, NULL, NULL, '', 142, '2016-08-26 19:19:08'),
(111, '', NULL, NULL, NULL, NULL, NULL, '', 143, '2016-08-26 19:19:54'),
(112, '', NULL, NULL, NULL, NULL, NULL, '', 144, '2016-08-26 19:19:54'),
(113, '', NULL, NULL, NULL, NULL, NULL, '', 145, '2016-08-26 19:21:26'),
(114, '', NULL, NULL, NULL, NULL, NULL, '', 146, '2016-08-26 19:21:27'),
(115, '', NULL, NULL, NULL, NULL, NULL, '', 147, '2016-08-26 19:23:26'),
(116, '', NULL, NULL, NULL, NULL, NULL, '', 148, '2016-08-26 19:23:26'),
(117, '', NULL, NULL, NULL, NULL, NULL, '', 149, '2016-08-26 19:23:26'),
(118, '', NULL, NULL, NULL, NULL, NULL, '', 150, '2016-08-26 19:24:19'),
(18, '', NULL, NULL, NULL, NULL, NULL, '', 151, '2016-08-26 19:40:08'),
(42, '', NULL, NULL, NULL, NULL, NULL, '', 152, '2016-08-26 19:40:09'),
(43, '', NULL, NULL, NULL, NULL, NULL, '', 153, '2016-08-26 19:40:10'),
(110, '', NULL, NULL, NULL, NULL, NULL, '', 154, '2016-08-26 19:40:11'),
(111, '', NULL, NULL, NULL, NULL, NULL, '', 155, '2016-08-26 19:40:12'),
(112, '', NULL, NULL, NULL, NULL, NULL, '', 156, '2016-08-26 19:40:12'),
(115, '', NULL, NULL, NULL, NULL, NULL, '', 157, '2016-08-26 19:48:49'),
(48, '', NULL, NULL, NULL, NULL, NULL, '', 158, '2016-08-26 19:54:05'),
(103, '', NULL, '', NULL, NULL, NULL, '', 159, '2016-08-26 20:03:13'),
(103, '', NULL, '', NULL, NULL, NULL, '', 160, '2016-08-26 20:04:03');

INSERT INTO `aliquot_internal_uses` (`id`, `aliquot_master_id`, `type`, `use_code`, `use_details`, `used_volume`, `use_datetime`, `use_datetime_accuracy`, `duration`, `duration_unit`, `used_by`, `study_summary_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 13, 'internal use', 'Loan to Dr Green Lab', '', NULL, '2010-03-01 00:00:00', 'h', NULL, '', '', 2, '2012-08-02 19:45:49', 1, '2012-08-02 19:52:28', 1, 0),
(2, 104, 'internal use', 'Reviewed By Dr Ter', 'see path report 6794', NULL, '2012-01-01 00:00:00', 'y', NULL, '', '', NULL, '2012-08-02 19:47:51', 1, '2012-08-02 19:52:50', 1, 0),
(3, 97, 'at room temperature', 'Error in lab (see report 6721)', '', NULL, '2012-08-02 00:00:00', 'h', 3, 'hr', '', NULL, '2012-08-02 19:55:29', 1, '2012-08-02 19:55:29', 1, 0);

INSERT INTO `aliquot_internal_uses_revs` (`id`, `aliquot_master_id`, `type`, `use_code`, `use_details`, `used_volume`, `use_datetime`, `use_datetime_accuracy`, `duration`, `duration_unit`, `used_by`, `study_summary_id`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 13, 'internal use', 'Loan to Dr Green Lab', '', NULL, '2010-03-01 00:00:00', 'h', NULL, NULL, '', NULL, 1, 1, '2012-08-02 19:45:49'),
(2, 104, 'internal use', 'Reviewed By Dr Ter', '', NULL, '2012-01-01 00:00:00', 'y', NULL, NULL, '', NULL, 1, 2, '2012-08-02 19:47:51'),
(1, 13, 'internal use', 'Loan to Dr Green Lab', '', NULL, '2010-03-01 00:00:00', 'h', NULL, '', 'tech. 2', 2, 1, 3, '2012-08-02 19:50:20'),
(1, 13, 'internal use', 'Loan to Dr Green Lab', '', NULL, '2010-03-01 00:00:00', 'h', NULL, '', '', 2, 1, 4, '2012-08-02 19:52:28'),
(2, 104, 'internal use', 'Reviewed By Dr Ter', 'see path report 6794', NULL, '2012-01-01 00:00:00', 'y', NULL, '', '', NULL, 1, 5, '2012-08-02 19:52:51'),
(3, 97, 'at room temperature', 'Error in lab (see report 6721)', '', NULL, '2012-08-02 00:00:00', 'h', 3, 'hr', '', NULL, 1, 6, '2012-08-02 19:55:29');

INSERT INTO `aliquot_masters` (`id`, `barcode`, `aliquot_label`, `aliquot_control_id`, `collection_id`, `sample_master_id`, `sop_master_id`, `initial_volume`, `current_volume`, `in_stock`, `in_stock_detail`, `use_counter`, `study_summary_id`, `storage_datetime`, `storage_datetime_accuracy`, `storage_master_id`, `storage_coord_x`, `storage_coord_y`, `product_code`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'b1892', 'block 98893.1', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 3, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, '2012-07-31 19:34:31', 1, '2012-08-01 13:45:38', 1, 0),
(2, 'b1893', 'block 98893.2', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 3, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, '2012-07-31 19:34:32', 1, '2012-08-01 13:45:40', 1, 0),
(3, 'b1894', 'block 98893.3', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 2, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, '2012-07-31 19:34:32', 1, '2014-02-14 20:19:46', 0, 0),
(4, 'b1895', 'block 98893.4', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 2, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, '2012-07-31 19:34:33', 1, '2014-02-14 20:19:47', 0, 0),
(5, 'b1896', 'block 98893.5', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 1, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, '2012-07-31 19:34:33', 1, '2014-02-14 20:19:49', 0, 0),
(6, 'b1897', 'block 98893.6', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 1, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, '2012-07-31 19:34:34', 1, '2014-02-14 20:19:50', 0, 0),
(7, 'b1898', 'block 98893.7', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 2, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, '2012-07-31 19:34:34', 1, '2012-08-01 13:45:43', 1, 0),
(8, 'b1899', 'block 98893.8', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 1, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, '2012-07-31 19:34:35', 1, '2014-02-14 20:19:52', 0, 0),
(9, 'b18910', 'block 98893.9', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 1, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, '2012-07-31 19:34:35', 1, '2014-02-14 20:19:53', 0, 0),
(10, 'b18911', 'block 98893.10', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 3, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, '2012-07-31 19:34:36', 1, '2014-02-14 20:19:54', 0, 0),
(11, 'b18912', 'block 98893.11', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 2, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, '2012-07-31 19:34:36', 1, '2014-02-14 20:19:56', 0, 0),
(12, 'r43.1', 'HY678', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 3, NULL, '2010-03-01 00:00:00', 'h', 30, '', '', NULL, NULL, '2012-07-31 19:42:15', 1, '2012-08-01 13:45:39', 1, 0),
(13, 'r43.2', 'HY678', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 3, NULL, '2010-03-01 00:00:00', 'h', 30, '', '', NULL, NULL, '2012-07-31 19:42:15', 1, '2014-02-14 20:19:58', 0, 0),
(14, 'r43.3', 'HY678', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 3, NULL, '2010-03-01 00:00:00', 'h', 30, '', '', NULL, NULL, '2012-07-31 19:42:16', 1, '2014-02-14 20:19:59', 0, 0),
(15, 'tb11', 'r41', 1, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 31, '1', 'A', NULL, NULL, '2012-07-31 19:45:05', 1, '2012-07-31 19:45:05', 1, 0),
(16, 'tb12', 'r41', 1, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 31, '1', 'B', NULL, NULL, '2012-07-31 19:45:06', 1, '2012-07-31 19:45:06', 1, 0),
(17, 'tb13', 'r41', 1, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 31, '1', 'C', NULL, NULL, '2012-07-31 19:45:06', 1, '2012-07-31 19:45:06', 1, 0),
(18, 'tb14', 'r41', 1, 3, 2, NULL, NULL, NULL, 'no', '', 0, NULL, '2010-03-01 00:00:00', 'h', NULL, '', '', NULL, NULL, '2012-07-31 19:45:07', 1, '2016-08-26 19:40:08', 1, 0),
(19, 'tb15', 'r41', 1, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 31, '1', 'E', NULL, NULL, '2012-07-31 19:45:07', 1, '2012-07-31 19:45:07', 1, 0),
(20, 'tb16', 'r41', 1, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 31, '1', 'F', NULL, NULL, '2012-07-31 19:45:08', 1, '2012-07-31 19:45:08', 1, 0),
(21, 'blood4', '', 3, 3, 3, NULL, '3.40000', '3.40000', 'yes - available', '', 0, NULL, '2019-03-01 00:00:00', 'c', 13, '3', 'A', NULL, NULL, '2012-07-31 19:48:12', 1, '2012-07-31 19:54:46', 1, 0),
(22, 'blood5', '', 3, 3, 3, NULL, '3.40000', '3.40000', 'yes - available', '', 0, NULL, '2019-03-01 00:00:00', 'c', 13, '2', 'A', NULL, NULL, '2012-07-31 19:48:12', 1, '2012-07-31 19:54:46', 1, 0),
(23, 'blood6', '', 3, 3, 3, NULL, '3.40000', '3.40000', 'yes - available', '', 0, NULL, '2019-03-01 00:00:00', 'c', 13, '1', 'A', NULL, NULL, '2012-07-31 19:48:13', 1, '2012-07-31 19:48:13', 1, 0),
(24, 'dna1', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '3', 'A', NULL, NULL, '2012-07-31 19:51:20', 1, '2012-07-31 19:51:20', 1, 0),
(25, 'dna2', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '3', 'B', NULL, NULL, '2012-07-31 19:51:21', 1, '2012-07-31 19:51:21', 1, 0),
(26, 'dna3', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '3', 'C', NULL, NULL, '2012-07-31 19:51:21', 1, '2012-07-31 19:51:21', 1, 0),
(27, 'dna4', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '3', 'D', NULL, NULL, '2012-07-31 19:51:22', 1, '2012-07-31 19:51:22', 1, 0),
(28, 'dna5', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '3', 'E', NULL, NULL, '2012-07-31 19:51:22', 1, '2012-07-31 19:51:22', 1, 0),
(29, 'dna6', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '3', 'F', NULL, NULL, '2012-07-31 19:51:23', 1, '2012-07-31 19:51:23', 1, 0),
(30, 'dna7', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '3', 'G', NULL, NULL, '2012-07-31 19:51:23', 1, '2012-07-31 19:51:23', 1, 0),
(31, 'dna8', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '4', 'A', NULL, NULL, '2012-07-31 19:51:24', 1, '2012-07-31 19:51:24', 1, 0),
(32, 'dna9', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '4', 'B', NULL, NULL, '2012-07-31 19:51:24', 1, '2012-07-31 19:51:24', 1, 0),
(33, 'dna10', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '4', 'C', NULL, NULL, '2012-07-31 19:51:25', 1, '2012-07-31 19:51:25', 1, 0),
(34, 'pl1', 'PLASMA 1', 16, 3, 6, NULL, '3.20000', '3.20000', 'yes - available', '', 0, NULL, NULL, '', 26, '11', '', NULL, NULL, '2012-07-31 19:52:36', 1, '2012-07-31 19:52:36', 1, 0),
(35, 'pl2', 'PLASMA 1', 16, 3, 6, NULL, '3.20000', '3.20000', 'yes - available', '', 0, NULL, NULL, '', 26, '12', '', NULL, NULL, '2012-07-31 19:52:37', 1, '2012-07-31 19:52:37', 1, 0),
(36, 'pl3', 'PLASMA 1', 16, 3, 6, NULL, '3.20000', '3.20000', 'yes - available', '', 0, NULL, NULL, '', 26, '13', '', NULL, NULL, '2012-07-31 19:52:38', 1, '2012-07-31 19:52:38', 1, 0),
(37, 'pl4', 'PLASMA 1', 16, 3, 6, NULL, '3.20000', '3.20000', 'yes - available', '', 0, NULL, NULL, '', 26, '14', '', NULL, NULL, '2012-07-31 19:52:38', 1, '2012-07-31 19:52:38', 1, 0),
(38, 'pl5', 'PLASMA 1', 16, 3, 6, NULL, '3.20000', '3.20000', 'yes - available', '', 0, NULL, NULL, '', 26, '15', '', NULL, NULL, '2012-07-31 19:52:39', 1, '2012-07-31 19:52:39', 1, 0),
(39, 'pl6', 'PLASMA 1', 16, 3, 6, NULL, '3.20000', '3.20000', 'yes - available', '', 0, NULL, NULL, '', 26, '16', '', NULL, NULL, '2012-07-31 19:52:39', 1, '2012-07-31 19:52:39', 1, 0),
(40, 'blck55', 'BL MET 001', 9, 4, 7, NULL, NULL, NULL, 'yes - available', '', 3, NULL, '2004-06-05 10:30:00', 'c', 30, '', '', NULL, NULL, '2012-07-31 20:46:47', 1, '2012-08-01 13:45:41', 1, 0),
(41, 'blck56', 'BL MET 001', 9, 4, 7, NULL, NULL, NULL, 'yes - available', '', 3, NULL, '2004-06-05 10:30:00', 'c', 30, '', '', NULL, '', '2012-07-31 20:46:47', 1, '2014-02-14 20:20:00', 0, 0),
(42, 'tistb6741', '', 1, 4, 7, NULL, NULL, NULL, 'no', '', 0, NULL, '2004-06-05 10:30:00', 'c', NULL, '', '', NULL, NULL, '2012-07-31 20:47:49', 1, '2016-08-26 19:40:09', 1, 0),
(43, 'tistb6742', '', 1, 4, 7, NULL, NULL, NULL, 'no', '', 0, NULL, '2004-06-05 10:30:00', 'c', NULL, '', '', NULL, NULL, '2012-07-31 20:47:50', 1, '2016-08-26 19:40:10', 1, 0),
(44, 'tistb6743', '', 1, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2004-06-05 10:30:00', 'c', 14, '72', '', NULL, NULL, '2012-07-31 20:47:50', 1, '2012-07-31 20:47:50', 1, 0),
(45, 'blpax 001', 'BLOOD P0002', 3, 5, 8, NULL, '12.00000', '12.00000', 'yes - available', '', 0, NULL, '2008-08-06 12:45:00', 'c', 13, '1', 'C', NULL, NULL, '2012-07-31 20:50:35', 1, '2012-08-01 13:14:23', 1, 0),
(46, 'tistb456', 'Tiss P002', 1, 5, 9, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2008-08-06 12:45:00', 'c', 14, '67', '', NULL, NULL, '2012-07-31 20:53:48', 1, '2012-07-31 20:53:49', 1, 0),
(47, '39021-bl1', '', 3, 1, 10, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2001-06-23 00:00:00', 'c', 13, '1', 'B', NULL, NULL, '2012-08-01 13:11:21', 1, '2012-08-01 13:14:22', 1, 0),
(48, '39021-bl2', '', 3, 1, 10, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2001-06-23 00:00:00', 'c', 32, '2', '1', NULL, NULL, '2012-08-01 13:11:21', 1, '2016-08-26 19:54:05', 1, 0),
(49, '39021-bl3', '', 3, 1, 10, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2001-06-23 00:00:00', 'c', 13, '3', 'B', NULL, NULL, '2012-08-01 13:11:22', 1, '2012-08-01 13:14:23', 1, 0),
(50, 'b1892.c1', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '8', '4', NULL, NULL, '2012-08-01 13:32:09', 1, '2012-08-01 13:36:00', 1, 0),
(51, 'b1892.c2', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '7', '8', NULL, NULL, '2012-08-01 13:32:10', 1, '2012-08-01 13:36:01', 1, 0),
(52, 'b18911.c3', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '7', '4', NULL, NULL, '2012-08-01 13:32:11', 1, '2012-08-01 13:36:01', 1, 0),
(53, 'b18911.c4', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '9', '7', NULL, NULL, '2012-08-01 13:32:12', 1, '2012-08-01 13:36:02', 1, 0),
(54, 'b18912.c5', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '9', '3', NULL, NULL, '2012-08-01 13:32:14', 1, '2012-08-01 13:36:02', 1, 0),
(55, 'b18912.c6', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '7', '3', NULL, NULL, '2012-08-01 13:32:15', 1, '2012-08-01 13:36:02', 1, 0),
(56, 'r43.1.c7', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '2', '7', NULL, NULL, '2012-08-01 13:32:16', 1, '2012-08-01 13:36:07', 1, 0),
(57, 'r43.1.c8', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '7', '2', NULL, NULL, '2012-08-01 13:32:17', 1, '2012-08-01 13:36:07', 1, 0),
(58, 'r43.2.c9', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '4', '4', NULL, NULL, '2012-08-01 13:32:19', 1, '2012-08-01 13:36:07', 1, 0),
(59, 'r43.2.c10', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '2', '4', NULL, NULL, '2012-08-01 13:32:20', 1, '2012-08-01 13:36:08', 1, 0),
(60, 'r43.3.c11', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '3', '4', NULL, NULL, '2012-08-01 13:32:21', 1, '2012-08-01 13:36:08', 1, 0),
(61, 'r43.3.c12', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '4', '3', NULL, NULL, '2012-08-01 13:32:22', 1, '2012-08-01 13:36:08', 1, 0),
(62, 'b1893.c20', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '4', '8', NULL, NULL, '2012-08-01 13:32:23', 1, '2012-08-01 13:36:03', 1, 0),
(63, 'b1893.c21', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '8', '8', NULL, NULL, '2012-08-01 13:32:24', 1, '2012-08-01 13:36:03', 1, 0),
(64, 'b1894.c22', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '8', '7', NULL, NULL, '2012-08-01 13:32:25', 1, '2012-08-01 13:36:03', 1, 0),
(65, 'b1894.c23', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '4', '7', NULL, NULL, '2012-08-01 13:32:26', 1, '2012-08-01 13:36:04', 1, 0),
(66, 'b1895.c30', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '9', '4', NULL, NULL, '2012-08-01 13:32:27', 1, '2012-08-01 13:36:04', 1, 0),
(67, 'b1895.c31', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '3', '8', NULL, NULL, '2012-08-01 13:32:28', 1, '2012-08-01 13:36:05', 1, 0),
(68, 'blck55.c35', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '3', '2', NULL, NULL, '2012-08-01 13:32:30', 1, '2012-08-01 13:36:09', 1, 0),
(69, 'blck55.c36', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '4', '2', NULL, NULL, '2012-08-01 13:32:31', 1, '2012-08-01 13:36:09', 1, 0),
(70, 'blck56.c40', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '2', '3', NULL, NULL, '2012-08-01 13:32:32', 1, '2012-08-01 13:36:10', 1, 0),
(71, 'blck56.c41', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '2', '2', NULL, NULL, '2012-08-01 13:32:32', 1, '2012-08-01 13:36:11', 1, 0),
(72, 'b1896.c90', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '7', '7', NULL, NULL, '2012-08-01 13:32:34', 1, '2012-08-01 13:36:05', 1, 0),
(73, 'b1897.c92', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '8', '2', NULL, NULL, '2012-08-01 13:32:35', 1, '2012-08-01 13:36:05', 1, 0),
(74, 'b1898.c4', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '9', '2', NULL, NULL, '2012-08-01 13:32:36', 1, '2012-08-01 13:36:06', 1, 0),
(75, 'b1899.c102', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '3', '7', NULL, NULL, '2012-08-01 13:32:37', 1, '2012-08-01 13:36:06', 1, 0),
(76, 'b18910.c332', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '2', '8', NULL, NULL, '2012-08-01 13:32:39', 1, '2012-08-01 13:36:06', 1, 0),
(77, 'sl-tma1', '', 10, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2012-08-01 13:42:00', 'c', 20, '', '', NULL, NULL, '2012-08-01 13:43:34', 1, '2012-08-01 13:43:34', 1, 0),
(78, 'sl-tma2', '', 10, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2012-08-01 13:42:00', 'c', 20, '', '', NULL, NULL, '2012-08-01 13:43:35', 1, '2012-08-01 13:43:35', 1, 0),
(79, 'sl-tma3', '', 10, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2012-08-01 13:42:00', 'c', 20, '', '', NULL, NULL, '2012-08-01 13:43:37', 1, '2012-08-01 13:43:37', 1, 0),
(80, 'QP98893.d1', '', 29, 2, 11, NULL, '2.00000', '0.70000', 'yes - available', '', 2, NULL, '2012-08-01 17:46:00', 'c', 11, '9', 'C', NULL, NULL, '2012-08-01 13:49:06', 1, '2012-08-02 19:54:25', 1, 0),
(81, 'QP98893.d2', '', 29, 2, 11, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '7', 'C', NULL, NULL, '2012-08-01 13:49:07', 1, '2012-08-02 19:54:25', 1, 0),
(82, 'QP98893.d3', '', 29, 2, 11, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '2', 'B', NULL, NULL, '2012-08-01 13:49:07', 1, '2012-08-02 19:54:25', 1, 0),
(83, 'QP98893.d4', '', 29, 2, 11, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '8', 'C', NULL, NULL, '2012-08-01 13:49:08', 1, '2012-08-02 19:54:26', 1, 0),
(84, 'QP98893.d5', '', 29, 2, 11, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '3', 'B', NULL, NULL, '2012-08-01 13:49:08', 1, '2012-08-02 19:54:26', 1, 0),
(85, 'QP98893.d6', '', 29, 2, 13, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '4', 'B', NULL, NULL, '2012-08-01 13:49:09', 1, '2012-08-02 19:54:26', 1, 0),
(86, 'QP98893.d7', '', 29, 2, 13, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '5', 'B', NULL, NULL, '2012-08-01 13:49:09', 1, '2012-08-02 19:54:27', 1, 0),
(87, 'QP98893.d8', '', 29, 2, 13, NULL, '2.00000', '0.70000', 'yes - available', '', 2, NULL, '2012-08-01 17:46:00', 'c', 11, '5', 'A', NULL, NULL, '2012-08-01 13:49:10', 1, '2012-08-02 19:54:27', 1, 0),
(88, 'QP98893.d9', '', 29, 2, 13, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '6', 'B', NULL, NULL, '2012-08-01 13:49:10', 1, '2012-08-02 19:54:27', 1, 0),
(89, 'QP98893.d0', '', 29, 2, 13, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '7', 'B', NULL, NULL, '2012-08-01 13:49:10', 1, '2012-08-02 19:54:28', 1, 0),
(90, 'QP98893.d21', '', 29, 2, 15, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '7', 'A', NULL, NULL, '2012-08-01 13:49:11', 1, '2012-08-02 19:54:28', 1, 0),
(91, 'QP98893.d22', '', 29, 2, 15, NULL, '2.00000', '0.70000', 'yes - available', '', 2, NULL, '2012-08-01 17:46:00', 'c', 11, '8', 'B', NULL, NULL, '2012-08-01 13:49:11', 1, '2012-08-02 19:54:29', 1, 0),
(92, 'QP98893.d23', '', 29, 2, 15, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '9', 'B', NULL, NULL, '2012-08-01 13:49:12', 1, '2012-08-02 19:54:29', 1, 0),
(93, 'QP98893.d24', '', 29, 2, 15, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '9', 'A', NULL, NULL, '2012-08-01 13:49:13', 1, '2012-08-02 19:54:29', 1, 0),
(94, 'QP98893.d25', '', 29, 2, 15, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '8', 'A', NULL, NULL, '2012-08-01 13:49:13', 1, '2012-08-02 19:54:30', 1, 0),
(95, 'QP9387.d1', '', 29, 3, 12, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '6', 'A', NULL, NULL, '2012-08-01 13:49:14', 1, '2012-08-02 19:54:30', 1, 0),
(96, 'QP9387.d2', '', 29, 3, 12, NULL, '2.00000', '0.70000', 'no', '', 2, NULL, '2012-08-01 17:46:00', 'c', NULL, '', '', NULL, NULL, '2012-08-01 13:49:14', 1, '2016-08-26 16:07:18', 1, 0),
(97, 'QP9387.d3', '', 29, 3, 12, NULL, '2.00000', '2.00000', 'no', '', 1, NULL, '2012-08-01 17:46:00', 'c', NULL, '', '', NULL, NULL, '2012-08-01 13:49:15', 1, '2016-08-26 16:07:20', 1, 0),
(98, 'QP9387.d4', '', 29, 3, 12, NULL, '1.00000', '1.00000', 'no', '', 0, NULL, '2012-08-01 17:46:00', 'c', NULL, '', '', NULL, NULL, '2012-08-01 13:49:16', 1, '2016-08-26 16:07:21', 1, 0),
(99, 'MET001.d1', '', 29, 4, 14, NULL, '2.00000', '0.70000', 'yes - available', '', 2, NULL, '2012-08-01 17:46:00', 'c', 11, '1', 'A', NULL, NULL, '2012-08-01 13:49:16', 1, '2012-08-02 19:54:31', 1, 0),
(100, 'MET001.d2', '', 29, 4, 14, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '2', 'A', NULL, NULL, '2012-08-01 13:49:17', 1, '2012-08-02 19:54:32', 1, 0),
(101, 'TT902.5', '', 29, 2, 11, NULL, '1.00000', '1.00000', 'no', 'shipped', 1, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, '2012-08-01 13:55:57', 1, '2012-08-01 13:59:43', 1, 0),
(102, 'TT902.4', '', 29, 2, 13, NULL, '1.00000', '1.00000', 'no', 'shipped', 1, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, '2012-08-01 13:55:59', 1, '2012-08-01 13:59:44', 1, 0),
(103, 'TT902.3', '', 29, 2, 15, NULL, '1.00000', '1.00000', 'yes - not available', 'reserved for order', 1, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, '2012-08-01 13:56:01', 1, '2016-08-26 20:04:03', 1, 0),
(104, 'TT902.2', '', 29, 3, 12, NULL, '1.00000', '1.00000', 'no', 'shipped', 2, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, '2012-08-01 13:56:02', 1, '2014-02-14 20:20:02', 0, 0),
(105, 'TT902.1', '', 29, 4, 14, NULL, '1.00000', '1.00000', 'no', 'shipped', 1, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, '2012-08-01 13:56:04', 1, '2012-08-01 13:59:47', 1, 0),
(106, 'dna-r1.1455', '', 29, 3, 12, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-08-26 16:03:00', 'c', 39, '1', 'A', NULL, '', '2016-08-26 16:07:17', 1, '2016-08-26 16:59:50', 1, 0),
(107, 'dna-r1.1456', '', 29, 3, 12, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-08-26 16:03:00', 'c', 39, '3', 'A', NULL, '', '2016-08-26 16:07:19', 1, '2016-08-26 16:59:51', 1, 0),
(108, 'dna-r1.1457', '', 29, 3, 12, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-08-26 16:03:00', 'c', 39, '2', 'A', NULL, '', '2016-08-26 16:07:20', 1, '2016-08-26 16:59:51', 1, 0),
(109, 'tl45323', '', 1, 6, 16, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2009-08-01 16:09:00', 'c', NULL, '', '', NULL, NULL, '2016-08-26 19:19:08', 1, '2016-08-26 19:19:08', 1, 0),
(110, 't3556f', '', 1, 6, 16, NULL, NULL, NULL, 'no', '', 0, NULL, '2009-08-01 16:09:00', 'c', NULL, '', '', NULL, NULL, '2016-08-26 19:19:08', 1, '2016-08-26 19:40:10', 1, 0),
(111, 'tr566', '', 1, 6, 17, NULL, NULL, NULL, 'no', '', 0, NULL, '2009-08-01 16:09:00', 'c', NULL, '', '', NULL, NULL, '2016-08-26 19:19:53', 1, '2016-08-26 19:40:11', 1, 0),
(112, 'tr54122', '', 1, 6, 17, NULL, NULL, NULL, 'no', '', 0, NULL, '2009-08-01 16:09:00', 'c', NULL, '', '', NULL, NULL, '2016-08-26 19:19:54', 1, '2016-08-26 19:40:12', 1, 0),
(113, 'p8499348', '', 16, 6, 19, NULL, NULL, NULL, 'yes - not available', 'reserved for study', 0, 1, '2009-08-01 18:14:00', 'c', 31, '2', 'A', NULL, NULL, '2016-08-26 19:21:26', 1, '2016-08-26 19:21:26', 1, 0),
(114, 'p8746628', '', 16, 6, 19, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2009-08-01 18:15:00', 'c', 31, '3', 'A', NULL, NULL, '2016-08-26 19:21:27', 1, '2016-08-26 19:21:27', 1, 0),
(115, 's787993', '', 17, 6, 20, NULL, NULL, NULL, 'yes - not available', 'reserved for order', 0, 1, '2009-08-01 18:00:00', 'c', 12, '5', 'C', NULL, NULL, '2016-08-26 19:23:25', 1, '2016-08-26 19:48:49', 1, 0),
(116, 's774839', '', 17, 6, 20, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2009-08-01 18:00:00', 'c', 12, '4', 'D', NULL, NULL, '2016-08-26 19:23:26', 1, '2016-08-26 19:23:26', 1, 0),
(117, 's77483', '', 17, 6, 20, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2009-08-01 18:00:00', 'c', 12, '4', 'E', NULL, NULL, '2016-08-26 19:23:26', 1, '2016-08-26 19:23:26', 1, 0),
(118, '7588239230a', '', 3, 6, 21, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2009-08-01 16:09:00', 'c', 12, '4', 'F', NULL, NULL, '2016-08-26 19:24:18', 1, '2016-08-26 19:24:18', 1, 0),
(119, 'B9-tss9.', '', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, '2016-08-26 19:40:08', 1, '2016-08-26 19:50:45', 1, 0),
(120, 'B9-tss9.1', '', 9, 4, 7, NULL, NULL, NULL, 'yes - available', 'shipped & returned', 0, NULL, '2016-04-08 11:38:00', 'c', NULL, '', '', NULL, NULL, '2016-08-26 19:40:09', 1, '2016-08-26 20:04:55', 1, 0),
(121, 'B9-tss9.2', '', 9, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, '2016-08-26 19:40:10', 1, '2016-08-26 19:50:49', 1, 0),
(122, 'B9-tss9.3', '', 9, 6, 16, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, '2016-08-26 19:40:11', 1, '2016-08-26 19:50:50', 1, 0),
(123, 'B9-tss9.4', '', 9, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, '2016-08-26 19:40:12', 1, '2016-08-26 19:50:51', 1, 0),
(124, 'B9-tss9.5', '', 9, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, '2016-08-26 19:40:13', 1, '2016-08-26 19:50:52', 1, 0),
(125, '4566.c17', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '9', '8', NULL, NULL, '2016-08-26 19:50:45', 1, '2016-08-26 19:58:37', 1, 0),
(126, '4566.c16', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '11', '8', NULL, NULL, '2016-08-26 19:50:46', 1, '2016-08-26 19:58:37', 1, 0),
(127, '4566.c15', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '10', '7', NULL, NULL, '2016-08-26 19:50:46', 1, '2016-08-26 19:58:38', 1, 0),
(128, '4566.c14', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '4', '9', NULL, NULL, '2016-08-26 19:50:47', 1, '2016-08-26 19:58:38', 1, 0),
(129, '4566.c13', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '2', '9', NULL, NULL, '2016-08-26 19:50:47', 1, '2016-08-26 19:58:38', 1, 0),
(130, '4566.c12', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '11', '9', NULL, NULL, '2016-08-26 19:50:48', 1, '2016-08-26 19:58:38', 1, 0),
(131, '4566.c11', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '9', '9', NULL, NULL, '2016-08-26 19:50:48', 1, '2016-08-26 19:58:39', 1, 0),
(132, '4566.c9', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '10', '9', NULL, NULL, '2016-08-26 19:50:49', 1, '2016-08-26 19:58:39', 1, 0),
(133, '4566.c8', '', 33, 6, 16, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '8', '9', NULL, NULL, '2016-08-26 19:50:50', 1, '2016-08-26 19:58:40', 1, 0),
(134, '4566.c7', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '7', '9', NULL, NULL, '2016-08-26 19:50:51', 1, '2016-08-26 19:58:40', 1, 0),
(135, '4566.c6', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '4', '10', NULL, NULL, '2016-08-26 19:50:51', 1, '2016-08-26 19:58:40', 1, 0),
(136, '4566.c5', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '3', '10', NULL, NULL, '2016-08-26 19:50:52', 1, '2016-08-26 19:58:41', 1, 0),
(137, '4566.c4', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '11', '10', NULL, NULL, '2016-08-26 19:50:52', 1, '2016-08-26 19:58:41', 1, 0),
(138, '4566.c3', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '7', '10', NULL, NULL, '2016-08-26 19:50:53', 1, '2016-08-26 19:58:42', 1, 0),
(139, '4566.c2', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '9', '10', NULL, NULL, '2016-08-26 19:50:53', 1, '2016-08-26 19:58:42', 1, 0),
(140, '4566.c1', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '8', '10', NULL, NULL, '2016-08-26 19:50:53', 1, '2016-08-26 19:58:43', 1, 0);

INSERT INTO `aliquot_masters_revs` (`id`, `barcode`, `aliquot_label`, `aliquot_control_id`, `collection_id`, `sample_master_id`, `sop_master_id`, `initial_volume`, `current_volume`, `in_stock`, `in_stock_detail`, `use_counter`, `study_summary_id`, `storage_datetime`, `storage_datetime_accuracy`, `storage_master_id`, `storage_coord_x`, `storage_coord_y`, `product_code`, `notes`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 'b1892', 'block 98893.1', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 1, '2012-07-31 19:34:31'),
(2, 'b1893', 'block 98893.2', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 2, '2012-07-31 19:34:32'),
(3, 'b1894', 'block 98893.3', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 3, '2012-07-31 19:34:32'),
(4, 'b1895', 'block 98893.4', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 4, '2012-07-31 19:34:33'),
(5, 'b1896', 'block 98893.5', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 5, '2012-07-31 19:34:33'),
(6, 'b1897', 'block 98893.6', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 6, '2012-07-31 19:34:34'),
(7, 'b1898', 'block 98893.7', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 7, '2012-07-31 19:34:34'),
(8, 'b1899', 'block 98893.8', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 8, '2012-07-31 19:34:35'),
(9, 'b18910', 'block 98893.9', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 9, '2012-07-31 19:34:35'),
(10, 'b18911', 'block 98893.10', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 10, '2012-07-31 19:34:36'),
(11, 'b18912', 'block 98893.11', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 11, '2012-07-31 19:34:36'),
(12, 'r43.1', 'HY678', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 30, '', '', NULL, NULL, 1, 12, '2012-07-31 19:42:15'),
(13, 'r43.2', 'HY678', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 30, '', '', NULL, NULL, 1, 13, '2012-07-31 19:42:15'),
(14, 'r43.3', 'HY678', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 30, '', '', NULL, NULL, 1, 14, '2012-07-31 19:42:16'),
(15, 'tb11', 'r41', 1, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 31, '1', 'A', NULL, NULL, 1, 15, '2012-07-31 19:45:05'),
(16, 'tb12', 'r41', 1, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 31, '1', 'B', NULL, NULL, 1, 16, '2012-07-31 19:45:06'),
(17, 'tb13', 'r41', 1, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 31, '1', 'C', NULL, NULL, 1, 17, '2012-07-31 19:45:06'),
(18, 'tb14', 'r41', 1, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 31, '1', 'D', NULL, NULL, 1, 18, '2012-07-31 19:45:07'),
(19, 'tb15', 'r41', 1, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 31, '1', 'E', NULL, NULL, 1, 19, '2012-07-31 19:45:07'),
(20, 'tb16', 'r41', 1, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 31, '1', 'F', NULL, NULL, 1, 20, '2012-07-31 19:45:08'),
(21, 'blood4', '', 3, 3, 3, NULL, '3.40000', '3.40000', 'yes - available', '', 0, NULL, '2019-03-01 00:00:00', 'c', 13, '1', 'A', NULL, NULL, 1, 21, '2012-07-31 19:48:12'),
(22, 'blood5', '', 3, 3, 3, NULL, '3.40000', '3.40000', 'yes - available', '', 0, NULL, '2019-03-01 00:00:00', 'c', 13, '1', 'A', NULL, NULL, 1, 22, '2012-07-31 19:48:12'),
(23, 'blood6', '', 3, 3, 3, NULL, '3.40000', '3.40000', 'yes - available', '', 0, NULL, '2019-03-01 00:00:00', 'c', 13, '1', 'A', NULL, NULL, 1, 23, '2012-07-31 19:48:13'),
(24, 'dna1', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '3', 'A', NULL, NULL, 1, 24, '2012-07-31 19:51:20'),
(25, 'dna2', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '3', 'B', NULL, NULL, 1, 25, '2012-07-31 19:51:21'),
(26, 'dna3', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '3', 'C', NULL, NULL, 1, 26, '2012-07-31 19:51:21'),
(27, 'dna4', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '3', 'D', NULL, NULL, 1, 27, '2012-07-31 19:51:22'),
(28, 'dna5', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '3', 'E', NULL, NULL, 1, 28, '2012-07-31 19:51:22'),
(29, 'dna6', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '3', 'F', NULL, NULL, 1, 29, '2012-07-31 19:51:23'),
(30, 'dna7', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '3', 'G', NULL, NULL, 1, 30, '2012-07-31 19:51:23'),
(31, 'dna8', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '4', 'A', NULL, NULL, 1, 31, '2012-07-31 19:51:24'),
(32, 'dna9', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '4', 'B', NULL, NULL, 1, 32, '2012-07-31 19:51:24'),
(33, 'dna10', 'DNA BLOOD ', 29, 3, 5, NULL, '3.00000', '3.00000', 'yes - available', '', 0, NULL, '2012-07-03 07:57:00', 'c', 12, '4', 'C', NULL, NULL, 1, 33, '2012-07-31 19:51:25'),
(34, 'pl1', 'PLASMA 1', 16, 3, 6, NULL, '3.20000', '3.20000', 'yes - available', '', 0, NULL, NULL, '', 26, '11', '', NULL, NULL, 1, 34, '2012-07-31 19:52:37'),
(35, 'pl2', 'PLASMA 1', 16, 3, 6, NULL, '3.20000', '3.20000', 'yes - available', '', 0, NULL, NULL, '', 26, '12', '', NULL, NULL, 1, 35, '2012-07-31 19:52:37'),
(36, 'pl3', 'PLASMA 1', 16, 3, 6, NULL, '3.20000', '3.20000', 'yes - available', '', 0, NULL, NULL, '', 26, '13', '', NULL, NULL, 1, 36, '2012-07-31 19:52:38'),
(37, 'pl4', 'PLASMA 1', 16, 3, 6, NULL, '3.20000', '3.20000', 'yes - available', '', 0, NULL, NULL, '', 26, '14', '', NULL, NULL, 1, 37, '2012-07-31 19:52:38'),
(38, 'pl5', 'PLASMA 1', 16, 3, 6, NULL, '3.20000', '3.20000', 'yes - available', '', 0, NULL, NULL, '', 26, '15', '', NULL, NULL, 1, 38, '2012-07-31 19:52:39'),
(39, 'pl6', 'PLASMA 1', 16, 3, 6, NULL, '3.20000', '3.20000', 'yes - available', '', 0, NULL, NULL, '', 26, '16', '', NULL, NULL, 1, 39, '2012-07-31 19:52:39'),
(21, 'blood4', '', 3, 3, 3, NULL, '3.40000', '3.40000', 'yes - available', '', 0, NULL, '2019-03-01 00:00:00', 'c', 13, '3', 'A', NULL, NULL, 1, 40, '2012-07-31 19:54:46'),
(22, 'blood5', '', 3, 3, 3, NULL, '3.40000', '3.40000', 'yes - available', '', 0, NULL, '2019-03-01 00:00:00', 'c', 13, '2', 'A', NULL, NULL, 1, 41, '2012-07-31 19:54:46'),
(40, 'blck55', 'BL MET 001', 9, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2004-06-05 10:30:00', 'c', 30, '', '', NULL, NULL, 1, 42, '2012-07-31 20:46:47'),
(41, 'blck56', 'BL MET 001', 9, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2004-06-05 10:30:00', 'c', NULL, '', '', NULL, NULL, 1, 43, '2012-07-31 20:46:48'),
(42, 'tistb6741', '', 1, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2004-06-05 10:30:00', 'c', 14, '70', '', NULL, NULL, 1, 44, '2012-07-31 20:47:49'),
(43, 'tistb6742', '', 1, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2004-06-05 10:30:00', 'c', 14, '71', '', NULL, NULL, 1, 45, '2012-07-31 20:47:50'),
(44, 'tistb6743', '', 1, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2004-06-05 10:30:00', 'c', 14, '72', '', NULL, NULL, 1, 46, '2012-07-31 20:47:50'),
(45, 'blpax 001', 'BLOOD P0002', 3, 5, 8, NULL, '12.00000', '12.00000', 'yes - available', '', 0, NULL, '2008-08-06 12:45:00', 'c', 13, '3', 'C', NULL, NULL, 1, 47, '2012-07-31 20:50:35'),
(46, 'tistb456', 'Tiss P002', 1, 5, 9, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2008-08-06 12:45:00', 'c', 14, '67', '', NULL, NULL, 1, 48, '2012-07-31 20:53:49'),
(41, 'blck56', 'BL MET 001', 9, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2004-06-05 10:30:00', 'c', 30, '', '', NULL, '', 1, 49, '2012-08-01 13:08:33'),
(47, '39021-bl1', '', 3, 1, 10, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2001-06-23 00:00:00', 'c', 13, '4', 'D', NULL, NULL, 1, 50, '2012-08-01 13:11:21'),
(48, '39021-bl2', '', 3, 1, 10, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2001-06-23 00:00:00', 'c', 13, '4', 'D', NULL, NULL, 1, 51, '2012-08-01 13:11:21'),
(49, '39021-bl3', '', 3, 1, 10, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2001-06-23 00:00:00', 'c', 13, '4', 'D', NULL, NULL, 1, 52, '2012-08-01 13:11:22'),
(47, '39021-bl1', '', 3, 1, 10, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2001-06-23 00:00:00', 'c', 13, '1', 'B', NULL, NULL, 1, 53, '2012-08-01 13:14:22'),
(48, '39021-bl2', '', 3, 1, 10, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2001-06-23 00:00:00', 'c', 13, '2', 'B', NULL, NULL, 1, 54, '2012-08-01 13:14:22'),
(49, '39021-bl3', '', 3, 1, 10, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2001-06-23 00:00:00', 'c', 13, '3', 'B', NULL, NULL, 1, 55, '2012-08-01 13:14:23'),
(45, 'blpax 001', 'BLOOD P0002', 3, 5, 8, NULL, '12.00000', '12.00000', 'yes - available', '', 0, NULL, '2008-08-06 12:45:00', 'c', 13, '1', 'C', NULL, NULL, 1, 56, '2012-08-01 13:14:23'),
(1, 'b1892', 'block 98893.1', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 57, '2012-08-01 13:32:09'),
(50, 'b1892.c1', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 58, '2012-08-01 13:32:09'),
(51, 'b1892.c2', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 59, '2012-08-01 13:32:10'),
(10, 'b18911', 'block 98893.10', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 60, '2012-08-01 13:32:11'),
(52, 'b18911.c3', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 61, '2012-08-01 13:32:11'),
(53, 'b18911.c4', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 62, '2012-08-01 13:32:12'),
(11, 'b18912', 'block 98893.11', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 63, '2012-08-01 13:32:13'),
(54, 'b18912.c5', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 64, '2012-08-01 13:32:14'),
(55, 'b18912.c6', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 65, '2012-08-01 13:32:15'),
(12, 'r43.1', 'HY678', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 30, '', '', NULL, NULL, 1, 66, '2012-08-01 13:32:16'),
(56, 'r43.1.c7', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 67, '2012-08-01 13:32:16'),
(57, 'r43.1.c8', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 68, '2012-08-01 13:32:17'),
(13, 'r43.2', 'HY678', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 30, '', '', NULL, NULL, 1, 69, '2012-08-01 13:32:18'),
(58, 'r43.2.c9', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 70, '2012-08-01 13:32:19'),
(59, 'r43.2.c10', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 71, '2012-08-01 13:32:20'),
(14, 'r43.3', 'HY678', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 30, '', '', NULL, NULL, 1, 72, '2012-08-01 13:32:21'),
(60, 'r43.3.c11', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 73, '2012-08-01 13:32:21'),
(61, 'r43.3.c12', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 74, '2012-08-01 13:32:22'),
(2, 'b1893', 'block 98893.2', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 75, '2012-08-01 13:32:23'),
(62, 'b1893.c20', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 76, '2012-08-01 13:32:23'),
(63, 'b1893.c21', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 77, '2012-08-01 13:32:24'),
(3, 'b1894', 'block 98893.3', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 78, '2012-08-01 13:32:25'),
(64, 'b1894.c22', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 79, '2012-08-01 13:32:25'),
(65, 'b1894.c23', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 80, '2012-08-01 13:32:26'),
(4, 'b1895', 'block 98893.4', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 81, '2012-08-01 13:32:27'),
(66, 'b1895.c30', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 82, '2012-08-01 13:32:27'),
(67, 'b1895.c31', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 83, '2012-08-01 13:32:28'),
(40, 'blck55', 'BL MET 001', 9, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2004-06-05 10:30:00', 'c', 30, '', '', NULL, NULL, 1, 84, '2012-08-01 13:32:30'),
(68, 'blck55.c35', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 85, '2012-08-01 13:32:30'),
(69, 'blck55.c36', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 86, '2012-08-01 13:32:31'),
(41, 'blck56', 'BL MET 001', 9, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2004-06-05 10:30:00', 'c', 30, '', '', NULL, '', 1, 87, '2012-08-01 13:32:31'),
(70, 'blck56.c40', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 88, '2012-08-01 13:32:32'),
(71, 'blck56.c41', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 89, '2012-08-01 13:32:33'),
(5, 'b1896', 'block 98893.5', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 90, '2012-08-01 13:32:33'),
(72, 'b1896.c90', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 91, '2012-08-01 13:32:34'),
(6, 'b1897', 'block 98893.6', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 92, '2012-08-01 13:32:34'),
(73, 'b1897.c92', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 93, '2012-08-01 13:32:35'),
(7, 'b1898', 'block 98893.7', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 94, '2012-08-01 13:32:36'),
(74, 'b1898.c4', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 95, '2012-08-01 13:32:36'),
(8, 'b1899', 'block 98893.8', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 96, '2012-08-01 13:32:37'),
(75, 'b1899.c102', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 97, '2012-08-01 13:32:37'),
(9, 'b18910', 'block 98893.9', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 98, '2012-08-01 13:32:38'),
(76, 'b18910.c332', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 20, '', '', NULL, NULL, 1, 99, '2012-08-01 13:32:39'),
(50, 'b1892.c1', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 100, '2012-08-01 13:33:29'),
(51, 'b1892.c2', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 101, '2012-08-01 13:33:30'),
(52, 'b18911.c3', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 102, '2012-08-01 13:33:30'),
(53, 'b18911.c4', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 103, '2012-08-01 13:33:31'),
(54, 'b18912.c5', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 104, '2012-08-01 13:33:31'),
(55, 'b18912.c6', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 105, '2012-08-01 13:33:32'),
(62, 'b1893.c20', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 106, '2012-08-01 13:33:32'),
(63, 'b1893.c21', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 107, '2012-08-01 13:33:33'),
(64, 'b1894.c22', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 108, '2012-08-01 13:33:34'),
(65, 'b1894.c23', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 109, '2012-08-01 13:33:34'),
(66, 'b1895.c30', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 110, '2012-08-01 13:33:35'),
(67, 'b1895.c31', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 111, '2012-08-01 13:33:35'),
(72, 'b1896.c90', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 112, '2012-08-01 13:33:36'),
(73, 'b1897.c92', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 113, '2012-08-01 13:33:36'),
(74, 'b1898.c4', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 114, '2012-08-01 13:33:37'),
(75, 'b1899.c102', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 115, '2012-08-01 13:33:37'),
(76, 'b18910.c332', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 116, '2012-08-01 13:33:38'),
(56, 'r43.1.c7', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 117, '2012-08-01 13:33:39'),
(57, 'r43.1.c8', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 118, '2012-08-01 13:33:40'),
(58, 'r43.2.c9', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 119, '2012-08-01 13:33:40'),
(59, 'r43.2.c10', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 120, '2012-08-01 13:33:41'),
(60, 'r43.3.c11', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 121, '2012-08-01 13:33:41'),
(61, 'r43.3.c12', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 122, '2012-08-01 13:33:42'),
(68, 'blck55.c35', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 123, '2012-08-01 13:33:43'),
(69, 'blck55.c36', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 124, '2012-08-01 13:33:43'),
(70, 'blck56.c40', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 125, '2012-08-01 13:33:44'),
(71, 'blck56.c41', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '', '', NULL, NULL, 1, 126, '2012-08-01 13:33:44'),
(50, 'b1892.c1', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '8', '4', NULL, NULL, 1, 127, '2012-08-01 13:36:01'),
(51, 'b1892.c2', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '7', '8', NULL, NULL, 1, 128, '2012-08-01 13:36:01'),
(52, 'b18911.c3', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '7', '4', NULL, NULL, 1, 129, '2012-08-01 13:36:01'),
(53, 'b18911.c4', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '9', '7', NULL, NULL, 1, 130, '2012-08-01 13:36:02'),
(54, 'b18912.c5', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '9', '3', NULL, NULL, 1, 131, '2012-08-01 13:36:02'),
(55, 'b18912.c6', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '7', '3', NULL, NULL, 1, 132, '2012-08-01 13:36:02'),
(62, 'b1893.c20', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '4', '8', NULL, NULL, 1, 133, '2012-08-01 13:36:03'),
(63, 'b1893.c21', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '8', '8', NULL, NULL, 1, 134, '2012-08-01 13:36:03'),
(64, 'b1894.c22', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '8', '7', NULL, NULL, 1, 135, '2012-08-01 13:36:04'),
(65, 'b1894.c23', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '4', '7', NULL, NULL, 1, 136, '2012-08-01 13:36:04'),
(66, 'b1895.c30', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '9', '4', NULL, NULL, 1, 137, '2012-08-01 13:36:04'),
(67, 'b1895.c31', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '3', '8', NULL, NULL, 1, 138, '2012-08-01 13:36:05'),
(72, 'b1896.c90', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '7', '7', NULL, NULL, 1, 139, '2012-08-01 13:36:05'),
(73, 'b1897.c92', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '8', '2', NULL, NULL, 1, 140, '2012-08-01 13:36:05'),
(74, 'b1898.c4', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '9', '2', NULL, NULL, 1, 141, '2012-08-01 13:36:06'),
(75, 'b1899.c102', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '3', '7', NULL, NULL, 1, 142, '2012-08-01 13:36:06'),
(76, 'b18910.c332', '', 33, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '2', '8', NULL, NULL, 1, 143, '2012-08-01 13:36:06'),
(56, 'r43.1.c7', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '2', '7', NULL, NULL, 1, 144, '2012-08-01 13:36:07'),
(57, 'r43.1.c8', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '7', '2', NULL, NULL, 1, 145, '2012-08-01 13:36:07'),
(58, 'r43.2.c9', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '4', '4', NULL, NULL, 1, 146, '2012-08-01 13:36:07'),
(59, 'r43.2.c10', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '2', '4', NULL, NULL, 1, 147, '2012-08-01 13:36:08'),
(60, 'r43.3.c11', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '3', '4', NULL, NULL, 1, 148, '2012-08-01 13:36:08'),
(61, 'r43.3.c12', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '4', '3', NULL, NULL, 1, 149, '2012-08-01 13:36:09'),
(68, 'blck55.c35', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '3', '2', NULL, NULL, 1, 150, '2012-08-01 13:36:09'),
(69, 'blck55.c36', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '4', '2', NULL, NULL, 1, 151, '2012-08-01 13:36:09'),
(70, 'blck56.c40', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '2', '3', NULL, NULL, 1, 152, '2012-08-01 13:36:10'),
(71, 'blck56.c41', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2012-03-01 00:00:00', 'h', 32, '2', '2', NULL, NULL, 1, 153, '2012-08-01 13:36:11'),
(41, 'blck56', 'BL MET 001', 9, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2004-06-05 10:30:00', 'c', 30, '', '', NULL, '', 1, 154, '2012-08-01 13:43:34'),
(77, 'sl-tma1', '', 10, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2012-08-01 13:42:00', 'c', 20, '', '', NULL, NULL, 1, 155, '2012-08-01 13:43:34'),
(14, 'r43.3', 'HY678', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 30, '', '', NULL, NULL, 1, 156, '2012-08-01 13:43:35'),
(78, 'sl-tma2', '', 10, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2012-08-01 13:42:00', 'c', 20, '', '', NULL, NULL, 1, 157, '2012-08-01 13:43:35'),
(10, 'b18911', 'block 98893.10', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 158, '2012-08-01 13:43:36'),
(79, 'sl-tma3', '', 10, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2012-08-01 13:42:00', 'c', 20, '', '', NULL, NULL, 1, 159, '2012-08-01 13:43:37'),
(1, 'b1892', 'block 98893.1', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 160, '2012-08-01 13:45:37'),
(1, 'b1892', 'block 98893.1', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 3, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 161, '2012-08-01 13:45:38'),
(12, 'r43.1', 'HY678', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 30, '', '', NULL, NULL, 1, 162, '2012-08-01 13:45:39'),
(12, 'r43.1', 'HY678', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 3, NULL, '2010-03-01 00:00:00', 'h', 30, '', '', NULL, NULL, 1, 163, '2012-08-01 13:45:39'),
(2, 'b1893', 'block 98893.2', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 164, '2012-08-01 13:45:40'),
(2, 'b1893', 'block 98893.2', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 3, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 165, '2012-08-01 13:45:40'),
(40, 'blck55', 'BL MET 001', 9, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2004-06-05 10:30:00', 'c', 30, '', '', NULL, NULL, 1, 166, '2012-08-01 13:45:41'),
(40, 'blck55', 'BL MET 001', 9, 4, 7, NULL, NULL, NULL, 'yes - available', '', 3, NULL, '2004-06-05 10:30:00', 'c', 30, '', '', NULL, NULL, 1, 167, '2012-08-01 13:45:41'),
(7, 'b1898', 'block 98893.7', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 0, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 168, '2012-08-01 13:45:42'),
(7, 'b1898', 'block 98893.7', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 2, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 1, 169, '2012-08-01 13:45:43'),
(80, 'QP98893.d1', '', 29, 2, 11, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 170, '2012-08-01 13:49:06'),
(81, 'QP98893.d2', '', 29, 2, 11, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 171, '2012-08-01 13:49:07'),
(82, 'QP98893.d3', '', 29, 2, 11, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 172, '2012-08-01 13:49:07'),
(83, 'QP98893.d4', '', 29, 2, 11, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 173, '2012-08-01 13:49:08'),
(84, 'QP98893.d5', '', 29, 2, 11, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 174, '2012-08-01 13:49:08'),
(85, 'QP98893.d6', '', 29, 2, 13, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 175, '2012-08-01 13:49:09'),
(86, 'QP98893.d7', '', 29, 2, 13, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 176, '2012-08-01 13:49:09'),
(87, 'QP98893.d8', '', 29, 2, 13, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 177, '2012-08-01 13:49:10'),
(88, 'QP98893.d9', '', 29, 2, 13, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 178, '2012-08-01 13:49:10'),
(89, 'QP98893.d0', '', 29, 2, 13, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 179, '2012-08-01 13:49:11'),
(90, 'QP98893.d21', '', 29, 2, 15, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 180, '2012-08-01 13:49:11'),
(91, 'QP98893.d22', '', 29, 2, 15, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 181, '2012-08-01 13:49:11'),
(92, 'QP98893.d23', '', 29, 2, 15, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 182, '2012-08-01 13:49:12'),
(93, 'QP98893.d24', '', 29, 2, 15, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 183, '2012-08-01 13:49:13'),
(94, 'QP98893.d25', '', 29, 2, 15, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 184, '2012-08-01 13:49:13'),
(95, 'QP9387.d1', '', 29, 3, 12, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 185, '2012-08-01 13:49:14'),
(96, 'QP9387.d2', '', 29, 3, 12, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 186, '2012-08-01 13:49:14'),
(97, 'QP9387.d3', '', 29, 3, 12, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 187, '2012-08-01 13:49:15'),
(98, 'QP9387.d4', '', 29, 3, 12, NULL, '1.00000', '1.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 188, '2012-08-01 13:49:16'),
(99, 'MET001.d1', '', 29, 4, 14, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 189, '2012-08-01 13:49:16'),
(100, 'MET001.d2', '', 29, 4, 14, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 190, '2012-08-01 13:49:17'),
(80, 'QP98893.d1', '', 29, 2, 11, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 191, '2012-08-01 13:53:59'),
(87, 'QP98893.d8', '', 29, 2, 13, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 192, '2012-08-01 13:53:59'),
(91, 'QP98893.d22', '', 29, 2, 15, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 193, '2012-08-01 13:53:59'),
(96, 'QP9387.d2', '', 29, 3, 12, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 194, '2012-08-01 13:53:59'),
(99, 'MET001.d1', '', 29, 4, 14, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 195, '2012-08-01 13:53:59'),
(80, 'QP98893.d1', '', 29, 2, 11, NULL, '2.00000', '1.70000', 'yes - available', '', 1, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 196, '2012-08-01 13:53:59'),
(87, 'QP98893.d8', '', 29, 2, 13, NULL, '2.00000', '1.70000', 'yes - available', '', 1, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 197, '2012-08-01 13:54:00'),
(91, 'QP98893.d22', '', 29, 2, 15, NULL, '2.00000', '1.70000', 'yes - available', '', 1, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 198, '2012-08-01 13:54:00'),
(96, 'QP9387.d2', '', 29, 3, 12, NULL, '2.00000', '1.70000', 'yes - available', '', 1, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 199, '2012-08-01 13:54:01'),
(99, 'MET001.d1', '', 29, 4, 14, NULL, '2.00000', '1.70000', 'yes - available', '', 1, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 200, '2012-08-01 13:54:01'),
(80, 'QP98893.d1', '', 29, 2, 11, NULL, '2.00000', '1.70000', 'yes - available', '', 1, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 201, '2012-08-01 13:55:57'),
(101, 'TT902.5', '', 29, 2, 11, NULL, '1.00000', '1.00000', 'yes - available', '', 0, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 202, '2012-08-01 13:55:57'),
(80, 'QP98893.d1', '', 29, 2, 11, NULL, '2.00000', '0.70000', 'yes - available', '', 2, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 203, '2012-08-01 13:55:58'),
(87, 'QP98893.d8', '', 29, 2, 13, NULL, '2.00000', '1.70000', 'yes - available', '', 1, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 204, '2012-08-01 13:55:59'),
(102, 'TT902.4', '', 29, 2, 13, NULL, '1.00000', '1.00000', 'yes - available', '', 0, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 205, '2012-08-01 13:55:59'),
(87, 'QP98893.d8', '', 29, 2, 13, NULL, '2.00000', '0.70000', 'yes - available', '', 2, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 206, '2012-08-01 13:56:00'),
(91, 'QP98893.d22', '', 29, 2, 15, NULL, '2.00000', '1.70000', 'yes - available', '', 1, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 207, '2012-08-01 13:56:00'),
(103, 'TT902.3', '', 29, 2, 15, NULL, '1.00000', '1.00000', 'yes - available', '', 0, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 208, '2012-08-01 13:56:01'),
(91, 'QP98893.d22', '', 29, 2, 15, NULL, '2.00000', '0.70000', 'yes - available', '', 2, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 209, '2012-08-01 13:56:01'),
(96, 'QP9387.d2', '', 29, 3, 12, NULL, '2.00000', '1.70000', 'yes - available', '', 1, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 210, '2012-08-01 13:56:02'),
(104, 'TT902.2', '', 29, 3, 12, NULL, '1.00000', '1.00000', 'yes - available', '', 0, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 211, '2012-08-01 13:56:02'),
(96, 'QP9387.d2', '', 29, 3, 12, NULL, '2.00000', '0.70000', 'yes - available', '', 2, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 212, '2012-08-01 13:56:03'),
(99, 'MET001.d1', '', 29, 4, 14, NULL, '2.00000', '1.70000', 'yes - available', '', 1, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 213, '2012-08-01 13:56:03'),
(105, 'TT902.1', '', 29, 4, 14, NULL, '1.00000', '1.00000', 'yes - available', '', 0, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 214, '2012-08-01 13:56:04'),
(99, 'MET001.d1', '', 29, 4, 14, NULL, '2.00000', '0.70000', 'yes - available', '', 2, NULL, '2012-08-01 17:46:00', 'c', 11, '', '', NULL, NULL, 1, 215, '2012-08-01 13:56:04'),
(101, 'TT902.5', '', 29, 2, 11, NULL, '1.00000', '1.00000', 'yes - not available', 'reserved for order', 0, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 216, '2012-08-01 13:58:05'),
(102, 'TT902.4', '', 29, 2, 13, NULL, '1.00000', '1.00000', 'yes - not available', 'reserved for order', 0, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 217, '2012-08-01 13:58:06'),
(103, 'TT902.3', '', 29, 2, 15, NULL, '1.00000', '1.00000', 'yes - not available', 'reserved for order', 0, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 218, '2012-08-01 13:58:07'),
(104, 'TT902.2', '', 29, 3, 12, NULL, '1.00000', '1.00000', 'yes - not available', 'reserved for order', 0, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 219, '2012-08-01 13:58:08'),
(105, 'TT902.1', '', 29, 4, 14, NULL, '1.00000', '1.00000', 'yes - not available', 'reserved for order', 0, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 220, '2012-08-01 13:58:09'),
(101, 'TT902.5', '', 29, 2, 11, NULL, '1.00000', '1.00000', 'no', 'shipped', 0, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 221, '2012-08-01 13:59:42'),
(101, 'TT902.5', '', 29, 2, 11, NULL, '1.00000', '1.00000', 'no', 'shipped', 1, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 222, '2012-08-01 13:59:43'),
(102, 'TT902.4', '', 29, 2, 13, NULL, '1.00000', '1.00000', 'no', 'shipped', 0, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 223, '2012-08-01 13:59:44'),
(102, 'TT902.4', '', 29, 2, 13, NULL, '1.00000', '1.00000', 'no', 'shipped', 1, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 224, '2012-08-01 13:59:44'),
(103, 'TT902.3', '', 29, 2, 15, NULL, '1.00000', '1.00000', 'no', 'shipped', 0, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 225, '2012-08-01 13:59:44'),
(103, 'TT902.3', '', 29, 2, 15, NULL, '1.00000', '1.00000', 'no', 'shipped', 1, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 226, '2012-08-01 13:59:45'),
(104, 'TT902.2', '', 29, 3, 12, NULL, '1.00000', '1.00000', 'no', 'shipped', 0, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 227, '2012-08-01 13:59:45'),
(104, 'TT902.2', '', 29, 3, 12, NULL, '1.00000', '1.00000', 'no', 'shipped', 1, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 228, '2012-08-01 13:59:46'),
(105, 'TT902.1', '', 29, 4, 14, NULL, '1.00000', '1.00000', 'no', 'shipped', 0, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 229, '2012-08-01 13:59:46'),
(105, 'TT902.1', '', 29, 4, 14, NULL, '1.00000', '1.00000', 'no', 'shipped', 1, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 230, '2012-08-01 13:59:47'),
(13, 'r43.2', 'HY678', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2010-03-01 00:00:00', 'h', 30, '', '', NULL, NULL, 1, 231, '2012-08-02 19:45:49'),
(104, 'TT902.2', '', 29, 3, 12, NULL, '1.00000', '1.00000', 'no', 'shipped', 1, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 232, '2012-08-02 19:47:51'),
(80, 'QP98893.d1', '', 29, 2, 11, NULL, '2.00000', '0.70000', 'yes - available', '', 2, NULL, '2012-08-01 17:46:00', 'c', 11, '9', 'C', NULL, NULL, 1, 233, '2012-08-02 19:54:25'),
(81, 'QP98893.d2', '', 29, 2, 11, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '7', 'C', NULL, NULL, 1, 234, '2012-08-02 19:54:25'),
(82, 'QP98893.d3', '', 29, 2, 11, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '2', 'B', NULL, NULL, 1, 235, '2012-08-02 19:54:25'),
(83, 'QP98893.d4', '', 29, 2, 11, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '8', 'C', NULL, NULL, 1, 236, '2012-08-02 19:54:26'),
(84, 'QP98893.d5', '', 29, 2, 11, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '3', 'B', NULL, NULL, 1, 237, '2012-08-02 19:54:26'),
(85, 'QP98893.d6', '', 29, 2, 13, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '4', 'B', NULL, NULL, 1, 238, '2012-08-02 19:54:26'),
(86, 'QP98893.d7', '', 29, 2, 13, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '5', 'B', NULL, NULL, 1, 239, '2012-08-02 19:54:27'),
(87, 'QP98893.d8', '', 29, 2, 13, NULL, '2.00000', '0.70000', 'yes - available', '', 2, NULL, '2012-08-01 17:46:00', 'c', 11, '5', 'A', NULL, NULL, 1, 240, '2012-08-02 19:54:27'),
(88, 'QP98893.d9', '', 29, 2, 13, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '6', 'B', NULL, NULL, 1, 241, '2012-08-02 19:54:28'),
(89, 'QP98893.d0', '', 29, 2, 13, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '7', 'B', NULL, NULL, 1, 242, '2012-08-02 19:54:28'),
(90, 'QP98893.d21', '', 29, 2, 15, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '7', 'A', NULL, NULL, 1, 243, '2012-08-02 19:54:28'),
(91, 'QP98893.d22', '', 29, 2, 15, NULL, '2.00000', '0.70000', 'yes - available', '', 2, NULL, '2012-08-01 17:46:00', 'c', 11, '8', 'B', NULL, NULL, 1, 244, '2012-08-02 19:54:29'),
(92, 'QP98893.d23', '', 29, 2, 15, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '9', 'B', NULL, NULL, 1, 245, '2012-08-02 19:54:29'),
(93, 'QP98893.d24', '', 29, 2, 15, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '9', 'A', NULL, NULL, 1, 246, '2012-08-02 19:54:29'),
(94, 'QP98893.d25', '', 29, 2, 15, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '8', 'A', NULL, NULL, 1, 247, '2012-08-02 19:54:30'),
(95, 'QP9387.d1', '', 29, 3, 12, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '6', 'A', NULL, NULL, 1, 248, '2012-08-02 19:54:30'),
(96, 'QP9387.d2', '', 29, 3, 12, NULL, '2.00000', '0.70000', 'yes - available', '', 2, NULL, '2012-08-01 17:46:00', 'c', 11, '4', 'A', NULL, NULL, 1, 249, '2012-08-02 19:54:30'),
(97, 'QP9387.d3', '', 29, 3, 12, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '1', 'B', NULL, NULL, 1, 250, '2012-08-02 19:54:31'),
(98, 'QP9387.d4', '', 29, 3, 12, NULL, '1.00000', '1.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '3', 'A', NULL, NULL, 1, 251, '2012-08-02 19:54:31'),
(99, 'MET001.d1', '', 29, 4, 14, NULL, '2.00000', '0.70000', 'yes - available', '', 2, NULL, '2012-08-01 17:46:00', 'c', 11, '1', 'A', NULL, NULL, 1, 252, '2012-08-02 19:54:32'),
(100, 'MET001.d2', '', 29, 4, 14, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '2', 'A', NULL, NULL, 1, 253, '2012-08-02 19:54:32'),
(97, 'QP9387.d3', '', 29, 3, 12, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2012-08-01 17:46:00', 'c', 11, '1', 'B', NULL, NULL, 1, 254, '2012-08-02 19:55:29'),
(97, 'QP9387.d3', '', 29, 3, 12, NULL, '2.00000', '2.00000', 'yes - available', '', 1, NULL, '2012-08-01 17:46:00', 'c', 11, '1', 'B', NULL, NULL, 1, 255, '2012-08-02 19:55:30'),
(3, 'b1894', 'block 98893.3', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 2, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 0, 256, '2014-02-14 20:19:46'),
(4, 'b1895', 'block 98893.4', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 2, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 0, 257, '2014-02-14 20:19:47'),
(5, 'b1896', 'block 98893.5', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 1, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 0, 258, '2014-02-14 20:19:49'),
(6, 'b1897', 'block 98893.6', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 1, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 0, 259, '2014-02-14 20:19:50'),
(8, 'b1899', 'block 98893.8', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 1, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 0, 260, '2014-02-14 20:19:52'),
(9, 'b18910', 'block 98893.9', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 1, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 0, 261, '2014-02-14 20:19:53'),
(10, 'b18911', 'block 98893.10', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 3, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 0, 262, '2014-02-14 20:19:54'),
(11, 'b18912', 'block 98893.11', 9, 2, 1, NULL, NULL, NULL, 'yes - available', '', 2, 2, '2012-07-03 12:23:00', 'c', 30, '', '', NULL, NULL, 0, 263, '2014-02-14 20:19:56'),
(13, 'r43.2', 'HY678', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 3, NULL, '2010-03-01 00:00:00', 'h', 30, '', '', NULL, NULL, 0, 264, '2014-02-14 20:19:58'),
(14, 'r43.3', 'HY678', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 3, NULL, '2010-03-01 00:00:00', 'h', 30, '', '', NULL, NULL, 0, 265, '2014-02-14 20:19:59'),
(41, 'blck56', 'BL MET 001', 9, 4, 7, NULL, NULL, NULL, 'yes - available', '', 3, NULL, '2004-06-05 10:30:00', 'c', 30, '', '', NULL, '', 0, 266, '2014-02-14 20:20:01'),
(104, 'TT902.2', '', 29, 3, 12, NULL, '1.00000', '1.00000', 'no', 'shipped', 2, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 0, 267, '2014-02-14 20:20:02'),
(96, 'QP9387.d2', '', 29, 3, 12, NULL, '2.00000', '0.70000', 'no', '', 2, NULL, '2012-08-01 17:46:00', 'c', NULL, '', '', NULL, NULL, 1, 268, '2016-08-26 16:07:17'),
(106, 'dna-r1.1455', '', 29, 3, 12, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-08-26 16:03:00', 'c', 33, '', '', NULL, NULL, 1, 269, '2016-08-26 16:07:17'),
(96, 'QP9387.d2', '', 29, 3, 12, NULL, '2.00000', '0.70000', 'no', '', 2, NULL, '2012-08-01 17:46:00', 'c', NULL, '', '', NULL, NULL, 1, 270, '2016-08-26 16:07:18'),
(97, 'QP9387.d3', '', 29, 3, 12, NULL, '2.00000', '2.00000', 'no', '', 1, NULL, '2012-08-01 17:46:00', 'c', NULL, '', '', NULL, NULL, 1, 271, '2016-08-26 16:07:19'),
(107, 'dna-r1.1456', '', 29, 3, 12, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-08-26 16:03:00', 'c', 33, '', '', NULL, NULL, 1, 272, '2016-08-26 16:07:19'),
(97, 'QP9387.d3', '', 29, 3, 12, NULL, '2.00000', '2.00000', 'no', '', 1, NULL, '2012-08-01 17:46:00', 'c', NULL, '', '', NULL, NULL, 1, 273, '2016-08-26 16:07:20'),
(98, 'QP9387.d4', '', 29, 3, 12, NULL, '1.00000', '1.00000', 'no', '', 0, NULL, '2012-08-01 17:46:00', 'c', NULL, '', '', NULL, NULL, 1, 274, '2016-08-26 16:07:20'),
(108, 'dna-r1.1457', '', 29, 3, 12, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-08-26 16:03:00', 'c', 33, '', '', NULL, NULL, 1, 275, '2016-08-26 16:07:20'),
(98, 'QP9387.d4', '', 29, 3, 12, NULL, '1.00000', '1.00000', 'no', '', 0, NULL, '2012-08-01 17:46:00', 'c', NULL, '', '', NULL, NULL, 1, 276, '2016-08-26 16:07:21'),
(106, 'dna-r1.1455', '', 29, 3, 12, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-08-26 16:03:00', 'c', 35, '', '', NULL, '', 1, 277, '2016-08-26 16:58:40'),
(107, 'dna-r1.1456', '', 29, 3, 12, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-08-26 16:03:00', 'c', 35, '', '', NULL, '', 1, 278, '2016-08-26 16:58:50'),
(108, 'dna-r1.1457', '', 29, 3, 12, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-08-26 16:03:00', 'c', 35, '', '', NULL, '', 1, 279, '2016-08-26 16:59:06'),
(106, 'dna-r1.1455', '', 29, 3, 12, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-08-26 16:03:00', 'c', 39, '1', 'A', NULL, '', 1, 280, '2016-08-26 16:59:50'),
(107, 'dna-r1.1456', '', 29, 3, 12, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-08-26 16:03:00', 'c', 39, '3', 'A', NULL, '', 1, 281, '2016-08-26 16:59:51'),
(108, 'dna-r1.1457', '', 29, 3, 12, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-08-26 16:03:00', 'c', 39, '2', 'A', NULL, '', 1, 282, '2016-08-26 16:59:51'),
(109, 'tl45323', '', 1, 6, 16, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2009-08-01 16:09:00', 'c', NULL, '', '', NULL, NULL, 1, 283, '2016-08-26 19:19:08'),
(110, 't3556f', '', 1, 6, 16, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2009-08-01 16:09:00', 'c', NULL, '', '', NULL, NULL, 1, 284, '2016-08-26 19:19:08'),
(111, 'tr566', '', 1, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2009-08-01 16:09:00', 'c', NULL, '', '', NULL, NULL, 1, 285, '2016-08-26 19:19:53'),
(112, 'tr54122', '', 1, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2009-08-01 16:09:00', 'c', NULL, '', '', NULL, NULL, 1, 286, '2016-08-26 19:19:54'),
(113, 'p8499348', '', 16, 6, 19, NULL, NULL, NULL, 'yes - not available', 'reserved for study', 0, 1, '2009-08-01 18:14:00', 'c', 31, '2', 'A', NULL, NULL, 1, 287, '2016-08-26 19:21:26'),
(114, 'p8746628', '', 16, 6, 19, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2009-08-01 18:15:00', 'c', 31, '3', 'A', NULL, NULL, 1, 288, '2016-08-26 19:21:27'),
(115, 's787993', '', 17, 6, 20, NULL, NULL, NULL, 'yes - not available', 'reserved for order', 0, 1, '2009-08-01 18:00:00', 'c', 12, '4', 'C', NULL, NULL, 1, 289, '2016-08-26 19:23:25'),
(116, 's774839', '', 17, 6, 20, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2009-08-01 18:00:00', 'c', 12, '4', 'D', NULL, NULL, 1, 290, '2016-08-26 19:23:26'),
(117, 's77483', '', 17, 6, 20, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2009-08-01 18:00:00', 'c', 12, '4', 'E', NULL, NULL, 1, 291, '2016-08-26 19:23:26'),
(118, '7588239230a', '', 3, 6, 21, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2009-08-01 16:09:00', 'c', 12, '4', 'F', NULL, NULL, 1, 292, '2016-08-26 19:24:18'),
(18, 'tb14', 'r41', 1, 3, 2, NULL, NULL, NULL, 'no', '', 0, NULL, '2010-03-01 00:00:00', 'h', NULL, '', '', NULL, NULL, 1, 293, '2016-08-26 19:40:08'),
(119, 'B9-tss9.', '', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, 1, 294, '2016-08-26 19:40:08');
INSERT INTO `aliquot_masters_revs` (`id`, `barcode`, `aliquot_label`, `aliquot_control_id`, `collection_id`, `sample_master_id`, `sop_master_id`, `initial_volume`, `current_volume`, `in_stock`, `in_stock_detail`, `use_counter`, `study_summary_id`, `storage_datetime`, `storage_datetime_accuracy`, `storage_master_id`, `storage_coord_x`, `storage_coord_y`, `product_code`, `notes`, `modified_by`, `version_id`, `version_created`) VALUES
(42, 'tistb6741', '', 1, 4, 7, NULL, NULL, NULL, 'no', '', 0, NULL, '2004-06-05 10:30:00', 'c', NULL, '', '', NULL, NULL, 1, 295, '2016-08-26 19:40:09'),
(120, 'B9-tss9.1', '', 9, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, 1, 296, '2016-08-26 19:40:09'),
(43, 'tistb6742', '', 1, 4, 7, NULL, NULL, NULL, 'no', '', 0, NULL, '2004-06-05 10:30:00', 'c', NULL, '', '', NULL, NULL, 1, 297, '2016-08-26 19:40:10'),
(121, 'B9-tss9.2', '', 9, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, 1, 298, '2016-08-26 19:40:10'),
(110, 't3556f', '', 1, 6, 16, NULL, NULL, NULL, 'no', '', 0, NULL, '2009-08-01 16:09:00', 'c', NULL, '', '', NULL, NULL, 1, 299, '2016-08-26 19:40:11'),
(122, 'B9-tss9.3', '', 9, 6, 16, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, 1, 300, '2016-08-26 19:40:11'),
(111, 'tr566', '', 1, 6, 17, NULL, NULL, NULL, 'no', '', 0, NULL, '2009-08-01 16:09:00', 'c', NULL, '', '', NULL, NULL, 1, 301, '2016-08-26 19:40:11'),
(123, 'B9-tss9.4', '', 9, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, 1, 302, '2016-08-26 19:40:12'),
(112, 'tr54122', '', 1, 6, 17, NULL, NULL, NULL, 'no', '', 0, NULL, '2009-08-01 16:09:00', 'c', NULL, '', '', NULL, NULL, 1, 303, '2016-08-26 19:40:12'),
(124, 'B9-tss9.5', '', 9, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, 1, 304, '2016-08-26 19:40:13'),
(120, 'B9-tss9.1', '', 9, 4, 7, NULL, NULL, NULL, 'yes - not available', 'reserved for order', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, 1, 305, '2016-08-26 19:45:13'),
(115, 's787993', '', 17, 6, 20, NULL, NULL, NULL, 'yes - not available', 'reserved for order', 0, 1, '2009-08-01 18:00:00', 'c', 12, '5', 'C', NULL, NULL, 1, 306, '2016-08-26 19:48:49'),
(119, 'B9-tss9.', '', 9, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, 1, 307, '2016-08-26 19:50:45'),
(125, '4566.c17', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '', '', NULL, NULL, 1, 308, '2016-08-26 19:50:46'),
(126, '4566.c16', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '', '', NULL, NULL, 1, 309, '2016-08-26 19:50:46'),
(127, '4566.c15', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '', '', NULL, NULL, 1, 310, '2016-08-26 19:50:46'),
(120, 'B9-tss9.1', '', 9, 4, 7, NULL, NULL, NULL, 'yes - not available', 'reserved for order', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, 1, 311, '2016-08-26 19:50:47'),
(128, '4566.c14', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '', '', NULL, NULL, 1, 312, '2016-08-26 19:50:47'),
(129, '4566.c13', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '', '', NULL, NULL, 1, 313, '2016-08-26 19:50:48'),
(130, '4566.c12', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '', '', NULL, NULL, 1, 314, '2016-08-26 19:50:48'),
(131, '4566.c11', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '', '', NULL, NULL, 1, 315, '2016-08-26 19:50:48'),
(121, 'B9-tss9.2', '', 9, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, 1, 316, '2016-08-26 19:50:49'),
(132, '4566.c9', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '', '', NULL, NULL, 1, 317, '2016-08-26 19:50:49'),
(122, 'B9-tss9.3', '', 9, 6, 16, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, 1, 318, '2016-08-26 19:50:50'),
(133, '4566.c8', '', 33, 6, 16, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '', '', NULL, NULL, 1, 319, '2016-08-26 19:50:50'),
(123, 'B9-tss9.4', '', 9, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, 1, 320, '2016-08-26 19:50:51'),
(134, '4566.c7', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '', '', NULL, NULL, 1, 321, '2016-08-26 19:50:51'),
(135, '4566.c6', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '', '', NULL, NULL, 1, 322, '2016-08-26 19:50:51'),
(136, '4566.c5', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '', '', NULL, NULL, 1, 323, '2016-08-26 19:50:52'),
(137, '4566.c4', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '', '', NULL, NULL, 1, 324, '2016-08-26 19:50:52'),
(124, 'B9-tss9.5', '', 9, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-08 11:38:00', 'c', 30, '', '', NULL, NULL, 1, 325, '2016-08-26 19:50:52'),
(138, '4566.c3', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '', '', NULL, NULL, 1, 326, '2016-08-26 19:50:53'),
(139, '4566.c2', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '', '', NULL, NULL, 1, 327, '2016-08-26 19:50:53'),
(140, '4566.c1', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '', '', NULL, NULL, 1, 328, '2016-08-26 19:50:53'),
(48, '39021-bl2', '', 3, 1, 10, NULL, '2.00000', '2.00000', 'yes - available', '', 0, NULL, '2001-06-23 00:00:00', 'c', 32, '2', '1', NULL, NULL, 1, 329, '2016-08-26 19:54:05'),
(125, '4566.c17', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '9', '8', NULL, NULL, 1, 330, '2016-08-26 19:58:37'),
(126, '4566.c16', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '11', '8', NULL, NULL, 1, 331, '2016-08-26 19:58:37'),
(127, '4566.c15', '', 33, 3, 2, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '10', '7', NULL, NULL, 1, 332, '2016-08-26 19:58:38'),
(128, '4566.c14', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '4', '9', NULL, NULL, 1, 333, '2016-08-26 19:58:38'),
(129, '4566.c13', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '2', '9', NULL, NULL, 1, 334, '2016-08-26 19:58:38'),
(130, '4566.c12', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '11', '9', NULL, NULL, 1, 335, '2016-08-26 19:58:39'),
(131, '4566.c11', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '9', '9', NULL, NULL, 1, 336, '2016-08-26 19:58:39'),
(132, '4566.c9', '', 33, 4, 7, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '10', '9', NULL, NULL, 1, 337, '2016-08-26 19:58:39'),
(133, '4566.c8', '', 33, 6, 16, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '8', '9', NULL, NULL, 1, 338, '2016-08-26 19:58:40'),
(134, '4566.c7', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '7', '9', NULL, NULL, 1, 339, '2016-08-26 19:58:40'),
(135, '4566.c6', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '4', '10', NULL, NULL, 1, 340, '2016-08-26 19:58:41'),
(136, '4566.c5', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '3', '10', NULL, NULL, 1, 341, '2016-08-26 19:58:41'),
(137, '4566.c4', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '11', '10', NULL, NULL, 1, 342, '2016-08-26 19:58:41'),
(138, '4566.c3', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '7', '10', NULL, NULL, 1, 343, '2016-08-26 19:58:42'),
(139, '4566.c2', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '9', '10', NULL, NULL, 1, 344, '2016-08-26 19:58:42'),
(140, '4566.c1', '', 33, 6, 17, NULL, NULL, NULL, 'yes - available', '', 0, NULL, '2016-04-01 00:00:00', 'd', 32, '8', '10', NULL, NULL, 1, 345, '2016-08-26 19:58:43'),
(120, 'B9-tss9.1', '', 9, 4, 7, NULL, NULL, NULL, 'no', 'shipped', 0, NULL, '2016-04-08 11:38:00', 'c', NULL, '', '', NULL, NULL, 1, 346, '2016-08-26 20:02:12'),
(103, 'TT902.3', '', 29, 2, 15, NULL, '1.00000', '1.00000', 'yes - available', 'shipped & returned', 1, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 347, '2016-08-26 20:03:12'),
(103, 'TT902.3', '', 29, 2, 15, NULL, '1.00000', '1.00000', 'yes - not available', 'reserved for order', 1, 1, '2012-08-03 07:51:00', 'c', NULL, '', '', NULL, NULL, 1, 348, '2016-08-26 20:04:03'),
(120, 'B9-tss9.1', '', 9, 4, 7, NULL, NULL, NULL, 'yes - available', 'shipped & returned', 0, NULL, '2016-04-08 11:38:00', 'c', NULL, '', '', NULL, NULL, 1, 349, '2016-08-26 20:04:55');

INSERT INTO `cd_nationals` (`consent_master_id`) VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8);

INSERT INTO `cd_nationals_revs` (`consent_master_id`, `version_id`, `version_created`) VALUES
(1, 1, '2012-07-31 15:18:23'),
(2, 2, '2012-07-31 18:25:22'),
(3, 3, '2012-08-01 13:20:04'),
(4, 4, '2016-08-26 17:20:36'),
(5, 5, '2016-08-26 17:21:18'),
(6, 6, '2016-08-26 17:22:41'),
(7, 7, '2016-08-26 17:23:13'),
(8, 8, '2016-08-26 19:12:38'),
(8, 9, '2016-08-26 19:14:50');

INSERT INTO `collections` (`id`, `acquisition_label`, `bank_id`, `collection_site`, `collection_datetime`, `collection_datetime_accuracy`, `sop_master_id`, `collection_property`, `collection_notes`, `participant_id`, `diagnosis_master_id`, `consent_master_id`, `treatment_master_id`, `event_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'Q-039021', 2, 'surg  room 2', '2001-06-23 00:00:00', 'h', NULL, 'participant collection', '', 1, 3, 1, 2, NULL, '2012-07-31 15:45:21', 0, '2012-07-31 19:26:42', 1, 0),
(2, 'QP98893', 2, 'surg  room 2', '2012-07-03 10:01:00', 'c', 1, 'participant collection', '', 3, 9, 3, NULL, NULL, '2012-07-31 19:29:06', 1, '2012-07-31 19:35:48', 1, 0),
(3, 'QP9387', 2, 'surg  room 2', '2010-03-01 00:00:00', 'd', NULL, 'participant collection', '', 3, 9, 3, NULL, NULL, '2012-07-31 19:37:24', 0, '2012-07-31 19:37:45', 1, 0),
(4, 'MET 001', 2, 'surg  room 2', '2004-06-05 08:09:00', 'c', NULL, 'participant collection', '', 1, 5, 1, 5, NULL, '2012-07-31 20:02:04', 0, '2012-07-31 20:03:05', 1, 0),
(5, 'P0002', 2, '', '2008-08-06 12:32:00', 'c', NULL, 'participant collection', '', 2, 7, 2, 7, NULL, '2012-07-31 20:48:50', 0, '2012-07-31 20:49:19', 1, 0),
(6, 'Q5687', 3, 'surg room 1', '2009-08-01 09:05:00', 'c', 1, 'participant collection', '', 4, 10, 8, 11, 8, '2016-08-26 19:13:02', 1, '2016-08-26 19:14:37', 1, 0);

INSERT INTO `collections_revs` (`id`, `acquisition_label`, `bank_id`, `collection_site`, `collection_datetime`, `collection_datetime_accuracy`, `sop_master_id`, `collection_property`, `collection_notes`, `participant_id`, `diagnosis_master_id`, `consent_master_id`, `treatment_master_id`, `event_master_id`, `modified_by`, `version_id`, `version_created`) VALUES
(1, '', NULL, NULL, NULL, '', NULL, NULL, NULL, 1, 3, 1, 2, NULL, 1, 1, '2012-07-31 15:45:21'),
(1, 'Q-03901', 1, 'surg  room 2', '2001-01-03 00:00:00', 'h', NULL, 'participant collection', '', 1, 3, 1, 2, NULL, 1, 2, '2012-07-31 15:47:09'),
(1, 'Q-03901', 1, 'surg  room 2', '2001-06-23 00:00:00', 'h', NULL, 'participant collection', '', 1, 3, 1, 2, NULL, 1, 3, '2012-07-31 15:47:46'),
(1, 'Q-03901', 2, 'surg  room 2', '2001-06-23 00:00:00', 'h', NULL, 'participant collection', '', 1, 3, 1, 2, NULL, 1, 4, '2012-07-31 19:23:03'),
(1, 'Q-039021', 2, 'surg  room 2', '2001-06-23 00:00:00', 'h', NULL, 'participant collection', '', 1, 3, 1, 2, NULL, 1, 5, '2012-07-31 19:26:42'),
(2, 'QP98893', 2, 'surg  room 2', '2012-07-03 10:01:00', 'c', 1, 'participant collection', '', NULL, NULL, NULL, NULL, NULL, 1, 6, '2012-07-31 19:29:06'),
(2, 'QP98893', 2, 'surg  room 2', '2012-07-03 10:01:00', 'c', 1, 'participant collection', '', 3, 9, NULL, NULL, NULL, 1, 7, '2012-07-31 19:35:48'),
(3, '', NULL, NULL, NULL, '', NULL, NULL, NULL, 3, 9, NULL, NULL, NULL, 1, 8, '2012-07-31 19:37:24'),
(3, 'QP9387', 2, 'surg  room 2', '2010-03-01 00:00:00', 'd', NULL, 'participant collection', '', 3, 9, NULL, NULL, NULL, 1, 9, '2012-07-31 19:37:45'),
(4, '', NULL, NULL, NULL, '', NULL, NULL, NULL, 1, 5, 1, 5, NULL, 1, 10, '2012-07-31 20:02:04'),
(4, 'MET 001', 2, 'surg  room 2', NULL, '', NULL, 'participant collection', '', 1, 5, 1, 5, NULL, 1, 11, '2012-07-31 20:02:25'),
(4, 'MET 001', 2, 'surg  room 2', '2004-06-05 08:09:00', 'c', NULL, 'participant collection', '', 1, 5, 1, 5, NULL, 1, 12, '2012-07-31 20:03:05'),
(5, '', NULL, NULL, NULL, '', NULL, NULL, NULL, 2, 7, 2, 7, NULL, 1, 13, '2012-07-31 20:48:50'),
(5, 'P0002', 2, '', '2008-08-06 12:32:00', 'c', NULL, 'participant collection', '', 2, 7, 2, 7, NULL, 1, 14, '2012-07-31 20:49:20'),
(3, 'QP9387', 2, 'surg  room 2', '2010-03-01 00:00:00', 'd', NULL, 'participant collection', '', 3, 9, 3, NULL, NULL, 1, 15, '2012-08-01 13:22:38'),
(2, 'QP98893', 2, 'surg  room 2', '2012-07-03 10:01:00', 'c', 1, 'participant collection', '', 3, 9, 3, NULL, NULL, 1, 16, '2012-08-01 13:23:14'),
(6, '', NULL, NULL, NULL, '', NULL, NULL, NULL, 4, 10, 8, 11, 8, 1, 17, '2016-08-26 19:13:02'),
(6, 'Q5687', 3, 'surg room 1', '2009-08-01 09:05:00', 'c', 1, 'participant collection', '', 4, 10, 8, 11, 8, 1, 18, '2016-08-26 19:14:37');

INSERT INTO `consent_masters` (`id`, `date_of_referral`, `date_of_referral_accuracy`, `route_of_referral`, `date_first_contact`, `date_first_contact_accuracy`, `consent_signed_date`, `consent_signed_date_accuracy`, `form_version`, `reason_denied`, `consent_status`, `process_status`, `status_date`, `status_date_accuracy`, `surgeon`, `operation_date`, `operation_date_accuracy`, `facility`, `notes`, `consent_method`, `translator_indicator`, `translator_signature`, `consent_person`, `facility_other`, `acquisition_id`, `participant_id`, `consent_control_id`, `type`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `study_summary_id`) VALUES
(1, NULL, '', '', NULL, '', '2001-10-12', 'c', 'v2.0', '', 'obtained', '', '2001-10-12', 'c', '', NULL, '', '', '', 'in person', 'n', '', '', '', NULL, 1, 1, '', '2012-07-31 15:18:22', 1, '2012-07-31 15:18:22', 1, 0, NULL),
(2, NULL, '', '', NULL, '', NULL, '', 'v1.0', '', 'obtained', '', NULL, '', '', NULL, '', '', '', '', '', '', '', '', NULL, 2, 1, '', '2012-07-31 18:25:22', 1, '2012-07-31 18:25:22', 1, 0, NULL),
(3, NULL, '', '', NULL, '', '2010-03-01', 'd', 'v2.0', '', 'pending', '', NULL, '', '', NULL, '', '', '', '', '', '', '', '', NULL, 3, 1, '', '2012-08-01 13:20:03', 1, '2012-08-01 13:20:03', 1, 0, NULL),
(4, NULL, '', NULL, NULL, '', '2016-04-05', 'c', 'v1.0', '', 'obtained', NULL, '2016-04-06', 'c', NULL, NULL, '', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, 1, 2, '', '2016-08-26 17:20:35', 1, '2016-08-26 17:20:36', 1, 0, 1),
(5, NULL, '', NULL, NULL, '', NULL, '', 'v1.0', '', 'pending', NULL, NULL, '', NULL, NULL, '', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, 1, 2, '', '2016-08-26 17:21:18', 1, '2016-08-26 17:21:18', 1, 0, 2),
(6, NULL, '', NULL, NULL, '', '2016-02-02', 'c', 'v1.0', '', 'obtained', NULL, '2016-02-02', 'c', NULL, NULL, '', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, 3, 2, '', '2016-08-26 17:22:41', 1, '2016-08-26 17:22:41', 1, 0, 2),
(7, NULL, '', NULL, NULL, '', NULL, '', '', '', 'obtained', NULL, '2016-08-22', 'c', NULL, NULL, '', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, 3, 2, '', '2016-08-26 17:23:12', 1, '2016-08-26 17:23:12', 1, 0, 1),
(8, NULL, '', NULL, NULL, '', '2009-08-01', 'c', '', '', 'obtained', NULL, NULL, '', NULL, NULL, '', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, 4, 2, '', '2016-08-26 19:12:38', 1, '2016-08-26 19:14:50', 1, 0, 1);

INSERT INTO `consent_masters_revs` (`id`, `date_of_referral`, `date_of_referral_accuracy`, `route_of_referral`, `date_first_contact`, `date_first_contact_accuracy`, `consent_signed_date`, `consent_signed_date_accuracy`, `form_version`, `reason_denied`, `consent_status`, `process_status`, `status_date`, `status_date_accuracy`, `surgeon`, `operation_date`, `operation_date_accuracy`, `facility`, `notes`, `consent_method`, `translator_indicator`, `translator_signature`, `consent_person`, `facility_other`, `acquisition_id`, `participant_id`, `consent_control_id`, `type`, `modified_by`, `version_id`, `version_created`, `study_summary_id`) VALUES
(1, NULL, '', '', NULL, '', '2001-10-12', 'c', 'v2.0', '', 'obtained', '', '2001-10-12', 'c', '', NULL, '', '', '', 'in person', 'n', '', '', '', NULL, 1, 1, '', 1, 1, '2012-07-31 15:18:23', NULL),
(2, NULL, '', '', NULL, '', NULL, '', 'v1.0', '', 'obtained', '', NULL, '', '', NULL, '', '', '', '', '', '', '', '', NULL, 2, 1, '', 1, 2, '2012-07-31 18:25:22', NULL),
(3, NULL, '', '', NULL, '', '2010-03-01', 'd', 'v2.0', '', 'pending', '', NULL, '', '', NULL, '', '', '', '', '', '', '', '', NULL, 3, 1, '', 1, 3, '2012-08-01 13:20:03', NULL),
(4, NULL, '', NULL, NULL, '', '2016-04-05', 'c', 'v1.0', '', 'obtained', NULL, '2016-04-06', 'c', NULL, NULL, '', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, 1, 2, '', 1, 4, '2016-08-26 17:20:36', 1),
(5, NULL, '', NULL, NULL, '', NULL, '', 'v1.0', '', 'pending', NULL, NULL, '', NULL, NULL, '', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, 1, 2, '', 1, 5, '2016-08-26 17:21:18', 2),
(6, NULL, '', NULL, NULL, '', '2016-02-02', 'c', 'v1.0', '', 'obtained', NULL, '2016-02-02', 'c', NULL, NULL, '', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, 3, 2, '', 1, 6, '2016-08-26 17:22:41', 2),
(7, NULL, '', NULL, NULL, '', NULL, '', '', '', 'obtained', NULL, '2016-08-22', 'c', NULL, NULL, '', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, 3, 2, '', 1, 7, '2016-08-26 17:23:12', 1),
(8, NULL, '', NULL, NULL, '', '2010-08-20', 'c', '', '', 'obtained', NULL, NULL, '', NULL, NULL, '', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, 4, 2, '', 1, 8, '2016-08-26 19:12:38', 1),
(8, NULL, '', NULL, NULL, '', '2009-08-01', 'c', '', '', 'obtained', NULL, NULL, '', NULL, NULL, '', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, 4, 2, '', 1, 9, '2016-08-26 19:14:50', 1);

INSERT INTO `datamart_batch_ids` (`id`, `set_id`, `lookup_id`) VALUES
(1, 1, 106),
(2, 1, 107),
(3, 1, 108),
(4, 2, 33),
(5, 3, 11),
(6, 3, 12),
(7, 3, 13),
(8, 3, 14),
(9, 3, 26),
(10, 3, 30),
(11, 3, 31),
(12, 4, 34),
(13, 4, 35),
(14, 4, 36),
(15, 4, 37),
(16, 4, 38),
(17, 5, 119),
(18, 5, 120),
(19, 5, 121),
(20, 5, 122),
(21, 5, 123),
(22, 5, 124),
(23, 6, 125),
(24, 6, 126),
(25, 6, 127),
(26, 6, 128),
(27, 6, 129),
(28, 6, 130),
(29, 6, 131),
(30, 6, 132),
(31, 6, 133),
(32, 6, 134),
(33, 6, 135),
(34, 6, 136),
(35, 6, 137),
(36, 6, 138),
(37, 6, 139),
(38, 6, 140);

INSERT INTO `datamart_batch_sets` (`id`, `user_id`, `group_id`, `sharing_status`, `title`, `description`, `datamart_structure_id`, `locked`, `flag_tmp`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(1, 1, 1, 'user', 'unknown', NULL, 1, 0, 1, '2016-08-26 16:07:22', 1, '2016-08-26 16:07:22', 1),
(2, 1, 1, 'user', '2016-08-26 16:19', NULL, 3, 0, 0, '2016-08-26 16:19:57', 1, '2016-08-26 16:19:57', 1),
(3, 1, 1, 'user', '2016-08-26 16:21', NULL, 3, 0, 0, '2016-08-26 16:21:08', 1, '2016-08-26 16:21:08', 1),
(4, 1, 1, 'user', '2016-08-26 16:24', NULL, 3, 0, 0, '2016-08-26 16:24:12', 1, '2016-08-26 16:24:12', 1),
(5, 1, 1, 'user', 'unknown', NULL, 1, 0, 1, '2016-08-26 19:40:13', 1, '2016-08-26 19:40:13', 1),
(6, 1, 1, 'user', 'unknown', NULL, 1, 0, 1, '2016-08-26 19:50:54', 1, '2016-08-26 19:50:54', 1);

INSERT INTO `datamart_browsing_indexes` (`id`, `root_node_id`, `notes`, `temporary`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(3, 11, NULL, 1, '2016-08-26 16:23:23', 1, '2016-08-26 16:23:23', 1),
(4, 12, NULL, 1, '2016-08-26 16:24:46', 1, '2016-08-26 16:24:46', 1),
(5, 20, NULL, 1, '2016-08-26 17:23:43', 1, '2016-08-26 17:23:43', 1),
(6, 23, NULL, 1, '2016-08-26 19:36:53', 1, '2016-08-26 19:36:53', 1),
(7, 24, NULL, 1, '2016-08-26 19:37:21', 1, '2016-08-26 19:37:21', 1),
(8, 25, NULL, 1, '2016-08-26 20:06:18', 1, '2016-08-26 20:06:18', 1);

INSERT INTO `datamart_browsing_results` (`id`, `user_id`, `parent_id`, `lft`, `rght`, `browsing_structures_id`, `browsing_structures_sub_id`, `parent_children`, `raw`, `browsing_type`, `serialized_search_params`, `id_csv`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(11, 1, 0, 1, 2, 3, 0, '', 1, 'initiated from batchset', NULL, '11,12,13,14,26,30,31', '2016-08-26 16:23:23', 1, '2016-08-26 16:23:23', 1),
(12, 1, 0, 3, 4, 3, 0, '', 1, 'initiated from batchset', NULL, '33', '2016-08-26 16:24:46', 1, '2016-08-26 16:24:46', 1),
(20, 1, 0, 5, 10, 25, 0, '', 1, 'direct access', 'a:3:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;s:21:"adv_search_conditions";a:0:{}}', '1,2', '2016-08-26 17:23:43', 1, '2016-08-26 17:23:43', 1),
(21, 1, 20, 6, 7, 8, 2, '', 1, 'direct access', 'a:3:{s:17:"search_conditions";a:1:{s:32:"ConsentMaster.consent_control_id";s:1:"2";}s:12:"exact_search";b:0;s:21:"adv_search_conditions";a:0:{}}', '4,5,6,7', '2016-08-26 17:24:09', 1, '2016-08-26 17:24:09', 1),
(22, 1, 20, 8, 9, 6, 0, '', 1, 'direct access', 'a:3:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;s:21:"adv_search_conditions";a:0:{}}', '8,9,10', '2016-08-26 18:32:21', 1, '2016-08-26 18:32:21', 1),
(23, 1, 0, 11, 12, 1, 17, '', 1, 'search', 'a:3:{s:17:"search_conditions";a:2:{s:22:"AliquotMaster.in_stock";a:1:{i:0;s:15:"yes - available";}s:32:"AliquotMaster.aliquot_control_id";s:2:"17";}s:12:"exact_search";b:0;s:21:"adv_search_conditions";a:0:{}}', '116,117', '2016-08-26 19:36:53', 1, '2016-08-26 19:36:53', 1),
(24, 1, 0, 13, 14, 1, 1, '', 1, 'search', 'a:3:{s:17:"search_conditions";a:2:{s:22:"AliquotMaster.in_stock";a:1:{i:0;s:15:"yes - available";}s:32:"AliquotMaster.aliquot_control_id";s:1:"1";}s:12:"exact_search";b:0;s:21:"adv_search_conditions";a:0:{}}', '15,16,17,18,19,20,42,43,44,46,109,110,111,112', '2016-08-26 19:37:21', 1, '2016-08-26 19:37:21', 1),
(25, 1, 0, 15, 22, 26, 0, '', 1, 'direct access', 'a:3:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;s:21:"adv_search_conditions";a:0:{}}', '1,2', '2016-08-26 20:06:18', 1, '2016-08-26 20:06:18', 1),
(26, 1, 25, 16, 21, 22, 0, '', 1, 'direct access', 'a:3:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;s:21:"adv_search_conditions";a:0:{}}', '1', '2016-08-26 20:06:47', 1, '2016-08-26 20:06:47', 1),
(27, 1, 26, 17, 20, 25, 0, '', 1, 'direct access', 'a:3:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;s:21:"adv_search_conditions";a:0:{}}', '1', '2016-08-26 20:07:06', 1, '2016-08-26 20:07:06', 1),
(28, 1, 27, 18, 19, 23, 0, '', 1, 'direct access', 'a:3:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;s:21:"adv_search_conditions";a:0:{}}', '1,2,3', '2016-08-26 20:07:06', 1, '2016-08-26 20:07:06', 1);

INSERT INTO `datamart_saved_browsing_indexes` (`id`, `user_id`, `group_id`, `sharing_status`, `name`, `starting_datamart_structure_id`, `deleted`) VALUES
(1, 1, 1, 'user', 'test', 1, 0),
(2, 1, 1, 'user', 'teest2', 3, 0);

INSERT INTO `datamart_saved_browsing_steps` (`id`, `datamart_saved_browsing_index_id`, `datamart_structure_id`, `datamart_sub_structure_id`, `serialized_search_params`, `deleted`, `parent_children`) VALUES
(1, 1, 3, 0, NULL, 0, ''),
(2, 1, 1, 0, 'a:3:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;s:21:"adv_search_conditions";a:0:{}}', 0, ''),
(3, 1, 3, 0, NULL, 0, ''),
(4, 2, 1, 0, 'a:3:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;s:21:"adv_search_conditions";a:0:{}}', 0, ''),
(5, 2, 2, 0, 'a:3:{s:17:"search_conditions";a:1:{i:0;a:1:{s:2:"OR";a:5:{i:0;a:2:{s:37:"ViewCollection.collection_datetime >=";s:14:"1903-1-1 0:0:0";s:43:"ViewCollection.collection_datetime_accuracy";a:2:{i:0;s:1:"c";i:1;s:1:" ";}}i:1;a:2:{s:37:"ViewCollection.collection_datetime >=";s:16:"1903-1-1 0:00:00";s:43:"ViewCollection.collection_datetime_accuracy";s:1:"i";}i:2;a:2:{s:37:"ViewCollection.collection_datetime >=";s:17:"1903-1-1 00:00:00";s:43:"ViewCollection.collection_datetime_accuracy";s:1:"h";}i:3;a:2:{s:37:"ViewCollection.collection_datetime >=";s:18:"1903-1-01 00:00:00";s:43:"ViewCollection.collection_datetime_accuracy";s:1:"d";}i:4;a:2:{s:37:"ViewCollection.collection_datetime >=";s:19:"1903-01-01 00:00:00";s:43:"ViewCollection.collection_datetime_accuracy";a:2:{i:0;s:1:"m";i:1;s:1:"y";}}}}}s:12:"exact_search";b:0;s:21:"adv_search_conditions";a:0:{}}', 0, ''),
(6, 2, 1, 0, 'a:3:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;s:21:"adv_search_conditions";a:0:{}}', 0, ''),
(7, 2, 3, 0, NULL, 0, ''),
(8, 2, 1, 0, 'a:3:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;s:21:"adv_search_conditions";a:0:{}}', 0, '');

INSERT INTO `demo_ed_all_ct_scans` (`icd_O_3_category`, `result`, `event_master_id`) VALUES
('C50', 'negative', 6),
('C71', 'positive', 7);

INSERT INTO `demo_ed_all_ct_scans_revs` (`icd_O_3_category`, `result`, `event_master_id`, `version_id`, `version_created`) VALUES
('C50', 'negative', 6, 1, '2016-08-26 19:02:30'),
('C71', 'positive', 7, 2, '2016-08-26 19:08:46');

INSERT INTO `derivative_details` (`sample_master_id`, `creation_site`, `creation_by`, `creation_datetime`, `lab_book_master_id`, `sync_with_lab_book`, `creation_datetime_accuracy`) VALUES
(4, 'r644', 'tech. 2', '2010-03-01 00:00:00', NULL, 0, 'd'),
(5, 'r644', 'res. assist. 1', '2012-07-03 07:34:00', NULL, 0, 'c'),
(6, '', '', '2010-03-01 00:00:00', NULL, 0, 'd'),
(11, 'r523', 'tech. 1', '2012-08-01 10:03:00', NULL, NULL, 'c'),
(12, 'r523', 'tech. 1', '2012-08-01 10:03:00', NULL, NULL, 'c'),
(13, 'r523', 'tech. 1', '2012-08-01 10:03:00', NULL, NULL, 'c'),
(14, 'r523', 'tech. 1', '2012-08-01 10:03:00', NULL, NULL, 'c'),
(15, 'r523', 'tech. 1', '2012-08-01 10:03:00', NULL, NULL, 'c'),
(19, 'r523', 'res. assist. 1', '2009-08-01 18:00:00', NULL, 0, 'i'),
(20, 'r523', 'res. assist. 1', '2009-08-01 18:00:00', NULL, 0, 'i');

INSERT INTO `derivative_details_revs` (`sample_master_id`, `creation_site`, `creation_by`, `creation_datetime`, `lab_book_master_id`, `sync_with_lab_book`, `version_id`, `version_created`, `creation_datetime_accuracy`) VALUES
(4, 'r644', 'tech. 2', '2010-03-01 00:00:00', NULL, 0, 1, '2012-07-31 19:48:33', 'd'),
(5, 'r644', 'res. assist. 1', '2012-07-03 07:34:00', NULL, 0, 2, '2012-07-31 19:49:03', 'c'),
(6, '', '', '2010-03-01 00:00:00', NULL, 0, 3, '2012-07-31 19:51:43', 'd'),
(11, 'r523', 'tech. 1', '2012-08-01 10:03:00', NULL, NULL, 4, '2012-08-01 13:45:33', 'c'),
(12, 'r523', 'tech. 1', '2012-08-01 10:03:00', NULL, NULL, 5, '2012-08-01 13:45:34', 'c'),
(13, 'r523', 'tech. 1', '2012-08-01 10:03:00', NULL, NULL, 6, '2012-08-01 13:45:35', 'c'),
(14, 'r523', 'tech. 1', '2012-08-01 10:03:00', NULL, NULL, 7, '2012-08-01 13:45:36', 'c'),
(15, 'r523', 'tech. 1', '2012-08-01 10:03:00', NULL, NULL, 8, '2012-08-01 13:45:37', 'c'),
(19, 'r523', 'res. assist. 1', '2009-08-01 18:00:00', NULL, 0, 9, '2016-08-26 19:20:36', 'i'),
(20, 'r523', 'res. assist. 1', '2009-08-01 18:00:00', NULL, 0, 10, '2016-08-26 19:22:32', 'i');

INSERT INTO `diagnosis_masters` (`id`, `primary_id`, `parent_id`, `dx_method`, `dx_nature`, `dx_date`, `dx_date_accuracy`, `tumor_size_greatest_dimension`, `additional_dimension_a`, `additional_dimension_b`, `tumor_size_cannot_be_determined`, `icd10_code`, `previous_primary_code`, `previous_primary_code_system`, `morphology`, `topography`, `icd_0_3_topography_category`, `tumour_grade`, `tumour_grade_specify`, `age_at_dx`, `age_at_dx_precision`, `ajcc_edition`, `collaborative_staged`, `clinical_tstage`, `clinical_nstage`, `clinical_mstage`, `clinical_stage_summary`, `path_tnm_descriptor_m`, `path_tnm_descriptor_r`, `path_tnm_descriptor_y`, `path_tstage`, `path_nstage`, `path_nstage_nbr_node_examined`, `path_nstage_nbr_node_involved`, `path_mstage`, `path_mstage_metastasis_site_specify`, `path_stage_summary`, `survival_time_months`, `information_source`, `notes`, `diagnosis_control_id`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, NULL, 'cytology', 'malignant', '1978-01-01', 'y', NULL, NULL, NULL, 0, 'C827', NULL, NULL, '', '', NULL, '', NULL, 40, '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, '', NULL, '', NULL, '', '', 1, 1, '2012-07-31 15:19:56', 1, '2012-07-31 15:19:56', 1, 0),
(2, 1, 1, NULL, NULL, '1990-01-01', 'y', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 17, 1, '2012-07-31 15:20:24', 1, '2012-07-31 15:20:24', 1, 0),
(3, 3, NULL, 'surgical', 'malignant', '2001-06-23', 'c', NULL, NULL, NULL, 0, 'C61', NULL, NULL, '', 'C619', 'C61', 'G2', NULL, NULL, '', '', '', '', '', '', '', '', '', '', '4', '1', 0, 0, '1', NULL, '', NULL, '', '', 2, 1, '2012-07-31 15:33:13', 1, '2016-08-26 18:39:02', 1, 0),
(4, 3, 3, NULL, NULL, '2003-01-01', 'y', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 17, 1, '2012-07-31 15:41:16', 1, '2012-07-31 15:41:16', 1, 0),
(5, 3, 3, '', NULL, '2005-05-04', 'c', NULL, NULL, NULL, 0, NULL, NULL, NULL, '', '', NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, '', '', 16, 1, '2012-07-31 15:42:35', 1, '2012-07-31 15:42:35', 1, 0),
(6, 6, NULL, '', 'malignant', '2008-07-11', 'c', NULL, NULL, NULL, 0, 'D075', NULL, NULL, '', '', NULL, '', NULL, NULL, '', '', '', '', '', '', '', '', '', '', '1', '1', 0, 0, '', NULL, '', NULL, '', '', 2, 2, '2012-07-31 18:48:58', 1, '2012-07-31 18:48:58', 1, 0),
(7, 6, 6, NULL, NULL, '2008-12-31', 'c', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 'PSA', 18, 2, '2012-07-31 18:50:03', 1, '2012-07-31 18:50:03', 1, 0),
(8, 6, 6, NULL, NULL, '2010-01-01', 'y', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 17, 2, '2012-07-31 18:50:35', 1, '2012-07-31 18:50:35', 1, 0),
(9, 9, NULL, 'surgical', 'benign', '2010-03-01', 'd', NULL, NULL, NULL, 0, NULL, NULL, NULL, '', '', NULL, '', NULL, NULL, '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, '', NULL, '', NULL, '', '', 2, 3, '2012-07-31 18:54:26', 1, '2012-07-31 18:54:26', 1, 0),
(10, 10, NULL, 'surgical/clinical', 'malignant', '2009-08-01', 'c', NULL, NULL, NULL, 0, 'C502', NULL, NULL, '80103', 'C502', 'C50', 'G1', NULL, NULL, '', NULL, NULL, '1a', '3a', 'm0', '', '', '', '', '1b', 'n0', 0, 0, 'cm0(i+)', NULL, '', NULL, 'path report', '', 20, 4, '2016-08-26 18:43:54', 1, '2016-08-26 18:43:54', 1, 0),
(11, 10, 10, NULL, NULL, '2010-05-01', 'c', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 17, 4, '2016-08-26 19:01:03', 1, '2016-08-26 19:01:03', 1, 0),
(12, 10, 10, 'radiology', NULL, '2014-08-26', 'c', NULL, NULL, NULL, 0, 'C798', NULL, NULL, '', 'C710', 'C71', NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, '', '', 16, 4, '2016-08-26 19:05:06', 1, '2016-08-26 19:05:06', 1, 0);

INSERT INTO `diagnosis_masters_revs` (`id`, `primary_id`, `parent_id`, `dx_method`, `dx_nature`, `dx_date`, `dx_date_accuracy`, `tumor_size_greatest_dimension`, `additional_dimension_a`, `additional_dimension_b`, `tumor_size_cannot_be_determined`, `icd10_code`, `previous_primary_code`, `previous_primary_code_system`, `morphology`, `topography`, `icd_0_3_topography_category`, `tumour_grade`, `tumour_grade_specify`, `age_at_dx`, `age_at_dx_precision`, `ajcc_edition`, `collaborative_staged`, `clinical_tstage`, `clinical_nstage`, `clinical_mstage`, `clinical_stage_summary`, `path_tnm_descriptor_m`, `path_tnm_descriptor_r`, `path_tnm_descriptor_y`, `path_tstage`, `path_nstage`, `path_nstage_nbr_node_examined`, `path_nstage_nbr_node_involved`, `path_mstage`, `path_mstage_metastasis_site_specify`, `path_stage_summary`, `survival_time_months`, `information_source`, `notes`, `diagnosis_control_id`, `participant_id`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 1, NULL, 'cytology', 'malignant', '1978-01-01', 'y', NULL, NULL, NULL, 0, 'C827', NULL, NULL, '', '', NULL, '', NULL, 40, '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, '', NULL, '', NULL, '', '', 1, 1, 1, 1, '2012-07-31 15:19:56'),
(2, 1, 1, NULL, NULL, '1990-01-01', 'y', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 17, 1, 1, 2, '2012-07-31 15:20:24'),
(3, 3, NULL, 'surgical', 'malignant', '2001-06-23', 'c', NULL, NULL, NULL, 0, 'C61', NULL, NULL, '', 'C619', 'C61', '', NULL, NULL, '', '', '', '', '', '', '', '', '', '', '4', '1', 0, 0, '1', NULL, '', NULL, '', '', 2, 1, 1, 3, '2012-07-31 15:33:14'),
(4, 3, 3, NULL, NULL, '2003-01-01', 'y', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 17, 1, 1, 4, '2012-07-31 15:41:16'),
(5, 3, 3, '', NULL, '2005-05-04', 'c', NULL, NULL, NULL, 0, NULL, NULL, NULL, '', '', NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, '', '', 16, 1, 1, 5, '2012-07-31 15:42:35'),
(6, 6, NULL, '', 'malignant', '2008-07-11', 'c', NULL, NULL, NULL, 0, 'D075', NULL, NULL, '', '', NULL, '', NULL, NULL, '', '', '', '', '', '', '', '', '', '', '1', '1', 0, 0, '', NULL, '', NULL, '', '', 2, 2, 1, 6, '2012-07-31 18:48:58'),
(7, 6, 6, NULL, NULL, '2008-12-31', 'c', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 'PSA', 18, 2, 1, 7, '2012-07-31 18:50:03'),
(8, 6, 6, NULL, NULL, '2010-01-01', 'y', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 17, 2, 1, 8, '2012-07-31 18:50:35'),
(9, 9, NULL, 'surgical', 'benign', '2010-03-01', 'd', NULL, NULL, NULL, 0, NULL, NULL, NULL, '', '', NULL, '', NULL, NULL, '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, '', NULL, '', NULL, '', '', 2, 3, 1, 9, '2012-07-31 18:54:26'),
(3, 3, NULL, 'surgical', 'malignant', '2001-06-23', 'c', NULL, NULL, NULL, 0, 'C61', NULL, NULL, '', 'C619', 'C61', 'G2', NULL, NULL, '', '', '', '', '', '', '', '', '', '', '4', '1', 0, 0, '1', NULL, '', NULL, '', '', 2, 1, 1, 10, '2016-08-26 18:39:02'),
(10, 10, NULL, 'surgical/clinical', 'malignant', '2009-08-01', 'c', NULL, NULL, NULL, 0, 'C502', NULL, NULL, '80103', 'C502', 'C50', 'G1', NULL, NULL, '', NULL, NULL, '1a', '3a', 'm0', '', '', '', '', '1b', 'n0', 0, 0, 'cm0(i+)', NULL, '', NULL, 'path report', '', 20, 4, 1, 11, '2016-08-26 18:43:54'),
(11, 10, 10, NULL, NULL, '2010-05-01', 'c', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 17, 4, 1, 12, '2016-08-26 19:01:03'),
(12, 10, 10, 'radiology', NULL, '2014-08-26', 'c', NULL, NULL, NULL, 0, 'C798', NULL, NULL, '', 'C710', 'C71', NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, '', '', 16, 4, 1, 13, '2016-08-26 19:05:06');

INSERT INTO `drugs` (`id`, `generic_name`, `trade_name`, `type`, `description`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'carboplatin', '', 'chemotherapy', '', '2012-07-31 15:26:06', 1, '2012-07-31 15:26:06', 1, 0),
(2, 'cyclophosphamide', '', 'chemotherapy', '', '2012-07-31 15:26:16', 1, '2012-07-31 15:26:16', 1, 0),
(3, 'methotrexate', '', 'chemotherapy', '', '2012-07-31 15:26:41', 1, '2012-07-31 15:26:41', 1, 0),
(4, 'fluorouracil', '', 'chemotherapy', '', '2012-07-31 15:26:53', 1, '2012-07-31 15:26:53', 1, 0),
(5, 'fluoxymesterone', '', 'hormonal', '', '2012-07-31 15:28:12', 1, '2012-07-31 15:28:12', 1, 0),
(6, 'doxorubicin', '', 'chemotherapy', '', '2016-08-26 18:53:33', 1, '2016-08-26 18:54:00', 1, 0),
(7, 'filgrastim', '', 'chemotherapy', '', '2016-08-26 18:54:51', 1, '2016-08-26 18:55:28', 1, 0);

INSERT INTO `drugs_revs` (`id`, `generic_name`, `trade_name`, `type`, `description`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 'carboplatin', '', 'chemotherapy', '', 1, 1, '2012-07-31 15:26:06'),
(2, 'cyclophosphamide', '', 'chemotherapy', '', 1, 2, '2012-07-31 15:26:23'),
(3, 'methotrexate', '', 'chemotherapy', '', 1, 3, '2012-07-31 15:26:41'),
(4, 'fluorouracil', '', 'chemotherapy', '', 1, 4, '2012-07-31 15:26:53'),
(5, 'fluoxymesterone', '', 'hormonal', '', 1, 5, '2012-07-31 15:28:12'),
(6, 'doxorubicin', '', '', '', 1, 6, '2016-08-26 18:53:33'),
(6, 'doxorubicin', '', 'chemotherapy', '', 1, 7, '2016-08-26 18:54:00'),
(7, 'gilgrastim', '', '', '', 1, 8, '2016-08-26 18:54:51'),
(7, 'filgrastim', '', 'chemotherapy', '', 1, 9, '2016-08-26 18:55:28');

INSERT INTO `dxd_bloods` (`diagnosis_master_id`, `text_field`) VALUES
(1, '');

INSERT INTO `dxd_bloods_revs` (`diagnosis_master_id`, `text_field`, `version_id`, `version_created`) VALUES
(1, '', 1, '2012-07-31 15:19:56');

INSERT INTO `dxd_progressions` (`diagnosis_master_id`) VALUES
(7);

INSERT INTO `dxd_progressions_revs` (`diagnosis_master_id`, `version_id`, `version_created`) VALUES
(7, 1, '2012-07-31 18:50:03');

INSERT INTO `dxd_remissions` (`diagnosis_master_id`) VALUES
(2),
(4),
(8),
(11);

INSERT INTO `dxd_remissions_revs` (`diagnosis_master_id`, `version_id`, `version_created`) VALUES
(2, 1, '2012-07-31 15:20:24'),
(4, 2, '2012-07-31 15:41:17'),
(8, 3, '2012-07-31 18:50:36'),
(11, 4, '2016-08-26 19:01:03');

INSERT INTO `dxd_secondaries` (`diagnosis_master_id`) VALUES
(5),
(12);

INSERT INTO `dxd_secondaries_revs` (`diagnosis_master_id`, `version_id`, `version_created`) VALUES
(5, 1, '2012-07-31 15:42:36'),
(12, 2, '2016-08-26 19:05:07');

INSERT INTO `dxd_tissues` (`diagnosis_master_id`, `laterality`) VALUES
(3, 'not applicable'),
(6, 'not applicable'),
(9, ''),
(10, 'right');

INSERT INTO `dxd_tissues_revs` (`diagnosis_master_id`, `laterality`, `version_id`, `version_created`) VALUES
(3, 'not applicable', 1, '2012-07-31 15:33:14'),
(6, 'not applicable', 2, '2012-07-31 18:48:59'),
(9, '', 3, '2012-07-31 18:54:27'),
(3, 'not applicable', 4, '2016-08-26 18:39:03'),
(10, 'right', 5, '2016-08-26 18:43:54');

INSERT INTO `ed_all_clinical_followups` (`weight`, `recurrence_status`, `disease_status`, `vital_status`, `event_master_id`) VALUES
(NULL, '', '', 'died of unknown cause', 3);

INSERT INTO `ed_all_clinical_followups_revs` (`weight`, `recurrence_status`, `disease_status`, `vital_status`, `event_master_id`, `version_id`, `version_created`) VALUES
(NULL, '', '', 'died of unknown cause', 3, 1, '2012-07-31 15:40:36');

INSERT INTO `ed_all_clinical_presentations` (`weight`, `height`, `event_master_id`) VALUES
('87.00', '176.00', 2),
('78.00', '165.00', 4);

INSERT INTO `ed_all_clinical_presentations_revs` (`weight`, `height`, `event_master_id`, `version_id`, `version_created`) VALUES
('87.00', '176.00', 2, 1, '2012-07-31 15:39:11'),
('78.00', '165.00', 4, 2, '2012-07-31 18:29:22');

INSERT INTO `ed_all_lifestyle_smokings` (`smoking_history`, `smoking_status`, `pack_years`, `product_used`, `event_master_id`, `started_on`, `started_on_accuracy`, `stopped_on`, `stopped_on_accuracy`) VALUES
('yes', 'smoker at dx', NULL, 'cigarettes', 1, '1969-01-01', 'm', NULL, ''),
('no', 'non-smoker', NULL, '', 5, NULL, '', NULL, '');

INSERT INTO `ed_all_lifestyle_smokings_revs` (`smoking_history`, `smoking_status`, `pack_years`, `product_used`, `event_master_id`, `version_id`, `version_created`, `started_on`, `started_on_accuracy`, `stopped_on`, `stopped_on_accuracy`) VALUES
('yes', 'smoker at dx', NULL, 'cigarettes', 1, 1, '2012-07-31 15:37:52', '1969-01-01', 'm', NULL, ''),
('no', 'non-smoker', NULL, '', 5, 2, '2012-07-31 18:47:40', NULL, '', NULL, '');

INSERT INTO `ed_breast_lab_pathologies` (`path_number`, `report_type`, `facility`, `vascular_lymph_invasion`, `extra_nodal_invasion`, `blood_lymph`, `tumour_type`, `grade`, `multifocal`, `preneoplastic_changes`, `spread_skin_nipple`, `level_nodal_involvement`, `frozen_section`, `er_assay_ligand`, `pr_assay_ligand`, `progesterone`, `estrogen`, `number_resected`, `number_positive`, `nodal_status`, `resection_margins`, `tumour_size`, `tumour_total_size`, `sentinel_only`, `in_situ_type`, `her2_grade`, `her2_method`, `mb_collectionid`, `event_master_id`, `breast_tumour_size`) VALUES
('7855533', '', '', 'negative', '', NULL, 'ductal', '1', 'yes', '', '', '', '', '', '', '', '', '', '', NULL, '', NULL, NULL, '', '', '', '', NULL, 8, '');

INSERT INTO `ed_breast_lab_pathologies_revs` (`path_number`, `report_type`, `facility`, `vascular_lymph_invasion`, `extra_nodal_invasion`, `blood_lymph`, `tumour_type`, `grade`, `multifocal`, `preneoplastic_changes`, `spread_skin_nipple`, `level_nodal_involvement`, `frozen_section`, `er_assay_ligand`, `pr_assay_ligand`, `progesterone`, `estrogen`, `number_resected`, `number_positive`, `nodal_status`, `resection_margins`, `tumour_size`, `tumour_total_size`, `sentinel_only`, `in_situ_type`, `her2_grade`, `her2_method`, `mb_collectionid`, `event_master_id`, `version_id`, `version_created`, `breast_tumour_size`) VALUES
('7855533', '', '', 'negative', '', NULL, 'ductal', '1', 'yes', '', '', '', '', '', '', '', '', '', '', NULL, '', NULL, NULL, '', '', '', '', NULL, 8, 1, '2016-08-26 19:10:14', '');

INSERT INTO `event_masters` (`id`, `event_control_id`, `event_status`, `event_summary`, `event_date`, `event_date_accuracy`, `information_source`, `urgency`, `date_required`, `date_required_accuracy`, `date_requested`, `date_requested_accuracy`, `reference_number`, `created`, `created_by`, `modified`, `modified_by`, `participant_id`, `diagnosis_master_id`, `deleted`) VALUES
(1, 30, NULL, '', '2001-01-01', 'm', NULL, NULL, NULL, '', NULL, '', NULL, '2012-07-31 15:37:52', 1, '2012-07-31 15:37:52', 1, 1, 3, 0),
(2, 22, NULL, '', '2006-01-01', 'm', NULL, NULL, NULL, '', NULL, '', NULL, '2012-07-31 15:39:11', 1, '2012-07-31 15:39:11', 1, 1, NULL, 0),
(3, 20, NULL, '', '2008-01-01', 'y', NULL, NULL, NULL, '', NULL, '', NULL, '2012-07-31 15:40:35', 1, '2012-07-31 15:40:35', 1, 1, NULL, 0),
(4, 22, NULL, '', NULL, '', NULL, NULL, NULL, '', NULL, '', NULL, '2012-07-31 18:29:21', 1, '2012-07-31 18:29:21', 1, 2, NULL, 0),
(5, 30, NULL, '', NULL, '', NULL, NULL, NULL, '', NULL, '', NULL, '2012-07-31 18:47:39', 1, '2012-07-31 18:47:39', 1, 2, NULL, 0),
(6, 51, NULL, NULL, '2010-05-01', 'd', NULL, NULL, NULL, '', NULL, '', NULL, '2016-08-26 19:02:30', 1, '2016-08-26 19:02:30', 1, 4, 11, 0),
(7, 51, NULL, NULL, '2014-08-20', 'c', NULL, NULL, NULL, '', NULL, '', NULL, '2016-08-26 19:08:45', 1, '2016-08-26 19:08:45', 1, 4, 12, 0),
(8, 18, NULL, '', '2009-08-02', 'c', NULL, NULL, NULL, '', NULL, '', NULL, '2016-08-26 19:10:13', 1, '2016-08-26 19:10:13', 1, 4, 10, 0);

INSERT INTO `event_masters_revs` (`id`, `event_control_id`, `event_status`, `event_summary`, `event_date`, `event_date_accuracy`, `information_source`, `urgency`, `date_required`, `date_required_accuracy`, `date_requested`, `date_requested_accuracy`, `reference_number`, `modified_by`, `participant_id`, `diagnosis_master_id`, `version_id`, `version_created`) VALUES
(1, 30, NULL, '', '2001-01-01', 'm', NULL, NULL, NULL, '', NULL, '', NULL, 1, 1, 3, 1, '2012-07-31 15:37:52'),
(2, 22, NULL, '', '2006-01-01', 'm', NULL, NULL, NULL, '', NULL, '', NULL, 1, 1, NULL, 2, '2012-07-31 15:39:11'),
(3, 20, NULL, '', '2008-01-01', 'y', NULL, NULL, NULL, '', NULL, '', NULL, 1, 1, NULL, 3, '2012-07-31 15:40:35'),
(4, 22, NULL, '', NULL, '', NULL, NULL, NULL, '', NULL, '', NULL, 1, 2, NULL, 4, '2012-07-31 18:29:21'),
(5, 30, NULL, '', NULL, '', NULL, NULL, NULL, '', NULL, '', NULL, 1, 2, NULL, 5, '2012-07-31 18:47:39'),
(6, 51, NULL, NULL, '2010-05-01', 'd', NULL, NULL, NULL, '', NULL, '', NULL, 1, 4, 11, 6, '2016-08-26 19:02:30'),
(7, 51, NULL, NULL, '2014-08-20', 'c', NULL, NULL, NULL, '', NULL, '', NULL, 1, 4, 12, 7, '2016-08-26 19:08:45'),
(8, 18, NULL, '', '2009-08-02', 'c', NULL, NULL, NULL, '', NULL, '', NULL, 1, 4, 10, 8, '2016-08-26 19:10:13');

INSERT INTO `family_histories` (`id`, `relation`, `family_domain`, `primary_icd10_code`, `previous_primary_code`, `previous_primary_code_system`, `age_at_dx`, `age_at_dx_precision`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'uncle', 'paternal', 'C831', '', '', NULL, '', 3, '2012-07-31 18:54:57', 1, '2012-07-31 18:54:58', 1, 0),
(2, 'mother', 'maternal', 'D27', '', '', NULL, '', 3, '2012-07-31 18:55:28', 1, '2012-07-31 18:55:28', 1, 0),
(3, 'mother', 'paternal', 'D057', '', '', NULL, '', 2, '2012-07-31 18:56:08', 1, '2012-07-31 18:56:08', 1, 0);

INSERT INTO `family_histories_revs` (`id`, `relation`, `family_domain`, `primary_icd10_code`, `previous_primary_code`, `previous_primary_code_system`, `age_at_dx`, `age_at_dx_precision`, `participant_id`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 'uncle', 'paternal', 'C831', '', '', NULL, '', 3, 1, 1, '2012-07-31 18:54:58'),
(2, 'mother', 'maternal', 'D27', '', '', NULL, '', 3, 1, 2, '2012-07-31 18:55:28'),
(3, 'mother', 'paternal', 'D057', '', '', NULL, '', 2, 1, 3, '2012-07-31 18:56:08');

DELETE FROM key_increments;
INSERT INTO `key_increments` (`key_name`, `key_value`) VALUES
('atim_internal_file', 1),
('br', 124),
('part_ident_hospital_num', 1),
('part_ident_insurance_num', 1),
('pr', 5943);

INSERT INTO `misc_identifiers` (`id`, `identifier_value`, `misc_identifier_control_id`, `effective_date`, `effective_date_accuracy`, `expiry_date`, `expiry_date_accuracy`, `notes`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `tmp_deleted`, `flag_unique`, `study_summary_id`) VALUES
(1, 'BR123', 1, NULL, '', NULL, '', NULL, NULL, '2012-07-31 18:22:34', 1, '2012-07-31 18:22:34', 1, 1, 1, 1, NULL),
(2, 'PR5940', 2, NULL, '', NULL, '', NULL, 2, '2012-07-31 18:22:51', 1, '2012-07-31 18:22:51', 1, 0, 0, 1, NULL),
(3, 'PR5941', 2, NULL, '', NULL, '', NULL, 1, '2012-07-31 18:23:05', 1, '2012-07-31 18:23:05', 1, 0, 0, 1, NULL),
(4, 'PR5942', 2, NULL, '', NULL, '', NULL, 3, '2012-07-31 18:59:17', 1, '2012-07-31 18:59:17', 1, 0, 0, 1, NULL),
(5, '443', 3, NULL, '', NULL, '', '', 3, '2012-07-31 18:59:28', 1, '2012-07-31 18:59:28', 1, 0, 0, 1, NULL),
(6, '479092', 3, NULL, '', NULL, '', '', 2, '2012-07-31 18:59:38', 1, '2012-07-31 18:59:38', 1, 0, 0, 1, NULL),
(7, '73991', 3, NULL, '', NULL, '', '', 1, '2012-07-31 18:59:48', 1, '2012-07-31 18:59:48', 1, 0, 0, 1, NULL),
(8, 'c13658', 4, NULL, '', NULL, '', NULL, 1, '2016-08-26 17:19:39', 1, '2016-08-26 17:19:39', 1, 0, 0, NULL, 1),
(9, 'c12859', 4, NULL, '', NULL, '', NULL, 3, '2016-08-26 17:21:55', 1, '2016-08-26 17:21:55', 1, 0, 0, NULL, 1),
(10, '47789', 4, NULL, '', NULL, '', NULL, 3, '2016-08-26 17:22:08', 1, '2016-08-26 17:22:08', 1, 0, 0, NULL, 2);

INSERT INTO `misc_identifiers_revs` (`id`, `identifier_value`, `misc_identifier_control_id`, `effective_date`, `effective_date_accuracy`, `expiry_date`, `expiry_date_accuracy`, `notes`, `participant_id`, `modified_by`, `version_id`, `version_created`, `tmp_deleted`, `flag_unique`, `study_summary_id`) VALUES
(1, 'BR123', 1, NULL, '', NULL, '', NULL, 2, 1, 1, '2012-07-31 18:22:34', 0, 1, NULL),
(2, 'PR5940', 2, NULL, '', NULL, '', NULL, 2, 1, 2, '2012-07-31 18:22:51', 0, 1, NULL),
(3, 'PR5941', 2, NULL, '', NULL, '', NULL, 1, 1, 3, '2012-07-31 18:23:05', 0, 1, NULL),
(4, 'PR5942', 2, NULL, '', NULL, '', NULL, 3, 1, 4, '2012-07-31 18:59:17', 0, 1, NULL),
(5, '443', 3, NULL, '', NULL, '', '', 3, 1, 5, '2012-07-31 18:59:28', 0, 1, NULL),
(6, '479092', 3, NULL, '', NULL, '', '', 2, 1, 6, '2012-07-31 18:59:38', 0, 1, NULL),
(7, '73991', 3, NULL, '', NULL, '', '', 1, 1, 7, '2012-07-31 18:59:48', 0, 1, NULL),
(8, 'c13658', 4, NULL, '', NULL, '', NULL, 1, 1, 8, '2016-08-26 17:19:39', 0, NULL, 1),
(9, 'c12859', 4, NULL, '', NULL, '', NULL, 3, 1, 9, '2016-08-26 17:21:55', 0, NULL, 1),
(10, '47789', 4, NULL, '', NULL, '', NULL, 3, 1, 10, '2016-08-26 17:22:08', 0, NULL, 2);

INSERT INTO `orders` (`id`, `order_number`, `short_title`, `description`, `date_order_placed`, `date_order_placed_accuracy`, `date_order_completed`, `date_order_completed_accuracy`, `processing_status`, `comments`, `created`, `created_by`, `modified`, `modified_by`, `default_study_summary_id`, `institution`, `contact`, `default_required_date`, `deleted`, `default_required_date_accuracy`) VALUES
(1, 'DNA -Pr 93891', '', '', '2012-06-22', 'c', NULL, '', 'pending', '', '2012-08-01 13:56:47', 1, '2012-08-01 13:56:47', 1, 1, '', '', NULL, 0, ''),
(2, 'Ord-847', '', '', '2016-01-01', 'c', '2016-06-07', 'c', 'pending', '', '2016-08-26 19:35:50', 1, '2016-08-26 19:44:46', 1, 1, 'CCRaTy', 'Dr Champlain', NULL, 0, '');

INSERT INTO `orders_revs` (`id`, `order_number`, `short_title`, `description`, `date_order_placed`, `date_order_placed_accuracy`, `date_order_completed`, `date_order_completed_accuracy`, `processing_status`, `comments`, `modified_by`, `default_study_summary_id`, `institution`, `contact`, `default_required_date`, `version_id`, `version_created`, `default_required_date_accuracy`) VALUES
(1, 'DNA -Pr 93891', '', '', '2012-06-22', 'c', NULL, '', 'pending', '', 1, 1, '', '', NULL, 1, '2012-08-01 13:56:47', ''),
(2, 'Ord-847', '', '', '2016-01-01', 'c', '2016-06-07', 'c', 'completed', '', 1, 1, 'CCRaTy', 'Dr Champlain', NULL, 2, '2016-08-26 19:35:50', ''),
(2, 'Ord-847', '', '', '2016-01-01', 'c', '2016-06-07', 'c', 'pending', '', 1, 1, 'CCRaTy', 'Dr Champlain', NULL, 3, '2016-08-26 19:44:46', '');

INSERT INTO `order_items` (`id`, `date_added`, `date_added_accuracy`, `added_by`, `status`, `created`, `created_by`, `modified`, `modified_by`, `order_line_id`, `shipment_id`, `aliquot_master_id`, `deleted`, `order_id`, `date_returned`, `date_returned_accuracy`, `reason_returned`, `reception_by`, `tma_slide_id`) VALUES
(1, '2012-08-09', 'c', 'tech. 2', 'shipped', '2012-08-01 13:58:05', 1, '2012-08-01 13:59:43', 1, 1, 1, 101, 0, 1, NULL, '', NULL, NULL, NULL),
(2, '2012-08-09', 'c', 'tech. 2', 'shipped', '2012-08-01 13:58:06', 1, '2012-08-01 13:59:44', 1, 1, 1, 102, 0, 1, NULL, '', NULL, NULL, NULL),
(3, '2012-08-09', 'c', 'tech. 2', 'shipped & returned', '2012-08-01 13:58:07', 1, '2016-08-26 20:03:12', 1, 1, 1, 103, 0, 1, '2016-08-02', 'c', '', 'tech. 2', NULL),
(4, '2012-08-09', 'c', 'tech. 2', 'shipped', '2012-08-01 13:58:07', 1, '2012-08-01 13:59:46', 1, 1, 1, 104, 0, 1, NULL, '', NULL, NULL, NULL),
(5, '2012-08-09', 'c', 'tech. 2', 'shipped', '2012-08-01 13:58:08', 1, '2012-08-01 13:59:47', 1, 1, 1, 105, 0, 1, NULL, '', NULL, NULL, NULL),
(6, '1900-04-01', 'c', 'tech. 1', 'shipped & returned', '2016-08-26 19:45:12', 1, '2016-08-26 20:04:55', 1, NULL, 2, 120, 0, 2, '2016-06-01', 'd', 'Slides creation done', 'tech. 1', NULL),
(7, '2016-04-01', 'd', 'res. assist. 1', 'shipped', '2016-08-26 20:00:58', 1, '2016-08-26 20:02:11', 1, NULL, 2, NULL, 0, 2, NULL, '', NULL, NULL, 3),
(8, NULL, '', '', 'pending', '2016-08-26 20:04:03', 1, '2016-08-26 20:04:03', 1, NULL, NULL, 103, 0, 2, NULL, '', NULL, NULL, NULL),
(9, NULL, '', '', 'shipped', '2016-08-26 20:16:01', 1, '2016-08-26 20:16:29', 1, NULL, 2, NULL, 0, 2, NULL, '', NULL, NULL, 2);

INSERT INTO `order_items_revs` (`id`, `date_added`, `date_added_accuracy`, `added_by`, `status`, `modified_by`, `order_line_id`, `shipment_id`, `aliquot_master_id`, `version_id`, `version_created`, `order_id`, `date_returned`, `date_returned_accuracy`, `reason_returned`, `reception_by`, `tma_slide_id`) VALUES
(1, '2012-08-09', 'c', 'tech. 2', 'pending', 1, 1, NULL, 101, 1, '2012-08-01 13:58:05', 1, NULL, '', NULL, NULL, NULL),
(2, '2012-08-09', 'c', 'tech. 2', 'pending', 1, 1, NULL, 102, 2, '2012-08-01 13:58:06', 1, NULL, '', NULL, NULL, NULL),
(3, '2012-08-09', 'c', 'tech. 2', 'pending', 1, 1, NULL, 103, 3, '2012-08-01 13:58:07', 1, NULL, '', NULL, NULL, NULL),
(4, '2012-08-09', 'c', 'tech. 2', 'pending', 1, 1, NULL, 104, 4, '2012-08-01 13:58:07', 1, NULL, '', NULL, NULL, NULL),
(5, '2012-08-09', 'c', 'tech. 2', 'pending', 1, 1, NULL, 105, 5, '2012-08-01 13:58:08', 1, NULL, '', NULL, NULL, NULL),
(1, '2012-08-09', 'c', 'tech. 2', 'shipped', 1, 1, 1, 101, 6, '2012-08-01 13:59:43', 1, NULL, '', NULL, NULL, NULL),
(2, '2012-08-09', 'c', 'tech. 2', 'shipped', 1, 1, 1, 102, 7, '2012-08-01 13:59:44', 1, NULL, '', NULL, NULL, NULL),
(3, '2012-08-09', 'c', 'tech. 2', 'shipped', 1, 1, 1, 103, 8, '2012-08-01 13:59:45', 1, NULL, '', NULL, NULL, NULL),
(4, '2012-08-09', 'c', 'tech. 2', 'shipped', 1, 1, 1, 104, 9, '2012-08-01 13:59:46', 1, NULL, '', NULL, NULL, NULL),
(5, '2012-08-09', 'c', 'tech. 2', 'shipped', 1, 1, 1, 105, 10, '2012-08-01 13:59:47', 1, NULL, '', NULL, NULL, NULL),
(6, '1900-04-01', 'c', 'tech. 1', 'pending', 1, NULL, NULL, 120, 11, '2016-08-26 19:45:12', 2, NULL, '', NULL, NULL, NULL),
(7, '2016-04-01', 'd', 'res. assist. 1', 'pending', 1, NULL, NULL, NULL, 12, '2016-08-26 20:00:58', 2, NULL, '', NULL, NULL, 3),
(7, '2016-04-01', 'd', 'res. assist. 1', 'shipped', 1, NULL, 2, NULL, 13, '2016-08-26 20:02:11', 2, NULL, '', NULL, NULL, 3),
(6, '1900-04-01', 'c', 'tech. 1', 'shipped', 1, NULL, 2, 120, 14, '2016-08-26 20:02:12', 2, NULL, '', NULL, NULL, NULL),
(3, '2012-08-09', 'c', 'tech. 2', 'shipped & returned', 1, 1, 1, 103, 15, '2016-08-26 20:03:12', 1, '2016-08-02', 'c', '', 'tech. 2', NULL),
(8, NULL, '', '', 'pending', 1, NULL, NULL, 103, 16, '2016-08-26 20:04:03', 2, NULL, '', NULL, NULL, NULL),
(6, '1900-04-01', 'c', 'tech. 1', 'shipped & returned', 1, NULL, 2, 120, 17, '2016-08-26 20:04:55', 2, '2016-06-01', 'd', 'Slides creation done', 'tech. 1', NULL),
(9, NULL, '', '', 'pending', 1, NULL, NULL, NULL, 18, '2016-08-26 20:16:01', 2, NULL, '', NULL, NULL, 2),
(9, NULL, '', '', 'shipped', 1, NULL, 2, NULL, 19, '2016-08-26 20:16:29', 2, NULL, '', NULL, NULL, 2);

INSERT INTO `order_lines` (`id`, `quantity_ordered`, `min_quantity_ordered`, `quantity_unit`, `date_required`, `date_required_accuracy`, `status`, `created`, `created_by`, `modified`, `modified_by`, `sample_control_id`, `aliquot_control_id`, `product_type_precision`, `order_id`, `study_summary_id`, `deleted`, `is_tma_slide`) VALUES
(1, '4', '', 'tb', NULL, '', 'shipped', '2012-08-01 13:57:12', 1, '2012-08-01 13:59:48', 1, 12, 29, '', 1, 1, 0, 0),
(2, '22', '', 'ml', NULL, '', 'pending', '2012-08-01 13:57:29', 1, '2012-08-01 13:57:29', 1, 9, 16, '', 1, 1, 0, 0);

INSERT INTO `order_lines_revs` (`id`, `quantity_ordered`, `min_quantity_ordered`, `quantity_unit`, `date_required`, `date_required_accuracy`, `status`, `modified_by`, `sample_control_id`, `aliquot_control_id`, `product_type_precision`, `order_id`, `study_summary_id`, `version_id`, `version_created`, `is_tma_slide`) VALUES
(1, '4', '', 'tb', NULL, '', 'pending', 1, 12, 29, '', 1, 1, 1, '2012-08-01 13:57:12', 0),
(2, '22', '', 'ml', NULL, '', 'pending', 1, 9, 16, '', 1, 1, 2, '2012-08-01 13:57:29', 0),
(1, '4', '', 'tb', NULL, '', 'pending', 1, 12, 29, '', 1, 1, 3, '2012-08-01 13:58:09', 0),
(1, '4', '', 'tb', NULL, '', 'shipped', 1, 12, 29, '', 1, 1, 4, '2012-08-01 13:59:48', 0);

INSERT INTO `participants` (`id`, `title`, `first_name`, `middle_name`, `last_name`, `date_of_birth`, `date_of_birth_accuracy`, `marital_status`, `language_preferred`, `sex`, `race`, `vital_status`, `notes`, `date_of_death`, `date_of_death_accuracy`, `cod_icd10_code`, `secondary_cod_icd10_code`, `cod_confirmation_source`, `participant_identifier`, `last_chart_checked_date`, `last_chart_checked_date_accuracy`, `last_modification`, `last_modification_ds_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2016-08-26 18:39:03', 4, '2012-07-31 15:16:42', 1, '2016-08-26 18:39:03', 1, 0),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:59:38', 4, '2012-07-31 18:13:42', 1, '2012-07-31 18:59:38', 1, 0),
(3, 'Mr.', 'J.', '', 'Doe', '1970-07-01', 'c', 'common law', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0003', NULL, '', '2016-08-26 17:23:13', 4, '2012-07-31 18:53:52', 1, '2016-08-26 17:23:13', 1, 0),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 19:14:50', 4, '2016-08-26 18:41:11', 1, '2016-08-26 19:14:50', 1, 0);

INSERT INTO `participants_revs` (`id`, `title`, `first_name`, `middle_name`, `last_name`, `date_of_birth`, `date_of_birth_accuracy`, `marital_status`, `language_preferred`, `sex`, `race`, `vital_status`, `notes`, `date_of_death`, `date_of_death_accuracy`, `cod_icd10_code`, `secondary_cod_icd10_code`, `cod_confirmation_source`, `participant_identifier`, `last_chart_checked_date`, `last_chart_checked_date_accuracy`, `last_modification`, `last_modification_ds_id`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'y', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:16:42', 4, 1, 1, '2012-07-31 15:16:42'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:18:23', 4, 1, 2, '2012-07-31 15:18:23'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:19:57', 4, 1, 3, '2012-07-31 15:19:57'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:20:24', 4, 1, 4, '2012-07-31 15:20:25'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:22:13', 4, 1, 5, '2012-07-31 15:22:13'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:29:25', 4, 1, 6, '2012-07-31 15:29:26'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:29:26', 4, 1, 7, '2012-07-31 15:29:26'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:33:14', 4, 1, 8, '2012-07-31 15:33:14'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:34:08', 4, 1, 9, '2012-07-31 15:34:08'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:34:33', 4, 1, 10, '2012-07-31 15:34:33'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:35:53', 4, 1, 11, '2012-07-31 15:35:53'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:36:25', 4, 1, 12, '2012-07-31 15:36:25'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:36:31', 4, 1, 13, '2012-07-31 15:36:31'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:36:31', 4, 1, 14, '2012-07-31 15:36:31'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:37:53', 4, 1, 15, '2012-07-31 15:37:53'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:39:11', 4, 1, 16, '2012-07-31 15:39:11'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:40:36', 4, 1, 17, '2012-07-31 15:40:36'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:41:17', 4, 1, 18, '2012-07-31 15:41:17'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:42:36', 4, 1, 19, '2012-07-31 15:42:36'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:43:21', 4, 1, 20, '2012-07-31 15:43:21'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 15:44:13', 4, 1, 21, '2012-07-31 15:44:13'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:13:42', 4, 1, 22, '2012-07-31 18:13:42'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:22:34', 4, 1, 23, '2012-07-31 18:22:34'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:22:46', 4, 1, 24, '2012-07-31 18:22:46'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:22:51', 4, 1, 25, '2012-07-31 18:22:51'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 18:23:05', 4, 1, 26, '2012-07-31 18:23:05'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:25:22', 4, 1, 27, '2012-07-31 18:25:23'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:29:22', 4, 1, 28, '2012-07-31 18:29:22'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:47:40', 4, 1, 29, '2012-07-31 18:47:40'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:48:59', 4, 1, 30, '2012-07-31 18:48:59'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:50:03', 4, 1, 31, '2012-07-31 18:50:03'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:50:36', 4, 1, 32, '2012-07-31 18:50:36'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:51:27', 4, 1, 33, '2012-07-31 18:51:27'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:52:15', 4, 1, 34, '2012-07-31 18:52:15'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:52:21', 4, 1, 35, '2012-07-31 18:52:21'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:52:21', 4, 1, 36, '2012-07-31 18:52:21'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:53:17', 4, 1, 37, '2012-07-31 18:53:17'),
(3, '', '', '', '', '1970-07-01', 'd', 'common law', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0003', NULL, '', '2012-07-31 18:53:52', 4, 1, 38, '2012-07-31 18:53:52'),
(3, '', '', '', '', '1970-07-01', 'c', 'common law', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0003', NULL, '', '2012-07-31 18:54:27', 4, 1, 39, '2012-07-31 18:54:27'),
(3, '', '', '', '', '1970-07-01', 'c', 'common law', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0003', NULL, '', '2012-07-31 18:54:58', 4, 1, 40, '2012-07-31 18:54:58'),
(3, '', '', '', '', '1970-07-01', 'c', 'common law', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0003', NULL, '', '2012-07-31 18:55:28', 4, 1, 41, '2012-07-31 18:55:28'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:56:09', 4, 1, 42, '2012-07-31 18:56:09'),
(3, '', '', '', '', '1970-07-01', 'c', 'common law', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0003', NULL, '', '2012-07-31 18:59:17', 4, 1, 43, '2012-07-31 18:59:18'),
(3, '', '', '', '', '1970-07-01', 'c', 'common law', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0003', NULL, '', '2012-07-31 18:59:28', 4, 1, 44, '2012-07-31 18:59:28'),
(2, 'Mr.', 'Robert', '', 'Azerty', '1942-01-01', 'c', '', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0002', NULL, '', '2012-07-31 18:59:38', 4, 1, 45, '2012-07-31 18:59:38'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2012-07-31 18:59:48', 4, 1, 46, '2012-07-31 18:59:48'),
(3, 'Mr.', 'J.', '', 'Doe', '1970-07-01', 'c', 'common law', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0003', NULL, '', '2012-08-01 13:18:25', 4, 1, 47, '2012-08-01 13:18:25'),
(3, 'Mr.', 'J.', '', 'Doe', '1970-07-01', 'c', 'common law', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0003', NULL, '', '2012-08-01 13:20:04', 4, 1, 48, '2012-08-01 13:20:04'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2016-08-26 17:19:39', 4, 1, 49, '2016-08-26 17:19:39'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2016-08-26 17:20:36', 4, 1, 50, '2016-08-26 17:20:36'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2016-08-26 17:21:18', 4, 1, 51, '2016-08-26 17:21:19'),
(3, 'Mr.', 'J.', '', 'Doe', '1970-07-01', 'c', 'common law', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0003', NULL, '', '2016-08-26 17:21:55', 4, 1, 52, '2016-08-26 17:21:56'),
(3, 'Mr.', 'J.', '', 'Doe', '1970-07-01', 'c', 'common law', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0003', NULL, '', '2016-08-26 17:22:08', 4, 1, 53, '2016-08-26 17:22:08'),
(3, 'Mr.', 'J.', '', 'Doe', '1970-07-01', 'c', 'common law', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0003', NULL, '', '2016-08-26 17:22:41', 4, 1, 54, '2016-08-26 17:22:42'),
(3, 'Mr.', 'J.', '', 'Doe', '1970-07-01', 'c', 'common law', '', 'm', '', 'alive', '', NULL, '', NULL, NULL, '', 'P0003', NULL, '', '2016-08-26 17:23:13', 4, 1, 55, '2016-08-26 17:23:13'),
(1, 'Mr.', 'John', '', 'Qwerty', '1938-02-24', 'c', 'married', '', 'm', '', 'deceased', '', '2008-01-01', 'c', NULL, NULL, '', 'P0001', '2012-07-24', 'c', '2016-08-26 18:39:03', 4, 1, 56, '2016-08-26 18:39:03'),
(4, '', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 18:41:11', 4, 1, 57, '2016-08-26 18:41:11'),
(4, '', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 18:43:55', 4, 1, 58, '2016-08-26 18:43:55'),
(4, '', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 18:44:58', 4, 1, 59, '2016-08-26 18:44:58'),
(4, '', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 18:45:02', 4, 1, 60, '2016-08-26 18:45:03'),
(4, '', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 18:45:03', 4, 1, 61, '2016-08-26 18:45:03'),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 18:58:57', 4, 1, 62, '2016-08-26 18:58:57'),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 18:59:36', 4, 1, 63, '2016-08-26 18:59:36'),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 18:59:48', 4, 1, 64, '2016-08-26 18:59:48'),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 19:00:03', 4, 1, 65, '2016-08-26 19:00:03'),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 19:00:03', 4, 1, 66, '2016-08-26 19:00:03'),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 19:01:03', 4, 1, 67, '2016-08-26 19:01:03'),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 19:02:31', 4, 1, 68, '2016-08-26 19:02:31'),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 19:05:07', 4, 1, 69, '2016-08-26 19:05:07'),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 19:06:17', 4, 1, 70, '2016-08-26 19:06:17'),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 19:07:06', 4, 1, 71, '2016-08-26 19:07:06'),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 19:08:46', 4, 1, 72, '2016-08-26 19:08:46'),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 19:10:14', 4, 1, 73, '2016-08-26 19:10:14'),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 19:11:24', 4, 1, 74, '2016-08-26 19:11:24'),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 19:11:51', 4, 1, 75, '2016-08-26 19:11:51'),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 19:12:39', 4, 1, 76, '2016-08-26 19:12:39'),
(4, 'Miss', 'Jeanne', '', 'Doe', '1948-10-27', 'c', 'married', '', 'f', '', 'deceased', '', '2016-03-01', 'c', 'V041', NULL, 'Sister', 'P0145', '2016-03-01', 'c', '2016-08-26 19:14:50', 4, 1, 77, '2016-08-26 19:14:50');

INSERT INTO `pd_chemos` (`protocol_master_id`) VALUES
(1),
(2);

INSERT INTO `pd_chemos_revs` (`protocol_master_id`, `version_id`, `version_created`) VALUES
(1, 1, '2012-07-31 15:28:36'),
(2, 2, '2016-08-26 18:56:03');

INSERT INTO `pe_chemos` (`method`, `dose`, `frequency`, `protocol_extend_master_id`) VALUES
('IV: Intravenous', '', '', 1),
('IV: Intravenous', '', '', 2),
('IV: Intravenous', '60mg/m2', '', 3),
('IV: Intravenous', '600 mg/m²', '', 4),
('SC: subcutaneous injection', '', '', 5);

INSERT INTO `pe_chemos_revs` (`method`, `dose`, `frequency`, `version_id`, `version_created`, `protocol_extend_master_id`) VALUES
('IV: Intravenous', '', '', 1, '2012-07-31 15:28:52', 1),
('IV: Intravenous', '', '', 2, '2012-07-31 15:29:00', 2),
('IV: Intravenous', '60mg/m2', '', 3, '2016-08-26 18:56:41', 3),
('IV: Intravenous', '600 mg/m²', '', 4, '2016-08-26 18:57:48', 4),
('SC: subcutaneous injection', '', '', 5, '2016-08-26 18:58:10', 5);

INSERT INTO `protocol_extend_masters` (`id`, `protocol_extend_control_id`, `protocol_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `drug_id`) VALUES
(1, 1, 1, '2012-07-31 15:28:51', 1, '2012-07-31 15:28:51', 1, 0, 1),
(2, 1, 1, '2012-07-31 15:29:00', 1, '2012-07-31 15:29:00', 1, 0, 5),
(3, 1, 2, '2016-08-26 18:56:41', 1, '2016-08-26 18:56:41', 1, 0, 6),
(4, 1, 2, '2016-08-26 18:57:48', 1, '2016-08-26 18:57:48', 1, 0, 2),
(5, 1, 2, '2016-08-26 18:58:10', 1, '2016-08-26 18:58:10', 1, 0, 7);

INSERT INTO `protocol_extend_masters_revs` (`id`, `protocol_extend_control_id`, `protocol_master_id`, `modified_by`, `version_id`, `version_created`, `drug_id`) VALUES
(1, 1, 1, 1, 1, '2012-07-31 15:28:52', 1),
(2, 1, 1, 1, 2, '2012-07-31 15:29:00', 5),
(3, 1, 2, 1, 3, '2016-08-26 18:56:41', 6),
(4, 1, 2, 1, 4, '2016-08-26 18:57:48', 2),
(5, 1, 2, 1, 5, '2016-08-26 18:58:10', 7);

INSERT INTO `protocol_masters` (`id`, `protocol_control_id`, `name`, `notes`, `code`, `arm`, `status`, `expiry`, `expiry_accuracy`, `activated`, `activated_accuracy`, `created`, `created_by`, `modified`, `modified_by`, `form_id`, `deleted`) VALUES
(1, 1, '', '', 'P-009X-39', '', NULL, NULL, '', NULL, '', '2012-07-31 15:28:36', 1, '2012-07-31 15:28:36', 1, NULL, 0),
(2, 1, '', '', 'Chbc20-2016', '', NULL, NULL, '', NULL, '', '2016-08-26 18:56:03', 1, '2016-08-26 18:56:03', 1, NULL, 0);

INSERT INTO `protocol_masters_revs` (`id`, `protocol_control_id`, `name`, `notes`, `code`, `arm`, `status`, `expiry`, `expiry_accuracy`, `activated`, `activated_accuracy`, `modified_by`, `form_id`, `version_id`, `version_created`) VALUES
(1, 1, '', '', 'P-009X-39', '', NULL, NULL, '', NULL, '', 1, NULL, 1, '2012-07-31 15:28:36'),
(2, 1, '', '', 'Chbc20-2016', '', NULL, NULL, '', NULL, '', 1, NULL, 2, '2016-08-26 18:56:03');

INSERT INTO `quality_ctrls` (`id`, `qc_code`, `sample_master_id`, `type`, `qc_type_precision`, `tool`, `run_id`, `run_by`, `date`, `date_accuracy`, `score`, `unit`, `conclusion`, `notes`, `aliquot_master_id`, `used_volume`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'QC - 1', 11, 'bioanalyzer', '', 'BioAnalyzer 007', 'QC1993892', 'res. assist. 1', '2012-08-01', 'c', '7', 'RIN', 'good', '', 80, '0.30000', '2012-08-01 13:53:59', 1, '2012-08-01 13:53:59', 1, 0),
(2, 'QC - 2', 13, 'bioanalyzer', '', 'BioAnalyzer 007', 'QC1993892', 'res. assist. 1', '2012-08-01', 'c', '8', 'RIN', 'good', '', 87, '0.30000', '2012-08-01 13:53:59', 1, '2012-08-01 13:53:59', 1, 0),
(3, 'QC - 3', 15, 'bioanalyzer', '', 'BioAnalyzer 007', 'QC1993892', 'res. assist. 1', '2012-08-01', 'c', '7', 'RIN', 'good', '', 91, '0.30000', '2012-08-01 13:53:59', 1, '2012-08-01 13:53:59', 1, 0),
(4, 'QC - 4', 12, 'bioanalyzer', '', 'BioAnalyzer 007', 'QC1993892', 'res. assist. 1', '2012-08-01', 'c', '10', 'RIN', 'very good', '', 96, '0.30000', '2012-08-01 13:53:59', 1, '2012-08-01 13:53:59', 1, 0),
(5, 'QC - 5', 14, 'bioanalyzer', '', 'BioAnalyzer 007', 'QC1993892', 'res. assist. 1', '2012-08-01', 'c', '8', 'RIN', 'good', '', 99, '0.30000', '2012-08-01 13:53:59', 1, '2012-08-01 13:53:59', 1, 0);

INSERT INTO `quality_ctrls_revs` (`id`, `qc_code`, `sample_master_id`, `type`, `qc_type_precision`, `tool`, `run_id`, `run_by`, `date`, `date_accuracy`, `score`, `unit`, `conclusion`, `notes`, `aliquot_master_id`, `used_volume`, `modified_by`, `version_id`, `version_created`) VALUES
(1, NULL, 11, 'bioanalyzer', '', 'BioAnalyzer 007', 'QC1993892', 'res. assist. 1', '2012-08-01', 'c', '7', 'RIN', 'good', '', 80, '0.30000', 1, 1, '2012-08-01 13:53:59'),
(2, NULL, 13, 'bioanalyzer', '', 'BioAnalyzer 007', 'QC1993892', 'res. assist. 1', '2012-08-01', 'c', '8', 'RIN', 'good', '', 87, '0.30000', 1, 2, '2012-08-01 13:53:59'),
(3, NULL, 15, 'bioanalyzer', '', 'BioAnalyzer 007', 'QC1993892', 'res. assist. 1', '2012-08-01', 'c', '7', 'RIN', 'good', '', 91, '0.30000', 1, 3, '2012-08-01 13:53:59'),
(4, NULL, 12, 'bioanalyzer', '', 'BioAnalyzer 007', 'QC1993892', 'res. assist. 1', '2012-08-01', 'c', '10', 'RIN', 'very good', '', 96, '0.30000', 1, 4, '2012-08-01 13:53:59'),
(5, NULL, 14, 'bioanalyzer', '', 'BioAnalyzer 007', 'QC1993892', 'res. assist. 1', '2012-08-01', 'c', '8', 'RIN', 'good', '', 99, '0.30000', 1, 5, '2012-08-01 13:53:59');

INSERT INTO `realiquotings` (`id`, `parent_aliquot_master_id`, `child_aliquot_master_id`, `parent_used_volume`, `realiquoting_datetime`, `realiquoting_datetime_accuracy`, `realiquoted_by`, `lab_book_master_id`, `sync_with_lab_book`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, 50, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:10', 1, '2012-08-01 13:32:10', 1, 0),
(2, 1, 51, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:11', 1, '2012-08-01 13:32:11', 1, 0),
(3, 10, 52, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:12', 1, '2012-08-01 13:32:12', 1, 0),
(4, 10, 53, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:13', 1, '2012-08-01 13:32:13', 1, 0),
(5, 11, 54, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:14', 1, '2012-08-01 13:32:14', 1, 0),
(6, 11, 55, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:15', 1, '2012-08-01 13:32:15', 1, 0),
(7, 12, 56, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:16', 1, '2012-08-01 13:32:16', 1, 0),
(8, 12, 57, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:18', 1, '2012-08-01 13:32:18', 1, 0),
(9, 13, 58, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:19', 1, '2012-08-01 13:32:19', 1, 0),
(10, 13, 59, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:20', 1, '2012-08-01 13:32:20', 1, 0),
(11, 14, 60, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:22', 1, '2012-08-01 13:32:22', 1, 0),
(12, 14, 61, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:22', 1, '2012-08-01 13:32:22', 1, 0),
(13, 2, 62, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:24', 1, '2012-08-01 13:32:24', 1, 0),
(14, 2, 63, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:25', 1, '2012-08-01 13:32:25', 1, 0),
(15, 3, 64, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:26', 1, '2012-08-01 13:32:26', 1, 0),
(16, 3, 65, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:27', 1, '2012-08-01 13:32:27', 1, 0),
(17, 4, 66, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:28', 1, '2012-08-01 13:32:28', 1, 0),
(18, 4, 67, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:29', 1, '2012-08-01 13:32:29', 1, 0),
(19, 40, 68, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:30', 1, '2012-08-01 13:32:30', 1, 0),
(20, 40, 69, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:31', 1, '2012-08-01 13:32:31', 1, 0),
(21, 41, 70, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:32', 1, '2012-08-01 13:32:32', 1, 0),
(22, 41, 71, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:33', 1, '2012-08-01 13:32:33', 1, 0),
(23, 5, 72, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:34', 1, '2012-08-01 13:32:34', 1, 0),
(24, 6, 73, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:36', 1, '2012-08-01 13:32:36', 1, 0),
(25, 7, 74, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:37', 1, '2012-08-01 13:32:37', 1, 0),
(26, 8, 75, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:38', 1, '2012-08-01 13:32:38', 1, 0),
(27, 9, 76, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, '2012-08-01 13:32:40', 1, '2012-08-01 13:32:40', 1, 0),
(28, 41, 77, NULL, '2012-08-01 13:42:00', 'c', '', NULL, NULL, '2012-08-01 13:43:35', 1, '2012-08-01 13:43:35', 1, 0),
(29, 14, 78, NULL, '2012-08-01 13:42:00', 'c', '', NULL, NULL, '2012-08-01 13:43:36', 1, '2012-08-01 13:43:36', 1, 0),
(30, 10, 79, NULL, '2012-08-01 13:42:00', 'c', '', NULL, NULL, '2012-08-01 13:43:37', 1, '2012-08-01 13:43:37', 1, 0),
(31, 80, 101, '1.00000', '2012-08-03 07:00:00', 'c', 'tech. 1', NULL, NULL, '2012-08-01 13:55:58', 1, '2012-08-01 13:55:58', 1, 0),
(32, 87, 102, '1.00000', '2012-08-03 07:00:00', 'c', 'tech. 1', NULL, NULL, '2012-08-01 13:56:00', 1, '2012-08-01 13:56:00', 1, 0),
(33, 91, 103, '1.00000', '2012-08-03 07:00:00', 'c', 'tech. 1', NULL, NULL, '2012-08-01 13:56:01', 1, '2012-08-01 13:56:01', 1, 0),
(34, 96, 104, '1.00000', '2012-08-03 07:00:00', 'c', 'tech. 1', NULL, NULL, '2012-08-01 13:56:02', 1, '2012-08-01 13:56:02', 1, 0),
(35, 99, 105, '1.00000', '2012-08-03 07:00:00', 'c', 'tech. 1', NULL, NULL, '2012-08-01 13:56:04', 1, '2012-08-01 13:56:04', 1, 0),
(36, 96, 106, NULL, '2016-08-26 16:03:00', 'c', '', NULL, NULL, '2016-08-26 16:07:17', 1, '2016-08-26 16:07:17', 1, 0),
(37, 97, 107, NULL, '2016-08-26 16:03:00', 'c', '', NULL, NULL, '2016-08-26 16:07:19', 1, '2016-08-26 16:07:19', 1, 0),
(38, 98, 108, NULL, '2016-08-26 16:03:00', 'c', '', NULL, NULL, '2016-08-26 16:07:20', 1, '2016-08-26 16:07:20', 1, 0),
(39, 18, 119, NULL, '2016-08-08 08:38:00', 'c', 'tech. 1', NULL, NULL, '2016-08-26 19:40:08', 1, '2016-08-26 19:40:08', 1, 0),
(40, 42, 120, NULL, '2016-08-08 08:38:00', 'c', 'tech. 1', NULL, NULL, '2016-08-26 19:40:09', 1, '2016-08-26 19:40:09', 1, 0),
(41, 43, 121, NULL, '2016-08-08 08:38:00', 'c', 'tech. 1', NULL, NULL, '2016-08-26 19:40:10', 1, '2016-08-26 19:40:10', 1, 0),
(42, 110, 122, NULL, '2016-08-08 08:38:00', 'c', 'tech. 1', NULL, NULL, '2016-08-26 19:40:11', 1, '2016-08-26 19:40:11', 1, 0),
(43, 111, 123, NULL, '2016-08-08 08:38:00', 'c', 'tech. 1', NULL, NULL, '2016-08-26 19:40:12', 1, '2016-08-26 19:40:12', 1, 0),
(44, 112, 124, NULL, '2016-08-08 08:38:00', 'c', 'tech. 1', NULL, NULL, '2016-08-26 19:40:13', 1, '2016-08-26 19:40:13', 1, 0),
(45, 119, 125, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, '2016-08-26 19:50:46', 1, '2016-08-26 19:50:46', 1, 0),
(46, 119, 126, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, '2016-08-26 19:50:46', 1, '2016-08-26 19:50:46', 1, 0),
(47, 119, 127, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, '2016-08-26 19:50:46', 1, '2016-08-26 19:50:46', 1, 0),
(48, 120, 128, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, '2016-08-26 19:50:47', 1, '2016-08-26 19:50:47', 1, 0),
(49, 120, 129, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, '2016-08-26 19:50:48', 1, '2016-08-26 19:50:48', 1, 0),
(50, 120, 130, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, '2016-08-26 19:50:48', 1, '2016-08-26 19:50:48', 1, 0),
(51, 120, 131, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, '2016-08-26 19:50:48', 1, '2016-08-26 19:50:48', 1, 0),
(52, 121, 132, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, '2016-08-26 19:50:49', 1, '2016-08-26 19:50:49', 1, 0),
(53, 122, 133, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, '2016-08-26 19:50:50', 1, '2016-08-26 19:50:50', 1, 0),
(54, 123, 134, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, '2016-08-26 19:50:51', 1, '2016-08-26 19:50:51', 1, 0),
(55, 123, 135, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, '2016-08-26 19:50:51', 1, '2016-08-26 19:50:51', 1, 0),
(56, 123, 136, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, '2016-08-26 19:50:52', 1, '2016-08-26 19:50:52', 1, 0),
(57, 123, 137, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, '2016-08-26 19:50:52', 1, '2016-08-26 19:50:52', 1, 0),
(58, 124, 138, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, '2016-08-26 19:50:53', 1, '2016-08-26 19:50:53', 1, 0),
(59, 124, 139, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, '2016-08-26 19:50:53', 1, '2016-08-26 19:50:53', 1, 0),
(60, 124, 140, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, '2016-08-26 19:50:54', 1, '2016-08-26 19:50:54', 1, 0);

INSERT INTO `realiquotings_revs` (`id`, `parent_aliquot_master_id`, `child_aliquot_master_id`, `parent_used_volume`, `realiquoting_datetime`, `realiquoting_datetime_accuracy`, `realiquoted_by`, `lab_book_master_id`, `sync_with_lab_book`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 1, 50, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 1, '2012-08-01 13:32:10'),
(2, 1, 51, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 2, '2012-08-01 13:32:11'),
(3, 10, 52, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 3, '2012-08-01 13:32:12'),
(4, 10, 53, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 4, '2012-08-01 13:32:13'),
(5, 11, 54, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 5, '2012-08-01 13:32:14'),
(6, 11, 55, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 6, '2012-08-01 13:32:15'),
(7, 12, 56, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 7, '2012-08-01 13:32:17'),
(8, 12, 57, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 8, '2012-08-01 13:32:18'),
(9, 13, 58, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 9, '2012-08-01 13:32:20'),
(10, 13, 59, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 10, '2012-08-01 13:32:20'),
(11, 14, 60, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 11, '2012-08-01 13:32:22'),
(12, 14, 61, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 12, '2012-08-01 13:32:22'),
(13, 2, 62, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 13, '2012-08-01 13:32:24'),
(14, 2, 63, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 14, '2012-08-01 13:32:25'),
(15, 3, 64, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 15, '2012-08-01 13:32:26'),
(16, 3, 65, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 16, '2012-08-01 13:32:27'),
(17, 4, 66, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 17, '2012-08-01 13:32:28'),
(18, 4, 67, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 18, '2012-08-01 13:32:29'),
(19, 40, 68, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 19, '2012-08-01 13:32:31'),
(20, 40, 69, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 20, '2012-08-01 13:32:31'),
(21, 41, 70, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 21, '2012-08-01 13:32:32'),
(22, 41, 71, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 22, '2012-08-01 13:32:33'),
(23, 5, 72, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 23, '2012-08-01 13:32:34'),
(24, 6, 73, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 24, '2012-08-01 13:32:36'),
(25, 7, 74, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 25, '2012-08-01 13:32:37'),
(26, 8, 75, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 26, '2012-08-01 13:32:38'),
(27, 9, 76, NULL, '2012-03-01 00:00:00', 'h', 'tech. 1', NULL, NULL, 1, 27, '2012-08-01 13:32:40'),
(28, 41, 77, NULL, '2012-08-01 13:42:00', 'c', '', NULL, NULL, 1, 28, '2012-08-01 13:43:35'),
(29, 14, 78, NULL, '2012-08-01 13:42:00', 'c', '', NULL, NULL, 1, 29, '2012-08-01 13:43:36'),
(30, 10, 79, NULL, '2012-08-01 13:42:00', 'c', '', NULL, NULL, 1, 30, '2012-08-01 13:43:37'),
(31, 80, 101, '1.00000', '2012-08-03 07:00:00', 'c', 'tech. 1', NULL, NULL, 1, 31, '2012-08-01 13:55:58'),
(32, 87, 102, '1.00000', '2012-08-03 07:00:00', 'c', 'tech. 1', NULL, NULL, 1, 32, '2012-08-01 13:56:00'),
(33, 91, 103, '1.00000', '2012-08-03 07:00:00', 'c', 'tech. 1', NULL, NULL, 1, 33, '2012-08-01 13:56:01'),
(34, 96, 104, '1.00000', '2012-08-03 07:00:00', 'c', 'tech. 1', NULL, NULL, 1, 34, '2012-08-01 13:56:03'),
(35, 99, 105, '1.00000', '2012-08-03 07:00:00', 'c', 'tech. 1', NULL, NULL, 1, 35, '2012-08-01 13:56:04'),
(36, 96, 106, NULL, '2016-08-26 16:03:00', 'c', '', NULL, NULL, 1, 36, '2016-08-26 16:07:18'),
(37, 97, 107, NULL, '2016-08-26 16:03:00', 'c', '', NULL, NULL, 1, 37, '2016-08-26 16:07:19'),
(38, 98, 108, NULL, '2016-08-26 16:03:00', 'c', '', NULL, NULL, 1, 38, '2016-08-26 16:07:21'),
(39, 18, 119, NULL, '2016-08-08 08:38:00', 'c', 'tech. 1', NULL, NULL, 1, 39, '2016-08-26 19:40:08'),
(40, 42, 120, NULL, '2016-08-08 08:38:00', 'c', 'tech. 1', NULL, NULL, 1, 40, '2016-08-26 19:40:09'),
(41, 43, 121, NULL, '2016-08-08 08:38:00', 'c', 'tech. 1', NULL, NULL, 1, 41, '2016-08-26 19:40:10'),
(42, 110, 122, NULL, '2016-08-08 08:38:00', 'c', 'tech. 1', NULL, NULL, 1, 42, '2016-08-26 19:40:11'),
(43, 111, 123, NULL, '2016-08-08 08:38:00', 'c', 'tech. 1', NULL, NULL, 1, 43, '2016-08-26 19:40:12'),
(44, 112, 124, NULL, '2016-08-08 08:38:00', 'c', 'tech. 1', NULL, NULL, 1, 44, '2016-08-26 19:40:13'),
(45, 119, 125, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, 1, 45, '2016-08-26 19:50:46'),
(46, 119, 126, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, 1, 46, '2016-08-26 19:50:46'),
(47, 119, 127, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, 1, 47, '2016-08-26 19:50:47'),
(48, 120, 128, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, 1, 48, '2016-08-26 19:50:47'),
(49, 120, 129, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, 1, 49, '2016-08-26 19:50:48'),
(50, 120, 130, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, 1, 50, '2016-08-26 19:50:48'),
(51, 120, 131, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, 1, 51, '2016-08-26 19:50:48'),
(52, 121, 132, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, 1, 52, '2016-08-26 19:50:49'),
(53, 122, 133, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, 1, 53, '2016-08-26 19:50:50'),
(54, 123, 134, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, 1, 54, '2016-08-26 19:50:51'),
(55, 123, 135, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, 1, 55, '2016-08-26 19:50:51'),
(56, 123, 136, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, 1, 56, '2016-08-26 19:50:52'),
(57, 123, 137, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, 1, 57, '2016-08-26 19:50:52'),
(58, 124, 138, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, 1, 58, '2016-08-26 19:50:53'),
(59, 124, 139, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, 1, 59, '2016-08-26 19:50:53'),
(60, 124, 140, NULL, '2016-04-01 00:00:00', 'd', 'res. assist. 1', NULL, NULL, 1, 60, '2016-08-26 19:50:54');

INSERT INTO `sample_masters` (`id`, `sample_code`, `sample_control_id`, `initial_specimen_sample_id`, `initial_specimen_sample_type`, `collection_id`, `parent_id`, `parent_sample_type`, `sop_master_id`, `product_code`, `is_problematic`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, '1', 3, 1, 'tissue', 2, NULL, NULL, NULL, NULL, '', '', '2012-07-31 19:31:17', 1, '2012-07-31 19:31:17', 1, 0),
(2, '2', 3, 2, 'tissue', 3, NULL, NULL, NULL, NULL, '', '', '2012-07-31 19:41:26', 1, '2012-07-31 19:41:26', 1, 0),
(3, '3', 2, 3, 'blood', 3, NULL, NULL, NULL, NULL, '', '', '2012-07-31 19:45:40', 1, '2012-07-31 19:45:40', 1, 0),
(4, '4', 7, 3, 'blood', 3, 3, 'blood', NULL, NULL, '', '', '2012-07-31 19:48:32', 1, '2012-07-31 19:48:32', 1, 0),
(5, '5', 12, 3, 'blood', 3, 4, 'blood cell', NULL, NULL, '', '', '2012-07-31 19:49:02', 1, '2012-07-31 19:49:02', 1, 0),
(6, '6', 9, 3, 'blood', 3, 3, 'blood', NULL, NULL, '', '', '2012-07-31 19:51:42', 1, '2012-07-31 19:51:42', 1, 0),
(7, '7', 3, 7, 'tissue', 4, NULL, NULL, NULL, NULL, '', '', '2012-07-31 20:46:10', 1, '2012-07-31 20:46:10', 1, 0),
(8, '8', 2, 8, 'blood', 5, NULL, NULL, NULL, NULL, '', '', '2012-07-31 20:49:39', 1, '2012-07-31 20:49:39', 1, 0),
(9, '9', 3, 9, 'tissue', 5, NULL, NULL, NULL, NULL, '', '', '2012-07-31 20:53:21', 1, '2012-07-31 20:53:21', 1, 0),
(10, '10', 2, 10, 'blood', 1, NULL, NULL, NULL, NULL, '', '', '2012-08-01 13:10:14', 1, '2012-08-01 13:10:28', 1, 0),
(11, '11', 12, 1, 'tissue', 2, 1, 'tissue', NULL, NULL, '', '', '2012-08-01 13:45:32', 1, '2012-08-01 13:45:32', 1, 0),
(12, '12', 12, 2, 'tissue', 3, 2, 'tissue', NULL, NULL, '', '', '2012-08-01 13:45:34', 1, '2012-08-01 13:45:34', 1, 0),
(13, '13', 12, 1, 'tissue', 2, 1, 'tissue', NULL, NULL, '', '', '2012-08-01 13:45:35', 1, '2012-08-01 13:45:35', 1, 0),
(14, '14', 12, 7, 'tissue', 4, 7, 'tissue', NULL, NULL, '', '', '2012-08-01 13:45:36', 1, '2012-08-01 13:45:36', 1, 0),
(15, '15', 12, 1, 'tissue', 2, 1, 'tissue', NULL, NULL, '', '', '2012-08-01 13:45:36', 1, '2012-08-01 13:45:36', 1, 0),
(16, '16', 3, 16, 'tissue', 6, NULL, NULL, NULL, NULL, '', '', '2016-08-26 19:18:42', 1, '2016-08-26 19:18:42', 1, 0),
(17, '17', 3, 17, 'tissue', 6, NULL, NULL, NULL, NULL, '', '', '2016-08-26 19:19:36', 1, '2016-08-26 19:19:36', 1, 0),
(18, '18', 2, 18, 'blood', 6, NULL, NULL, NULL, NULL, '', '', '2016-08-26 19:20:12', 1, '2016-08-26 19:20:12', 1, 0),
(19, '19', 9, 18, 'blood', 6, 18, 'blood', NULL, NULL, '', '', '2016-08-26 19:20:36', 1, '2016-08-26 19:20:36', 1, 0),
(20, '20', 10, 18, 'blood', 6, 18, 'blood', NULL, NULL, '', 'a', '2016-08-26 19:22:31', 1, '2016-08-26 19:22:31', 1, 0),
(21, '21', 2, 21, 'blood', 6, NULL, NULL, NULL, NULL, '', '', '2016-08-26 19:23:48', 1, '2016-08-26 19:23:48', 1, 0);

INSERT INTO `sample_masters_revs` (`id`, `sample_code`, `sample_control_id`, `initial_specimen_sample_id`, `initial_specimen_sample_type`, `collection_id`, `parent_id`, `parent_sample_type`, `sop_master_id`, `product_code`, `is_problematic`, `notes`, `modified_by`, `version_id`, `version_created`) VALUES
(1, '1', 3, 1, 'tissue', 2, NULL, NULL, NULL, NULL, '', '', 1, 1, '2012-07-31 19:31:17'),
(2, '2', 3, 2, 'tissue', 3, NULL, NULL, NULL, NULL, '', '', 1, 2, '2012-07-31 19:41:26'),
(3, '3', 2, 3, 'blood', 3, NULL, NULL, NULL, NULL, '', '', 1, 3, '2012-07-31 19:45:40'),
(4, '4', 7, 3, 'blood', 3, 3, 'blood', NULL, NULL, '', '', 1, 4, '2012-07-31 19:48:33'),
(5, '5', 12, 3, 'blood', 3, 4, 'blood cell', NULL, NULL, '', '', 1, 5, '2012-07-31 19:49:02'),
(6, '6', 9, 3, 'blood', 3, 3, 'blood', NULL, NULL, '', '', 1, 6, '2012-07-31 19:51:42'),
(7, '7', 3, 7, 'tissue', 4, NULL, NULL, NULL, NULL, '', '', 1, 7, '2012-07-31 20:46:10'),
(8, '8', 2, 8, 'blood', 5, NULL, NULL, NULL, NULL, '', '', 1, 8, '2012-07-31 20:49:39'),
(9, '9', 3, 9, 'tissue', 5, NULL, NULL, NULL, NULL, '', '', 1, 9, '2012-07-31 20:53:21'),
(10, '10', 2, 10, 'blood', 1, NULL, NULL, NULL, NULL, '', '', 1, 10, '2012-08-01 13:10:14'),
(10, '10', 2, 10, 'blood', 1, NULL, NULL, NULL, NULL, '', '', 1, 11, '2012-08-01 13:10:29'),
(11, '11', 12, 1, 'tissue', 2, 1, 'tissue', NULL, NULL, '', '', 1, 12, '2012-08-01 13:45:32'),
(12, '12', 12, 2, 'tissue', 3, 2, 'tissue', NULL, NULL, '', '', 1, 13, '2012-08-01 13:45:34'),
(13, '13', 12, 1, 'tissue', 2, 1, 'tissue', NULL, NULL, '', '', 1, 14, '2012-08-01 13:45:35'),
(14, '14', 12, 7, 'tissue', 4, 7, 'tissue', NULL, NULL, '', '', 1, 15, '2012-08-01 13:45:36'),
(15, '15', 12, 1, 'tissue', 2, 1, 'tissue', NULL, NULL, '', '', 1, 16, '2012-08-01 13:45:37'),
(16, '16', 3, 16, 'tissue', 6, NULL, NULL, NULL, NULL, '', '', 1, 17, '2016-08-26 19:18:42'),
(17, '17', 3, 17, 'tissue', 6, NULL, NULL, NULL, NULL, '', '', 1, 18, '2016-08-26 19:19:36'),
(18, '18', 2, 18, 'blood', 6, NULL, NULL, NULL, NULL, '', '', 1, 19, '2016-08-26 19:20:12'),
(19, '19', 9, 18, 'blood', 6, 18, 'blood', NULL, NULL, '', '', 1, 20, '2016-08-26 19:20:36'),
(20, '20', 10, 18, 'blood', 6, 18, 'blood', NULL, NULL, '', 'a', 1, 21, '2016-08-26 19:22:32'),
(21, '21', 2, 21, 'blood', 6, NULL, NULL, NULL, NULL, '', '', 1, 22, '2016-08-26 19:23:48');

INSERT INTO `sd_der_blood_cells` (`sample_master_id`) VALUES
(4);

INSERT INTO `sd_der_blood_cells_revs` (`sample_master_id`, `version_id`, `version_created`) VALUES
(4, 1, '2012-07-31 19:48:33');

INSERT INTO `sd_der_dnas` (`sample_master_id`) VALUES
(5),
(11),
(12),
(13),
(14),
(15);

INSERT INTO `sd_der_dnas_revs` (`sample_master_id`, `version_id`, `version_created`) VALUES
(5, 1, '2012-07-31 19:49:02'),
(11, 2, '2012-08-01 13:45:33'),
(12, 3, '2012-08-01 13:45:34'),
(13, 4, '2012-08-01 13:45:35'),
(14, 5, '2012-08-01 13:45:36'),
(15, 6, '2012-08-01 13:45:37');

INSERT INTO `sd_der_plasmas` (`sample_master_id`) VALUES
(6),
(19);

INSERT INTO `sd_der_plasmas_revs` (`sample_master_id`, `version_id`, `version_created`) VALUES
(6, 1, '2012-07-31 19:51:43'),
(19, 2, '2016-08-26 19:20:36');

INSERT INTO `sd_der_serums` (`sample_master_id`) VALUES
(20);

INSERT INTO `sd_der_serums_revs` (`sample_master_id`, `version_id`, `version_created`) VALUES
(20, 1, '2016-08-26 19:22:32');

INSERT INTO `sd_spe_bloods` (`sample_master_id`, `blood_type`, `collected_tube_nbr`, `collected_volume`, `collected_volume_unit`) VALUES
(3, 'EDTA', 3, '12.00000', 'ml'),
(8, 'paxgene', 2, NULL, ''),
(10, 'EDTA', 3, '6.00000', 'ml'),
(18, 'EDTA', NULL, NULL, ''),
(21, 'paxgene', 2, NULL, '');

INSERT INTO `sd_spe_bloods_revs` (`sample_master_id`, `blood_type`, `collected_tube_nbr`, `collected_volume`, `collected_volume_unit`, `version_id`, `version_created`) VALUES
(3, 'EDTA', 3, '12.00000', 'ml', 1, '2012-07-31 19:45:41'),
(8, 'paxgene', 2, NULL, '', 2, '2012-07-31 20:49:40'),
(10, 'EDTA', 3, '2.00000', '', 3, '2012-08-01 13:10:15'),
(10, 'EDTA', 3, '6.00000', 'ml', 4, '2012-08-01 13:10:29'),
(18, 'EDTA', NULL, NULL, '', 5, '2016-08-26 19:20:12'),
(21, 'paxgene', 2, NULL, '', 6, '2016-08-26 19:23:48');

INSERT INTO `sd_spe_tissues` (`sample_master_id`, `tissue_source`, `tissue_nature`, `tissue_laterality`, `pathology_reception_datetime`, `pathology_reception_datetime_accuracy`, `tissue_size`, `tissue_size_unit`, `tissue_weight`, `tissue_weight_unit`) VALUES
(1, '', NULL, 'right', '2012-06-03 10:40:00', 'c', '1x2x1', 'cm', '', ''),
(2, '', NULL, '', NULL, '', '1x1.5x2', 'cm', '', ''),
(7, '', NULL, '', NULL, '', '', '', '', ''),
(9, '', NULL, 'not applicable', NULL, '', '', '', '', ''),
(16, 'C50', NULL, 'left', '2009-08-01 10:06:00', 'c', '', '', '', ''),
(17, 'C50', NULL, 'right', '2009-04-01 00:00:00', 'h', '', '', '', '');

INSERT INTO `sd_spe_tissues_revs` (`sample_master_id`, `tissue_source`, `tissue_nature`, `tissue_laterality`, `pathology_reception_datetime`, `pathology_reception_datetime_accuracy`, `tissue_size`, `tissue_size_unit`, `tissue_weight`, `tissue_weight_unit`, `version_id`, `version_created`) VALUES
(1, '', NULL, 'right', '2012-06-03 10:40:00', 'c', '1x2x1', 'cm', '', '', 1, '2012-07-31 19:31:17'),
(2, '', NULL, '', NULL, '', '1x1.5x2', 'cm', '', '', 2, '2012-07-31 19:41:27'),
(7, '', NULL, '', NULL, '', '', '', '', '', 3, '2012-07-31 20:46:10'),
(9, '', NULL, 'not applicable', NULL, '', '', '', '', '', 4, '2012-07-31 20:53:22'),
(16, 'C50', NULL, 'left', '2009-08-01 10:06:00', 'c', '', '', '', '', 5, '2016-08-26 19:18:43'),
(17, 'C50', NULL, 'right', '2009-04-01 00:00:00', 'h', '', '', '', '', 6, '2016-08-26 19:19:37');

INSERT INTO `shipments` (`id`, `shipment_code`, `recipient`, `facility`, `delivery_street_address`, `delivery_city`, `delivery_province`, `delivery_postal_code`, `delivery_country`, `delivery_phone_number`, `delivery_department_or_door`, `delivery_notes`, `shipping_company`, `shipping_account_nbr`, `tracking`, `datetime_shipped`, `datetime_shipped_accuracy`, `datetime_received`, `datetime_received_accuracy`, `shipped_by`, `created`, `created_by`, `modified`, `modified_by`, `order_id`, `deleted`) VALUES
(1, '778', 'Dr Bond', '', '12 main street', 'Torronto', '', '', '', '001 444 993 3333', '', '', 'Red-Mail', '6728', '', '2012-08-09 00:00:00', 'h', NULL, '', 'res. assist. 1', '2012-08-01 13:59:24', 1, '2012-08-01 13:59:24', 1, 1, 0),
(2, 'Sh789', 'Dr Folamour', '', '', '', '', '', '', '', '', '', 'DURAMAIL', '565488', '', '2016-05-19 00:00:00', 'h', '2016-05-31 00:00:00', 'h', 'tech. 2', '2016-08-26 20:01:59', 1, '2016-08-26 20:01:59', 1, 2, 0);

INSERT INTO `shipments_revs` (`id`, `shipment_code`, `recipient`, `facility`, `delivery_street_address`, `delivery_city`, `delivery_province`, `delivery_postal_code`, `delivery_country`, `delivery_phone_number`, `delivery_department_or_door`, `delivery_notes`, `shipping_company`, `shipping_account_nbr`, `tracking`, `datetime_shipped`, `datetime_shipped_accuracy`, `datetime_received`, `datetime_received_accuracy`, `shipped_by`, `modified_by`, `order_id`, `version_id`, `version_created`) VALUES
(1, '778', 'Dr Bond', '', '12 main street', 'Torronto', '', '', '', '001 444 993 3333', '', '', 'Red-Mail', '6728', '', '2012-08-09 00:00:00', 'h', NULL, '', 'res. assist. 1', 1, 1, 1, '2012-08-01 13:59:24'),
(2, 'Sh789', 'Dr Folamour', '', '', '', '', '', '', '', '', '', 'DURAMAIL', '565488', '', '2016-05-19 00:00:00', 'h', '2016-05-31 00:00:00', 'h', 'tech. 2', 1, 2, 2, '2016-08-26 20:01:59');

INSERT INTO `sopd_inventory_alls` (`sop_master_id`) VALUES
(1);

INSERT INTO `sopd_inventory_alls_revs` (`sop_master_id`, `version_id`, `version_created`) VALUES
(1, 1, '2012-07-31 17:57:41');

INSERT INTO `sop_masters` (`id`, `sop_control_id`, `title`, `notes`, `code`, `version`, `status`, `expiry_date`, `expiry_date_accuracy`, `activated_date`, `activated_date_accuracy`, `scope`, `purpose`, `created`, `created_by`, `modified`, `modified_by`, `form_id`, `deleted`) VALUES
(1, 2, 'SOP PR Coll 8948', '', 'spc-8948', '', '', NULL, '', NULL, '', NULL, NULL, '2012-07-31 17:57:40', 1, '2012-07-31 17:57:40', 1, NULL, 0);

INSERT INTO `sop_masters_revs` (`id`, `sop_control_id`, `title`, `notes`, `code`, `version`, `status`, `expiry_date`, `expiry_date_accuracy`, `activated_date`, `activated_date_accuracy`, `scope`, `purpose`, `modified_by`, `form_id`, `version_id`, `version_created`) VALUES
(1, 2, 'SOP PR Coll 8948', '', 'spc-8948', '', '', NULL, '', NULL, '', NULL, NULL, 1, NULL, 1, '2012-07-31 17:57:41');

INSERT INTO `source_aliquots` (`id`, `sample_master_id`, `aliquot_master_id`, `used_volume`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 11, 1, NULL, '2012-08-01 13:45:33', 1, '2012-08-01 13:45:33', 1, 0),
(2, 12, 12, NULL, '2012-08-01 13:45:34', 1, '2012-08-01 13:45:34', 1, 0),
(3, 13, 2, NULL, '2012-08-01 13:45:35', 1, '2012-08-01 13:45:35', 1, 0),
(4, 14, 40, NULL, '2012-08-01 13:45:36', 1, '2012-08-01 13:45:36', 1, 0),
(5, 15, 7, NULL, '2012-08-01 13:45:37', 1, '2012-08-01 13:45:37', 1, 0);

INSERT INTO `source_aliquots_revs` (`id`, `sample_master_id`, `aliquot_master_id`, `used_volume`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 11, 1, NULL, 1, 1, '2012-08-01 13:45:33'),
(2, 12, 12, NULL, 1, 2, '2012-08-01 13:45:34'),
(3, 13, 2, NULL, 1, 3, '2012-08-01 13:45:35'),
(4, 14, 40, NULL, 1, 4, '2012-08-01 13:45:36'),
(5, 15, 7, NULL, 1, 5, '2012-08-01 13:45:37');

INSERT INTO `specimen_details` (`sample_master_id`, `supplier_dept`, `time_at_room_temp_mn`, `reception_by`, `reception_datetime`, `reception_datetime_accuracy`) VALUES
(1, 'patho dpt', 12, '', '2012-07-03 11:15:00', 'c'),
(2, 'surgery room', 0, 'tech. 1', '2010-03-01 00:00:00', 'd'),
(3, 'surgery room', NULL, 'tech. 1', '2019-03-01 00:00:00', 'd'),
(7, 'patho dpt', 2, 'tech. 1', '2004-06-05 10:30:00', 'c'),
(8, '', NULL, '', '2008-08-06 12:45:00', 'c'),
(9, 'patho dpt', NULL, 'res. assist. 1', '2008-08-06 12:45:00', 'c'),
(10, '', NULL, '', '2001-06-23 00:00:00', 'h'),
(16, 'patho dpt', NULL, 'res. assist. 1', '2009-08-01 16:09:00', 'c'),
(17, 'patho dpt', NULL, 'res. assist. 1', '2009-08-01 16:09:00', 'c'),
(18, 'patho dpt', 23, 'res. assist. 1', '2009-08-01 16:09:00', 'c'),
(21, 'patho dpt', NULL, 'res. assist. 1', '2009-08-01 16:09:00', 'c');

INSERT INTO `specimen_details_revs` (`sample_master_id`, `supplier_dept`, `time_at_room_temp_mn`, `reception_by`, `reception_datetime`, `reception_datetime_accuracy`, `version_id`, `version_created`) VALUES
(1, 'patho dpt', 12, '', '2012-07-03 11:15:00', 'c', 1, '2012-07-31 19:31:17'),
(2, 'surgery room', 0, 'tech. 1', '2010-03-01 00:00:00', 'd', 2, '2012-07-31 19:41:27'),
(3, 'surgery room', NULL, 'tech. 1', '2019-03-01 00:00:00', 'd', 3, '2012-07-31 19:45:41'),
(7, 'patho dpt', 2, 'tech. 1', '2004-06-05 10:30:00', 'c', 4, '2012-07-31 20:46:11'),
(8, '', NULL, '', '2008-08-06 12:45:00', 'c', 5, '2012-07-31 20:49:40'),
(9, 'patho dpt', NULL, 'res. assist. 1', '2008-08-06 12:45:00', 'c', 6, '2012-07-31 20:53:22'),
(10, '', NULL, '', '2001-06-23 00:00:00', 'h', 7, '2012-08-01 13:10:15'),
(10, '', NULL, '', '2001-06-23 00:00:00', 'h', 8, '2012-08-01 13:10:29'),
(16, 'patho dpt', NULL, 'res. assist. 1', '2009-08-01 16:09:00', 'c', 9, '2016-08-26 19:18:43'),
(17, 'patho dpt', NULL, 'res. assist. 1', '2009-08-01 16:09:00', 'c', 10, '2016-08-26 19:19:37'),
(18, 'patho dpt', 23, 'res. assist. 1', '2009-08-01 16:09:00', 'c', 11, '2016-08-26 19:20:12'),
(21, 'patho dpt', NULL, 'res. assist. 1', '2009-08-01 16:09:00', 'c', 12, '2016-08-26 19:23:49');

INSERT INTO `std_boxs` (`storage_master_id`) VALUES
(11),
(12),
(13),
(14),
(19),
(20),
(26),
(27),
(28),
(29),
(30),
(31),
(39);

INSERT INTO `std_boxs_revs` (`storage_master_id`, `version_id`, `version_created`) VALUES
(11, 1, '2012-07-31 18:01:00'),
(12, 2, '2012-07-31 18:01:12'),
(13, 3, '2012-07-31 18:01:41'),
(14, 4, '2012-07-31 18:03:06'),
(19, 5, '2012-07-31 18:05:07'),
(20, 6, '2012-07-31 18:05:14'),
(26, 7, '2012-07-31 18:06:37'),
(27, 8, '2012-07-31 18:06:52'),
(28, 9, '2012-07-31 18:06:59'),
(29, 10, '2012-07-31 18:07:08'),
(26, 11, '2012-07-31 18:07:27'),
(27, 12, '2012-07-31 18:07:27'),
(28, 13, '2012-07-31 18:07:28'),
(29, 14, '2012-07-31 18:07:28'),
(11, 15, '2012-07-31 18:08:11'),
(12, 16, '2012-07-31 18:08:40'),
(11, 17, '2012-07-31 18:09:36'),
(14, 18, '2012-07-31 18:10:03'),
(14, 19, '2012-07-31 18:10:53'),
(30, 20, '2012-07-31 19:33:18'),
(31, 21, '2012-07-31 19:43:50'),
(13, 22, '2012-07-31 19:47:04'),
(39, 23, '2016-08-26 16:58:06');

INSERT INTO `std_cupboards` (`storage_master_id`) VALUES
(15);

INSERT INTO `std_cupboards_revs` (`storage_master_id`, `version_id`, `version_created`) VALUES
(15, 1, '2012-07-31 18:04:25');

INSERT INTO `std_freezers` (`storage_master_id`) VALUES
(1),
(21);

INSERT INTO `std_freezers_revs` (`storage_master_id`, `version_id`, `version_created`) VALUES
(1, 1, '2012-07-31 17:58:22'),
(21, 2, '2012-07-31 18:05:46'),
(1, 3, '2012-07-31 19:47:00');

INSERT INTO `std_nitro_locates` (`storage_master_id`) VALUES
(34);

INSERT INTO `std_nitro_locates_revs` (`storage_master_id`, `version_id`, `version_created`) VALUES
(34, 1, '2016-08-26 16:05:30');

INSERT INTO `std_racks` (`storage_master_id`) VALUES
(5),
(6),
(7),
(8),
(9),
(10),
(22),
(23),
(24),
(25),
(35),
(36),
(37),
(38);

INSERT INTO `std_racks_revs` (`storage_master_id`, `version_id`, `version_created`) VALUES
(5, 1, '2012-07-31 17:59:25'),
(6, 2, '2012-07-31 17:59:34'),
(7, 3, '2012-07-31 17:59:43'),
(8, 4, '2012-07-31 18:00:05'),
(9, 5, '2012-07-31 18:00:11'),
(10, 6, '2012-07-31 18:00:17'),
(22, 7, '2012-07-31 18:06:00'),
(23, 8, '2012-07-31 18:06:05'),
(24, 9, '2012-07-31 18:06:12'),
(25, 10, '2012-07-31 18:06:20'),
(5, 11, '2012-07-31 19:47:01'),
(6, 12, '2012-07-31 19:47:02'),
(7, 13, '2012-07-31 19:47:02'),
(8, 14, '2012-07-31 19:47:03'),
(9, 15, '2012-07-31 19:47:03'),
(10, 16, '2012-07-31 19:47:03'),
(35, 17, '2016-08-26 16:05:50'),
(36, 18, '2016-08-26 16:05:59'),
(37, 19, '2016-08-26 16:06:05'),
(38, 20, '2016-08-26 16:06:12');

INSERT INTO `std_rooms` (`storage_master_id`, `laboratory`, `floor`) VALUES
(33, 'Labo Dr Bono', '4th');

INSERT INTO `std_rooms_revs` (`storage_master_id`, `laboratory`, `floor`, `version_id`, `version_created`) VALUES
(33, 'Labo Dr Bono', '4th', 1, '2016-08-26 16:04:52');

INSERT INTO `std_shelfs` (`storage_master_id`) VALUES
(2),
(3),
(4),
(16),
(17),
(18);

INSERT INTO `std_shelfs_revs` (`storage_master_id`, `version_id`, `version_created`) VALUES
(2, 1, '2012-07-31 17:58:49'),
(3, 2, '2012-07-31 17:58:55'),
(4, 3, '2012-07-31 17:59:01'),
(16, 4, '2012-07-31 18:04:39'),
(17, 5, '2012-07-31 18:04:44'),
(18, 6, '2012-07-31 18:04:52'),
(2, 7, '2012-07-31 19:47:00'),
(3, 8, '2012-07-31 19:47:00'),
(4, 9, '2012-07-31 19:47:01');

INSERT INTO `std_tma_blocks` (`storage_master_id`, `sop_master_id`, `product_code`, `creation_datetime`, `creation_datetime_accuracy`) VALUES
(32, NULL, NULL, '2012-03-01 00:00:00', 'c');

INSERT INTO `std_tma_blocks_revs` (`storage_master_id`, `sop_master_id`, `product_code`, `creation_datetime`, `creation_datetime_accuracy`, `version_id`, `version_created`) VALUES
(32, NULL, NULL, '2012-03-01 00:00:00', 'h', 1, '2012-08-01 13:26:06'),
(32, NULL, NULL, '2012-03-01 00:00:00', 'c', 2, '2016-08-26 20:12:51'),
(32, NULL, NULL, '2012-03-01 00:00:00', 'c', 3, '2016-08-26 20:14:50');

INSERT INTO `storage_masters` (`id`, `code`, `storage_control_id`, `parent_id`, `lft`, `rght`, `barcode`, `short_label`, `selection_label`, `storage_status`, `parent_storage_coord_x`, `parent_storage_coord_y`, `temperature`, `temp_unit`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, '1', 6, NULL, 1, 22, NULL, 'fre', 'fre', '', '', '', '4.50', 'celsius', '', '2012-07-31 17:58:21', 1, '2012-07-31 19:46:59', 1, 0),
(2, '2', 14, 1, 2, 9, NULL, '1', 'fre-1', '', '', '', '4.50', 'celsius', '', '2012-07-31 17:58:49', 1, '2012-07-31 19:47:00', 1, 0),
(3, '3', 14, 1, 10, 19, NULL, '2', 'fre-2', '', '', '', '4.50', 'celsius', '', '2012-07-31 17:58:55', 1, '2012-07-31 19:47:00', 1, 0),
(4, '4', 14, 1, 20, 21, NULL, '3', 'fre-3', '', '', '', '4.50', 'celsius', '', '2012-07-31 17:59:01', 1, '2012-07-31 19:47:01', 1, 0),
(5, '5', 12, 2, 3, 4, NULL, 'r1', 'fre-1-r1', '', '', '', '4.50', 'celsius', '', '2012-07-31 17:59:25', 1, '2012-07-31 19:47:01', 1, 0),
(6, '6', 12, 2, 5, 6, NULL, 'r2', 'fre-1-r2', '', '', '', '4.50', 'celsius', '', '2012-07-31 17:59:34', 1, '2012-07-31 19:47:02', 1, 0),
(7, '7', 12, 2, 7, 8, NULL, 'r3', 'fre-1-r3', '', '', '', '4.50', 'celsius', '', '2012-07-31 17:59:43', 1, '2012-07-31 19:47:02', 1, 0),
(8, '8', 12, 3, 11, 12, NULL, 'r1', 'fre-2-r1', '', '', '', '4.50', 'celsius', '', '2012-07-31 18:00:05', 1, '2012-07-31 19:47:02', 1, 0),
(9, '9', 12, 3, 13, 16, NULL, 'r2', 'fre-2-r2', '', '', '', '4.50', 'celsius', '', '2012-07-31 18:00:11', 1, '2012-07-31 19:47:03', 1, 0),
(10, '10', 12, 3, 17, 18, NULL, 'r3', 'fre-2-r3', '', '', '', '4.50', 'celsius', '', '2012-07-31 18:00:17', 1, '2012-07-31 19:47:03', 1, 0),
(11, '11', 9, 24, 49, 50, NULL, 'dna9', 'F-3-dna9', '', '2', '', '-82.00', 'celsius', '', '2012-07-31 18:01:00', 1, '2012-07-31 18:09:35', 1, 0),
(12, '12', 9, 23, 41, 42, NULL, 'dna10', 'F-2-dna10', '', '2', '', '-82.00', 'celsius', '', '2012-07-31 18:01:11', 1, '2012-07-31 18:08:40', 1, 0),
(13, '13', 9, 9, 14, 15, NULL, 'blood6', 'fre-2-r2-blood6', '', '1', '', '4.50', 'celsius', '', '2012-07-31 18:01:40', 1, '2012-07-31 19:47:04', 1, 0),
(14, '14', 10, 24, 51, 52, NULL, 'tiss1', 'F-3-tiss1', '', '1', '', '-82.00', 'celsius', '', '2012-07-31 18:03:06', 1, '2012-07-31 18:10:53', 1, 0),
(15, '15', 2, NULL, 23, 36, NULL, 'c', 'c', '', '', '', NULL, NULL, '', '2012-07-31 18:04:25', 1, '2012-07-31 18:04:25', 1, 0),
(16, '16', 14, 15, 24, 25, NULL, '1', 'c-1', '', '', '', NULL, NULL, '', '2012-07-31 18:04:39', 1, '2012-07-31 18:04:39', 1, 0),
(17, '17', 14, 15, 26, 27, NULL, '2', 'c-2', '', '', '', NULL, NULL, '', '2012-07-31 18:04:44', 1, '2012-07-31 18:04:44', 1, 0),
(18, '18', 14, 15, 28, 35, NULL, '3', 'c-3', '', '', '', NULL, NULL, '', '2012-07-31 18:04:51', 1, '2012-07-31 18:04:51', 1, 0),
(19, '19', 8, 18, 29, 30, NULL, 'blck', 'c-3-blck', '', '', '', NULL, NULL, '', '2012-07-31 18:05:07', 1, '2012-07-31 18:05:07', 1, 0),
(20, '20', 8, 18, 31, 34, NULL, 'TMA', 'c-3-TMA', '', '', '', NULL, NULL, '', '2012-07-31 18:05:13', 1, '2012-07-31 18:05:13', 1, 0),
(21, '21', 6, NULL, 37, 64, NULL, 'F', 'F', '', '', '', '-82.00', 'celsius', '', '2012-07-31 18:05:46', 1, '2012-07-31 18:05:46', 1, 0),
(22, '22', 15, 21, 38, 39, NULL, '1', 'F-1', '', '', '', '-82.00', 'celsius', '', '2012-07-31 18:06:00', 1, '2012-07-31 18:06:00', 1, 0),
(23, '23', 15, 21, 40, 47, NULL, '2', 'F-2', '', '', '', '-82.00', 'celsius', '', '2012-07-31 18:06:05', 1, '2012-07-31 18:06:05', 1, 0),
(24, '24', 15, 21, 48, 53, NULL, '3', 'F-3', '', '', '', '-82.00', 'celsius', '', '2012-07-31 18:06:11', 1, '2012-07-31 18:06:11', 1, 0),
(25, '25', 15, 21, 54, 63, NULL, '4', 'F-4', '', '', '', '-82.00', 'celsius', '', '2012-07-31 18:06:17', 1, '2012-07-31 18:06:17', 1, 0),
(26, '26', 10, 25, 55, 56, NULL, 'plasma1', 'F-4-plasma1', '', '4', '', '-82.00', 'celsius', '', '2012-07-31 18:06:37', 1, '2012-07-31 18:07:27', 1, 0),
(27, '27', 10, 25, 57, 58, NULL, 'plasma2', 'F-4-plasma2', '', '2', '', '-82.00', 'celsius', '', '2012-07-31 18:06:51', 1, '2012-07-31 18:07:27', 1, 0),
(28, '28', 10, 25, 59, 60, NULL, 'plasma3', 'F-4-plasma3', '', '3', '', '-82.00', 'celsius', '', '2012-07-31 18:06:59', 1, '2012-07-31 18:07:28', 1, 0),
(29, '29', 10, 25, 61, 62, NULL, 'plasma4', 'F-4-plasma4', '', '1', '', '-82.00', 'celsius', '', '2012-07-31 18:07:08', 1, '2012-07-31 18:07:28', 1, 0),
(30, '30', 8, 23, 43, 44, NULL, 'blck', 'F-2-blck', '', '', '', '-82.00', 'celsius', '', '2012-07-31 19:33:17', 1, '2012-07-31 19:33:17', 1, 0),
(31, '31', 9, 23, 45, 46, NULL, 'TisTb', 'F-2-TisTb', '', '11', '', '-82.00', 'celsius', '', '2012-07-31 19:43:49', 1, '2012-07-31 19:43:49', 1, 0),
(32, '32', 20, 20, 32, 33, NULL, 'TMA-Proj.3', 'c-3-TMA-TMA-Proj.3', '', '', '', NULL, NULL, '', '2012-08-01 13:26:06', 1, '2016-08-26 20:14:50', 1, 0),
(33, '33', 1, NULL, 65, 78, NULL, 'R124', 'R124', '', '', '', '21.00', 'celsius', '', '2016-08-26 16:04:52', 1, '2016-08-26 16:04:52', 1, 0),
(34, '34', 3, 33, 66, 77, NULL, 'Az-45', 'R124-Az-45', '', '', '', '-180.00', 'celsius', '', '2016-08-26 16:05:30', 1, '2016-08-26 16:05:30', 1, 0),
(35, '35', 16, 34, 67, 70, NULL, '1', 'R124-Az-45-1', '', '', '', '-180.00', 'celsius', '', '2016-08-26 16:05:50', 1, '2016-08-26 16:05:50', 1, 0),
(36, '36', 16, 34, 71, 72, NULL, '2', 'R124-Az-45-2', '', '', '', '-180.00', 'celsius', '', '2016-08-26 16:05:58', 1, '2016-08-26 16:05:58', 1, 0),
(37, '37', 16, 34, 73, 74, NULL, '3', 'R124-Az-45-3', '', '', '', '-180.00', 'celsius', '', '2016-08-26 16:06:05', 1, '2016-08-26 16:06:05', 1, 0),
(38, '38', 16, 34, 75, 76, NULL, '4', 'R124-Az-45-4', '', '', '', '-180.00', 'celsius', '', '2016-08-26 16:06:12', 1, '2016-08-26 16:06:12', 1, 0),
(39, '39', 9, 35, 68, 69, NULL, 'd1', 'R124-Az-45-1-d1', '', '', '', '-180.00', 'celsius', '', '2016-08-26 16:58:06', 1, '2016-08-26 16:58:06', 1, 0);

INSERT INTO `storage_masters_revs` (`id`, `code`, `storage_control_id`, `parent_id`, `lft`, `rght`, `barcode`, `short_label`, `selection_label`, `storage_status`, `parent_storage_coord_x`, `parent_storage_coord_y`, `temperature`, `temp_unit`, `notes`, `modified_by`, `version_id`, `version_created`) VALUES
(1, '1', 6, NULL, 1, 2, NULL, 'f', 'f', '', '', '', '4.50', 'celsius', '', 1, 1, '2012-07-31 17:58:22'),
(2, '2', 14, 1, 0, 0, NULL, '1', 'f-1', '', '', '', '4.50', 'celsius', '', 1, 2, '2012-07-31 17:58:49'),
(3, '3', 14, 1, 0, 0, NULL, '2', 'f-2', '', '', '', '4.50', 'celsius', '', 1, 3, '2012-07-31 17:58:55'),
(4, '4', 14, 1, 0, 0, NULL, '3', 'f-3', '', '', '', '4.50', 'celsius', '', 1, 4, '2012-07-31 17:59:01'),
(5, '5', 12, 2, 0, 0, NULL, 'r1', 'f-1-r1', '', '', '', '4.50', 'celsius', '', 1, 5, '2012-07-31 17:59:25'),
(6, '6', 12, 2, 0, 0, NULL, 'r2', 'f-1-r2', '', '', '', '4.50', 'celsius', '', 1, 6, '2012-07-31 17:59:34'),
(7, '7', 12, 2, 0, 0, NULL, 'r3', 'f-1-r3', '', '', '', '4.50', 'celsius', '', 1, 7, '2012-07-31 17:59:43'),
(8, '8', 12, 3, 0, 0, NULL, 'r1', 'f-2-r1', '', '', '', '4.50', 'celsius', '', 1, 8, '2012-07-31 18:00:05'),
(9, '9', 12, 3, 0, 0, NULL, 'r2', 'f-2-r2', '', '', '', '4.50', 'celsius', '', 1, 9, '2012-07-31 18:00:11'),
(10, '10', 12, 3, 0, 0, NULL, 'r3', 'f-2-r3', '', '', '', '4.50', 'celsius', '', 1, 10, '2012-07-31 18:00:17'),
(11, '11', 9, 8, 0, 0, NULL, 'dna9', 'f-2-r1-dna9', '', '1', '', '4.50', 'celsius', '', 1, 11, '2012-07-31 18:01:00'),
(12, '12', 9, 8, 0, 0, NULL, 'dna10', 'f-2-r1-dna10', '', '2', '', '4.50', 'celsius', '', 1, 12, '2012-07-31 18:01:11'),
(13, '13', 9, 9, 0, 0, NULL, 'blood6', 'f-2-r2-blood6', '', '1', '', '4.50', 'celsius', '', 1, 13, '2012-07-31 18:01:40'),
(14, '14', 10, 8, 0, 0, NULL, 'tiss1', 'f-2-r1-tiss1', '', '3', '', '4.50', 'celsius', '', 1, 14, '2012-07-31 18:03:06'),
(15, '15', 2, NULL, 29, 30, NULL, 'c', 'c', '', '', '', NULL, NULL, '', 1, 15, '2012-07-31 18:04:25'),
(16, '16', 14, 15, 0, 0, NULL, '1', 'c-1', '', '', '', NULL, NULL, '', 1, 16, '2012-07-31 18:04:39'),
(17, '17', 14, 15, 0, 0, NULL, '2', 'c-2', '', '', '', NULL, NULL, '', 1, 17, '2012-07-31 18:04:44'),
(18, '18', 14, 15, 0, 0, NULL, '3', 'c-3', '', '', '', NULL, NULL, '', 1, 18, '2012-07-31 18:04:51'),
(19, '19', 8, 18, 0, 0, NULL, 'blck', 'c-3-blck', '', '', '', NULL, NULL, '', 1, 19, '2012-07-31 18:05:07'),
(20, '20', 8, 18, 0, 0, NULL, 'TMA', 'c-3-TMA', '', '', '', NULL, NULL, '', 1, 20, '2012-07-31 18:05:13'),
(21, '21', 6, NULL, 41, 42, NULL, 'F', 'F', '', '', '', '-82.00', 'celsius', '', 1, 21, '2012-07-31 18:05:46'),
(22, '22', 15, 21, 0, 0, NULL, '1', 'F-1', '', '', '', '-82.00', 'celsius', '', 1, 22, '2012-07-31 18:06:00'),
(23, '23', 15, 21, 0, 0, NULL, '2', 'F-2', '', '', '', '-82.00', 'celsius', '', 1, 23, '2012-07-31 18:06:05'),
(24, '24', 15, 21, 0, 0, NULL, '3', 'F-3', '', '', '', '-82.00', 'celsius', '', 1, 24, '2012-07-31 18:06:11'),
(25, '25', 15, 21, 0, 0, NULL, '4', 'F-4', '', '', '', '-82.00', 'celsius', '', 1, 25, '2012-07-31 18:06:18'),
(26, '26', 10, 25, 0, 0, NULL, 'plasma1', 'F-4-plasma1', '', '', '', '-82.00', 'celsius', '', 1, 26, '2012-07-31 18:06:37'),
(27, '27', 10, 25, 0, 0, NULL, 'plasma2', 'F-4-plasma2', '', '2', '', '-82.00', 'celsius', '', 1, 27, '2012-07-31 18:06:51'),
(28, '28', 10, 25, 0, 0, NULL, 'plasma3', 'F-4-plasma3', '', '', '', '-82.00', 'celsius', '', 1, 28, '2012-07-31 18:06:59'),
(29, '29', 10, 25, 0, 0, NULL, 'plasma4', 'F-4-plasma4', '', '', '', '-82.00', 'celsius', '', 1, 29, '2012-07-31 18:07:08'),
(26, '26', 10, 25, 49, 50, NULL, 'plasma1', 'F-4-plasma1', '', '4', '', '-82.00', 'celsius', '', 1, 30, '2012-07-31 18:07:27'),
(27, '27', 10, 25, 51, 52, NULL, 'plasma2', 'F-4-plasma2', '', '2', '', '-82.00', 'celsius', '', 1, 31, '2012-07-31 18:07:27'),
(28, '28', 10, 25, 53, 54, NULL, 'plasma3', 'F-4-plasma3', '', '3', '', '-82.00', 'celsius', '', 1, 32, '2012-07-31 18:07:28'),
(29, '29', 10, 25, 55, 56, NULL, 'plasma4', 'F-4-plasma4', '', '1', '', '-82.00', 'celsius', '', 1, 33, '2012-07-31 18:07:28'),
(11, '11', 9, 6, 12, 13, NULL, 'dna9', 'f-1-r2-dna9', '', '1', '', '4.50', 'celsius', '', 1, 34, '2012-07-31 18:08:10'),
(12, '12', 9, 23, 14, 15, NULL, 'dna10', 'F-2-dna10', '', '2', '', '-82.00', 'celsius', '', 1, 35, '2012-07-31 18:08:40'),
(11, '11', 9, 24, 6, 7, NULL, 'dna9', 'F-3-dna9', '', '2', '', '-82.00', 'celsius', '', 1, 36, '2012-07-31 18:09:35'),
(14, '14', 10, 24, 12, 13, NULL, 'tiss1', 'F-3-tiss1', '', '2', '', '-82.00', 'celsius', '', 1, 37, '2012-07-31 18:10:03'),
(14, '14', 10, 24, 45, 46, NULL, 'tiss1', 'F-3-tiss1', '', '1', '', '-82.00', 'celsius', '', 1, 38, '2012-07-31 18:10:53'),
(30, '30', 8, 23, 0, 0, NULL, 'blck', 'F-2-blck', '', '', '', '-82.00', 'celsius', '', 1, 39, '2012-07-31 19:33:18'),
(31, '31', 9, 23, 0, 0, NULL, 'TisTb', 'F-2-TisTb', '', '11', '', '-82.00', 'celsius', '', 1, 40, '2012-07-31 19:43:49'),
(1, '1', 6, NULL, 1, 22, NULL, 'fre', 'fre', '', '', '', '4.50', 'celsius', '', 1, 41, '2012-07-31 19:46:59'),
(2, '2', 14, 1, 2, 9, NULL, '1', 'fre-1', '', '', '', '4.50', 'celsius', '', 1, 42, '2012-07-31 19:47:00'),
(3, '3', 14, 1, 10, 19, NULL, '2', 'fre-2', '', '', '', '4.50', 'celsius', '', 1, 43, '2012-07-31 19:47:00'),
(4, '4', 14, 1, 20, 21, NULL, '3', 'fre-3', '', '', '', '4.50', 'celsius', '', 1, 44, '2012-07-31 19:47:01'),
(5, '5', 12, 2, 3, 4, NULL, 'r1', 'fre-1-r1', '', '', '', '4.50', 'celsius', '', 1, 45, '2012-07-31 19:47:01'),
(6, '6', 12, 2, 5, 6, NULL, 'r2', 'fre-1-r2', '', '', '', '4.50', 'celsius', '', 1, 46, '2012-07-31 19:47:02'),
(7, '7', 12, 2, 7, 8, NULL, 'r3', 'fre-1-r3', '', '', '', '4.50', 'celsius', '', 1, 47, '2012-07-31 19:47:02'),
(8, '8', 12, 3, 11, 12, NULL, 'r1', 'fre-2-r1', '', '', '', '4.50', 'celsius', '', 1, 48, '2012-07-31 19:47:02'),
(9, '9', 12, 3, 13, 16, NULL, 'r2', 'fre-2-r2', '', '', '', '4.50', 'celsius', '', 1, 49, '2012-07-31 19:47:03'),
(10, '10', 12, 3, 17, 18, NULL, 'r3', 'fre-2-r3', '', '', '', '4.50', 'celsius', '', 1, 50, '2012-07-31 19:47:03'),
(13, '13', 9, 9, 14, 15, NULL, 'blood6', 'fre-2-r2-blood6', '', '1', '', '4.50', 'celsius', '', 1, 51, '2012-07-31 19:47:04'),
(32, '32', 20, 20, 0, 0, NULL, 'TMA-Proj.3', 'c-3-TMA-TMA-Proj.3', '', '', '', NULL, NULL, '', 1, 52, '2012-08-01 13:26:06'),
(33, '33', 1, NULL, 65, 66, NULL, 'R124', 'R124', '', '', '', '21.00', 'celsius', '', 1, 53, '2016-08-26 16:04:52'),
(34, '34', 3, 33, 0, 0, NULL, 'Az-45', 'R124-Az-45', '', '', '', '-180.00', 'celsius', '', 1, 54, '2016-08-26 16:05:30'),
(35, '35', 16, 34, 0, 0, NULL, '1', 'R124-Az-45-1', '', '', '', '-180.00', 'celsius', '', 1, 55, '2016-08-26 16:05:50'),
(36, '36', 16, 34, 0, 0, NULL, '2', 'R124-Az-45-2', '', '', '', '-180.00', 'celsius', '', 1, 56, '2016-08-26 16:05:58'),
(37, '37', 16, 34, 0, 0, NULL, '3', 'R124-Az-45-3', '', '', '', '-180.00', 'celsius', '', 1, 57, '2016-08-26 16:06:05'),
(38, '38', 16, 34, 0, 0, NULL, '4', 'R124-Az-45-4', '', '', '', '-180.00', 'celsius', '', 1, 58, '2016-08-26 16:06:12'),
(39, '39', 9, 35, 0, 0, NULL, 'd1', 'R124-Az-45-1-d1', '', '', '', '-180.00', 'celsius', '', 1, 59, '2016-08-26 16:58:06'),
(32, '32', 20, 5, 32, 33, NULL, 'TMA-Proj.3', 'fre-1-r1-TMA-Proj.3', '', '', '', '4.50', 'celsius', '', 1, 60, '2016-08-26 20:12:50'),
(32, '32', 20, 20, 4, 5, NULL, 'TMA-Proj.3', 'c-3-TMA-TMA-Proj.3', '', '', '', NULL, NULL, '', 1, 61, '2016-08-26 20:14:50');

INSERT INTO `study_fundings` (`id`, `study_sponsor`, `restrictions`, `year_1`, `amount_year_1`, `year_2`, `amount_year_2`, `year_3`, `amount_year_3`, `year_4`, `amount_year_4`, `year_5`, `amount_year_5`, `contact`, `phone_number`, `phone_extension`, `fax_number`, `fax_extension`, `email`, `status`, `date`, `date_accuracy`, `created`, `created_by`, `modified`, `modified_by`, `rtbform_id`, `study_summary_id`, `deleted`) VALUES
(1, 'CTRNet', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', '', '', 'cc@ctrnet.com', 'completed', '2016-08-31', 'c', '2016-08-26 17:11:32', 1, '2016-08-26 17:11:32', 1, NULL, 2, 0),
(2, 'CCI-Ou', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', '', '', '', 'completed', NULL, '', '2016-08-26 17:13:48', 1, '2016-08-26 17:13:48', 1, NULL, 1, 0),
(3, '789639', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', '', '', '', '', NULL, '', '2016-08-26 17:16:09', 1, '2016-08-26 17:17:02', 1, NULL, 1, 1);

INSERT INTO `study_fundings_revs` (`id`, `study_sponsor`, `restrictions`, `year_1`, `amount_year_1`, `year_2`, `amount_year_2`, `year_3`, `amount_year_3`, `year_4`, `amount_year_4`, `year_5`, `amount_year_5`, `contact`, `phone_number`, `phone_extension`, `fax_number`, `fax_extension`, `email`, `status`, `date`, `date_accuracy`, `modified_by`, `rtbform_id`, `study_summary_id`, `version_id`, `version_created`) VALUES
(1, 'CTRNet', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', '', '', 'cc@ctrnet.com', 'completed', '2016-08-31', 'c', 1, NULL, 2, 1, '2016-08-26 17:11:32'),
(2, 'CCI-Ou', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', '', '', '', 'completed', NULL, '', 1, NULL, 1, 2, '2016-08-26 17:13:48'),
(3, '78963', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', '', '', '', '', NULL, '', 1, NULL, 1, 3, '2016-08-26 17:16:09'),
(3, '789639', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', '', '', '', '', NULL, '', 1, NULL, 1, 4, '2016-08-26 17:16:34'),
(3, '789639', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', '', '', '', '', NULL, '', 1, NULL, 1, 5, '2016-08-26 17:17:02');

INSERT INTO `study_investigators` (`id`, `first_name`, `middle_name`, `last_name`, `accrediation`, `occupation`, `department`, `organization`, `address_street`, `address_city`, `address_province`, `address_country`, `sort`, `email`, `role`, `brief`, `participation_start_date`, `participation_start_date_accuracy`, `participation_end_date`, `participation_end_date_accuracy`, `created`, `created_by`, `modified`, `modified_by`, `path_to_file`, `study_summary_id`, `deleted`) VALUES
(1, 'Gerald', NULL, 'Rouge', NULL, NULL, NULL, '', '48 Av Qwerty', 'Montreal', 'Qc', '', NULL, 'G.Rouge@cc.iru.com', 'principle_investigator', '', NULL, '', NULL, '', '2016-08-26 17:10:16', 1, '2016-08-26 17:10:16', 1, NULL, 2, 0),
(2, 'Julie', NULL, 'Zare', NULL, NULL, NULL, '', '', '', '', '', NULL, '', 'co_investigator', '', NULL, '', NULL, '', '2016-08-26 17:10:47', 1, '2016-08-26 17:10:47', 1, NULL, 2, 0),
(3, 'Jerome', NULL, 'Kasper', NULL, NULL, NULL, '', '', '', '', '', NULL, '', 'principle_investigator', '', NULL, '', NULL, '', '2016-08-26 17:13:21', 1, '2016-08-26 17:13:21', 1, NULL, 1, 0),
(4, '113', NULL, '', NULL, NULL, NULL, '', '', '', '', '', NULL, '', 'co_investigator', '', NULL, '', NULL, '', '2016-08-26 17:14:08', 1, '2016-08-26 17:15:18', 1, NULL, 1, 1),
(5, '7897897', NULL, '', NULL, NULL, NULL, '', '', '', '', '', NULL, '', 'principle_investigator', '', NULL, '', NULL, '', '2016-08-26 17:15:42', 1, '2016-08-26 17:15:52', 1, NULL, 1, 1);

INSERT INTO `study_investigators_revs` (`id`, `first_name`, `middle_name`, `last_name`, `accrediation`, `occupation`, `department`, `organization`, `address_street`, `address_city`, `address_province`, `address_country`, `sort`, `email`, `role`, `brief`, `participation_start_date`, `participation_start_date_accuracy`, `participation_end_date`, `participation_end_date_accuracy`, `modified_by`, `path_to_file`, `study_summary_id`, `version_id`, `version_created`) VALUES
(1, 'Gerald', NULL, 'Rouge', NULL, NULL, NULL, '', '48 Av Qwerty', 'Montreal', 'Qc', '', NULL, 'G.Rouge@cc.iru.com', 'principle_investigator', '', NULL, '', NULL, '', 1, NULL, 2, 1, '2016-08-26 17:10:16'),
(2, 'Julie', NULL, 'Zare', NULL, NULL, NULL, '', '', '', '', '', NULL, '', 'co_investigator', '', NULL, '', NULL, '', 1, NULL, 2, 2, '2016-08-26 17:10:47'),
(3, 'Jerome', NULL, 'Kasper', NULL, NULL, NULL, '', '', '', '', '', NULL, '', 'principle_investigator', '', NULL, '', NULL, '', 1, NULL, 1, 3, '2016-08-26 17:13:21'),
(4, '11', NULL, '', NULL, NULL, NULL, '', '', '', '', '', NULL, '', 'co_investigator', '', NULL, '', NULL, '', 1, NULL, 1, 4, '2016-08-26 17:14:08'),
(4, '113', NULL, '', NULL, NULL, NULL, '', '', '', '', '', NULL, '', 'co_investigator', '', NULL, '', NULL, '', 1, NULL, 1, 5, '2016-08-26 17:14:52'),
(4, '113', NULL, '', NULL, NULL, NULL, '', '', '', '', '', NULL, '', 'co_investigator', '', NULL, '', NULL, '', 1, NULL, 1, 6, '2016-08-26 17:15:18'),
(5, '7897897', NULL, '', NULL, NULL, NULL, '', '', '', '', '', NULL, '', 'principle_investigator', '', NULL, '', NULL, '', 1, NULL, 1, 7, '2016-08-26 17:15:42'),
(5, '7897897', NULL, '', NULL, NULL, NULL, '', '', '', '', '', NULL, '', 'principle_investigator', '', NULL, '', NULL, '', 1, NULL, 1, 8, '2016-08-26 17:15:52');

INSERT INTO `study_summaries` (`id`, `disease_site`, `study_type`, `study_science`, `study_use`, `title`, `start_date`, `start_date_accuracy`, `end_date`, `end_date_accuracy`, `summary`, `abstract`, `hypothesis`, `approach`, `analysis`, `significance`, `additional_clinical`, `created`, `created_by`, `modified`, `modified_by`, `path_to_file`, `deleted`, `demo_institution`, `demo_ethical_approved`, `demo_ethical_approval_file_name`, `demo_mta_data_sharing_approved`, `demo_mta_data_sharing_approved_file_name`, `demo_pubmed_ids`) VALUES
(1, 'male genital - prostate', NULL, NULL, NULL, 'Bcc-7847', '2013-08-07', 'c', NULL, '', '', NULL, NULL, NULL, NULL, NULL, NULL, '2012-07-31 17:56:39', 1, '2016-08-26 17:12:49', 1, NULL, 0, 'BC Cancer Agency', 'y', ' D:/Ethic/Banks/Studies/bk_cst843333_bcc7847.pdf', 'y', ' D:/Ethic/Banks/Studies/bk_cst843333_bcc7847.pdf', ''),
(2, 'digestive - pancreas', NULL, NULL, NULL, 'CTRNet.12 - ICh46', '2005-01-07', 'c', '2017-01-01', 'm', '', NULL, NULL, NULL, NULL, NULL, NULL, '2012-07-31 17:56:53', 1, '2016-08-26 17:08:52', 1, NULL, 0, 'CNRT', 'y', 'D:/Ethic/Banks/Studies/bk_cst84983_Ich46.pdf', 'y', 'D:/Ethic/Banks/Studies/bk_cst84983_Ich46.pdf', '2756108288\r\n8493002093');

INSERT INTO `study_summaries_revs` (`id`, `disease_site`, `study_type`, `study_science`, `study_use`, `title`, `start_date`, `start_date_accuracy`, `end_date`, `end_date_accuracy`, `summary`, `abstract`, `hypothesis`, `approach`, `analysis`, `significance`, `additional_clinical`, `modified_by`, `path_to_file`, `version_id`, `version_created`, `demo_institution`, `demo_ethical_approved`, `demo_ethical_approval_file_name`, `demo_mta_data_sharing_approved`, `demo_mta_data_sharing_approved_file_name`, `demo_pubmed_ids`) VALUES
(1, 'male genital - prostate', NULL, NULL, NULL, 'TT PROST', NULL, '', NULL, '', '', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, '2012-07-31 17:56:39', NULL, '', NULL, '', NULL, NULL),
(2, 'digestive - pancreas', NULL, NULL, NULL, 'PORSMABO', NULL, '', NULL, '', '', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 2, '2012-07-31 17:56:53', NULL, '', NULL, '', NULL, NULL),
(2, 'digestive - pancreas', NULL, NULL, NULL, 'CTRNet.12 - ICh46', '2005-01-07', 'c', '2017-01-01', 'm', '', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 3, '2016-08-26 17:07:05', '', 'y', 'D:/Ethic/Banks/Studies/bk_cst84983_Ich46.pdf', 'y', 'D:/Ethic/Banks/Studies/bk_cst84983_Ich46.pdf', '2756108288\r\n8493002093'),
(2, 'digestive - pancreas', NULL, NULL, NULL, 'CTRNet.12 - ICh46', '2005-01-07', 'c', '2017-01-01', 'm', '', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 4, '2016-08-26 17:08:52', 'CNRT', 'y', 'D:/Ethic/Banks/Studies/bk_cst84983_Ich46.pdf', 'y', 'D:/Ethic/Banks/Studies/bk_cst84983_Ich46.pdf', '2756108288\r\n8493002093'),
(1, 'male genital - prostate', NULL, NULL, NULL, 'Bcc-7847', '2013-08-07', 'c', NULL, '', '', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 5, '2016-08-26 17:12:50', 'BC Cancer Agency', 'y', ' D:/Ethic/Banks/Studies/bk_cst843333_bcc7847.pdf', 'y', ' D:/Ethic/Banks/Studies/bk_cst843333_bcc7847.pdf', '');

INSERT INTO `tma_slides` (`id`, `tma_block_storage_master_id`, `barcode`, `product_code`, `sop_master_id`, `immunochemistry`, `picture_path`, `storage_datetime`, `storage_datetime_accuracy`, `storage_master_id`, `storage_coord_x`, `storage_coord_y`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `study_summary_id`, `in_stock`, `in_stock_detail`) VALUES
(1, 32, 'slt649', NULL, NULL, 'Ic948', '', NULL, '', NULL, '', '', '2016-08-26 20:00:10', 1, '2016-08-26 20:00:10', 1, 0, 1, 'yes - available', ''),
(2, 32, 'slt650', NULL, NULL, 'ic545', '', NULL, '', NULL, '', '', '2016-08-26 20:00:10', 1, '2016-08-26 20:16:28', 1, 0, 1, 'no', 'shipped'),
(3, 32, 'slt651', NULL, NULL, 'ic56d8', '', NULL, '', NULL, '', '', '2016-08-26 20:00:10', 1, '2016-08-26 20:14:32', 1, 0, 1, 'no', 'shipped'),
(4, 32, 'li899', NULL, NULL, '', '', NULL, '', 20, '', '', '2016-08-26 20:11:00', 1, '2016-08-26 20:11:00', 1, 0, NULL, 'yes - available', '');

INSERT INTO `tma_slides_revs` (`id`, `tma_block_storage_master_id`, `barcode`, `product_code`, `sop_master_id`, `immunochemistry`, `picture_path`, `storage_datetime`, `storage_datetime_accuracy`, `storage_master_id`, `storage_coord_x`, `storage_coord_y`, `modified_by`, `version_id`, `version_created`, `study_summary_id`, `in_stock`, `in_stock_detail`) VALUES
(1, 32, 'slt649', NULL, NULL, 'Ic948', '', NULL, '', NULL, '', '', 1, 1, '2016-08-26 20:00:10', 1, 'yes - available', ''),
(2, 32, 'slt650', NULL, NULL, 'ic545', '', NULL, '', NULL, '', '', 1, 2, '2016-08-26 20:00:10', 1, 'yes - available', ''),
(3, 32, 'slt651', NULL, NULL, 'ic56d8', '', NULL, '', NULL, '', '', 1, 3, '2016-08-26 20:00:10', 1, 'yes - available', ''),
(3, 32, 'slt651', NULL, NULL, 'ic56d8', '', NULL, '', NULL, '', '', 1, 4, '2016-08-26 20:00:58', 1, 'yes - not available', 'reserved for order'),
(3, 32, 'slt651', NULL, NULL, 'ic56d8', '', NULL, '', NULL, '', '', 1, 5, '2016-08-26 20:02:11', 1, 'no', 'shipped'),
(4, 32, 'li899', NULL, NULL, '', '', NULL, '', 20, '', '', 1, 6, '2016-08-26 20:11:00', NULL, 'yes - available', ''),
(3, 32, 'slt651', NULL, NULL, 'ic56d8', '', NULL, '', 5, '', '', 1, 7, '2016-08-26 20:12:55', 1, 'yes - available', 'shipped'),
(3, 32, 'slt651', NULL, NULL, 'ic56d8', '', NULL, '', NULL, '', '', 1, 8, '2016-08-26 20:14:32', 1, 'no', 'shipped'),
(2, 32, 'slt650', NULL, NULL, 'ic545', '', NULL, '', 10, '', '', 1, 9, '2016-08-26 20:15:24', 1, 'yes - available', ''),
(2, 32, 'slt650', NULL, NULL, 'ic545', '', NULL, '', 10, '', '', 1, 10, '2016-08-26 20:16:01', 1, 'yes - not available', 'reserved for order'),
(2, 32, 'slt650', NULL, NULL, 'ic545', '', NULL, '', NULL, '', '', 1, 11, '2016-08-26 20:16:28', 1, 'no', 'shipped');

INSERT INTO `tma_slide_uses` (`id`, `tma_slide_id`, `date`, `date_accuracy`, `study_summary_id`, `immunochemistry`, `picture_path`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 3, '2016-04-01', 'd', 1, '', '', '2016-08-26 20:08:44', 1, '2016-08-26 20:08:44', 1, 0);

INSERT INTO `tma_slide_uses_revs` (`id`, `tma_slide_id`, `date`, `date_accuracy`, `study_summary_id`, `immunochemistry`, `picture_path`, `version_id`, `version_created`, `modified_by`) VALUES
(1, 3, '2016-04-01', 'd', 1, '', '', 1, '2016-08-26 20:08:44', 1);

INSERT INTO `treatment_extend_masters` (`id`, `treatment_extend_control_id`, `treatment_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `drug_id`) VALUES
(1, 1, 1, '2012-07-31 15:29:25', 1, '2012-07-31 15:29:25', 1, 0, 1),
(2, 1, 1, '2012-07-31 15:29:26', 1, '2012-07-31 15:29:26', 1, 0, 3),
(3, 1, 4, '2012-07-31 15:36:31', 1, '2012-07-31 15:36:31', 1, 0, 1),
(4, 1, 4, '2012-07-31 15:36:31', 1, '2012-07-31 15:36:31', 1, 0, 5),
(5, 1, 8, '2012-07-31 18:52:21', 1, '2012-07-31 18:52:21', 1, 0, 1),
(6, 1, 8, '2012-07-31 18:52:21', 1, '2012-07-31 18:52:21', 1, 0, 5),
(8, 2, 2, '2012-07-31 15:34:32', 1, '2012-07-31 15:34:32', 1, 0, NULL),
(9, 1, 10, '2016-08-26 18:45:02', 1, '2016-08-26 18:45:02', 1, 1, NULL),
(10, 1, 10, '2016-08-26 18:45:03', 1, '2016-08-26 18:45:03', 1, 1, NULL),
(11, 1, 10, '2016-08-26 19:00:03', 1, '2016-08-26 19:00:03', 1, 0, 1),
(12, 1, 10, '2016-08-26 19:00:03', 1, '2016-08-26 19:00:03', 1, 0, 5),
(13, 2, 11, '2016-08-26 19:07:06', 1, '2016-08-26 19:07:06', 1, 0, NULL),
(14, 1, 12, '2016-08-26 19:11:50', 1, '2016-08-26 19:11:50', 1, 0, 5);

INSERT INTO `treatment_extend_masters_revs` (`id`, `treatment_extend_control_id`, `treatment_master_id`, `modified_by`, `version_id`, `version_created`, `drug_id`) VALUES
(1, 1, 1, 1, 1, '2012-07-31 15:29:25', 1),
(2, 1, 1, 1, 2, '2012-07-31 15:29:26', 3),
(3, 1, 4, 1, 3, '2012-07-31 15:36:31', 1),
(4, 1, 4, 1, 4, '2012-07-31 15:36:31', 5),
(5, 1, 8, 1, 5, '2012-07-31 18:52:21', 1),
(6, 1, 8, 1, 6, '2012-07-31 18:52:21', 5),
(8, 2, 2, 1, 8, '2012-07-31 15:34:33', NULL),
(9, 1, 10, 1, 9, '2016-08-26 18:45:02', NULL),
(10, 1, 10, 1, 10, '2016-08-26 18:45:03', NULL),
(10, 1, 10, 1, 11, '2016-08-26 18:59:36', NULL),
(9, 1, 10, 1, 12, '2016-08-26 18:59:47', NULL),
(11, 1, 10, 1, 13, '2016-08-26 19:00:03', 1),
(12, 1, 10, 1, 14, '2016-08-26 19:00:03', 5),
(13, 2, 11, 1, 15, '2016-08-26 19:07:06', NULL),
(14, 1, 12, 1, 16, '2016-08-26 19:11:50', 5);

INSERT INTO `treatment_masters` (`id`, `treatment_control_id`, `tx_intent`, `target_site_icdo`, `start_date`, `start_date_accuracy`, `finish_date`, `finish_date_accuracy`, `information_source`, `facility`, `notes`, `protocol_master_id`, `participant_id`, `diagnosis_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, 'curative', NULL, '1978-11-01', 'd', '1979-03-01', 'd', 'path report', '', '', NULL, 1, 1, '2012-07-31 15:22:13', 1, '2012-07-31 15:22:13', 1, 0),
(2, 3, 'curative', NULL, '2001-06-23', 'c', NULL, '', 'path report', '', '', NULL, 1, 3, '2012-07-31 15:34:07', 1, '2012-07-31 15:34:07', 1, 0),
(3, 1, 'curative', NULL, '2001-12-01', 'd', NULL, '', '', '', '', NULL, 1, 3, '2012-07-31 15:35:52', 1, '2012-07-31 15:35:52', 1, 0),
(4, 1, 'curative', NULL, '2002-01-01', 'd', NULL, '', '', '', '', 1, 1, 3, '2012-07-31 15:36:24', 1, '2012-07-31 15:36:24', 1, 0),
(5, 3, 'curative', NULL, '2004-06-05', 'c', NULL, '', '', '', '', NULL, 1, 5, '2012-07-31 15:43:21', 1, '2012-07-31 15:43:21', 1, 0),
(6, 2, '', NULL, '2005-10-01', 'd', NULL, '', '', '', '', NULL, 1, 5, '2012-07-31 15:44:12', 1, '2012-07-31 15:44:12', 1, 0),
(7, 3, 'curative', NULL, '2008-08-06', 'c', NULL, '', 'path report', 'Building A', '', NULL, 2, 6, '2012-07-31 18:51:27', 1, '2012-07-31 18:51:27', 1, 0),
(8, 1, 'curative', NULL, '2008-09-03', 'c', '2008-10-12', 'c', '', '', '', 1, 2, 6, '2012-07-31 18:52:14', 1, '2012-07-31 18:52:14', 1, 0),
(9, 1, '', NULL, '2009-03-01', 'd', NULL, '', '', '', '', 1, 2, 7, '2012-07-31 18:53:17', 1, '2012-07-31 18:53:17', 1, 0),
(10, 1, 'curative', NULL, '2009-10-02', 'c', '2010-01-01', 'm', '', '', '', 1, 4, 10, '2016-08-26 18:44:58', 1, '2016-08-26 18:44:58', 1, 0),
(11, 3, 'curative', 'C50', '2009-08-01', 'c', NULL, '', '', 'Building A', '', NULL, 4, 10, '2016-08-26 19:06:16', 1, '2016-08-26 19:06:16', 1, 0),
(12, 1, 'curative', NULL, '2014-09-03', 'c', NULL, '', '', 'Building A', '', NULL, 4, 12, '2016-08-26 19:11:24', 1, '2016-08-26 19:11:24', 1, 0);

INSERT INTO `treatment_masters_revs` (`id`, `treatment_control_id`, `tx_intent`, `target_site_icdo`, `start_date`, `start_date_accuracy`, `finish_date`, `finish_date_accuracy`, `information_source`, `facility`, `notes`, `modified_by`, `protocol_master_id`, `participant_id`, `diagnosis_master_id`, `version_id`, `version_created`) VALUES
(1, 1, 'curative', NULL, '1978-11-01', 'd', '1979-03-01', 'd', 'path report', '', '', 1, NULL, 1, 1, 1, '2012-07-31 15:22:13'),
(2, 3, 'curative', NULL, '2001-06-23', 'c', NULL, '', 'path report', '', '', 1, NULL, 1, 3, 2, '2012-07-31 15:34:07'),
(3, 1, 'curative', NULL, '2001-12-01', 'd', NULL, '', '', '', '', 1, NULL, 1, 3, 3, '2012-07-31 15:35:52'),
(4, 1, 'curative', NULL, '2002-01-01', 'd', NULL, '', '', '', '', 1, 1, 1, 3, 4, '2012-07-31 15:36:24'),
(5, 4, 'curative', NULL, '2004-06-05', 'c', NULL, '', '', '', '', 1, NULL, 1, 5, 5, '2012-07-31 15:43:21'),
(6, 2, '', NULL, '2005-10-01', 'd', NULL, '', '', '', '', 1, NULL, 1, 5, 6, '2012-07-31 15:44:12'),
(7, 3, 'curative', NULL, '2008-08-06', 'c', NULL, '', 'path report', 'Building A', '', 1, NULL, 2, 6, 7, '2012-07-31 18:51:27'),
(8, 1, 'curative', NULL, '2008-09-03', 'c', '2008-10-12', 'c', '', '', '', 1, 1, 2, 6, 8, '2012-07-31 18:52:14'),
(9, 1, '', NULL, '2009-03-01', 'd', NULL, '', '', '', '', 1, 1, 2, 7, 9, '2012-07-31 18:53:17'),
(10, 1, 'curative', NULL, '2009-10-02', 'c', '2010-01-01', 'm', '', '', '', 1, 1, 4, 10, 10, '2016-08-26 18:44:58'),
(11, 3, 'curative', 'C50', '2009-08-01', 'c', NULL, '', '', 'Building A', '', 1, NULL, 4, 10, 11, '2016-08-26 19:06:16'),
(12, 1, 'curative', NULL, '2014-09-03', 'c', NULL, '', '', 'Building A', '', 1, NULL, 4, 12, 12, '2016-08-26 19:11:24');

INSERT INTO `txd_chemos` (`chemo_completed`, `response`, `num_cycles`, `length_cycles`, `completed_cycles`, `treatment_master_id`) VALUES
('yes', 'complete', 3, 2, 3, 1),
('yes', 'stable disease', NULL, NULL, NULL, 3),
('yes', 'stable disease', NULL, NULL, NULL, 4),
('yes', '', NULL, NULL, NULL, 8),
('yes', 'complete', NULL, NULL, NULL, 9),
('yes', 'complete', NULL, NULL, NULL, 10),
('no', '', NULL, NULL, NULL, 12);

INSERT INTO `txd_chemos_revs` (`chemo_completed`, `response`, `num_cycles`, `length_cycles`, `completed_cycles`, `treatment_master_id`, `version_id`, `version_created`) VALUES
('yes', 'complete', 3, 2, 3, 1, 1, '2012-07-31 15:22:13'),
('yes', 'stable disease', NULL, NULL, NULL, 3, 2, '2012-07-31 15:35:53'),
('yes', 'stable disease', NULL, NULL, NULL, 4, 3, '2012-07-31 15:36:24'),
('yes', '', NULL, NULL, NULL, 8, 4, '2012-07-31 18:52:15'),
('yes', 'complete', NULL, NULL, NULL, 9, 5, '2012-07-31 18:53:17'),
('yes', 'complete', NULL, NULL, NULL, 10, 6, '2016-08-26 18:44:58'),
('no', '', NULL, NULL, NULL, 12, 7, '2016-08-26 19:11:24');

INSERT INTO `txd_radiations` (`rad_completed`, `treatment_master_id`) VALUES
('', 6);

INSERT INTO `txd_radiations_revs` (`rad_completed`, `treatment_master_id`, `version_id`, `version_created`) VALUES
('', 6, 1, '2012-07-31 15:44:13');

INSERT INTO `txd_surgeries` (`path_num`, `primary`, `treatment_master_id`) VALUES
('R78EXC', NULL, 2),
('', NULL, 5),
('P938', NULL, 7),
('7855533', NULL, 11);

INSERT INTO `txd_surgeries_revs` (`path_num`, `primary`, `treatment_master_id`, `version_id`, `version_created`) VALUES
('R78EXC', NULL, 2, 1, '2012-07-31 15:34:07'),
('', NULL, 5, 2, '2012-07-31 15:43:21'),
('P938', NULL, 7, 3, '2012-07-31 18:51:27'),
('7855533', NULL, 11, 4, '2016-08-26 19:06:16');

INSERT INTO `txe_chemos` (`dose`, `method`, `treatment_extend_master_id`) VALUES
('', 'IV: Intravenous', 1),
('', 'IV: Intravenous', 2),
('', 'IV: Intravenous', 3),
('', 'IV: Intravenous', 4),
('', 'IV: Intravenous', 5),
('', 'IV: Intravenous', 6),
('', 'IV: Intravenous', 9),
('', 'IV: Intravenous', 10),
('', 'IV: Intravenous', 11),
('', 'IV: Intravenous', 12),
('', 'IV: Intravenous', 14);

INSERT INTO `txe_chemos_revs` (`dose`, `method`, `version_id`, `version_created`, `treatment_extend_master_id`) VALUES
('', 'IV: Intravenous', 1, '2012-07-31 15:29:25', 1),
('', 'IV: Intravenous', 2, '2012-07-31 15:29:26', 2),
('', 'IV: Intravenous', 3, '2012-07-31 15:36:31', 3),
('', 'IV: Intravenous', 4, '2012-07-31 15:36:31', 4),
('', 'IV: Intravenous', 5, '2012-07-31 18:52:21', 5),
('', 'IV: Intravenous', 6, '2012-07-31 18:52:21', 6),
('', 'IV: Intravenous', 7, '2016-08-26 18:45:02', 9),
('', 'IV: Intravenous', 8, '2016-08-26 18:45:03', 10),
('', 'IV: Intravenous', 9, '2016-08-26 18:59:36', 10),
('', 'IV: Intravenous', 10, '2016-08-26 18:59:47', 9),
('', 'IV: Intravenous', 11, '2016-08-26 19:00:03', 11),
('', 'IV: Intravenous', 12, '2016-08-26 19:00:03', 12),
('', 'IV: Intravenous', 13, '2016-08-26 19:11:51', 14);

INSERT INTO `txe_surgeries` (`surgical_procedure`, `treatment_extend_master_id`) VALUES
('SURG-90391', 8),
('Mastectomy bilateral', 13);

INSERT INTO `txe_surgeries_revs` (`surgical_procedure`, `version_id`, `version_created`, `treatment_extend_master_id`) VALUES
('SURG-90391', 1, '2012-07-31 15:34:33', 8),
('Mastectomy bilateral', 2, '2016-08-26 19:07:06', 13);

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
SET FOREIGN_KEY_CHECKS=1;
