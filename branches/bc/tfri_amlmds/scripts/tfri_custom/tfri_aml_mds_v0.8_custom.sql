-- TFRI AML/MDS Custom Script
-- Version: v0.8
-- ATiM Version: v2.5.4

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'TFRI MDS/AML Biobank v0.8 DEV', '');


-- Eventum ID: #3009 - S8 Transplant 8.1
	
UPDATE structure_fields SET  `tablename`='ed_tfri_clinical_transplant' WHERE model='EventDetail' AND tablename='ed_tfri_study_eq_5d_health' AND field='date_of_transplant' AND `type`='date' AND structure_value_domain  IS NULL ;

ALTER TABLE `ed_tfri_clinical_transplant` 
ADD COLUMN `date_of_transplant` DATE NULL DEFAULT NULL AFTER `transplant_type`;

ALTER TABLE `ed_tfri_clinical_transplant_revs` 
ADD COLUMN `date_of_transplant` DATE NULL DEFAULT NULL AFTER `transplant_type`;

-- Eventum ID: #3010 - EQ-5D String length
ALTER TABLE `ed_tfri_study_eq_5d_health` 
CHANGE COLUMN `method_of_completion` `method_of_completion` VARCHAR(100) NULL DEFAULT NULL ,
CHANGE COLUMN `followup_period` `followup_period` VARCHAR(100) NULL DEFAULT NULL ,
CHANGE COLUMN `mobility` `mobility` VARCHAR(100) NULL DEFAULT NULL ,
CHANGE COLUMN `self-care` `self-care` VARCHAR(100) NULL DEFAULT NULL ,
CHANGE COLUMN `usual_activities` `usual_activities` VARCHAR(100) NULL DEFAULT NULL ,
CHANGE COLUMN `pain_discomfort` `pain_discomfort` VARCHAR(100) NULL DEFAULT NULL ,
CHANGE COLUMN `anxiety_depression` `anxiety_depression` VARCHAR(100) NULL DEFAULT NULL ;

ALTER TABLE `ed_tfri_study_eq_5d_health_revs` 
CHANGE COLUMN `method_of_completion` `method_of_completion` VARCHAR(100) NULL DEFAULT NULL ,
CHANGE COLUMN `followup_period` `followup_period` VARCHAR(100) NULL DEFAULT NULL ,
CHANGE COLUMN `mobility` `mobility` VARCHAR(100) NULL DEFAULT NULL ,
CHANGE COLUMN `self-care` `self-care` VARCHAR(100) NULL DEFAULT NULL ,
CHANGE COLUMN `usual_activities` `usual_activities` VARCHAR(100) NULL DEFAULT NULL ,
CHANGE COLUMN `pain_discomfort` `pain_discomfort` VARCHAR(100) NULL DEFAULT NULL ,
CHANGE COLUMN `anxiety_depression` `anxiety_depression` VARCHAR(100) NULL DEFAULT NULL ;

-- Eventum ID: #3007 - S8 transplant 8.7
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_graft_manipulated"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "7", "1");


-- Eventum ID: #3000 - S2 Month 6 Follow-Up (2.14)
ALTER TABLE `ed_tfri_clinical_section_2` 
CHANGE COLUMN `study_type` `study_type_hematologic_malignancy` VARCHAR(45) NULL DEFAULT NULL ,
ADD COLUMN `study_type_prevention_gvhd` VARCHAR(45) NULL DEFAULT NULL AFTER `study_type_hematologic_malignancy`,
ADD COLUMN `study_type_treatment_gvhd` VARCHAR(45) NULL DEFAULT NULL AFTER `study_type_prevention_gvhd`,
ADD COLUMN `study_type_infection_prophylaxis` VARCHAR(45) NULL DEFAULT NULL AFTER `study_type_treatment_gvhd`,
ADD COLUMN `study_type_infection_treatment` VARCHAR(45) NULL DEFAULT NULL AFTER `study_type_infection_prophylaxis`,
ADD COLUMN `study_type_observational_other` VARCHAR(100) NULL DEFAULT NULL AFTER `study_type_infection_treatment`,
ADD COLUMN `study_type_other_specify` VARCHAR(100) NULL DEFAULT NULL AFTER `study_type_other`;

