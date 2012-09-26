-- CCBR Customization Script
-- Version: v0.9
-- ATiM Version: v2.4.3A
-- Notes: Before running this script run custom_post_243a.sql

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Child and Family Research Institute - CCBR v0.9 (RC1)', '');

-- Fix column name for extended radiation tables. Incorrect field name
ALTER TABLE `txe_radiations` DROP FOREIGN KEY `FK_txe_radiations_tx_masters` ;
ALTER TABLE `txe_radiations` CHANGE COLUMN `treatment_master_id` `tx_master_id` INT(11) NULL DEFAULT NULL  , 
  ADD CONSTRAINT `FK_txe_radiations_tx_masters`
  FOREIGN KEY (`tx_master_id` )
  REFERENCES `treatment_masters` (`id` );
  
ALTER TABLE `txe_radiations_revs` CHANGE COLUMN `treatment_master_id` `tx_master_id` INT(11) NULL DEFAULT NULL  ;  

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
	EVENTUM ISSUE: #2377 - Radiation - Add Target Site
	---------------------------------------------------------------------------
*/
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr rad site other', 'Site, if Other', '');

ALTER TABLE `txd_radiations` ADD COLUMN `ccbr_rad_site_other` VARCHAR(100) NULL DEFAULT NULL AFTER `ccbr_rad_site` ;
ALTER TABLE `txd_radiations_revs` ADD COLUMN `ccbr_rad_site_other` VARCHAR(100) NULL DEFAULT NULL AFTER `ccbr_rad_site` ;

INSERT INTO `structure_fields` (`plugin`, `model`, `tablename`, `field`, `language_label`, `type`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_radiations', 'ccbr_rad_site_other', 'ccbr rad site other', 'input');
	
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='ccbr_rad_site_other' AND `type`='input' AND `language_label`='ccbr rad site other'), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
 
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
	EVENTUM ISSUE: #2392 - Consent revisions
	---------------------------------------------------------------------------
*/

ALTER TABLE `cd_ccbr_consents_rev` CHANGE COLUMN `version_id` `version_id` INT(11) NOT NULL AUTO_INCREMENT  ; 		
	
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

