-- CCBR Customization Script
-- Version: v0.9
-- ATiM Version: v2.4.3A
-- Notes: Before running this script run custom_post_243a.sql

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Child and Family Research Institute - CCBR v0.9 (RC1)', '');

/*
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2135 - Dx/Tx Source
	---------------------------------------------------------------------------
*/

-- Add new lookup value to DiagnosisMaster.InformationSource and TreatmentMaster.InformationSource
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr eve', 'EVE', '');

INSERT INTO `structure_permissible_values` (`value`, `language_alias`) VALUES ('eve', 'ccbr eve');

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((select id from structure_value_domains where domain_name = 'information_source'), (SELECT id FROM structure_permissible_values where value = 'eve' and language_alias = 'ccbr eve'), 5, 1, 1);

/*
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2145 - Fix PHN Validation
	---------------------------------------------------------------------------
*/

-- Fix validation for PHN number 
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr PHN validation error', 'PHN must have the format: DDDD DDD DDD', '');

/*
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2311 - Tx -> Radiation -> Site add drop down value
	---------------------------------------------------------------------------
*/

-- Add 'total body' to radiation site
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr total body', 'Total body', '');

INSERT INTO structure_permissible_values (value, language_alias) VALUES("total body", "ccbr total body");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_treatment_site"), (SELECT id FROM structure_permissible_values WHERE value="total body" AND language_alias="ccbr total body"), "1", "1");

/*
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2307 - Annotation -> CBC (LDH Label)
	---------------------------------------------------------------------------
*/

-- Update Annotation -> Lab -> CBC and Bone Marrow Form. Add units to LDH field
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr ldh level', 'LDH Level (U/L)', '');

/*
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2305 - Treatment -> Radiation (Label change for units)
	---------------------------------------------------------------------------
*/
	
-- Fix units label for radiation total dose	
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr rad total dose', 'Total Dose (cGy)', '');	

/*	
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2306 - Annotation -> CBC - Cellularity
	---------------------------------------------------------------------------
*/

-- Annotation -> Lab -> CBC and Bone Marrow. Move old cellularity field to new field so old values can be retained
ALTER TABLE `ed_ccbr_lab_cbc_bone_marrows` CHANGE COLUMN `ccbr_bone_marrow_cellularity` `ccbr_bone_marrow_cellularity_value` FLOAT NULL DEFAULT NULL  ;
ALTER TABLE `ed_ccbr_lab_cbc_bone_marrows_revs` CHANGE COLUMN `ccbr_bone_marrow_cellularity` `ccbr_bone_marrow_cellularity_value` FLOAT NULL DEFAULT NULL  ;

-- New table field for cellularity drop down field
ALTER TABLE `ed_ccbr_lab_cbc_bone_marrows` ADD COLUMN `ccbr_bone_marrow_cellularity` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_bone_marrow_cellularity_value` ;
ALTER TABLE `ed_ccbr_lab_cbc_bone_marrows_revs` ADD COLUMN `ccbr_bone_marrow_cellularity` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_bone_marrow_cellularity_value` ;
 
-- New value domain for bone marrow cellularity
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("ccbr_bone_marrow_cellularity", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("increased", "ccbr increased");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_bone_marrow_cellularity"), (SELECT id FROM structure_permissible_values WHERE value="increased" AND language_alias="ccbr increased"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("slightly increased", "ccbr slightly increased");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_bone_marrow_cellularity"), (SELECT id FROM structure_permissible_values WHERE value="slightly increased" AND language_alias="ccbr slightly increased"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("normal", "ccbr normal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_bone_marrow_cellularity"), (SELECT id FROM structure_permissible_values WHERE value="normal" AND language_alias="ccbr normal"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("slightly decreased", "ccbr slightly decreased");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_bone_marrow_cellularity"), (SELECT id FROM structure_permissible_values WHERE value="slightly decreased" AND language_alias="ccbr slightly decreased"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("decreased", "ccbr decreased");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_bone_marrow_cellularity"), (SELECT id FROM structure_permissible_values WHERE value="decreased" AND language_alias="ccbr decreased"), "5", "1");

-- Language update for drop down list
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('ccbr increased', 'Increased', ''),
	('ccbr slightly increased', 'Slightly increased', ''),
	('ccbr slightly decreased', 'Slightly decreased', ''),
	('ccbr decreased', 'Decreased', ''),
	('ccbr normal', 'Normal', '');

-- Fix old structure field to represent new drop down list
UPDATE 
	`structure_fields`
SET
	`type`='select',
	`structure_value_domain` = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'ccbr_bone_marrow_cellularity')
WHERE 
	`plugin` = 'Clinicalannotation' AND
	`model` = 'EventDetail' AND
	`field` = 'ccbr_bone_marrow_cellularity' AND
	`tablename` = 'ed_ccbr_lab_cbc_bone_marrows';
	
-- New structure field for cellularity value
INSERT INTO `structure_fields` (`plugin`, `model`, `tablename`, `field`, `language_label`, `type`) VALUES
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_cbc_bone_marrows', 'ccbr_bone_marrow_cellularity_value', 'ccbr bone marrow cellularity value', 'float');

