-- PedVas Custom Script
-- Version: v0.3
-- ATiM Version: v2.5.2

-- This script must be run against a v2.5.2 ATiM database with all previous custom scripts applied.
-- NOTE: PedVas wished to keep data entered on the development site. Be sure to run this update on that version!


-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'PedVas - v0.3 DEV', '');
	

/*
	------------------------------------------------------------
	Eventum ID: 2661 - New Identifier (UKVAS)	
	------------------------------------------------------------
*/

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `display_order`, `flag_once_per_participant`, `flag_unique`, `pad_to_length`) VALUES ('ukvas id', '1', '5', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ukvas id', 'UKVAS ID', '');

/*
	------------------------------------------------------------
	Eventum ID: 2662 - Combine Identifiers
	------------------------------------------------------------
*/

UPDATE `misc_identifier_controls` SET `misc_identifier_name`='pedvas/archive id' WHERE `misc_identifier_name`='archive id';

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('pedvas/archive id', 'PedVas/ARCHIVE ID', '');
	
DELETE FROM `misc_identifier_controls` WHERE `id`='1';


/*
	------------------------------------------------------------
	Eventum ID: 2655 - Enable treatment menus
	------------------------------------------------------------
*/

UPDATE menus SET flag_active=true WHERE id IN('clin_CAN_75', 'clin_CAN_80');


/*
	------------------------------------------------------------
	Eventum ID: 2651 - Consent - Date of Verbal Consent
	------------------------------------------------------------
*/

ALTER TABLE `cd_pv_consents` 
ADD COLUMN `pv_date_verbal_consent` DATE NULL DEFAULT NULL AFTER `pv_consent_type`;

ALTER TABLE `cd_pv_consents_revs` 
ADD COLUMN `pv_date_verbal_consent` DATE NULL DEFAULT NULL AFTER `pv_consent_type`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_pv_consents', 'pv_date_verbal_consent', 'date',  NULL , '0', '', '', '', 'pv date verbal consent', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_pv_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_date_verbal_consent' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv date verbal consent' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('pv date verbal consent', 'Date of Verbal Consent', '');


/*
	------------------------------------------------------------
	Eventum ID: 2499 - Profile - Year of Birth validation
	------------------------------------------------------------
*/

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES
 ((SELECT `id` FROM `structure_fields` WHERE `field` = 'pv_birth_year'), 'range,1850,2100', 'pv enter 4 digit year value between 1850 and 2100');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('pv enter 4 digit year value between 1850 and 2100', 'Enter 4 digit year value between 1850 and 2100', '');


/*
	------------------------------------------------------------
	Eventum ID: 2649 - Collection Bank - Values
	------------------------------------------------------------
*/

UPDATE `banks` SET `name`='PedVas', `description`='', `created_by`='1' WHERE `id`='1';
INSERT INTO `banks` (`name`, `created_by`, `created`) VALUES ('General Rheumatology', '1', '2013-09-23 00:00:00');
INSERT INTO `banks` (`name`, `created_by`, `created`) VALUES ('PREVENT JIA', '1', '2013-09-23 00:00:00');
INSERT INTO `banks` (`name`, `created_by`, `created`) VALUES ('PARC', '1', '2013-09-23 00:00:00');
INSERT INTO `banks` (`name`, `created_by`, `created`) VALUES ('Other', '1', '2013-09-23 00:00:00');

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

	
/*
	------------------------------------------------------------
	Eventum ID: 2659 - Fix diagnosis type
	------------------------------------------------------------
*/

-- Change Primary CNS, remove the sub-type from list value
INSERT INTO structure_permissible_values (value, language_alias) VALUES("primary cns vasculitis", "primary cns vasculitis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv diagnosis type"), (SELECT id FROM structure_permissible_values WHERE value="primary cns vasculitis" AND language_alias="primary cns vasculitis"), "11", "1");

DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="primary cns vasculitis - medium/large vessel" AND spv.language_alias="primary cns vasculitis - medium/large vessel";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="primary cns vasculitis - small vessel" AND spv.language_alias="primary cns vasculitis - small vessel";

DELETE FROM structure_permissible_values WHERE value="primary cns vasculitis - medium/large vessel" AND language_alias="primary cns vasculitis - medium/large vessel";
DELETE FROM structure_permissible_values WHERE value="primary cns vasculitis - small vessel" AND language_alias="primary cns vasculitis - small vessel";

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('primary cns vasculitis', 'Primary CNS vasculitis', '');