/*	
	---------------------------------------------------------------------------
	EVENTUM ISSUE: #2319 - Annotation -> Lab -> Karyotype
	---------------------------------------------------------------------------
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('ccbr chrom 1', 'Chromosome 1', ''),
	('ccbr chrom 2', 'Chromosome 2', ''),
	('ccbr chrom 3', 'Chromosome 3', ''),
	('ccbr chrom 4', 'Chromosome 4', ''),
	('ccbr chrom 5', 'Chromosome 5', ''),
	('ccbr chrom 6', 'Chromosome 6', ''),
	('ccbr chrom 7', 'Chromosome 7', ''),
	('ccbr chrom 8', 'Chromosome 8', ''),
	('ccbr chrom 9', 'Chromosome 9', ''),
	('ccbr chrom 10', 'Chromosome 10', ''),
	('ccbr chrom 11', 'Chromosome 11', ''),
	('ccbr chrom 12', 'Chromosome 12', ''),
	('ccbr chrom 13', 'Chromosome 13', ''),
	('ccbr chrom 14', 'Chromosome 14', ''),
	('ccbr chrom 15', 'Chromosome 15', ''),
	('ccbr chrom 16', 'Chromosome 16', ''),
	('ccbr chrom 17', 'Chromosome 17', ''),
	('ccbr chrom 18', 'Chromosome 18', ''),
	('ccbr chrom 19', 'Chromosome 19', ''),
	('ccbr chrom 20', 'Chromosome 20', ''),
	('ccbr chrom 21', 'Chromosome 21', ''),
	('ccbr chrom 22', 'Chromosome 22', ''),
	('ccbr chrom x', 'Chromosome X', ''),
	('ccbr chrom y', 'Chromosome Y', ''),
	('ccbr karyotype', 'Karyotype', ''),
	('ccbr normal', 'Normal', ''),
	('ccbr +', '+', ''),
	('ccbr -', '-', '');

	
DROP TABLE IF EXISTS `ed_ccbr_lab_karyotypes`; 	
CREATE TABLE `ed_ccbr_lab_karyotypes` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `ccbr_chrom_1` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_2` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_3` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_4` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_5` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_6` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_7` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_8` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_9` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_10` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_11` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_12` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_13` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_14` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_15` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_16` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_17` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_18` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_19` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_20` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_21` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_22` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_x` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_y` VARCHAR(10) NULL DEFAULT NULL ,
  `deleted` TINYINT(3) NOT NULL DEFAULT '0',
  `event_master_id` INT(11), 
PRIMARY KEY (`id`),
KEY `event_master_id` (`event_master_id`),
CONSTRAINT `ed_ccbr_lab_karyotypes_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`) 
);	

DROP TABLE IF EXISTS `ed_ccbr_lab_karyotypes_revs`; 
CREATE TABLE `ed_ccbr_lab_karyotypes_revs` (
  `id` INT(11) NOT NULL ,
  `ccbr_chrom_1` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_2` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_3` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_4` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_5` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_6` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_7` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_8` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_9` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_10` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_11` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_12` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_13` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_14` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_15` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_16` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_17` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_18` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_19` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_20` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_21` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_22` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_x` VARCHAR(10) NULL DEFAULT NULL ,
  `ccbr_chrom_y` VARCHAR(10) NULL DEFAULT NULL ,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `event_master_id` INT(11), 
PRIMARY KEY (`version_id`),
KEY `event_master_id` (`event_master_id`)
);	

-- Add structure
INSERT INTO `structures` (`alias`) VALUES ('ed_ccbr_lab_karyotypes');  

-- Event Control
INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
 ('ccbr', 'lab', 'karyotype', '1', 'eventmasters,ed_ccbr_lab_karyotypes', 'ed_ccbr_lab_karyotypes', '0', 'lab|ccbr|karyotype');


-- Value domain for karotype status
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("ccbr_karyotype", "", "", "");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_karyotype"), (SELECT id FROM structure_permissible_values WHERE value="normal" AND language_alias="ccbr normal"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("+", "ccbr +");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_karyotype"), (SELECT id FROM structure_permissible_values WHERE value="+" AND language_alias="ccbr +"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("-", "ccbr -");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_karyotype"), (SELECT id FROM structure_permissible_values WHERE value="-" AND language_alias="ccbr -"), "3", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_1', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 1', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_2', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 2', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_3', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 3', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_4', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 4', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_5', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 5', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_6', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 6', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_7', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 7', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_8', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 8', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_9', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 9', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_10', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 10', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_11', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 11', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_12', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 12', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_13', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 13', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_14', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 14', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_15', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 15', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_16', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 16', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_17', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 17', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_18', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 18', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_19', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 19', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_20', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 20', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_21', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 21', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_22', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom 22', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_x', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom x', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_karyotypes', 'ccbr_chrom_y', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype') , '0', '', '', '', 'ccbr chrom y', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_1' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 1' AND `language_tag`=''), '1', '1', 'ccbr karyotype', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_2' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 2' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_3' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 3' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_4' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 4' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_5' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 5' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_6' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 6' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_7' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 7' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_8' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 8' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_9' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 9' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_10' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 10' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_11' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 11' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_12' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 12' AND `language_tag`=''), '2', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_13' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 13' AND `language_tag`=''), '2', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_14' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 14' AND `language_tag`=''), '2', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_15' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 15' AND `language_tag`=''), '2', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_16' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 16' AND `language_tag`=''), '2', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_17' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 17' AND `language_tag`=''), '2', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_18' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 18' AND `language_tag`=''), '2', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_19' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 19' AND `language_tag`=''), '2', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_20' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 20' AND `language_tag`=''), '2', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_21' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 21' AND `language_tag`=''), '2', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_22' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom 22' AND `language_tag`=''), '2', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_x' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom x' AND `language_tag`=''), '3', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_karyotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_karyotypes' AND `field`='ccbr_chrom_y' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_karyotype')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr chrom y' AND `language_tag`=''), '3', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');