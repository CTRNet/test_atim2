-- TFRI AML/MDS Custom Script
-- Version: v0.2
-- ATiM Version: v2.5.4

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'TFRI AML-MDS v0.3 DEV', '');

/*
	Eventum Issue: #2789 - Vital Status - Default to Alive
*/
	
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='health_status') ,  `default`='alive' WHERE model='Participant' AND tablename='participants' AND field='vital_status' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='health_status');

/*
	Eventum Issue: #2777 - Profile - Screening number validation
*/

-- Change field from INT to VARCHAR. Screening contains alphabetic characters
ALTER TABLE `participants` 
CHANGE COLUMN `tfri_aml_screening_code` `tfri_aml_screening_code` VARCHAR(50) NULL DEFAULT NULL ;

ALTER TABLE `participants_revs` 
CHANGE COLUMN `tfri_aml_screening_code` `tfri_aml_screening_code` VARCHAR(50) NULL DEFAULT NULL ;

UPDATE structure_fields SET  `type`='input',  `setting`='size=8' WHERE model='Participant' AND tablename='participants' AND field='tfri_aml_screening_code' AND `type`='integer' AND structure_value_domain  IS NULL ;

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT `id` FROM `structure_fields` WHERE `field` = 'tfri_aml_screening_code'), 'custom,/^\\A\\d{4}[A-F]$/', 'tfri_aml screening number validation error');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri_aml screening number validation error', 'Screening number must be 4 digits then an upper case site letter', ''),
 ('tfri help screening code', 'Screening number must be 4 digits then an upper case site letter. For example 0001A or 2843C.', ''); 

/*
	Eventum Issue: #2801 - Profile Move - Acknowledgement Section
*/

UPDATE structure_formats SET `display_column` = 2, `display_order` = 70 WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_registration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column` = 2, `display_order` = 75 WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_day_zero' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

/*
	Eventum Issue: #2790 - Profile - Site Letter
*/

ALTER TABLE `participants` 
ADD COLUMN `tfri_site_letter` CHAR(1) NULL DEFAULT NULL AFTER `tfri_aml_site_number`;

ALTER TABLE `participants_revs` 
ADD COLUMN `tfri_site_letter` CHAR(1) NULL DEFAULT NULL AFTER `tfri_aml_site_number`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_site_letter', 'input',  NULL , '0', 'size=5', '', 'tfri help site letter', '', 'tfri site letter');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_site_letter' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='tfri help site letter' AND `language_label`='' AND `language_tag`='tfri site letter'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0');

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT `id` FROM `structure_fields` where `field` = 'tfri_site_letter'), 'custom,/^[ABCDEF]$/', 'tfri_aml site letter validation error');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri site letter', 'Site Letter', ''),
 ('tfri_aml site letter validation error', 'Site letter must be an upper case letter from A to F.', ''),
 ('tfri help site letter', 'Site letter must be an upper case letter between A and F.', '');

/*
	Eventum Issue: #2795 - Consent Status - Two fields
*/

ALTER TABLE `consent_masters` 
ADD COLUMN `tfri_aml_local_consent_status` VARCHAR(45) NULL DEFAULT NULL AFTER `consent_status`;

ALTER TABLE `consent_masters_revs` 
ADD COLUMN `tfri_aml_local_consent_status` VARCHAR(45) NULL DEFAULT NULL AFTER `consent_status`;

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status') AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'tfri_aml_local_consent_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='consent_status') , '0', '', '', 'help_consent_status', 'tfri aml local consent status', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='tfri_aml_local_consent_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_consent_status' AND `language_label`='tfri aml local consent status' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0');

-- Update consent status value domain
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="consent_status"), (SELECT id FROM structure_permissible_values WHERE value="active" AND language_alias="active"), "2", "1");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='consent_status' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="pending" AND language_alias="pending");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='consent_status' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="denied" AND language_alias="denied");
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="obtained" AND spv.language_alias="obtained";
DELETE FROM structure_permissible_values WHERE value="obtained" AND language_alias="obtained";

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('consent status', 'Study Consent Status', ''),
 ('active', 'Active', ''),
 ('tfri aml local consent status', 'Local Consent Status', '');
 
/*
	Eventum Issue: #2812 - Disable clinical menus
*/ 

UPDATE menus SET flag_active=false WHERE id IN('clin_CAN_10', 'clin_CAN_26', 'clin_CAN_68');

/*
	Eventum Issue: #2813 - Rename menu options
*/

UPDATE `menus` SET `language_title`='tfri clinical data treatment', `language_description`='tfri clinical data treatment' WHERE `id`='clin_CAN_75';
UPDATE `menus` SET `language_title`='tfri clinical data general', `language_description`='tfri clinical data general' WHERE `id`='clin_CAN_4';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri clinical data treatment', 'Clinical Data - Treatment', ''),
 ('tfri clinical data general', 'Clinical Data - General', '');
 
/*
	Eventum Issue: #2810 - Diagnosis - MDS form
*/
 
-- Add CMML and Other to drop down for MDS Type 
INSERT INTO structure_permissible_values (value, language_alias) VALUES("cmml", "cmml");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_sub_type"), (SELECT id FROM structure_permissible_values WHERE value="cmml" AND language_alias="cmml"), "8", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_sub_type"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "9", "1");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("mds associated with isolated del", "mds associated with isolated del");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_sub_type"), (SELECT id FROM structure_permissible_values WHERE value="mds associated with isolated del" AND language_alias="mds associated with isolated del"), "7", "1");

-- Add if other field to MDS table
UPDATE structure_formats SET `flag_search`='1', `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tfri_mds') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tfri_mds' AND `field`='tfri_myelodysplastic_subtype' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='mds_sub_type') AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_tfri_mds', 'tfri_other_diagnosis', 'input',  NULL , '0', 'size=30', '', '', 'tfri other diagnosis', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_tfri_mds'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tfri_mds' AND `field`='tfri_other_diagnosis' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='tfri other diagnosis' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `flag_search`='1', `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tfri_mds') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tfri_mds' AND `field`='tfri_myelodysplastic_subtype' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='mds_sub_type') AND `flag_confidential`='0');