-- Fix list order
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="1" WHERE svd.domain_name='pv diagnosis type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="anca positive pauci-immune glomerulonephritis" AND language_alias="anca positive pauci-immune glomerulonephritis");

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="2" WHERE svd.domain_name='pv diagnosis type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="cutaneous polyarteritis nodosa" AND language_alias="cutaneous polyarteritis nodosa");

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="3" WHERE svd.domain_name='pv diagnosis type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="eosinophilic granulomatosis with polyangiitis (churg-strauss syndrome)" AND language_alias="eosinophilic granulomatosis with polyangiitis (churg-strauss syndrome)");

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="3" WHERE svd.domain_name='pv diagnosis type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="granulomatosis with polyangiitis (wegener\'s granulomatosis)" AND language_alias="pv granulomatosis with polyangiitis (wegener\'s granulomatosis)");

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="3" WHERE svd.domain_name='pv diagnosis type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="limited granulomatosis with polyangiitis (limited wegener\'s granulomatosis)" AND language_alias="pv limited granulomatosis with polyangiitis (limited wegener\'s granulomatosis)");

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="6" WHERE svd.domain_name='pv diagnosis type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="microscopic polyangiitis" AND language_alias="microscopic polyangiitis");

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="7" WHERE svd.domain_name='pv diagnosis type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="microscopic polyangiitis with isolated renal involvement" AND language_alias="microscopic polyangiitis with isolated renal involvement");

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="8" WHERE svd.domain_name='pv diagnosis type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="polyarteritis nodosa" AND language_alias="polyarteritis nodosa");

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="9" WHERE svd.domain_name='pv diagnosis type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="primary cns vasculitis" AND language_alias="primary cns vasculitis");

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="11" WHERE svd.domain_name='pv diagnosis type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="unclassified primary vasculitis" AND language_alias="unclassified primary vasculitis");

-- Move sub-type to tag line
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='pv_sub_type') ,  `language_label`='',  `language_tag`='pv sub type' WHERE model='DiagnosisDetail' AND tablename='dxd_pv_diagnosis' AND field='pv_sub_type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='pv_sub_type');

-- Fix sub-type value domain
INSERT INTO structure_permissible_values (value, language_alias) VALUES("small vessel", "pv small vessel");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_sub_type"), (SELECT id FROM structure_permissible_values WHERE value="small vessel" AND language_alias="pv small vessel"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("large vessel", "pv large vessel");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_sub_type"), (SELECT id FROM structure_permissible_values WHERE value="large vessel" AND language_alias="pv large vessel"), "2", "1");
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="progressive" AND spv.language_alias="pv progressive";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="non-progressive" AND spv.language_alias="pv non-progressive";
DELETE FROM structure_permissible_values WHERE value="progressive" AND language_alias="pv progressive";
DELETE FROM structure_permissible_values WHERE value="non-progressive" AND language_alias="pv non-progressive";

-- Add field, large vessel sub-type
ALTER TABLE `dxd_pv_diagnosis` 
ADD COLUMN `pv_large_disease_type` VARCHAR(45) NULL DEFAULT NULL AFTER `pv_sub_type`;

