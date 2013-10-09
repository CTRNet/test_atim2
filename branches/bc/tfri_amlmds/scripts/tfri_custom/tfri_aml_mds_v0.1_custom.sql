-- TFRI AML/MDS Custom Script
-- Version: v0.1
-- ATiM Version: v2.5.4

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'TFRI AML-MDS v0.1 DEV', '');

-- Enable default users	
UPDATE `users` SET `flag_active`='1' WHERE `username`='administrator';
UPDATE `users` SET `flag_active`='1' WHERE `username`='manager';
UPDATE `users` SET `flag_active`='1' WHERE `username`='user';

/*
	Eventum Issue: #2729 - Participant Form
*/

-- Rename participant identifer, add validation
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('participant identifier', 'Participant Code', '');
	
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES
 ((SELECT `id` FROM `structure_fields` WHERE `field` = 'participant_identifier' AND `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant'), 'custom,/^\\A\\d{4}$/', 'tfri_aml participant code 4 digits');
 
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('tfri_aml participant code 4 digits', 'Participant Code must be 4 digits', '');


-- Rename Sex to Gender, disable other and unknown values
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('sex', 'Gender', '');
	
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='sex' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="u" AND language_alias="unknown");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='sex' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other");

-- Disable unneeded fields
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sex') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='sex' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sex');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='race') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='race' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='race');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_confirmation_source' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='marital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='language_preferred' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='language_preferred') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='', `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='secondary_cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='marital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status') AND `flag_confidential`='0');

-- Add new fields to table
ALTER TABLE `participants` 
	ADD COLUMN `tfri_aml_site_number` TINYINT NULL DEFAULT NULL AFTER `last_chart_checked_date_accuracy`,
	ADD COLUMN `tfri_aml_screening_code` INT NULL DEFAULT NULL AFTER `tfri_aml_site_number`,
	ADD COLUMN `tfri_aml_date_registration` DATE NULL DEFAULT NULL AFTER `tfri_aml_screening_code`,
	ADD COLUMN `tfri_aml_date_day_zero` DATE NULL DEFAULT NULL AFTER `tfri_aml_date_registration`,
	ADD COLUMN `tfri_aml_suspected_disease` VARCHAR(45) NULL DEFAULT NULL AFTER `tfri_aml_date_day_zero`,
	ADD COLUMN `tfri_aml_confirmed_disease` VARCHAR(45) NULL DEFAULT NULL AFTER `tfri_aml_suspected_disease`,
	ADD COLUMN `tfri_aml_english_french` VARCHAR(45) NULL DEFAULT NULL AFTER `tfri_aml_confirmed_disease`,
	ADD COLUMN `tfri_aml_chemo_start` DATE NULL DEFAULT NULL AFTER `tfri_aml_english_french`,
	ADD COLUMN `tfri_aml_standard_regimen` TEXT NULL DEFAULT NULL AFTER `tfri_aml_chemo_start`,
	ADD COLUMN `tfri_aml_date_part_two` DATE NULL DEFAULT NULL AFTER `tfri_aml_standard_regimen`,
	ADD COLUMN `tfri_aml_date_withdrawal` DATE NULL DEFAULT NULL AFTER `tfri_aml_date_part_two`;
	
ALTER TABLE `participants_revs` 
	ADD COLUMN `tfri_aml_site_number` TINYINT NULL DEFAULT NULL AFTER `last_chart_checked_date_accuracy`,
	ADD COLUMN `tfri_aml_screening_code` INT NULL DEFAULT NULL AFTER `tfri_aml_site_number`,
	ADD COLUMN `tfri_aml_date_registration` DATE NULL DEFAULT NULL AFTER `tfri_aml_screening_code`,
	ADD COLUMN `tfri_aml_date_day_zero` DATE NULL DEFAULT NULL AFTER `tfri_aml_date_registration`,
	ADD COLUMN `tfri_aml_suspected_disease` VARCHAR(45) NULL DEFAULT NULL AFTER `tfri_aml_date_day_zero`,
	ADD COLUMN `tfri_aml_confirmed_disease` VARCHAR(45) NULL DEFAULT NULL AFTER `tfri_aml_suspected_disease`,
	ADD COLUMN `tfri_aml_english_french` VARCHAR(45) NULL DEFAULT NULL AFTER `tfri_aml_confirmed_disease`,
	ADD COLUMN `tfri_aml_chemo_start` DATE NULL DEFAULT NULL AFTER `tfri_aml_english_french`,
	ADD COLUMN `tfri_aml_standard_regimen` TEXT NULL DEFAULT NULL AFTER `tfri_aml_chemo_start`,
	ADD COLUMN `tfri_aml_date_part_two` DATE NULL DEFAULT NULL AFTER `tfri_aml_standard_regimen`,
	ADD COLUMN `tfri_aml_date_withdrawal` DATE NULL DEFAULT NULL AFTER `tfri_aml_date_part_two`;

-- Value domains for disease type	 
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("tfri_profile_disease", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("MDS", "tfri MDS");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_profile_disease"), (SELECT id FROM structure_permissible_values WHERE value="MDS" AND language_alias="tfri MDS"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("CMML", "tfri CMML");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_profile_disease"), (SELECT id FROM structure_permissible_values WHERE value="CMML" AND language_alias="tfri CMML"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("AML", "tfri AML");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_profile_disease"), (SELECT id FROM structure_permissible_values WHERE value="AML" AND language_alias="tfri AML"), "1", "1");
		
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri MDS', 'MDS', ''),
 ('tfri CMML', 'CML', ''),
 ('tfri AML', 'AML', '');
 
-- Add new fields
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_site_number', 'integer',  NULL , '0', '', '', '', 'tfri aml site number', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_screening_code', 'integer',  NULL , '0', '', '', '', 'tfri aml screening code', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_date_registration', 'date',  NULL , '0', '', '', '', 'tfri aml date registration', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_date_day_zero', 'date',  NULL , '0', '', '', '', 'tfri aml date day zero', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_suspected_disease', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_profile_disease') , '0', '', '', '', 'tfri aml suspected disease', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_confirmed_disease', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_profile_disease') , '0', '', '', '', 'tfri aml confirmed disease', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_site_number' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml site number' AND `language_tag`=''), '3', '10', 'tfri study summary', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_screening_code' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml screening code' AND `language_tag`=''), '3', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_registration' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml date registration' AND `language_tag`=''), '3', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_day_zero' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml date day zero' AND `language_tag`=''), '3', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_suspected_disease' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_profile_disease')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml suspected disease' AND `language_tag`=''), '3', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_confirmed_disease' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_profile_disease')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml confirmed disease' AND `language_tag`=''), '3', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_english_french', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'tfri aml english french', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_chemo_start', 'date',  NULL , '0', '', '', '', 'tfri aml chemo start', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_standard_regimen', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'tfri aml standard regimen', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_date_part_two', 'date',  NULL , '0', '', '', '', 'tfri aml date part two', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_date_withdrawal', 'date',  NULL , '0', '', '', '', 'tfri aml date withdrawal', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_english_french' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml english french' AND `language_tag`=''), '3', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_chemo_start' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml chemo start' AND `language_tag`=''), '3', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_standard_regimen' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml standard regimen' AND `language_tag`=''), '3', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_part_two' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml date part two' AND `language_tag`=''), '3', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_withdrawal' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml date withdrawal' AND `language_tag`=''), '3', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri study summary', 'Study Summary', ''),
 ('tfri aml site number', 'Site Number', ''),
 ('tfri aml screening code', 'Screening Code', ''),
 ('tfri aml date registration', 'Date of Registration', ''),
 ('tfri aml date day zero', 'Date of Day 0', ''),
 ('tfri aml suspected disease', 'Suspected Disease', ''),
 ('tfri aml confirmed disease', 'Confirmed Disease', ''),
 ('tfri aml english french', 'Understand English or French', ''),
 ('tfri aml chemo start', 'Planned Chemo Start', ''),
 ('tfri aml standard regimen', 'Planned Standard Regimen', ''),
 ('tfri aml date part two', 'Date of Part 2 Enrolment', ''),
 ('tfri aml date withdrawal', 'Date of Withdrawal', '');
 
 
