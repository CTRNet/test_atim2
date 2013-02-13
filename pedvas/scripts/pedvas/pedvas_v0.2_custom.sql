-- PedVas Custom Script
-- Version: v0.2
-- ATiM Version: v2.5.2

-- This script must be run against a v2.5.2 ATiM database with all previous custom scripts applied.

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'PedVas - v0.2 DEV', '');
	
 /*
	------------------------------------------------------------
	Eventum ID: 2477 - Fix quote issue on Diagnosis Type drop down	
	------------------------------------------------------------
*/
/* not working
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	("granulomatosis with polyangiitis (wegener’s granulomatosis)", "Granulomatosis with polyangiitis (Wegener\'s granulomatosis)", ''),
	("limited granulomatosis with polyangiitis (limited wegener’s granulomatosis))", "Limited granulomatosis with polyangiitis (Limited Wegener\'s granulomatosis)", ''),
	("takayasu’s arteritis", "Takayasu\'s arteritis", '');
*/

 /*
	------------------------------------------------------------
	Eventum ID: 2478 - Add year to profile	
	------------------------------------------------------------
*/
	
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE `participants` ADD COLUMN `pv_birth_year` INT(10) NULL AFTER `pv_subject_type` ;
ALTER TABLE `participants_revs` ADD COLUMN `pv_birth_year` INT(10) NULL AFTER `pv_subject_type` ;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'pv_birth_year', 'integer',  NULL , '0', '', '', '', 'pv birth year', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='pv_birth_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv birth year' AND `language_tag`=''), '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('pv birth year', 'Birth Year', '');
	
/*
	------------------------------------------------------------
	Eventum ID: 2479 - Consent - Fix assent/formal consent dropdown	
	------------------------------------------------------------
*/

INSERT INTO structure_permissible_values (value, language_alias) VALUES("obtained (assent)", "obtained (assent)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="consent_status"), (SELECT id FROM structure_permissible_values WHERE value="obtained (assent)" AND language_alias="obtained (assent)"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("obtained (formal)", "obtained (formal)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="consent_status"), (SELECT id FROM structure_permissible_values WHERE value="obtained (formal)" AND language_alias="obtained (formal)"), "3", "1");

DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="obtained" AND spv.language_alias="obtained";
DELETE FROM structure_permissible_values WHERE value="obtained" AND language_alias="obtained";

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('obtained (assent)', 'Obtained - Assent', ''),
	('obtained (formal)', 'Obtained - Formal', '');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_pv_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_assent_status' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_pv_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_date_assent' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

/*
	------------------------------------------------------------
	Eventum ID: 2488 - Diagnosis Type Label	
	------------------------------------------------------------
*/

-- Alter table to reflect field change

ALTER TABLE `dxd_pv_diagnosis` CHANGE COLUMN `pv_diagnosis_type` `pv_prelim_diagnosis_type` VARCHAR(200) NULL DEFAULT NULL  ;
ALTER TABLE `dxd_pv_diagnosis_revs` CHANGE COLUMN `pv_diagnosis_type` `pv_prelim_diagnosis_type` VARCHAR(200) NULL DEFAULT NULL  ;

UPDATE `structure_fields` SET `field`='pv_prelim_diagnosis_type', `language_label`='pv prelim diagnosis type' WHERE `field`='pv_diagnosis_type';

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('pv prelim diagnosis type', 'Preliminary Diagnosis Type', '');

/*
	------------------------------------------------------------
	Eventum ID: 2489 - Diagnosis Dx Method
	------------------------------------------------------------
*/

-- Add new field for other Dx Method
ALTER TABLE `dxd_pv_diagnosis` 
	ADD COLUMN `pv_dx_method` VARCHAR(45) NULL DEFAULT NULL  AFTER `pv_prelim_diagnosis_type` ,
	ADD COLUMN `pv_dx_method_other` VARCHAR(200) NULL DEFAULT NULL  AFTER `pv_dx_method` ;
	
ALTER TABLE `dxd_pv_diagnosis_revs` 
	ADD COLUMN `pv_dx_method` VARCHAR(45) NULL DEFAULT NULL  AFTER `pv_prelim_diagnosis_type` ,
	ADD COLUMN `pv_dx_method_other` VARCHAR(200) NULL DEFAULT NULL  AFTER `pv_dx_method` ;	
	