ALTER TABLE `ed_tfri_clinical_section_2_revs` 
CHANGE COLUMN `study_type` `study_type_hematologic_malignancy` VARCHAR(45) NULL DEFAULT NULL ,
ADD COLUMN `study_type_prevention_gvhd` VARCHAR(45) NULL DEFAULT NULL AFTER `study_type_hematologic_malignancy`,
ADD COLUMN `study_type_treatment_gvhd` VARCHAR(45) NULL DEFAULT NULL AFTER `study_type_prevention_gvhd`,
ADD COLUMN `study_type_infection_prophylaxis` VARCHAR(45) NULL DEFAULT NULL AFTER `study_type_treatment_gvhd`,
ADD COLUMN `study_type_infection_treatment` VARCHAR(45) NULL DEFAULT NULL AFTER `study_type_infection_prophylaxis`,
ADD COLUMN `study_type_observational_other` VARCHAR(100) NULL DEFAULT NULL AFTER `study_type_infection_treatment`,
ADD COLUMN `study_type_other_specify` VARCHAR(100) NULL DEFAULT NULL AFTER `study_type_other`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'study_type_hematologic_malignancy', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'study type hematologic malignancy', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'study_type_prevention_gvhd', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'study type prevention gvhd', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'study_type_infection_prophylaxis', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'study type infection prophylaxis', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'study_type_infection_treatment', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'study type infection treatment', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'study_type_observational', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'study type observational', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'study_type_observational_other', 'input',  NULL , '0', 'size=20', '', '', '', 'study type observational other'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'study_type_other_specify', 'input',  NULL , '0', 'size=20', '', '', '', 'study type other specify');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_hematologic_malignancy' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study type hematologic malignancy' AND `language_tag`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_prevention_gvhd' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study type prevention gvhd' AND `language_tag`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_infection_prophylaxis' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study type infection prophylaxis' AND `language_tag`=''), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_infection_treatment' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study type infection treatment' AND `language_tag`=''), '1', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_observational' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study type observational' AND `language_tag`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_observational_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='study type observational other'), '1', '76', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_other_specify' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='study type other specify'), '1', '78', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_fields SET  `type`='checkbox',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') ,  `setting`='' WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_2' AND field='study_type_other' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='77' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='79' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='investigational_therapy_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='involvement in clinical trials' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='other_study_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_trial_type') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='77' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_other' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='2.14 type of study' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_hematologic_malignancy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type' AND `language_label`='study type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='study_trial_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type' AND `language_label`='study type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='study_trial_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type' AND `language_label`='study type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='study_trial_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='74' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_infection_prophylaxis' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='73' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_infection_treatment' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_observational' AND `language_label`='' AND `language_tag`='study type observational' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_observational' AND `language_label`='' AND `language_tag`='study type observational' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_observational' AND `language_label`='' AND `language_tag`='study type observational' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'study_type_treatment_gvhd', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'study type treatment gvhd', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_treatment_gvhd' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study type treatment gvhd' AND `language_tag`=''), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

UPDATE structure_formats SET `display_order`='74' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_infection_treatment' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='75' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_infection_prophylaxis' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='75' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_infection_treatment' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='74' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_infection_prophylaxis' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='76' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_observational' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='77' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_observational_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='78' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_other' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='79' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_other_specify' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='80' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='investigational_therapy_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='82' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='karnofsky_performance_3month' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='kps_options') AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('2.14 type of study', '2.14 What type of study and/or clinical trial?', ''),
 ('study type hematologic malignancy', 'Treatment of hematologic malignancy', ''),
 ('study type prevention gvhd', 'Prevention of GVHD', ''),
 ('study type infection prophylaxis', 'Infection prophylaxis', ''),
 ('study type infection treatment', 'Infection treatment', ''),
 ('study type treatment gvhd', 'Treatment GVHD', ''),
 ('study type observational other', 'If other observational type, specify', ''),
 ('study type other specify', 'If other study type, specify', ''),    
 ('study type observational', 'Observational and/or sample collection', ''), 
 ('study type other', 'Other study and/or clinical trial', ''); 