-- Help info
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='mds_sub_type') ,  `language_help`='tfri help mds subtype' WHERE model='DiagnosisDetail' AND tablename='dxd_tfri_mds' AND field='tfri_myelodysplastic_subtype' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='mds_sub_type');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('mds', 'MDS', ''),
 ('tfri other diagnosis', 'Other MDS Subtype', ''),
 ('refractory anemia with unilineage dysplasia', 'Refractory anemia with unilineage dysplasia (RCUD)', ''),
 ('refractory anemia with ring sideroblasts', 'Refractory anemia with ring sideroblasts (RARS)', ''),
 ('refractory cytopenia with multilineage dysplasia', 'Refractory cytopenia with multilineage dysplasia (RCMD)', ''),
 ('refractory anemia with excess blasts-1', 'Refractory anemia with excess blasts-1 (RAEB-1)', ''),
 ('refractory anemia with excess blasts-2', 'Refractory anemia with excess blasts-2 (RAEB-2)', ''),
 ('myelodysplastic syndrome - unclassified', 'Myelodysplastic syndrome - unclassified (MDS-U)', ''),
 ('mds associated with isolated del', 'MDS associated with isolated del (5q)', ''),
 ('tfri help mds subtype', 'Diagnosis according to the WHO (2008) criteria.', ''), 
 ('cmml', 'CMML', '');
 
 
/*
	Eventum Issue: #2809 - Diagnosis - AML form
*/

ALTER TABLE `dxd_tfri_aml` 
DROP COLUMN `tfri_t_lymphoblastic`,
DROP COLUMN `tfri_aml_b_lymphoblastic`;

ALTER TABLE `dxd_tfri_aml_revs` 
DROP COLUMN `tfri_t_lymphoblastic`,
DROP COLUMN `tfri_aml_b_lymphoblastic`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_tfri_aml', 'tfri_aml_recurrent_genetic', 'input',  NULL , '0', '', '', '', 'tfri aml recurrent genetic', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_tfri_aml', 'tfri_aml_aml_not_otherwise_categorized', 'input',  NULL , '0', '', '', '', 'tfri aml aml not otherwise categorized', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_tfri_aml', 'tfri_aml_ambiguous_lineage', 'input',  NULL , '0', '', '', '', 'tfri aml ambiguous lineage', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_tfri_aml', 'tfri_aml_myeloid_proliferations', 'input',  NULL , '0', '', '', '', 'tfri aml myeloid proliferations', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_tfri_aml', 'tfri_aml_transform_mds_mdp', 'input',  NULL , '0', '', '', '', 'tfri aml transform mds mdp', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_tfri_aml'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tfri_aml' AND `field`='tfri_aml_recurrent_genetic' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml recurrent genetic' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_tfri_aml'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tfri_aml' AND `field`='tfri_aml_aml_not_otherwise_categorized' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml aml not otherwise categorized' AND `language_tag`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_tfri_aml'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tfri_aml' AND `field`='tfri_aml_ambiguous_lineage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml ambiguous lineage' AND `language_tag`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_tfri_aml'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tfri_aml' AND `field`='tfri_aml_myeloid_proliferations' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml myeloid proliferations' AND `language_tag`=''), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_tfri_aml'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tfri_aml' AND `field`='tfri_aml_transform_mds_mdp' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml transform mds mdp' AND `language_tag`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');


REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('aml', 'AML', ''),
 ('tfri aml recurrent genetic', 'AML with Recurrent Genetic Abnormalities', ''),
 ('tfri aml aml not otherwise categorized', 'AML Not Otherwise Categorized', ''),
 ('tfri aml ambiguous lineage', 'AML of Ambiguous Lineage', ''),
 ('tfri aml myeloid proliferations', 'Myeloid Proliferations Related to Down Syndrome', ''), 
 ('tfri aml transform mds mdp', 'Did AML Transform from MDS/MDP?', '');
 
/*
	Eventum Issue: #2814 - Diagnosis - Other Types
*/ 

INSERT INTO `diagnosis_controls` (`category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES ('primary', 'other', '1', 'dx_primary,dx_tfri_other', 'dxd_tfri_other', '3', 'primary|other', '0');

INSERT INTO `structures` (`alias`) VALUES ('dx_tfri_other');

CREATE TABLE `dxd_tfri_other` (
  `tfri_b_lyphoblastic_leukemia_lymphoma` varchar(255) DEFAULT NULL,
  `tfri_t_lyphoblastic_leukemia_lymphoma` varchar(255) DEFAULT NULL,
  `tfri_other_diagnosis` varchar(255) DEFAULT NULL,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dxd_tfri_other_revs` (
  `tfri_b_lyphoblastic_leukemia_lymphoma` varchar(255) DEFAULT NULL,
  `tfri_t_lyphoblastic_leukemia_lymphoma` varchar(255) DEFAULT NULL,
  `tfri_other_diagnosis` varchar(255) DEFAULT NULL,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_tfri_other', 'tfri_b_lyphoblastic_leukemia_lymphoma', 'input',  NULL , '0', '', '', '', 'tfri b lyphoblastic leukemia lymphoma', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_tfri_other', 'tfri_t_lyphoblastic_leukemia_lymphoma', 'input',  NULL , '0', '', '', '', 'tfri t lyphoblastic leukemia lymphoma', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_tfri_other', 'tfri_other_diagnosis', 'input',  NULL , '0', '', '', '', 'tfri other diagnosis', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_tfri_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tfri_other' AND `field`='tfri_b_lyphoblastic_leukemia_lymphoma' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri b lyphoblastic leukemia lymphoma' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_tfri_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tfri_other' AND `field`='tfri_t_lyphoblastic_leukemia_lymphoma' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri t lyphoblastic leukemia lymphoma' AND `language_tag`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_tfri_other'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tfri_other' AND `field`='tfri_other_diagnosis' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri other diagnosis' AND `language_tag`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri b lyphoblastic leukemia lymphoma', 'B Lymphoblastic Leukemia/Lymphoma', ''),
 ('tfri t lyphoblastic leukemia lymphoma', 'T Lymphoblastic Leukemia/Lymphoma', ''),
 ('tfri other diagnosis', 'Other Diagnosis', '');
 
/*
	Eventum Issue: #2796 - Diagnosis - Recurrence Forms
*/ 
 
UPDATE `diagnosis_controls` SET `flag_active`='1' WHERE `category`='recurrence';
UPDATE `diagnosis_controls` SET `detail_form_alias`='dx_recurrence,dx_tfri_recurrence' WHERE `category`='recurrence';
UPDATE `diagnosis_controls` SET `controls_type`='tfri relapse' WHERE `category`='recurrence';

INSERT INTO `structures` (`alias`) VALUES ('dx_tfri_recurrence');

ALTER TABLE `dxd_recurrences` 
ADD COLUMN `tfri_method_peripheral_blood` VARCHAR(10) NULL DEFAULT NULL AFTER `diagnosis_master_id`,
ADD COLUMN `tfri_method_bm_aspirate_biopsy` VARCHAR(10) NULL DEFAULT NULL AFTER `tfri_method_peripheral_blood`,
ADD COLUMN `tfri_method_fish` VARCHAR(10) NULL DEFAULT NULL AFTER `tfri_method_bm_aspirate_biopsy`,
ADD COLUMN `tfri_method_flow_cytometry` VARCHAR(10) NULL DEFAULT NULL AFTER `tfri_method_fish`,
ADD COLUMN `tfri_method_molecular_test` VARCHAR(10) NULL DEFAULT NULL AFTER `tfri_method_flow_cytometry`,
ADD COLUMN `tfri_method_other` VARCHAR(10) NULL DEFAULT NULL AFTER `tfri_method_molecular_test`,
ADD COLUMN `tfri_method_other_details` VARCHAR(255) NULL DEFAULT NULL AFTER `tfri_method_other`;

ALTER TABLE `dxd_recurrences_revs` 
ADD COLUMN `tfri_method_peripheral_blood` VARCHAR(10) NULL DEFAULT NULL AFTER `diagnosis_master_id`,
ADD COLUMN `tfri_method_bm_aspirate_biopsy` VARCHAR(10) NULL DEFAULT NULL AFTER `tfri_method_peripheral_blood`,
ADD COLUMN `tfri_method_fish` VARCHAR(10) NULL DEFAULT NULL AFTER `tfri_method_bm_aspirate_biopsy`,
ADD COLUMN `tfri_method_flow_cytometry` VARCHAR(10) NULL DEFAULT NULL AFTER `tfri_method_fish`,
ADD COLUMN `tfri_method_molecular_test` VARCHAR(10) NULL DEFAULT NULL AFTER `tfri_method_flow_cytometry`,
ADD COLUMN `tfri_method_other` VARCHAR(10) NULL DEFAULT NULL AFTER `tfri_method_molecular_test`,
ADD COLUMN `tfri_method_other_details` VARCHAR(255) NULL DEFAULT NULL AFTER `tfri_method_other`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_recurrences', 'tfri_method_peripheral_blood', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'tfri method peripheral blood', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_recurrences', 'tfri_method_bm_aspirate_biopsy', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'tfri method bm aspirate biopsy', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_recurrences', 'tfri_method_fish', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'tfri method fish', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_recurrences', 'tfri_method_flow_cytometry', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'tfri method flow cytometry', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_recurrences', 'tfri_method_molecular_test', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'tfri method molecular test', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_recurrences', 'tfri_method_other', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'tfri method other', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_tfri_recurrence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_recurrences' AND `field`='tfri_method_peripheral_blood' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri method peripheral blood' AND `language_tag`=''), '1', '10', 'tfri method relapse confirmed', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_tfri_recurrence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_recurrences' AND `field`='tfri_method_bm_aspirate_biopsy' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri method bm aspirate biopsy' AND `language_tag`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_tfri_recurrence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_recurrences' AND `field`='tfri_method_fish' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri method fish' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_tfri_recurrence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_recurrences' AND `field`='tfri_method_flow_cytometry' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri method flow cytometry' AND `language_tag`=''), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_tfri_recurrence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_recurrences' AND `field`='tfri_method_molecular_test' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri method molecular test' AND `language_tag`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_tfri_recurrence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_recurrences' AND `field`='tfri_method_other' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri method other' AND `language_tag`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_recurrences', 'tfri_method_other_details', 'input',  NULL , '0', 'size=30', '', '', '', 'tfri method other details');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_tfri_recurrence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_recurrences' AND `field`='tfri_method_other_details' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='tfri method other details'), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri relapse', 'Section 12: Relapse', ''),
 ('tfri method relapse confirmed', 'Method relapse was confirmed', ''),
 ('tfri method peripheral blood', 'Peripheral blood CBC (blast count)', ''),
 ('tfri method bm aspirate biopsy', 'Bone marrow aspirate & biopsy', ''),
 ('tfri method fish', 'FISH', ''),
 ('tfri method flow cytometry', 'Flow cytometry', ''),
 ('tfri method molecular test', 'Molecular test (PCR, FLT-3, etc)', ''),
 ('tfri method other', 'Other', ''),
 ('tfri method other details', 'If other method', '');
 
/*
	Eventum Issue: #2815 - Disable sample types not used
*/  

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 142, 143, 141, 144, 139, 140);