ALTER TABLE `dxd_pv_diagnosis_revs` 
ADD COLUMN `pv_large_disease_type` VARCHAR(45) NULL DEFAULT NULL AFTER `pv_sub_type`;

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("pv_large_disease_type", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("progressive", "pv progressive");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_large_disease_type"), (SELECT id FROM structure_permissible_values WHERE value="progressive" AND language_alias="pv progressive"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("non-progressive", "pv non-progressive");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_large_disease_type"), (SELECT id FROM structure_permissible_values WHERE value="non-progressive" AND language_alias="pv non-progressive"), "1", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_pv_diagnosis', 'pv_large_disease_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='pv_large_disease_type') , '0', '', '', '', '', 'pv large disease type');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dxd_pv_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_pv_diagnosis' AND `field`='pv_large_disease_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='pv_large_disease_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='pv large disease type'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_formats SET `display_order`='13' WHERE structure_id=(SELECT id FROM structures WHERE alias='dxd_pv_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_pv_diagnosis' AND `field`='pv_dx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='pv_dx_method') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='14' WHERE structure_id=(SELECT id FROM structures WHERE alias='dxd_pv_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_pv_diagnosis' AND `field`='pv_dx_method_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `language_help`='help_memo' WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='notes' AND `type`='textarea' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='99', `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('pv large disease type', 'Large Disease Type', ''),
 ('pv small vessel', 'Small vessel', ''),
 ('pv large vessel', 'Large vessel', '');

/*
	------------------------------------------------------------
	Eventum ID: 2468 - Validation for Brainworks
	------------------------------------------------------------
*/

UPDATE `misc_identifier_controls` SET `reg_exp_validation`='\\A\\d{3}(-)\\d{4}$' WHERE `misc_identifier_name`='brainworks id';


/*
	------------------------------------------------------------
	Eventum ID: 2650 - Blood tube types
	------------------------------------------------------------
*/

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="EDTA" AND language_alias="EDTA");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="1" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="gel CSA" AND language_alias="gel CSA");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="paxgene" AND language_alias="paxgene");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="ZCSA" AND language_alias="ZCSA");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("k2-edta", "pv k2-edta");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="k2-edta" AND language_alias="K2-EDTA"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("p100 plasma", "pv p100 plasma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="p100 plasma" AND language_alias="P100 Plasma"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("PAXgene DNA", "pv paxgene dna");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="PAXgene DNA" AND language_alias="PAXgene DNA"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("PAXgene RNA", "pv paxgene rna");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="PAXgene RNA" AND language_alias="PAXgene RNA"), "6", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("serum", "pv serum");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="serum" AND language_alias="Serum"), "7", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("tempus rna", "pv tempus RNA");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="tempus rna" AND language_alias="Tempus RNA"), "7", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "8", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('pv k2-edta', 'K2-EDTA', ''),
 ('pv p100 plasma', 'P100 Plasma', ''),
 ('pv paxgene dna', 'PAXgene DNA', ''),
 ('pv paxgene rna', 'PAXgene RNA', ''),
 ('pv serum', 'Serum', ''),
 ('pv tempus RNA', 'Tempus RNA', '');

/*
	------------------------------------------------------------
	Eventum ID: 2652 - Blood derivitives
	------------------------------------------------------------
*/

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(24, 5);

/*
	------------------------------------------------------------
	Eventum ID: 26493 - Saliva - Add tube types
	------------------------------------------------------------
*/

-- Rev table missing
CREATE TABLE `sd_spe_salivas_revs` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_spe_salivas_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_spe_salivas_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB;

-- Add new column
ALTER TABLE `sd_spe_salivas` 
ADD COLUMN `pv_saliva_tube` VARCHAR(45) NULL DEFAULT NULL AFTER `sample_master_id`;
ALTER TABLE `sd_spe_salivas_revs` 
ADD COLUMN `pv_saliva_tube` VARCHAR(45) NULL DEFAULT NULL AFTER `sample_master_id`;

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('saliva', 'Saliva', '');

-- New value domain for tube type
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("pv_saliva_tube", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("OG500", "pv OG500");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_saliva_tube"), (SELECT id FROM structure_permissible_values WHERE value="OG500" AND language_alias="pv OG500"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("OCR100", "pv OCR100");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_saliva_tube"), (SELECT id FROM structure_permissible_values WHERE value="OCR100" AND language_alias="pv OCR100"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pv_saliva_tube"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "3", "1");

-- Add field
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'SampleDetail', 'sd_spe_salivas', 'pv_saliva_tube', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='pv_saliva_tube') , '0', '', '', '', 'pv saliva tube', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_salivas'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_salivas' AND `field`='pv_saliva_tube' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='pv_saliva_tube')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv saliva tube' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('pv saliva tube', 'Saliva Tube', ''),
 ('pv OG500', 'OG500', ''),
 ('pv OCR100', 'OCR100', '');

/*
	------------------------------------------------------------
	Eventum ID: 2656 - New box type (7x7) A1 - G7
	------------------------------------------------------------
*/
INSERT INTO `storage_controls` (`storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
 ('box49 A1-G7', 'column', 'integer', '7', 'row', 'alphabetical', '7', '7', '7', '0', '0', '1', '0', '0', '1', 'storage_w_spaces', 'std_boxs', 'box49 A1-G7', '1');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('box49 A1-G7', 'Box 49 A1-G7', '');

/*
	------------------------------------------------------------
	Eventum ID: 2657 - New Box Type (8x12) A1 - H12
	------------------------------------------------------------
*/

INSERT INTO `storage_controls` (`storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
 ('box96 A1-H12', 'column', 'integer', '12', 'row', 'alphabetical', '8', '12', '8', '0', '0', '1', '0', '0', '1', 'storage_w_spaces', 'std_boxs', 'box96 A1-H12', '1');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('box96 A1-H12', 'Box 96 A1-H12', '');

/*
	------------------------------------------------------------
	Eventum ID: 2658 - Setup storage
	------------------------------------------------------------
*/

-- Flush existing storage entities
DELETE FROM `std_rooms`;
DELETE FROM `std_rooms_revs`;

DELETE FROM `std_boxs`;
DELETE FROM `std_boxs_revs`;

UPDATE `storage_masters` SET `parent_id`= NULL WHERE `id`='9';
DELETE FROM `storage_masters`;
DELETE FROM `storage_masters_revs`;

-- Add new rooms


/*
	------------------------------------------------------------
	Eventum ID: 2648 - Add field clinic visit
	------------------------------------------------------------
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('pv visit', 'Clinic Visit', '');