-- Eventum ID: #2998 - S2 Followup - NA checkboxes
ALTER TABLE `ed_tfri_clinical_section_2` 
ADD COLUMN `date_of_death_unknown` VARCHAR(45) NULL DEFAULT NULL AFTER `date_of_death`,
ADD COLUMN `date_of_diagnosis_unknown` VARCHAR(45) NULL DEFAULT NULL AFTER `dodx_new_malignancy`;

ALTER TABLE `ed_tfri_clinical_section_2_revs` 
ADD COLUMN `date_of_death_unknown` VARCHAR(45) NULL DEFAULT NULL AFTER `date_of_death`,
ADD COLUMN `date_of_diagnosis_unknown` VARCHAR(45) NULL DEFAULT NULL AFTER `dodx_new_malignancy`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'date_of_diagnosis_unknown', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', '', 'date of diagnosis unknown'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'date_of_death_unknown', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', '', 'date of death unknown');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='date_of_diagnosis_unknown' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='date of diagnosis unknown'), '1', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='date_of_death_unknown' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='date of death unknown'), '1', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('date of diagnosis unknown', 'Unknown date of diagnosis', ''),
 ('date of death unknown', 'Unknown date of death', '');
 
-- Eventum ID: #2997 S2 Followup - Change checkboxes
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_2' AND field='chemo_treatment_status' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_2' AND field='radiation_treatment_status' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_2' AND field='disease_status' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_2' AND field='hpct_status' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_2' AND field='new_malignancy_status' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_2' AND field='tx_for_new_malignancy' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_2' AND field='participant_vs_status' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_2' AND field='investigational_therapy_status' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_2' AND field='other_study_status' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');