-- Value Domain for Dx Method
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("pv_dx_method", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("physician", "pv physician");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_dx_method"), (SELECT id FROM structure_permissible_values WHERE value="physician" AND language_alias="pv physician"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("clinical research", "pv clinical research");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_dx_method"), (SELECT id FROM structure_permissible_values WHERE value="clinical research" AND language_alias="pv clinical research"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("genetic evidence", "pv genetic evidence");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_dx_method"), (SELECT id FROM structure_permissible_values WHERE value="genetic evidence" AND language_alias="pv genetic evidence"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("rna", "pv rna");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_dx_method"), (SELECT id FROM structure_permissible_values WHERE value="rna" AND language_alias="pv rna"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("other", "pv other");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_dx_method"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="pv other"), "5", "1");

-- Add field for dx method and dx method other
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_pv_diagnosis', 'pv_dx_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='pv_dx_method') , '0', '', '', '', 'pv dx method', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_pv_diagnosis', 'pv_dx_method_other', 'input',  NULL , '0', 'size=30', '', '', '', 'pv dx method other');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dxd_pv_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_pv_diagnosis' AND `field`='pv_dx_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='pv_dx_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv dx method' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dxd_pv_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_pv_diagnosis' AND `field`='pv_dx_method_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='pv dx method other'), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('pv physician', 'Physician', ''),
	('pv clinical research', 'Clinical Research', ''),
	('pv genetic evidence', 'Genetic Evidence', ''),
	('pv rna', 'RNA', ''),
	('pv other', 'Other', ''),
	('pv dx method', 'Diagnosis Method', ''),
	('pv dx method other', 'If Other', '');
	

/*
	------------------------------------------------------------
	Eventum ID: 2486 - Diagnosis - Sub Type	
	------------------------------------------------------------
*/

ALTER TABLE `dxd_pv_diagnosis` ADD COLUMN `pv_sub_type` VARCHAR(45) NULL DEFAULT NULL  AFTER `pv_dx_method_other` ;
ALTER TABLE `dxd_pv_diagnosis_revs` ADD COLUMN `pv_sub_type` VARCHAR(45) NULL DEFAULT NULL  AFTER `pv_dx_method_other` ;

-- Value Domain for sub-type
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("pv_sub_type", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("progressive", "pv progressive");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_sub_type"), (SELECT id FROM structure_permissible_values WHERE value="progressive" AND language_alias="pv progressive"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("non-progressive", "pv non-progressive");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_sub_type"), (SELECT id FROM structure_permissible_values WHERE value="non-progressive" AND language_alias="pv non-progressive"), "2", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_pv_diagnosis', 'pv_sub_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='pv_sub_type') , '0', '', '', '', 'pv sub type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dxd_pv_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_pv_diagnosis' AND `field`='pv_sub_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='pv_sub_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv sub type' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
	
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('pv sub type', 'Sub Type', ''),
	('pv progressive', 'Progressive', ''),
	('pv non-progressive', 'Non Progressive', '');
	
/*
	------------------------------------------------------------
	Eventum ID: 2491 - Collection - Hide Bank
	------------------------------------------------------------
*/

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

/*
	------------------------------------------------------------
	Eventum ID: 2492 - Enable Derivative cDNA from RNA
	------------------------------------------------------------
*/

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(136);

/*
	------------------------------------------------------------
	Eventum ID: 2494 - Diagnosis - Add disease code back to form
	------------------------------------------------------------
*/

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dxd_pv_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '15', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');	


/*
	------------------------------------------------------------
	Eventum ID: 2487 - Consent form not saving (Invalid Date)
	------------------------------------------------------------
*/

ALTER TABLE `cd_pv_consents` CHANGE COLUMN `pv_date_assent` `pv_date_assent` DATE NULL DEFAULT NULL  ;
ALTER TABLE `cd_pv_consents_revs` CHANGE COLUMN `pv_date_assent` `pv_date_assent` DATE NULL DEFAULT NULL  ;


/*
	------------------------------------------------------------
	Eventum ID: 2498 - Fix detail table definitions
	------------------------------------------------------------
*/

ALTER TABLE `cd_pv_consents` CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT  ;
ALTER TABLE `cd_pv_consents_revs` CHANGE COLUMN `version_id` `version_id` INT(11) NOT NULL AUTO_INCREMENT  ;
ALTER TABLE `dxd_pv_diagnosis` CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT  ;