-- Link new field to existing structure
INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_add`, `flag_edit`, `flag_detail`) VALUES
((select `id` from `structures` where `alias` = 'ed_ccbr_lab_cbc_bone_marrows'), (select `id` from `structure_fields` where `tablename` = 'ed_ccbr_lab_cbc_bone_marrows' AND `field` = 'ccbr_bone_marrow_cellularity_value'), 1, 7, 1, 1, 1);

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr bone marrow cellularity value', 'Cellularity Value (%)', '');	

/*	
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2308 - Annotation -> Lab -> Immunophenotype (New field)
	---------------------------------------------------------------------------
*/

-- Add new field for CD65
ALTER TABLE `ed_ccbr_lab_immunophenotypes` ADD COLUMN `ccbr_CD65` CHAR(1) NOT NULL DEFAULT ''  AFTER `ccbr_CD64` ;
ALTER TABLE `ed_ccbr_lab_immunophenotypes_revs` ADD COLUMN `ccbr_CD65` CHAR(1) NOT NULL DEFAULT ''  AFTER `ccbr_CD64` ;

-- New structure field
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD65', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesnopartial') , '0', '', 'n', '', 'ccbr CD65', ''); 

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD65' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesnopartial')  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD65' AND `language_tag`=''), '2', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'); 

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr CD65', 'CD65', '');	
	
/*	
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2338 - Consent - Formal Consent By
		Add new field with drop down values (parental, participant)
	---------------------------------------------------------------------------
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('ccbr formal consent type', 'Type', ''),
	('ccbr participant', 'Participant', ''),
	('ccbr parental', 'Parental', '');		

-- Add new field	
ALTER TABLE `cd_ccbr_consents` ADD COLUMN `ccbr_formal_consent_type` VARCHAR(45) NULL DEFAULT NULL  AFTER `ccbr_formal_consent` ;
ALTER TABLE `cd_ccbr_consents_rev` ADD COLUMN `ccbr_formal_consent_type` VARCHAR(45) NULL DEFAULT NULL  AFTER `ccbr_formal_consent` ;

-- Fix rev tablename
ALTER TABLE `cd_ccbr_consents_rev` RENAME TO `cd_ccbr_consents_revs` ;

-- New value domain
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("ccbr_formal_consent_type", "", "", "");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("participant", "ccbr participant");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_formal_consent_type"), (SELECT id FROM structure_permissible_values WHERE value="participant" AND language_alias="ccbr participant"), "1", "1");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("parental", "ccbr parental");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_formal_consent_type"), (SELECT id FROM structure_permissible_values WHERE value="parental" AND language_alias="ccbr parental"), "1", "1");

-- Add field
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_formal_consent_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_formal_consent_type') , '0', '', '', '', '', 'ccbr formal consent type');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_formal_consent_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_formal_consent_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr formal consent type'), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_date_formal_consent' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_person_formal_consent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_person_consenting') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_blood_donation' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='9' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_international_research' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_any_research' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_stem_cells' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') AND `flag_confidential`='0');


/*	
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2339 - Consent - Assent Section New Fields
			Add checkbox fields for Formally consented at age of majority and age seven.
	---------------------------------------------------------------------------
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('ccbr formal at age 7', 'Formal Consent - Age 7', ''),
	('ccbr formal at age majority', 'Formal Consent - Age Majority', '');

ALTER TABLE `cd_ccbr_consents` 
	ADD COLUMN `ccbr_formal_at_age_7` VARCHAR(5) NULL DEFAULT NULL AFTER `ccbr_assent_reason_decline` ,
	ADD COLUMN `ccbr_formal_at_age_majority` VARCHAR(5) NULL DEFAULT NULL  AFTER `ccbr_formal_at_age_7` ;

ALTER TABLE `cd_ccbr_consents_revs` 
	ADD COLUMN `ccbr_formal_at_age_7` VARCHAR(5) NULL DEFAULT NULL AFTER `ccbr_assent_reason_decline` ,
	ADD COLUMN `ccbr_formal_at_age_majority` VARCHAR(5) NULL DEFAULT NULL  AFTER `ccbr_formal_at_age_7` ;
	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_formal_at_age_7', 'yes_no',  NULL , '0', '', '', '', 'ccbr formal at age 7', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_formal_at_age_7' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr formal at age 7' AND `language_tag`=''), '2', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_formal_at_age_majority', 'yes_no',  NULL , '0', '', '', '', 'ccbr formal at age majority', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_formal_at_age_majority' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr formal at age majority' AND `language_tag`=''), '2', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');	
		
/*	
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2355 - Storage - Enable new types
			Freezer, Rack and Shelves for plasma and DNA aliquot storage
	---------------------------------------------------------------------------
*/

UPDATE `storage_controls` SET `flag_active`='1' WHERE `storage_type`='freezer';
UPDATE `storage_controls` SET `flag_active`='1' WHERE `storage_type`='shelf';
	