-- Eventum ID: #2999 KPS Unknown checkbox and #2989 KPS Values
INSERT INTO structure_permissible_values (value, language_alias) VALUES("100", "100 normal, no complaints or evidence of disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="100" AND language_alias="100 normal, no complaints or evidence of disease"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("90", "90 able to perform normal activity; minor signs and symptoms of disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="90" AND language_alias="90 able to perform normal activity; minor signs and symptoms of disease"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("80", "80 able to perform normal activity with effort; some signs and symptoms of disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="80" AND language_alias="80 able to perform normal activity with effort; some signs and symptoms of disease"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("70", "70 cares for self, unable to perform normal activity or to do active work");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="70" AND language_alias="70 cares for self, unable to perform normal activity or to do active work"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("60", "60 requires occasional assistance but is able to care for most of own needs");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="60" AND language_alias="60 requires occasional assistance but is able to care for most of own needs"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("50", "50 requires considerable assistance and frequent medical care");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="50" AND language_alias="50 requires considerable assistance and frequent medical care"), "6", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("40", "40 requires special care and assistance; disabled");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="40" AND language_alias="40 requires special care and assistance; disabled"), "7", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("30", "30 hospitalization indicated, although death not imminent; severely disabled");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="30" AND language_alias="30 hospitalization indicated, although death not imminent; severely disabled"), "8", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("20", "20 hospitalization necessary; active supportive treatment required, very sick");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="20" AND language_alias="20 hospitalization necessary; active supportive treatment required, very sick"), "9", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("10", "10 fatal processess progressing rapidly; moribund");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="10" AND language_alias="10 fatal processess progressing rapidly; moribund"), "10", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("0", "0 dead");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="0 dead"), "11", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("unknown/not done", "unknown/not done");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="unknown/not done" AND language_alias="unknown/not done"), "12", "1");
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="100 normal, no complaints or evidence of disease" AND spv.language_alias="100 normal, no complaints or evidence of disease";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="90 able to perform normal activity; minor signs and symptoms of disease" AND spv.language_alias="90 able to perform normal activity; minor signs and symptoms of disease";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="80 able to perform normal activity with effort; some signs and symptoms of disease" AND spv.language_alias="80 able to perform normal activity with effort; some signs and symptoms of disease";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="70 cares for self, unable to perform normal activity or to do active work" AND spv.language_alias="70 cares for self, unable to perform normal activity or to do active work";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="60 requires occasional assistance but is able to care for most of own needs" AND spv.language_alias="60 requires occasional assistance but is able to care for most of own needs";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="50 requires considerable assistance and frequent medical care" AND spv.language_alias="50 requires considerable assistance and frequent medical care";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="40 requires special care and assistance; disabled" AND spv.language_alias="40 requires special care and assistance; disabled";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="30 hospitalization indicated, although death not imminent; severely disabled" AND spv.language_alias="30 hospitalization indicated, although death not imminent; severely disabled";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="20 hospitalization necessary; active supportive treatment required, very sick" AND spv.language_alias="20 hospitalization necessary; active supportive treatment required, very sick";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="10 fatal processess progressing rapidly; moribund" AND spv.language_alias="10 fatal processess progressing rapidly; moribund";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="0 dead" AND spv.language_alias="0 dead";
DELETE FROM structure_permissible_values WHERE value="100 normal, no complaints or evidence of disease" AND language_alias="100 normal, no complaints or evidence of disease";
DELETE FROM structure_permissible_values WHERE value="90 able to perform normal activity; minor signs and symptoms of disease" AND language_alias="90 able to perform normal activity; minor signs and symptoms of disease";
DELETE FROM structure_permissible_values WHERE value="80 able to perform normal activity with effort; some signs and symptoms of disease" AND language_alias="80 able to perform normal activity with effort; some signs and symptoms of disease";
DELETE FROM structure_permissible_values WHERE value="70 cares for self, unable to perform normal activity or to do active work" AND language_alias="70 cares for self, unable to perform normal activity or to do active work";
DELETE FROM structure_permissible_values WHERE value="60 requires occasional assistance but is able to care for most of own needs" AND language_alias="60 requires occasional assistance but is able to care for most of own needs";
DELETE FROM structure_permissible_values WHERE value="50 requires considerable assistance and frequent medical care" AND language_alias="50 requires considerable assistance and frequent medical care";
DELETE FROM structure_permissible_values WHERE value="40 requires special care and assistance; disabled" AND language_alias="40 requires special care and assistance; disabled";
DELETE FROM structure_permissible_values WHERE value="30 hospitalization indicated, although death not imminent; severely disabled" AND language_alias="30 hospitalization indicated, although death not imminent; severely disabled";
DELETE FROM structure_permissible_values WHERE value="20 hospitalization necessary; active supportive treatment required, very sick" AND language_alias="20 hospitalization necessary; active supportive treatment required, very sick";
DELETE FROM structure_permissible_values WHERE value="10 fatal processess progressing rapidly; moribund" AND language_alias="10 fatal processess progressing rapidly; moribund";
DELETE FROM structure_permissible_values WHERE value="0 dead" AND language_alias="0 dead";

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('unknown/not done', 'Unknown/not done', '');
 
-- Eventum ID: #2993 S1 Baseline 1.32 - Missing item 
ALTER TABLE `ed_tfri_clinical_section_1` 
ADD COLUMN `oth_malignancy_than_study` VARCHAR(45) NULL DEFAULT NULL AFTER `other_exposure_history`;
ALTER TABLE `ed_tfri_clinical_section_1_revs` 
ADD COLUMN `oth_malignancy_than_study` VARCHAR(45) NULL DEFAULT NULL AFTER `other_exposure_history`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_than_study', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') , '0', '', '', '', 'oth malignancy than study', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_than_study' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy than study' AND `language_tag`=''), '1', '152', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

UPDATE structure_formats SET `language_heading`='other previous malignancies' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_than_study' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_leukemia' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('oth malignancy than study', '1.32 History of malignancy... (see website form for full text)', ''),
 ('other previous malignancies', 'Other malignancies', '');
 