/*
	Eventum Issue: #2737 - Profile - Add validations for site/screening codes
*/
 
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES
 ((SELECT `id` FROM `structure_fields` WHERE `field` = 'tfri_aml_site_number' AND `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant'), 'custom,/^\\A\\d{2}$/', 'tfri_aml site number 2 digits');
 
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('tfri_aml site number 2 digits', 'Site number must be two digits', '');
	
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES
 ((SELECT `id` FROM `structure_fields` WHERE `field` = 'tfri_aml_screening_code' AND `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant'), 'custom,/^\\A\\d{4}$/', 'tfri_aml screening code 4 digits');
 
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('tfri_aml screening code 4 digits', 'Screening code must be four digits', ''); 
	
/*
	Eventum Issue: #2730 - Create control fields for DCF's
*/	

-- Disable current clinical forms
UPDATE `event_controls` SET `flag_active`='0' WHERE `event_type`='follow up';
UPDATE `event_controls` SET `flag_active`='0' WHERE `event_type`='presentation';
UPDATE `event_controls` SET `flag_active`='0' WHERE `event_type`='smoking';
UPDATE `event_controls` SET `flag_active`='0' WHERE `event_type`='comorbidity';

-- Add DCF control forms
INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES
 ('tfri', 'clinical', 'DCF - S1 Baseline', '1', 'ed_tfri_clinical_section_1', 'ed_tfri_clinical_section_1', '0', 'clinical|tfri|section 1', '0'),
 ('tfri', 'clinical', 'DCF - S2 Follow-up 6 Month', '1', 'ed_tfri_clinical_section_2', 'ed_tfri_clinical_section_2', '0', 'clinical|tfri|section 2', '0'),
 ('tfri', 'clinical', 'DCF - S3 Follow-up 12 Month', '1', 'ed_tfri_clinical_section_3', 'ed_tfri_clinical_section_3', '0', 'clinical|tfri|section 3', '0'),
 ('tfri', 'clinical', 'DCF - S4 Follow-up 18 Month', '1', 'ed_tfri_clinical_section_4', 'ed_tfri_clinical_section_4', '0', 'clinical|tfri|section 4', '0'),
 ('tfri', 'clinical', 'DCF - S5 Follow-up 24 Month', '1', 'ed_tfri_clinical_section_5', 'ed_tfri_clinical_section_5', '0', 'clinical|tfri|section 5', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('DCF - S1 Baselin', 'DCF - S1 Baseline', ''),
 ('DCF - S2 Follow-up 6 Month', 'DCF - S2 Follow-up 6 Month', ''),
 ('DCF - S3 Follow-up 12 Month', 'DCF - S3 Follow-up 12 Month', ''),
 ('DCF - S4 Follow-up 18 Month', 'DCF - S4 Follow-up 18 Month', ''),
 ('DCF - S5 Follow-up 24 Month', 'DCF - S5 Follow-up 24 Month', ''),
 ('tfri', 'TFRI', ''); 
 
-- Add structures 
INSERT INTO `structures` (`alias`) VALUES ('ed_tfri_clinical_section_1');
INSERT INTO `structures` (`alias`) VALUES ('ed_tfri_clinical_section_2');
INSERT INTO `structures` (`alias`) VALUES ('ed_tfri_clinical_section_3');
INSERT INTO `structures` (`alias`) VALUES ('ed_tfri_clinical_section_4');
INSERT INTO `structures` (`alias`) VALUES ('ed_tfri_clinical_section_5');

-- Create detail tables
CREATE TABLE `ed_tfri_clinical_section_1` (

  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `ed_tfri_clinical_section_1_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ed_tfri_clinical_section_1_revs` (

  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `ed_tfri_clinical_section_2` (

  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `ed_tfri_clinical_section_2_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ed_tfri_clinical_section_2_revs` (

  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `ed_tfri_clinical_section_3` (

  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `ed_tfri_clinical_section_3_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ed_tfri_clinical_section_3_revs` (

  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `ed_tfri_clinical_section_4` (

  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `ed_tfri_clinical_section_4_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ed_tfri_clinical_section_4_revs` (

  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1; 


CREATE TABLE `ed_tfri_clinical_section_5` (

  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `ed_tfri_clinical_section_5_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ed_tfri_clinical_section_5_revs` (

  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;                