DROP TABLE IF EXISTS `dxd_pv_diagnosis_revs`;
CREATE TABLE `dxd_pv_diagnosis_revs` (
  `id` INT(11) NOT NULL ,
  `pv_prelim_diagnosis_type` varchar(200) DEFAULT NULL,
  `pv_dx_method` varchar(45) DEFAULT NULL,
  `pv_dx_method_other` varchar(200) DEFAULT NULL,
  `pv_sub_type` varchar(45) DEFAULT NULL,
  `version_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `version_created` DATETIME NOT NULL,
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB;


/*
	------------------------------------------------------------
	Eventum ID: 2477 - Fix quote issue on Diagnosis Type drop down
	------------------------------------------------------------
*/

-- Remove values from value domain with wrong apostrophe
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value LIKE "granulomatosis with polyangiitis%";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value LIKE "limited granulomatosis with polyangiitis%";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value LIKE "takaya%";

DELETE FROM structure_permissible_values WHERE value LIKE "granulomatosis with polyangiitis%";
DELETE FROM structure_permissible_values WHERE value LIKE "limited granulomatosis with polyangiitis%";
DELETE FROM structure_permissible_values WHERE value LIKE "takaya%";

-- Add them back correctly
INSERT INTO structure_permissible_values (value, language_alias) VALUES("granulomatosis with polyangiitis (wegener\'s granulomatosis)", "pv granulomatosis with polyangiitis (wegener\'s granulomatosis)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv diagnosis type"), (SELECT id FROM structure_permissible_values WHERE value="granulomatosis with polyangiitis (wegener\'s granulomatosis)" AND language_alias="pv granulomatosis with polyangiitis (wegener\'s granulomatosis)"), "1", "1");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("limited granulomatosis with polyangiitis (limited wegener\'s granulomatosis)", "pv limited granulomatosis with polyangiitis (limited wegener\'s granulomatosis)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv diagnosis type"), (SELECT id FROM structure_permissible_values WHERE value="limited granulomatosis with polyangiitis (limited wegener\'s granulomatosis)" AND language_alias="pv limited granulomatosis with polyangiitis (limited wegener\'s granulomatosis)"), "2", "1");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("takayasu\'s arteritis", "pv takayasu\'s arteritis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv diagnosis type"), (SELECT id FROM structure_permissible_values WHERE value="takayasu\'s arteritis" AND language_alias="pv takayasu\'s arteritis"), "9", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	("pv granulomatosis with polyangiitis (wegener\'s granulomatosis)", "Granulomatosis with polyangiitis (Wegener\'s granulomatosis)", ''),
	("pv limited granulomatosis with polyangiitis (limited wegener\'s granulomatosis)", "Limited granulomatosis with polyangiitis (Limited Wegener\'s granulomatosis)", ''),
	("pv takayasu\'s arteritis", "Takayasu\'s arteritis", '');

/*
	------------------------------------------------------------
	Eventum ID: 2470 - Samples - Add Saliva
	------------------------------------------------------------
*/

-- Add new saliva sample	
INSERT INTO `sample_controls` (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES ('saliva', 'specimen', 'sd_spe_salivas,specimens', 'sd_spe_salivas', '1', 'saliva');

-- New blank structure for saliva specimen
INSERT INTO `structures` (`alias`) VALUES ('sd_spe_salivas');

-- Table structure for saliva
CREATE TABLE `sd_spe_salivas` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_spe_salivas_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_spe_salivas_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB;

-- Tube for new saliva
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `detail_form_alias`, `detail_tablename`, `flag_active`, `databrowser_label`) VALUES ((SELECT id FROM `sample_controls` WHERE `sample_type` = 'saliva'), 'tube', 'ad_spec_tubes', 'ad_tubes', '1', 'saliva|tube');

-- Allow DNA creation from new saliva sample and enable saliva
INSERT INTO `parent_to_derivative_sample_controls` (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES ((SELECT id FROM `sample_controls` WHERE `sample_type` = 'saliva'), '12', '1');
INSERT INTO `parent_to_derivative_sample_controls` (`derivative_sample_control_id`, `flag_active`) VALUES ((SELECT id FROM `sample_controls` WHERE `sample_type` = 'saliva'), '1');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	("saliva)", "Saliva", '');
	