-- Eventum ID: #2992 S1 Baseline - 1.30
ALTER TABLE `ed_tfri_clinical_section_1` 
ADD COLUMN `date_of_leukapheresis_not_applicable` VARCHAR(45) NULL DEFAULT NULL AFTER `date_of_leukapheresis`;
ALTER TABLE `ed_tfri_clinical_section_1_revs` 
ADD COLUMN `date_of_leukapheresis_not_applicable` VARCHAR(45) NULL DEFAULT NULL AFTER `date_of_leukapheresis`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'date_of_leukapheresis_not_applicable', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', '', 'date of leukapheresis not applicable');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='date_of_leukapheresis_not_applicable' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='date of leukapheresis not applicable'), '1', '148', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_fields SET  `model`='EventDetail' WHERE model='Participant' AND tablename='ed_tfri_clinical_section_1' AND field='flt_tkd_date_collection' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='flt_date_collection_options')  WHERE model='Participant' AND tablename='ed_tfri_clinical_section_1' AND field='flt_tkd_date_collection_status' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='flt_date_collection_options');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('date of leukapheresis not applicable', 'Leukapheresis not applicable', '');
 
-- Eventum ID: #2992 S1 Baseline - 1.37
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('years smoked unknown', 'Duration unknown or not applicable', '');

-- Eventum ID: #2990 S1 Baseline - Fix units
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('hemoglobin', '1.23 Hemoglobin (g/L)', ''),
 ('hematocrit', '1.24 Hematocrit (L/L)', '');

-- Eventum ID: #2996 S1 Baseline (1.13, 1.15, 1.17, 1.23, 1.25)
ALTER TABLE `ed_tfri_clinical_section_1` 
CHANGE COLUMN `ast_sgot` `ast_sgot` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `total_bilirubin` `total_bilirubin` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `creatinine` `creatinine` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `hemoglobin` `hemoglobin` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `platelets` `platelets` INT(11) NULL DEFAULT NULL ;

ALTER TABLE `ed_tfri_clinical_section_1_revs` 
CHANGE COLUMN `ast_sgot` `ast_sgot` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `total_bilirubin` `total_bilirubin` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `creatinine` `creatinine` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `hemoglobin` `hemoglobin` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `platelets` `platelets` INT(11) NULL DEFAULT NULL ;

UPDATE structure_fields SET  `type`='integer' WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_1' AND field='ast_sgot' AND `type`='float' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='integer' WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_1' AND field='total_bilirubin' AND `type`='float' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='integer' WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_1' AND field='creatinine' AND `type`='float' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='integer' WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_1' AND field='hemoglobin' AND `type`='float' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='integer' WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_1' AND field='platelets' AND `type`='float' AND structure_value_domain  IS NULL ;

-- Eventum ID: #2988 Consent Site 4 - Field error
UPDATE structure_fields SET  `model`='ConsentDetail' WHERE model='Participant' AND tablename='cd_tfri_aml_mds' AND field='tfri_intercellular_not_applicable' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
UPDATE structure_fields SET  `model`='ConsentDetail' WHERE model='Participant' AND tablename='cd_tfri_aml_mds' AND field='tfri_other_research_not_applicable' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');

-- Eventum ID: #2965 Aliquot - Detail form hide field
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Eventum ID: #3005 Aliquot - Radiation labels
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('location tumour specific', 'Location', ''),
 ('total body', 'Total body', ''),
 ('tumour specific', 'Tumour specific', ''),
 ('location other', 'Location of tumour', ''),
 ('dose per fraction', 'Dose per fraction (Gy)', '');  
 
-- Eventum ID: #3002 Chemo clinical trial options 
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  WHERE model='TreatmentExtend' AND tablename='txe_radiations' AND field='part_clinical_trial' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  WHERE model='TreatmentExtend' AND tablename='txe_chemos' AND field='part_clinical_trial' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');

-- Eventum ID: #2924 Blood sample fields
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='tfri_blood_tube_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
 
-- Eventum ID: #3004 Chemo treatment
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('therapy start date', 'Start date', ''),
 ('therapy end date', 'End date', '');
 
