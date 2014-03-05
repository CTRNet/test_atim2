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
	Eventum Issue: #2752 - Participant Identifier Validation and label
*/

-- Rename participant identifer, add validation
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('participant identifier', 'Participant Code', '');
	
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES
 ((SELECT `id` FROM `structure_fields` WHERE `field` = 'participant_identifier' AND `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant'), 'range,999,1600', 'tfri_aml error participant code range');
 
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('tfri_aml error participant code range', 'Participant Code must be between 1000 and 1600', '');


/*
	Eventum Issue: #2729 - Participant Form
*/

-- Rename Sex to Gender, disable other and unknown values
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('sex', 'Gender', '');
	
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='sex' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="u" AND language_alias="unknown");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='sex' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other");

-- Disable unneeded fields
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sex') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='sex' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sex');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='race') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='race' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='race');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
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
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Add new fields to table
ALTER TABLE `participants` 
	ADD COLUMN `tfri_aml_site_number` TINYINT NULL DEFAULT NULL AFTER `last_chart_checked_date_accuracy`,
	ADD COLUMN `tfri_aml_screening_code` INT NULL DEFAULT NULL AFTER `tfri_aml_site_number`,
	ADD COLUMN `tfri_aml_date_registration` DATE NULL DEFAULT NULL AFTER `tfri_aml_screening_code`,
	ADD COLUMN `tfri_aml_date_day_zero` DATE NULL DEFAULT NULL AFTER `tfri_aml_date_registration`,
	ADD COLUMN `tfri_aml_registration_diagnosis` VARCHAR(45) NULL DEFAULT NULL AFTER `tfri_aml_date_day_zero`,
	ADD COLUMN `tfri_aml_other_diagnosis` VARCHAR(200) NULL DEFAULT NULL AFTER `tfri_aml_registration_diagnosis`,
	ADD COLUMN `tfri_aml_english_french` VARCHAR(45) NULL DEFAULT NULL AFTER `tfri_aml_other_diagnosis`,
	ADD COLUMN `tfri_aml_chemo_start` DATE NULL DEFAULT NULL AFTER `tfri_aml_english_french`,
	ADD COLUMN `tfri_aml_chemo_start_unknown` VARCHAR(10) NULL DEFAULT NULL AFTER `tfri_aml_chemo_start`,
	ADD COLUMN `tfri_aml_standard_regimen` TEXT NULL DEFAULT NULL AFTER `tfri_aml_chemo_start_unknown`,
	ADD COLUMN `tfri_aml_regimen_unknown` VARCHAR(10) NULL DEFAULT NULL AFTER `tfri_aml_standard_regimen`,
	ADD COLUMN `tfri_cause_of_death` VARCHAR(100) NULL DEFAULT NULL AFTER `tfri_aml_standard_regimen`,
	ADD COLUMN `tfri_cause_of_death_other` VARCHAR(100) NULL DEFAULT NULL AFTER `tfri_cause_of_death`,
	ADD COLUMN `tfri_age_at_registration` INT(11) NULL DEFAULT NULL AFTER `tfri_cause_of_death_other`;
	
ALTER TABLE `participants_revs` 
	ADD COLUMN `tfri_aml_site_number` TINYINT NULL DEFAULT NULL AFTER `last_chart_checked_date_accuracy`,
	ADD COLUMN `tfri_aml_screening_code` INT NULL DEFAULT NULL AFTER `tfri_aml_site_number`,
	ADD COLUMN `tfri_aml_date_registration` DATE NULL DEFAULT NULL AFTER `tfri_aml_screening_code`,
	ADD COLUMN `tfri_aml_date_day_zero` DATE NULL DEFAULT NULL AFTER `tfri_aml_date_registration`,
	ADD COLUMN `tfri_aml_registration_diagnosis` VARCHAR(45) NULL DEFAULT NULL AFTER `tfri_aml_date_day_zero`,
	ADD COLUMN `tfri_aml_other_diagnosis` VARCHAR(200) NULL DEFAULT NULL AFTER `tfri_aml_registration_diagnosis`,
	ADD COLUMN `tfri_aml_english_french` VARCHAR(45) NULL DEFAULT NULL AFTER `tfri_aml_other_diagnosis`,
	ADD COLUMN `tfri_aml_chemo_start` DATE NULL DEFAULT NULL AFTER `tfri_aml_english_french`,
	ADD COLUMN `tfri_aml_chemo_start_unknown` VARCHAR(10) NULL DEFAULT NULL AFTER `tfri_aml_chemo_start`,
	ADD COLUMN `tfri_aml_standard_regimen` TEXT NULL DEFAULT NULL AFTER `tfri_aml_chemo_start_unknown`,
	ADD COLUMN `tfri_aml_regimen_unknown` VARCHAR(10) NULL DEFAULT NULL AFTER `tfri_aml_standard_regimen`,
	ADD COLUMN `tfri_cause_of_death` VARCHAR(100) NULL DEFAULT NULL AFTER `tfri_aml_standard_regimen`,
	ADD COLUMN `tfri_cause_of_death_other` VARCHAR(100) NULL DEFAULT NULL AFTER `tfri_cause_of_death`,
	ADD COLUMN `tfri_age_at_registration` INT(11) NULL DEFAULT NULL AFTER `tfri_cause_of_death_other`;

-- Value domains for disease type	 
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("tfri_profile_disease", "", "", NULL);

INSERT INTO structure_permissible_values (value, language_alias) VALUES("Known AML", "tfri Known AML");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_profile_disease"), (SELECT id FROM structure_permissible_values WHERE value="Known AML" AND language_alias="tfri Known AML"), "1", "1");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("Suspected AML", "tfri Suspected AML");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_profile_disease"), (SELECT id FROM structure_permissible_values WHERE value="Suspected AML" AND language_alias="tfri Suspected AML"), "2", "1");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("Known MDS", "tfri Known MDS");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_profile_disease"), (SELECT id FROM structure_permissible_values WHERE value="Known MDS" AND language_alias="tfri Known MDS"), "3", "1");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("Suspected MDS", "tfri Suspected MDS");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_profile_disease"), (SELECT id FROM structure_permissible_values WHERE value="Suspected MDS" AND language_alias="tfri Suspected MDS"), "4", "1");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("Known CMML", "tfri Known CMML");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_profile_disease"), (SELECT id FROM structure_permissible_values WHERE value="Known CMML" AND language_alias="tfri Known CMML"), "5", "1");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("Suspected CMML", "tfri Suspected CMML");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_profile_disease"), (SELECT id FROM structure_permissible_values WHERE value="Suspected CMML" AND language_alias="tfri Suspected CMML"), "6", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri Known AML', 'Known AML', ''),
 ('tfri Suspected AML', 'Suspected AML', ''),
 ('tfri Known MDS', 'Known MDS', ''),
 ('tfri Suspected MDS', 'Suspected MDS', ''),
 ('tfri Known CMML', 'Known CMML', ''),
 ('tfri Suspected CMML', 'Suspected CMML', ''); 
 
-- Add new fields
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_site_number', 'integer',  NULL , '0', '', '', '', 'tfri aml site number', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_screening_code', 'integer',  NULL , '0', '', '', '', 'tfri aml screening code', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_date_registration', 'date',  NULL , '0', '', '', '', 'tfri aml date registration', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_date_day_zero', 'date',  NULL , '0', '', '', '', 'tfri aml date day zero', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_registration_diagnosis', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_profile_disease') , '0', '', '', '', 'tfri aml diagnosis', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_other_diagnosis', 'input', NULL , '0', '', '', '', '', 'tfri aml other diagnosis');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_site_number' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml site number' AND `language_tag`=''), '3', '10', 'tfri study registration', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_screening_code' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml screening code' AND `language_tag`=''), '3', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_registration' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml date registration' AND `language_tag`=''), '3', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_day_zero' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml date day zero' AND `language_tag`=''), '3', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_registration_diagnosis' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_profile_disease')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml diagnosis' AND `language_tag`=''), '3', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_other_diagnosis' AND `type`='input' AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='tfri aml other diagnosis'), '3', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_english_french', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'tfri aml english french', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_chemo_start', 'date',  NULL , '0', '', '', '', 'tfri aml chemo start', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_standard_regimen', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'tfri aml standard regimen', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_english_french' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml english french' AND `language_tag`=''), '3', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_chemo_start' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml chemo start' AND `language_tag`=''), '3', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_standard_regimen' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='tfri aml standard regimen' AND `language_tag`=''), '3', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');


REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri study registration', 'Study Registration', ''),
 ('tfri aml site number', 'Site Number', ''),
 ('tfri aml screening code', 'Screening Code', ''),
 ('tfri aml date registration', 'Date of Registration', ''),
 ('tfri aml date day zero', 'Date of Day 0', ''),
 ('tfri aml diagnosis', 'Diagnosis', ''),
 ('tfri aml other diagnosis', 'If other', ''),
 ('tfri aml english french', 'Understand Spoken English or French', ''),
 ('tfri aml chemo start', 'Planned Chemo Start', ''),
 ('tfri aml standard regimen', 'Planned Standard Regimen', '');
 
/*
	Eventum Issue: #2733 - Participant Profile - Age at Registration
*/
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_age_at_registration', 'integer',  NULL , '0', '', '', '', 'tfri age at registration', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_age_at_registration' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri age at registration' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '1', '0', '0'); 
 
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri age at registration', 'Age at Registration', ''); 

/*
	Eventum Issue: #2739 - Profile - Chemo/Standard Regimen
*/

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_chemo_start_unknown', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', '', 'tfri aml chemo start unknown'), 
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_aml_regimen_unknown', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', '', 'tfri aml regimen unknown');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_chemo_start_unknown' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='tfri aml chemo start unknown'), '3', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_regimen_unknown' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='tfri aml regimen unknown'), '3', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri aml chemo start unknown', 'Chemo Start Unknown', ''),
 ('tfri aml regimen unknown', 'Regimen Unknown', ''); 
 
/*
	Eventum Issue: #2737 - Profile - Add validation for site code
*/
 
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES
 ((SELECT `id` FROM `structure_fields` WHERE `field` = 'tfri_aml_site_number' AND `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant'), 'custom,/^\\A\\d{1}$/', 'tfri_aml site number 1 digit');
 
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('tfri_aml site number 1 digit', 'Site number must be one digit', '');
	
/*
	Eventum Issue: #2741 - Profile - Cause of death form
*/

-- Move vital status fields to first column
UPDATE structure_formats SET `display_column`='1', `display_order`='50' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='55' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Create value domain for cause of death
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("tfri_cause_of_death", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("relapse of baseline disease", "tfri relapse of baseline disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_cause_of_death"), (SELECT id FROM structure_permissible_values WHERE value="relapse of baseline disease" AND language_alias="tfri relapse of baseline disease"), "6", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("progression of baseline disease", "tfri progression of baseline disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_cause_of_death"), (SELECT id FROM structure_permissible_values WHERE value="progression of baseline disease" AND language_alias="tfri progression of baseline disease"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("treatment toxicity", "tfri treatment toxicity");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_cause_of_death"), (SELECT id FROM structure_permissible_values WHERE value="treatment toxicity" AND language_alias="tfri treatment toxicity"), "8", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("infection", "tfri infection");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_cause_of_death"), (SELECT id FROM structure_permissible_values WHERE value="infection" AND language_alias="tfri infection"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("subsequent malignancy", "tfri subsequent malignancy");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_cause_of_death"), (SELECT id FROM structure_permissible_values WHERE value="subsequent malignancy" AND language_alias="tfri subsequent malignancy"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("prior malignancy", "tfri prior malignancy");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_cause_of_death"), (SELECT id FROM structure_permissible_values WHERE value="prior malignancy" AND language_alias="tfri prior malignancy"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("transplant (hpct) related complications", "tfri transplant (hpct) related complications");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_cause_of_death"), (SELECT id FROM structure_permissible_values WHERE value="transplant (hpct) related complications" AND language_alias="tfri transplant (hpct) related complications"), "7", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("accident", "tfri accident");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_cause_of_death"), (SELECT id FROM structure_permissible_values WHERE value="accident" AND language_alias="tfri accident"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_cause_of_death"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "9", "1");

-- Add custom cause of death, other COD
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_cause_of_death', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_cause_of_death') , '0', '', '', '', 'tfri cause of death', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_cause_of_death' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_cause_of_death')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri cause of death' AND `language_tag`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'tfri_cause_of_death_other', 'input',  NULL , '0', '', '', '', '', 'tfri cause of death other');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES  
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_cause_of_death_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='tfri cause of death other'), '1', '65', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');


REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
  ('tfri cause of death', 'Cause of Death', ''),
  ('tfri relapse of baseline disease', 'Relapse of baseline disease', ''),
  ('tfri progression of baseline disease', 'Progression of baseline disease', ''),    
  ('tfri treatment toxicity', 'Treatment toxicity', ''),
  ('tfri infection', 'Infection', ''), 
  ('tfri subsequent malignancy', 'Subsequent malignancy', ''),
  ('tfri prior malignancy', 'Prior malignancy', ''),
  ('tfri transplant (hpct) related complications', 'Transplant (HPCT) related complications', ''),    
  ('tfri accident', 'Accident', ''),
  ('tfri cause of death other', 'COD, if other', ''); 

/*
	Eventum Issue: #2770 - Profile - Hide name fields
*/

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

  	
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
 ('DCF - S1 Baseline', 'DCF - S1 Baseline', ''),
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

-- Add fields to form               