-- Eventum ID: #3001 Chemo frequency options
ALTER TABLE `txe_chemos` 
ADD COLUMN `frequency_per_week` VARCHAR(45) NULL DEFAULT NULL AFTER `frequency`,
ADD COLUMN `frequency_custom_period` VARCHAR(45) NULL DEFAULT NULL AFTER `frequency_per_week`;
ALTER TABLE `txe_chemos_revs` 
ADD COLUMN `frequency_per_week` VARCHAR(45) NULL DEFAULT NULL AFTER `frequency`,
ADD COLUMN `frequency_custom_period` VARCHAR(45) NULL DEFAULT NULL AFTER `frequency_per_week`;

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("frequency_per_week", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("1x per week", "1x per week");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="frequency_per_week"), (SELECT id FROM structure_permissible_values WHERE value="1x per week" AND language_alias="1x per week"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("2x per week", "2x per week");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="frequency_per_week"), (SELECT id FROM structure_permissible_values WHERE value="2x per week" AND language_alias="2x per week"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("3x per week", "3x per week");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="frequency_per_week"), (SELECT id FROM structure_permissible_values WHERE value="3x per week" AND language_alias="3x per week"), "3", "1");

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='dose' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='route_units') AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtend', 'txe_chemos', 'frequency_per_week', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='frequency_per_week') , '0', '', '', '', 'frequency per week', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txe_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='frequency_per_week' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='frequency_per_week')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='frequency per week' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("frequency_custom_period", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("2 days per time period", "2 days per time period");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="frequency_custom_period"), (SELECT id FROM structure_permissible_values WHERE value="2 days per time period" AND language_alias="2 days per time period"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("3 days per time period", "3 days per time period");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="frequency_custom_period"), (SELECT id FROM structure_permissible_values WHERE value="3 days per time period" AND language_alias="3 days per time period"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("4 days per time period", "4 days per time period");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="frequency_custom_period"), (SELECT id FROM structure_permissible_values WHERE value="4 days per time period" AND language_alias="4 days per time period"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("5 days per time period", "5 days per time period");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="frequency_custom_period"), (SELECT id FROM structure_permissible_values WHERE value="5 days per time period" AND language_alias="5 days per time period"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("6 days per time period", "6 days per time period");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="frequency_custom_period"), (SELECT id FROM structure_permissible_values WHERE value="6 days per time period" AND language_alias="6 days per time period"), "5", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtend', 'txe_chemos', 'frequency_custom_period', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='frequency_custom_period') , '0', '', '', '', 'frequency custom period', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txe_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='frequency_custom_period' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='frequency_custom_period')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='frequency custom period' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtend', 'txe_chemos', 'freq_other', 'input',  NULL , '0', '', '', '', 'freq other', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txe_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='freq_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='freq other' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('frequency per week', 'Per week', ''),
 ('frequency custom period', 'Per period', ''),
 ('1x per week', '1x per week', ''),
 ('2x per week', '2x per week', ''),  
 ('3x per week', '3x per week', ''),
 ('2 days per time period', '2 days per time period', ''),
 ('3 days per time period', '3 days per time period', ''),
 ('4 days per time period', '4 days per time period', ''), 
 ('5 days per time period', '5 days per time period', ''),
 ('6 days per time period', '6 days per time period', ''),
 ('freq other', 'Frequency if other', '');          

-- Eventum ID: #3006 Radiation frequency options
ALTER TABLE `txe_radiations` 
ADD COLUMN `frequency_per_week` VARCHAR(45) NULL DEFAULT NULL AFTER `frequency`,
ADD COLUMN `frequency_custom_period` VARCHAR(45) NULL DEFAULT NULL AFTER `frequency_per_week`;
ALTER TABLE `txe_radiations_revs` 
ADD COLUMN `frequency_per_week` VARCHAR(45) NULL DEFAULT NULL AFTER `frequency`,
ADD COLUMN `frequency_custom_period` VARCHAR(45) NULL DEFAULT NULL AFTER `frequency_per_week`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtend', 'txe_radiations', 'frequency_per_week', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='frequency_per_week') , '0', '', '', '', 'frequency per week', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txe_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='frequency_per_week' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='frequency_per_week')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='frequency per week' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtend', 'txe_radiations', 'frequency_custom_period', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='frequency_custom_period') , '0', '', '', '', 'frequency custom period', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txe_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='frequency_custom_period' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='frequency_custom_period')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='frequency custom period' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtend', 'txe_radiations', 'freq_other', 'input',  NULL , '0', '', '', '', 'freq other', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txe_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='freq_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='freq other' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

